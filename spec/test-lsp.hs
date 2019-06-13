{-# LANGUAGE OverloadedStrings #-}

import           Test.Hspec
import           Control.Monad.IO.Class
import           Control.Lens
import           Data.Text
import           Language.Haskell.LSP.Messages
import           Language.Haskell.LSP.Test
import           Language.Haskell.LSP.Types
import           Language.Haskell.LSP.Types.Lens as LSP
import           Language.Haskell.LSP.Types.Capabilities as LSP

digestif_cmd = "digestif"
data_dir = "spec/data"

main = hspec $ do
  describe "textDocument/completion" $ do
    it "completes commands" $ runSession digestif_cmd fullCaps data_dir $ do
      doc <- openDoc "file1.tex" "latex"
      item:_ <- getCompletions doc (Position 3 7)
      liftIO $ do
        item ^. label `shouldBe` "raisebox"
        item ^. detail `shouldBe` Just "{distance}[height][depth]{text}"

    it "completes commands from a package" $ runSession digestif_cmd fullCaps data_dir $ do
      doc <- openDoc "using-tikz.tex" "latex"
      item:_ <- getCompletions doc (Position 1 8)
      --items <- getCompletions doc (Position 1 8)
      liftIO $ item ^. label `shouldBe` "pgfmatrix"

    it "completes tikz options" $ runSession digestif_cmd fullCaps data_dir $ do
      doc <- openDoc "using-tikz.tex" "latex"
      env_opt:_ <- getCompletions doc (Position 3 40)
      path_opt:_ <- getCompletions doc (Position 4 18)
      liftIO $ do
        env_opt ^. label `shouldBe` "execute at begin picture"
        path_opt ^. label `shouldBe` "line cap"
        path_opt ^. detail `shouldBe` Just "=⟨type⟩"

    it "completes local labels" $ runSession digestif_cmd fullCaps data_dir $ do
      doc <- openDoc "file1.tex" "latex"
      item:_ <- getCompletions doc (Position 5 7)
      liftIO $ item ^. label `shouldBe` "somelabel"

    it "completes label from included file" $ runSession digestif_cmd fullCaps data_dir $ do
      doc <- openDoc "root.tex" "latex"
      item:_ <- getCompletions doc (Position 2 8)
      liftIO $ item ^. label `shouldBe` "childlabel"

    it "completes label from root file" $ runSession digestif_cmd fullCaps data_dir $ do
      doc <- openDoc "child.tex" "latex"
      item:_ <- getCompletions doc (Position 2 8)
      liftIO $ item ^. label `shouldBe` "rootlabel"

    it "completes citation from thebibliography environment" $ runSession digestif_cmd fullCaps data_dir $ do
      doc <- openDoc "file1.tex" "latex"
      item:_ <- getCompletions doc (Position 9 10)
      liftIO $ item ^. label `shouldBe` "somebibitem"

    it "completes citation from bibtex file" $ runSession digestif_cmd fullCaps data_dir $ do
      doc <- openDoc "child.tex" "latex"
      item:_ <- getCompletions doc (Position 3 8)
      liftIO $ do
        item ^. label `shouldBe` "somepaper"
        item ^. detail `shouldBe` Just "Thor 1999; Some great paper"

  describe "textDocument/completion with inconsistent root information" $ do
    it "works when root doesn't exist" $ runSession digestif_cmd fullCaps data_dir $ do
      doc <- openDoc "child.tex" "latex"
      let changeEv = TextDocumentContentChangeEvent (Just (Range (Position 0 14) (Position 0 18))) (Just 4) "nonexistent"
      changeDoc doc [changeEv]
      items <- getCompletions doc (Position 2 8)
      liftIO $ items `shouldBe` []

    it "works when root doesn't exist" $ runSession digestif_cmd fullCaps data_dir $ do
      doc <- openDoc "child.tex" "latex"
      let changeEv = TextDocumentContentChangeEvent (Just (Range (Position 0 14) (Position 0 18))) (Just 4) "nonexistent"
      changeDoc doc [changeEv]
      item:_ <- getCompletions doc (Position 4 8)
      liftIO $ item ^. label `shouldBe` "childlabel"

    it "works when root doesn't refer back to child" $ runSession digestif_cmd fullCaps data_dir $ do
      doc <- openDoc "child.tex" "latex"
      let edit = TextEdit (Range (Position 0 14) (Position 0 18)) "file1"
      changeDoc doc [TextDocumentContentChangeEvent (Just (Range (Position 0 14) (Position 0 18))) (Just 4) "file1"]
      item:_ <- getCompletions doc (Position 4 8)
      liftIO $ item ^. label `shouldBe` "childlabel"

  describe "textDocument/definition" $
    it "works" $ runSession digestif_cmd fullCaps data_dir $ do
      doc <- openDoc "file1.tex" "latex"
      def <- getDefinitions doc (Position 6 6)
      liftIO $ def `shouldBe` [Location (doc ^. uri) (Range (Position 4 7) (Position 4 16))]

  describe "textDocument/references" $ do
    it "finds references in a single file" $ runSession digestif_cmd fullCaps data_dir $ do
      let pos = (Position 6 6)
      doc <- openDoc "file1.tex" "latex"
      defs <- getReferences doc pos True
      liftIO $ defs `shouldBe` [
        Location (doc ^. uri) (Range (Position 4 7) (Position 4 16)),
        Location (doc ^. uri) (Range (Position 7 5) (Position 7 14))]

    it "finds references across files" $ runSession digestif_cmd fullCaps data_dir $ do
      doc <- openDoc "root.tex" "latex"
      doc2 <- openDoc "child.tex" "latex"
      defs <- getReferences doc (Position 3 13) True
      liftIO $ defs `shouldBe` [
        Location (doc2 ^. uri) (Range (Position 1 7) (Position 1 17)),
        Location (doc ^. uri) (Range (Position 3 5) (Position 3 15))]

  describe "textDocument/hover" $ do
    it "finds command documentation" $ runSession digestif_cmd fullCaps data_dir $ do
      let getText (HoverContents (MarkupContent MkMarkdown x)) = x
      doc <- openDoc "file2.tex" "latex"
      Just h <- getHover doc (Position 1 5)
      liftIO $ getText(h ^. contents) `shouldSatisfy` isInfixOf "do nothing"

    it "finds context around a label" $ runSession digestif_cmd fullCaps data_dir $ do
      let getText (HoverContents (MarkupContent MkMarkdown x)) = x
      doc <- openDoc "file2.tex" "latex"
      Just h <- getHover doc (Position 0 5)
      -- liftIO $ print $ getText(h ^. contents)
      liftIO $ do
        getText(h ^. contents) `shouldSatisfy` isInfixOf "Lorem ipsum"
        getText(h ^. contents) `shouldSatisfy` isInfixOf "minim veniam"

