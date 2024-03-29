from pathlib import Path
from urllib.parse import urlparse
from urllib.request import url2pathname

import pytest
import pytest_lsp
from lsprotocol.types import (
    Location,
    MarkupKind,
    Position,
    Range,
    ReferenceContext,
    ReferenceParams,
    TextDocumentIdentifier,
)
from pytest_lsp import ClientServerConfig
from pytest_lsp.client import LanguageClient

BIN_DIR = Path(__file__).parents[1].joinpath("bin")
FIXTURE_DIR = Path(__file__).parent.joinpath("fixtures")


@pytest_lsp.fixture(
    config=ClientServerConfig(
        server_command=["lua", BIN_DIR / "digestif", "-v"],
        root_uri=FIXTURE_DIR.as_uri(),
    ),
)
async def client():
    pass


def open_doc(client, file, language):
    root = Path(url2pathname(urlparse(client.root_uri).path))
    doc = root.joinpath(file)
    with open(doc) as f:
        contents = f.read()
    client.notify_did_open(doc.as_uri(), language, contents)
    return doc.as_uri()


# Basic completion tests


@pytest.mark.asyncio
async def test_completion_latex(client: LanguageClient):
    "Complete a built-in command."
    doc_uri = open_doc(client, "file1.tex", "latex")
    result = await client.completion_request(doc_uri, 3, 7)
    assert result[0].label == "raisebox"
    assert result[0].detail == "{distance}[height][depth]{text}"
    assert result[0].documentation


@pytest.mark.asyncio
async def test_completion_from_package(client: LanguageClient):
    "Complete a command loaded from a package."
    doc_uri = open_doc(client, "using-tikz.tex", "latex")
    result = await client.completion_request(doc_uri, 1, 8)
    assert result[0].label == "pgfmatrix"


@pytest.mark.asyncio
async def test_completion_tikz_option(client: LanguageClient):
    "Complete a TikZ option."
    doc_uri = open_doc(client, "using-tikz.tex", "latex")
    result = await client.completion_request(doc_uri, 3, 40)
    assert result[0].label == "execute at begin picture"
    result = await client.completion_request(doc_uri, 4, 18)
    assert result[0].label == "line cap"
    assert result[0].detail == "=⟨type⟩"


@pytest.mark.asyncio
async def test_completion_label(client: LanguageClient):
    "Complete a label defined in the current file."
    doc_uri = open_doc(client, "file1.tex", "latex")
    result = await client.completion_request(doc_uri, 5, 7)
    assert result[0].label.startswith("somelabel")
    assert result[0].text_edit.new_text == "somelabel"


@pytest.mark.asyncio
async def test_completion_label_from_child(client: LanguageClient):
    "Complete a label defined in an included file, referenced in the root file."
    doc_uri = open_doc(client, "root.tex", "latex")
    result = await client.completion_request(doc_uri, 2, 8)
    assert result[0].label.startswith("childlabel")


@pytest.mark.asyncio
async def test_completion_label_from_root(client: LanguageClient):
    "Complete a label defined in the root file, referenced in an included file."
    doc_uri = open_doc(client, "child.tex", "latex")
    result = await client.completion_request(doc_uri, 2, 8)
    assert result[0].label.startswith("rootlabel")


@pytest.mark.asyncio
async def test_completion_thebibliography(client: LanguageClient):
    "Complete a citation defined in 'thebibliogprahy' environment."
    doc_uri = open_doc(client, "file1.tex", "latex")
    result = await client.completion_request(doc_uri, 9, 10)
    assert result[0].label.startswith("somebibitem")
    assert result[0].text_edit.new_text == "somebibitem"


@pytest.mark.asyncio
async def test_completion_bibtex(client: LanguageClient):
    "Complete a citation defined in a bibtex file."
    doc_uri = open_doc(client, "child.tex", "latex")
    result = await client.completion_request(doc_uri, 3, 8)
    assert result[0].label.startswith("somepaper")
    assert result[0].text_edit.new_text == "somepaper"
    assert result[0].detail is None


@pytest.mark.asyncio
async def test_completion_citation_fuzzy(client: LanguageClient):
    "Complete a citation defined in 'thebibliogprahy' environment."
    doc_uri = open_doc(client, "file2.tex", "latex")
    result = await client.completion_request(doc_uri, 10, 10)
    assert result[0].label.startswith("somepaper")
    assert result[0].text_edit.new_text == "somepaper"


# Completion with inconsistent root information


@pytest.mark.asyncio
async def test_completion_no_root(client: LanguageClient):
    "Try to complete locally when root document doesn't exist."
    doc_uri = open_doc(client, "child.tex", "latex")
    client.notify_did_change(doc_uri, text="xxxx", line=0, character=14)
    result = await client.completion_request(doc_uri, 4, 8)
    assert result[0].label.startswith("childlabel")


@pytest.mark.asyncio
async def test_completion_broken_root(client: LanguageClient):
    "Try to complete locally when root doesn't refer back to child."
    doc_uri = open_doc(client, "child.tex", "latex")
    client.notify_did_change(doc_uri, text="file1.tex\n", line=0, character=14)
    result = await client.completion_request(doc_uri, 4, 8)
    assert result[0].label.startswith("childlabel")


@pytest.mark.asyncio
async def test_completion_from_root_no_root(client: LanguageClient):
    "Try to complete label from root document when it doesn't exist."
    doc_uri = open_doc(client, "child.tex", "latex")
    result = await client.completion_request(doc_uri, 2, 8)
    assert result[0].label.startswith("rootlabel")
    client.notify_did_change(doc_uri, text="xxxx", line=0, character=14)
    result = await client.completion_request(doc_uri, 2, 8)
    assert result == []


# Tests for textDocument/definition method


@pytest.mark.asyncio
async def test_definition(client: LanguageClient):
    "Find the definition Try to complete locally when root doesn't refer back to child."
    doc_uri = open_doc(client, "file1.tex", "latex")
    result = await client.definition_request(doc_uri, 7, 6)
    assert result == Location(
        uri=doc_uri,
        range=Range(
            start=Position(line=4, character=7), end=Position(line=4, character=16)
        ),
    )


# Tests for textDocument/references method


@pytest.mark.asyncio
async def test_references(client: LanguageClient):
    "Find references in a single file."
    doc_uri = open_doc(client, "file1.tex", "latex")
    result = await client.text_document_references_request(
        ReferenceParams(
            context=ReferenceContext(include_declaration=True),
            text_document=TextDocumentIdentifier(uri=doc_uri),
            position=Position(line=7, character=6),
        )
    )
    assert len(result) == 2
    assert result[0] == Location(
        uri=doc_uri,
        range=Range(
            start=Position(line=4, character=7), end=Position(line=4, character=16)
        ),
    )
    assert result[1] == Location(
        uri=doc_uri,
        range=Range(
            start=Position(line=7, character=5), end=Position(line=7, character=14)
        ),
    )


@pytest.mark.asyncio
async def test_references_across_files(client: LanguageClient):
    "Find references across file."
    root_uri = open_doc(client, "root.tex", "latex")
    child_uri = open_doc(client, "child.tex", "latex")
    result = await client.text_document_references_request(
        ReferenceParams(
            context=ReferenceContext(include_declaration=True),
            text_document=TextDocumentIdentifier(uri=root_uri),
            position=Position(line=3, character=13),
        )
    )
    assert len(result) == 2
    assert result[0] == Location(
        uri=child_uri,
        range=Range(
            start=Position(line=1, character=7), end=Position(line=1, character=17)
        ),
    )
    assert result[1] == Location(
        uri=root_uri,
        range=Range(
            start=Position(line=3, character=5), end=Position(line=3, character=15)
        ),
    )


# Tests for textDocument/hover method


@pytest.mark.asyncio
async def test_hover_command(client: LanguageClient):
    "Find command documentation."
    doc_uri = open_doc(client, "file2.tex", "latex")
    result = await client.hover_request(doc_uri, 1, 5)
    assert result.contents.kind == MarkupKind.Markdown
    assert result.contents.value.startswith("`\\relax`:")
    assert "do nothing" in result.contents.value


@pytest.mark.asyncio
async def test_hover_label(client: LanguageClient):
    "Find context around a label."
    doc_uri = open_doc(client, "file2.tex", "latex")
    result = await client.hover_request(doc_uri, 0, 5)
    assert result.contents.kind == MarkupKind.Markdown
    assert result.contents.value.startswith("`somelabel`:")
    assert "Lorem ipsum" in result.contents.value
    assert "minim veniam" in result.contents.value
