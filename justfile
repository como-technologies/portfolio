# Default: list available recipes
default:
    @just --list

# Install project dependencies and tools
init:
    cargo install mdbook mdbook-mermaid mdbook-gruvbox

# Run all CI checks (used by .github/workflows/ci.yml)
ci: verify-claims book adr-check

# The truthfulness gate (ADR-0003): assert the book's load-bearing claims
# against the sibling repos, each resolved by the suite convention
# (ADR-0004): COMO_<REPO>_DIR -> sibling ../<name> -> .como/deps clone
# cache at the script's declared pin -> skip-with-notice naming the knobs.
verify-claims:
    python3 scripts/verify-claims

# Build the book
book:
    mdbook build

# Re-extract the per-run dogfood evidence pages (src/loop/dogfood/run-N.md)
# from the captured full-loop run directories in the workspace evidence
# ledger (${COMO_DOCS_DIR:-../docs}/iteration-N/run-N — a local-only git
# repo by policy: no remote, never pushed, never cloned). With no RUN_DIR
# every committed run is refreshed, so a new run's directory is picked up
# when it lands and breaks nothing beforehand. Deterministic and idempotent.
refresh-evidence RUN_DIR="":
    python3 scripts/refresh-evidence {{RUN_DIR}}

# Validate the adr/ corpus with adroit, resolved by the suite's uniform
# convention (ADR-0004; self-contained — never sourced from a sibling):
# ADROIT_BIN -> sibling ../adroit build (release preferred over debug;
# NOTE: a fresh sibling build now beats a stale PATH install) -> PATH ->
# gitignored .como/tools clone cache (an existing cache is always used; a
# fresh `cargo install --git` is attempted only when COMO_GIT_BASE is set
# and COMO_OFFLINE isn't, keeping ci fast and offline-safe) ->
# skip-with-notice. Advisory gate: it never fails the build when absent.
adr-check:
    #!/usr/bin/env bash
    set -u
    bin=""
    if [ -n "${ADROIT_BIN:-}" ]; then
        bin="${ADROIT_BIN}"
    elif [ -x ../adroit/target/release/adroit ]; then
        bin=../adroit/target/release/adroit
    elif [ -x ../adroit/target/debug/adroit ]; then
        bin=../adroit/target/debug/adroit
    elif command -v adroit >/dev/null 2>&1; then
        bin=adroit
    elif [ -x .como/tools/bin/adroit ]; then
        bin=.como/tools/bin/adroit
    elif [ "${COMO_OFFLINE:-0}" != "1" ] && [ -n "${COMO_GIT_BASE:-}" ]; then
        url="${COMO_GIT_BASE}/adroit.git"
        echo "adr-check: installing adroit from ${url} into .como/tools (first run only)"
        if cargo install --git "${url}" --locked --root .como/tools adroit; then
            bin=.como/tools/bin/adroit
        fi
    fi
    if [ -n "${bin}" ]; then
        "${bin}" check --dir src/adr
    else
        echo "skip: adroit not found (set ADROIT_BIN, build ../adroit, install adroit on PATH, or set COMO_GIT_BASE to arm the .como/tools cached install)"
    fi

# Serve the book locally with live reload
book-serve:
    mdbook serve --open

# Run mdbook tests (validates code blocks)
book-test:
    mdbook test

# Clean built book artifacts
book-clean:
    rm -rf target/book

# Clean all build artifacts
clean:
    rm -rf target
