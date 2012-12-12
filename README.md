# Dart Cookbook

This project contains the source and code for the `Dart Cookbook`

## Project Structure

### README.md:
This file.

### AUTHORS: 
The names of the authors of the recipes.

### recipes/:

The recipes, organized by subject (strings, HTML5, etc.). Inside
each subfoler, the recipes are presented as complete Dart applications.

### src/:

The source of the book stored in a single file, index.md. Code snippets extracted
from the recipes are designated by calls to MERGE(name_of_snippet) in this file.
`doc_code_merge` is used to generate a new directory with the snippets
filled out with real code. Usage:
    doc_code_merge src/ recipes/ book/

You can read more about `doc_code_merge` at
[https://github.com/dart-lang/doc-code-merge/](https://github.com/dart-lang/doc-code-merge/)

### book/
index.md and /index.html contain the readable source of the book.

