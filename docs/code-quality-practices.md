# Code Quality Guidelines for Data Engineering Projects

Welcome to the **Code Quality Guide** for our data engineering repositories. This document outlines how we ensure high-quality, maintainable Python code using industry-standard tools: **Black**, **isort**, **flake8**, **pylint**, and optionally **Ruff**.

> "Good code is not just for computers — it's for humans who maintain it next."

---

## 📘 Python Style Guides (PEP 8 & Google)

### PEP 8 – Python’s Official Style Guide
- Stands for *Python Enhancement Proposal 8*
- Sets the standard for Python formatting and readability
- Covers line length, indentation, naming conventions, whitespace, and more
- **Reference:** [PEP 8 — Style Guide for Python Code](https://peps.python.org/pep-0008/)

### Google Python Style Guide
- Stricter rules over PEP 8 for large engineering teams
- Emphasizes docstrings, module layout, imports, and type hints
- Adapted by many FAANG-scale teams
- **Reference:** [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html)

> We adopt PEP 8 as a baseline with elements of Google’s guide for better scalability and clarity.

---

## 🚀 Why Code Quality Matters

- Reduces bugs early (before runtime)
- Makes collaboration seamless, especially across roles (data engineers, analysts, ML engineers)
- Ensures consistent formatting and readability
- Encourages better onboarding, team handoffs, and knowledge transfer

---

## 🔗 Tools We Use

| Tool      | Purpose                             | Status         |
|-----------|-------------------------------------|----------------|
| **Black** | Auto-formats code consistently      | Mandatory      |
| **isort** | Orders and groups imports properly  | Mandatory      |
| **flake8**| Linting: catches unused vars, bugs  | Mandatory      |
| **pylint**| Enforces best practices & warnings  | Optional       |
| **Ruff**  | Ultra-fast linter + formatter       | Optional/Alt   |
| **mypy**  | Type checker                        | Optional (CI)  |

---

## 🔢 What is Type Hinting?

> 💡 Type hinting is also validated using tools like `mypy`, which checks that your code uses the correct types — catching bugs earlier and enabling better IDE support. Learn more at [mypy.readthedocs.io](https://mypy.readthedocs.io/).?

Type hinting tells Python what kind of data to expect in a function.

**Think of it as "inline documentation + error prevention."**

Without Type Hints:
```python
def get_customer(customer_id):
    pass  # Is id an int? str? UUID?
```

With Type Hints:
```python
def get_customer(id: str) -> dict:
    pass
```

> ✅ Now, any teammate instantly knows the expected input/output.

### Why Type Hinting Matters:
- Catches bugs before runtime
- Makes function intent clear
- Improves IDE suggestions and autocompletion
- Helps reviewers understand usage without reading all the code

---

## 📊 Example from Data Engineering

```python
# BEFORE

def calculate_discount(price, rate):
    return price * rate

# Bug: calculate_discount("100", 0.1) → "100100100100100100100100100100"

# AFTER

def calculate_discount(price: float, rate: float) -> float:
    return price * rate
```

> mypy catches the bug: `str` instead of `float`

---

## 🐞 Logging & Typing Catch Bugs Early

### 🐞 Example 1: Logging Catches Incomplete Workflow

```python
def process_file(file_path: str):
    df = pd.read_csv(file_path)
    # process and save
    print("done")
```

🚫 No logging = no visibility when failures occur on production datasets.

✅ With logging:

```python
import logging

logger = logging.getLogger(__name__)

def process_file(file_path: str):
    logger.info(f"Reading file: {file_path}")
    try:
        df = pd.read_csv(file_path)
    except Exception as e:
        logger.error(f"Failed to read {file_path}: {e}", exc_info=True)
        raise
    logger.info("File processed successfully")
```

💥 **Bug caught**: missing file path or corrupted file → logged with stack trace instead of silent failure or misleading "done" message.

---

### 🐞 Example 4: Logging + Typing in ETL Pipeline

```python
def extract_orders(date):
    logger.info("Running ETL")
    return db.query(f"SELECT * FROM orders WHERE date = {date}")
```

🚫 Runtime bug:
- `date = datetime` ➡️ f-string will produce invalid SQL.
- No query logging = blind SQL injection risk.

✅ Better:

```python
from datetime import date as dt_date
from typing import Union

def extract_orders(date: Union[str, dt_date]) -> pd.DataFrame:
    logger.info(f"Extracting orders for {date}")
    if isinstance(date, dt_date):
        date = date.strftime("%Y-%m-%d")
    query = f"SELECT * FROM orders WHERE date = '{date}'"
    logger.debug(f"Running query: {query}")
    return db.query(query)
```

💥 **Bug caught**: datetime-to-string conversion avoided SQL failure. Logs helped debug failures in test vs prod.

---

## ✨ Black: Code Auto Formatter

**Usage:**
```bash
black .
```

**Before**:
```python
def get_data(x,y): return x+y
```

**After**:
```python
def get_data(x, y):
    return x + y
```

---

## 🗂️ isort: Organize Imports

**Usage:**
```bash
isort .
```

**Before**:
```python
import os
import pandas as pd
import json
```

**After**:
```python
import json
import os

import pandas as pd
```

---

## 🔍 flake8: Find Common Errors

**Usage:**
```bash
flake8 .
```

**Example Output**:
```
app.py:1:1: F401 'os' imported but unused
app.py:10:1: E302 expected 2 blank lines, found 1
app.py:16:1: E302 expected 2 blank lines, found 1
app.py:25:1: W391 blank line at end of file
```

**What it catches:**
- Unused imports
- Improper spacing and blank lines
- Inconsistent indentation
- Shadowed variables

**Additional Example – Catching a Mistake**:
```python
def run_etl():
  df = pd.read_csv("data.csv")
  return df

  df = df.dropna()  # unreachable code
```

**flake8 warning:**
```
W391: Unreachable code detected
```

---

## 🧠 Pylint: Static Analysis with Scores

**Usage:**
```bash
pylint your_script.py
```

**Benefits:**
- Gives a score (0-10) to measure code quality
- Warns about variables not used, not defined, too many arguments, etc.

**Example Output:**
```
E:  6,0: Undefined variable 'resut' (undefined-variable)
W: 10,4: Redundant assignment to 'total' (redundant-assignment)
C:  1,0: Missing module docstring (missing-docstring)
```

**Tip:** Use pylint as a CI quality gate for shared utilities.

---

## 🌈 Ruff (Optional)

> 💡 Ruff also supports configuration via `pyproject.toml`, aligning with tools like Black and isort for a unified config experience.

**Why Ruff?** Lightning fast, single-binary alternative to flake8 + isort + pyflakes + more.

**Usage:**
```bash
ruff check .
ruff format .
```

**Ruff catches:**
- Dead code (`unused variables`, `imports`)
- Style issues (like `f-string` instead of `.format()`)
- Simplifications (e.g., `len(x) == 0` → `not x`)

**Example Fixes:**
```python
# Before
print("Name: {}".format(name))

# After
print(f"Name: {name}")
```

---

## ⚡ Logging: Don't Fly Blind

**Before**:
```python
print("Done")
```

**After**:
```python
import logging
logger = logging.getLogger(__name__)
logger.info("File processed successfully")
logger.error("Failed to process file", exc_info=True)
```

> Logging gives you visibility into failures in prod, not just on your laptop.

---

## 🔄 Recommended Workflow

1. Save your code
2. Run:
```bash
./run-code-quality-check.sh
```
3. Fix any issues reported
4. Commit your changes

---

## 💡 Pro Tips for Team Adoption

- Consider using `pre-commit` for auto-running quality checks before each commit. Start with optional hooks and expand as confidence builds.
- Example config:
```yaml
repos:
  - repo: https://github.com/psf/black
    rev: 23.9.1
    hooks:
      - id: black

  - repo: https://github.com/pre-commit/mirrors-isort
    rev: v5.12.0
    hooks:
      - id: isort

  - repo: https://github.com/pycqa/flake8
    rev: 6.1.0
    hooks:
      - id: flake8
```

- Setup:
```bash
pip install pre-commit
pre-commit install
```
- Run manually:
```bash
pre-commit run --all-files
```

- Add type hints **gradually** (public functions, return types)
- Prefer `black` and `isort` for auto-fixable changes
- Use flake8 and pylint for alerts (non-blocking at first)
- Use `mypy` or `ruff` in CI pipeline

---

## 🔢 Summary Table

| Bug Type                       | Tool          | Why It Mattered                                   |
|-------------------------------|---------------|---------------------------------------------------|
| Silent string multiplication  | `mypy`        | Prevented logic bug with type enforcement         |
| File I/O failure              | `logging`     | Showed missing path with exception trace          |
| Variable reuse (shadowing)    | `flake8`      | Detected overwritten variables                    |
| Missing function docstring    | `pylint`      | Prompted better documentation                    |
| F-string vs format() warning  | `ruff`        | Simplified syntax and improved readability        |

---

## 🔧 TL;DR Developer Checklist

> Tip: **Ruff** can replace both `flake8` and `isort` if configured properly in `pyproject.toml`. Great for teams consolidating tools or speeding up CI pipelines.

```bash
# Step 1: Setup
pip install black isort flake8 pylint ruff

# Step 2: Run checks
black .
isort .
flake8 .
pylint your_script.py
ruff check .  # Optional
```

> "Start simple. Improve daily. Code is teamwork."

---

Let's write clean, professional, and production-grade Python, one commit at a time. 🚀