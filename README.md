# Como Technologies Portfolio

The source for the **TAPS Portfolio** book — Como Technologies' living
documentation of its Tools, Apps, Products, and Services and the closed
four-stage modernization loop (Assess → Prescribe → Adopt → Measure) they
serve. It's an [mdBook](https://rust-lang.github.io/mdBook/) site; the prose
lives in [`src/`](src/) and the navigation in [`src/SUMMARY.md`](src/SUMMARY.md).

Start with the rendered [Introduction](src/introduction.md) for what the
portfolio *is*. This README is about how to **build and work on the book**.

## Prerequisites

| Tool | Why | Install |
|---|---|---|
| [Rust toolchain](https://rustup.rs) (`cargo`) | mdBook and its plugins are installed via `cargo install` | `curl https://sh.rustup.rs -sSf \| sh` |
| [`just`](https://github.com/casey/just) | Command runner for every task below | `cargo install just` (or your package manager) |
| `python3` | Only for the CI truthfulness gates (`verify-claims`, `refresh-evidence`) — not needed to read or build the book | preinstalled on most systems |

## Getting started

```sh
# 1. Install mdBook and the book's preprocessors (mdbook, mdbook-mermaid, mdbook-gruvbox)
just init

# 2. Serve the book locally with live reload; opens your browser
just book-serve
```

That's it — edit anything under `src/` and the page reloads. To produce a
static build instead, run `just book` (output lands in `target/book/`).

Run `just` (or `just --list`) any time to see every available recipe.

## Common tasks

| Command | What it does |
|---|---|
| `just init` | Install mdBook + the `mermaid` and `gruvbox` preprocessors |
| `just book-serve` | Serve locally with live reload (opens browser) |
| `just book` | Build the static site into `target/book/` |
| `just book-test` | Validate code blocks in the book |
| `just clean` | Remove all build artifacts |
| `just ci` | Run the full CI suite (see below) |

## CI and the truthfulness gates

`just ci` runs `verify-claims`, `book`, and `adr-check`. The book makes
load-bearing claims about its sibling repos, and these gates assert those
claims against the real code rather than trusting the prose
(see [How this book stays true](src/truthfulness.md)).

`verify-claims` and `adr-check` resolve sibling repos by convention —
`COMO_<REPO>_DIR` env var → sibling checkout under `../<name>` → cached clone —
and **skip with a notice** when a dependency isn't found, so they never block a
plain `just book`. You only need the siblings checked out (e.g. `../adroit`) to
exercise the full gate locally; the build itself needs none of them.

## Layout

```
src/            book content (Markdown); SUMMARY.md is the table of contents
justfile        all tasks — run `just` to list them
book.toml       mdBook configuration
gruvbox/        theme assets
scripts/        verify-claims, refresh-evidence (CI tooling)
```
