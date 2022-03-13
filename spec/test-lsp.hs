{-# LANGUAGE OverloadedStrings #-}

import           Test.Hspec
import           Control.Monad.IO.Class
import           Control.Lens
import           Data.Text
import           Language.LSP.Test
import           Language.LSP.Types
import           Language.LSP.Types.Lens

digestif_cmd = "digestif"
fixtures = "spec/fixtures"

mySession = runSession digestif_cmd fullCaps fixtures

main = hspec $ do
  describe "textDocument/completion" $ do
    it "completes commands" $ mySession $ do
      doc <- openDoc "file1.tex" "latex"
      item:_ <- getCompletions doc (Position 3 7)
      liftIO $ do
        item ^. label `shouldBe` "raisebox"
        item ^. detail `shouldBe` Just "{distance}[height][depth]{text}"

    it "completes commands from a package" $ mySession $ do
      doc <- openDoc "using-tikz.tex" "latex"
      item:_ <- getCompletions doc (Position 1 8)
      --items <- getCompletions doc (Position 1 8)
      liftIO $ item ^. label `shouldBe` "pgfmatrix"

    it "completes tikz options" $ mySession $ do
      doc <- openDoc "using-tikz.tex" "latex"
      env_opt:_ <- getCompletions doc (Position 3 40)
      path_opt:_ <- getCompletions doc (Position 4 18)
      liftIO $ do
        env_opt ^. label `shouldBe` "execute at begin picture"
        path_opt ^. label `shouldBe` "line cap"
        path_opt ^. detail `shouldBe` Just "=⟨type⟩"

    it "completes local labels" $ mySession $ do
      doc <- openDoc "file1.tex" "latex"
      item:_ <- getCompletions doc (Position 5 7)
      liftIO $ item ^. label `shouldSatisfy` isPrefixOf "somelabel"

    it "completes label from included file" $ mySession $ do
      doc <- openDoc "root.tex" "latex"
      item:_ <- getCompletions doc (Position 2 8)
      liftIO $ item ^. label `shouldSatisfy` isPrefixOf "childlabel"

    it "completes label from root file" $ mySession $ do
      doc <- openDoc "child.tex" "latex"
      item:_ <- getCompletions doc (Position 2 8)
      liftIO $ item ^. label `shouldSatisfy` isPrefixOf "rootlabel"

    it "completes citation from thebibliography environment" $ mySession $ do
      doc <- openDoc "file1.tex" "latex"
      item:_ <- getCompletions doc (Position 9 10)
      liftIO $ item ^. label `shouldSatisfy` isPrefixOf "somebibitem"

    it "completes citation from bibtex file" $ mySession $ do
      doc <- openDoc "child.tex" "latex"
      item:_ <- getCompletions doc (Position 3 8)
      liftIO $ do
        item ^. label `shouldSatisfy` isPrefixOf "somepaper"
        item ^. detail `shouldBe` Nothing

    it "completes label wth fuzzy match" $ mySession $ do
      doc <- openDoc "file2.tex" "latex"
      item:_ <- getCompletions doc (Position 2 10)
      liftIO $ item ^. label `shouldSatisfy` isPrefixOf "somelabel"

    it "completes citation wth fuzzy match" $ mySession $ do
      doc <- openDoc "file2.tex" "latex"
      item:_ <- getCompletions doc (Position 10 10)
      liftIO $ item ^. label `shouldSatisfy` isPrefixOf "somepaper"

  describe "textDocument/completion with inconsistent root information" $ do
    it "works when root doesn't exist" $ mySession $ do
      doc <- openDoc "child.tex" "latex"
      let changeEv = TextDocumentContentChangeEvent (Just (Range (Position 0 14) (Position 0 18))) (Just 4) "nonexistent"
      changeDoc doc [changeEv]
      items <- getCompletions doc (Position 2 8)
      liftIO $ items `shouldBe` []

    it "works when root doesn't exist" $ mySession $ do
      doc <- openDoc "child.tex" "latex"
      let changeEv = TextDocumentContentChangeEvent (Just (Range (Position 0 14) (Position 0 18))) (Just 4) "nonexistent"
      changeDoc doc [changeEv]
      item:_ <- getCompletions doc (Position 4 8)
      liftIO $ item ^. label `shouldSatisfy` isPrefixOf "childlabel"

    it "works when root doesn't refer back to child" $ mySession $ do
      doc <- openDoc "child.tex" "latex"
      let edit = TextEdit (Range (Position 0 14) (Position 0 18)) "file1"
      changeDoc doc [TextDocumentContentChangeEvent (Just (Range (Position 0 14) (Position 0 18))) (Just 4) "file1"]
      item:_ <- getCompletions doc (Position 4 8)
      liftIO $ item ^. label `shouldSatisfy` isPrefixOf "childlabel"

  describe "textDocument/definition" $
    it "works" $ mySession $ do
      doc <- openDoc "file1.tex" "latex"
      def <- getDefinitions doc (Position 6 6)
      liftIO $ def `shouldBe` (InL [Location (doc ^. uri) (Range (Position 4 7) (Position 4 16))])

  describe "textDocument/references" $ do
    it "finds references in a single file" $ mySession $ do
      let pos = (Position 6 6)
      doc <- openDoc "file1.tex" "latex"
      defs <- getReferences doc pos True
      liftIO $ defs `shouldBe` (Language.LSP.Types.List [
        Location (doc ^. uri) (Range (Position 4 7) (Position 4 16)),
        Location (doc ^. uri) (Range (Position 7 5) (Position 7 14))])

    it "finds references across files" $ mySession $ do
      doc <- openDoc "root.tex" "latex"
      doc2 <- openDoc "child.tex" "latex"
      defs <- getReferences doc (Position 3 13) True
      liftIO $ defs `shouldBe` (Language.LSP.Types.List [
        Location (doc2 ^. uri) (Range (Position 1 7) (Position 1 17)),
        Location (doc ^. uri) (Range (Position 3 5) (Position 3 15))])

  describe "textDocument/hover" $ do
    it "finds command documentation" $ mySession $ do
      let getText (HoverContents (MarkupContent MkMarkdown x)) = x
      doc <- openDoc "file2.tex" "latex"
      Just h <- getHover doc (Position 1 5)
      liftIO $ getText(h ^. contents) `shouldSatisfy` isInfixOf "do nothing"

    it "finds context around a label" $ mySession $ do
      let getText (HoverContents (MarkupContent MkMarkdown x)) = x
      doc <- openDoc "file2.tex" "latex"
      Just h <- getHover doc (Position 0 5)
      -- liftIO $ print $ getText(h ^. contents)
      liftIO $ do
        getText(h ^. contents) `shouldSatisfy` isInfixOf "Lorem ipsum"
        getText(h ^. contents) `shouldSatisfy` isInfixOf "minim veniam"

