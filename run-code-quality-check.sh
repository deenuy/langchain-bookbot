#!/bin/bash

# ==============================================================================
# SCRIPT: run-code-quality-check.sh
# PURPOSE: Enforces basic Python code quality using Black, isort, and Flake8
# AUTHOR: Your Team Name / Engineering Ops
# USAGE: ./run-code-quality-check.sh
# NOTE: Intended for local dev or CI pipelines (Unix-compatible)
# ==============================================================================

set -e  # Exit on first error

# Optional timestamping (comment out if not needed)
timestamp=$(date +"%Y-%m-%d %H:%M:%S")

echo ""
echo "=============================================================================="
echo "🔍 [${timestamp}] Starting Python Code Quality Checks"
echo "=============================================================================="
echo ""

# ------------------------------------------------------------------------------
# Step 1: Define directories/files to exclude from quality checks
# ------------------------------------------------------------------------------
EXCLUDES="--exclude .venv,notebooks,tests,data"

# ------------------------------------------------------------------------------
# Step 2: Dependency check for required tools
# ------------------------------------------------------------------------------
echo "[INFO] Verifying required tools: black, isort, flake8 ..."
for tool in black flake8 isort; do
  if ! command -v $tool &> /dev/null; then
    echo "[ERROR] '$tool' is not installed. Please run: pip install $tool"
    exit 1
  fi
done
echo "[OK] All tools are available."
echo ""

# ------------------------------------------------------------------------------
# Step 3: Apply isort to reorder Python imports
# ------------------------------------------------------------------------------
echo "[STEP] Running isort (import sorting)..."
isort . --skip .venv --skip notebooks --skip tests
echo "[OK] Import sorting complete."
echo ""

# ------------------------------------------------------------------------------
# Step 4: Apply black to auto-format code
# ------------------------------------------------------------------------------
echo "[STEP] Running black (auto formatter)..."
black . --exclude '(\.venv|notebooks|tests)'
echo "[OK] Code formatting complete."
echo ""

# ------------------------------------------------------------------------------
# Step 5: Run flake8 for remaining lint violations
# ------------------------------------------------------------------------------
echo "[STEP] Running flake8 (PEP8 lint checker)..."
flake8 . $EXCLUDES
flake_status=$?

if [ $flake_status -ne 0 ]; then
  echo "[WARN] flake8 found issues. Please review and fix manually."
else
  echo "[OK] flake8 passed. No style violations detected."
fi
echo ""

# ------------------------------------------------------------------------------
# Summary
# ------------------------------------------------------------------------------
echo "=============================================================================="
echo "✅ Code Quality Check Complete – Status Summary"
echo "    ✔ isort - Imports organized"
echo "    ✔ black - Code formatted"
[ $flake_status -eq 0 ] && echo "    ✔ flake8 - Clean" || echo "    ⚠ flake8 - Issues found"
echo "=============================================================================="
echo ""

# Exit code: flake8 status drives success/failure signal
exit $flake_status
# End of script
# ==============================================================================
# Note: This script is intended for Unix-like environments. Adjustments may be needed for Windows.