# FinCEN PDF as HTML

This entire repo and the github pages exist to make it easier for AI tooling to parse and reason about the requirements of FinCEN PDFs and XML formats.

There is a script that reads the files generated in the `htmls` folder and then puts it into the docs.  

The files in the `docs/crawlable` are a "full smash" of _all_ the generated HTML pages from the PDF.  

## How to create a new set of pages

1. Manually download the PDFs from FinCEN (see `pdfs/` folder).
2. Then copy those to the `htmls/MY_FILE/`
3. run `pdftohtml -c FILE`
4. Delete the pdf file from the html folder
5. Run the top level create docs script
6. Should see the new files showing up in the docs
7. push change -- deploys to the http://fincen-docs.garrypolley.com/ a few minutes later
