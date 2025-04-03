# Pre-commit Guide for Python Projects

This document helps you understand and configure `pre-commit` to automatically enforce code quality and hygiene before you commit your changes.

## 🚀 What is pre-commit?

`pre-commit` is a lightweight framework that lets you run scripts on your code automatically before each `git commit`. These scripts (called "hooks") catch common issues like syntax errors, bad formatting, unused imports, and large file mistakes — before they make it to version control.

---

## ✅ Why Use It?

- Consistent code style across contributors
- Auto-fix formatting and import order
- Detect errors before they get committed
- Prevent committing large files, secrets, or broken YAML
- Boost confidence in your commits

---

## 📦 Installation

```bash
pip install pre-commit
pre-commit install
```

---

## 🛠️ `.pre-commit-config.yaml` Hooks Breakdown

Here's a breakdown of the hooks used in the `pre-commit-config.yaml` shown in your setup:

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: check-merge-conflict          # ❌ Prevent committing unresolved merge conflicts
      - id: trailing-whitespace           # 🧹 Remove trailing whitespace in all files
        args: [--markdown-linebreak-ext=md]
      - id: end-of-file-fixer             # ✅ Ensure each file ends with a newline
      - id: check-toml                    # ✅ Validate TOML syntax
      - id: check-yaml                    # ✅ Validate YAML syntax (unsafe: structure-only)
        args: ["--unsafe"]
      - id: check-symlinks                # 🚫 Detect broken symbolic links
      - id: check-added-large-files       # ⚠️ Prevent committing files over 500kb
        args: ["--maxkb=500"]

  - repo: https://github.com/PyCQA/pylint
    rev: v3.0.0a6
    hooks:
      - id: pylint                        # 📏 Run Pylint with defined rules
        args: [--rcfile=.pylintrc]

  - repo: https://github.com/charliermarsh/ruff-pre-commit
    rev: v0.0.261
    hooks:
      - id: ruff                          # 🏎️ Fast all-in-one linter (replaces flake8, isort)
        args: [--fix, --exit-non-zero-on-fix, --config=ruff.toml]

  - repo: https://github.com/pycqa/isort
    rev: 5.12.0
    hooks:
      - id: isort                         # 🗂️ Auto-organize imports
        name: isort (python)
        args: [--settings=.isort.cfg]

  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.2.0
    hooks:
      - id: mypy                          # 🧠 Type-check Python using type hints

  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: requirements-txt-fixer        # 🧾 Sort and deduplicate requirements.txt
      - id: forbid-new-submodules         # 🚫 Prevent adding Git submodules
      - id: no-commit-to-branch           # 🛡️ Block commits to trunk/default branch
        args: ["--branch=trunk"]
      - id: detect-aws-credentials        # 🔐 Catch accidentally committed AWS credentials
      - id: detect-private-key            # 🔐 Detect committed private SSH keys
```

---

## 🔁 Usage

Once installed, `pre-commit` runs automatically on each `git commit`. To manually run against all files:

```bash
pre-commit run --all-files
```

You can also temporarily disable a hook using:
```bash
SKIP=hook-id git commit -m "skip specific hook"
```

---

## 📂 Tips for Teams

- ✅ Use pre-commit with a `README.md` badge so contributors know it's enforced
- 🐍 Use `pyproject.toml` to consolidate configs (e.g., black, isort, ruff)
- 🛠️ Enable `--fix` where possible to auto-resolve issues
- 🔒 Prioritize hooks that detect secrets, broken YAML, and large files
- 🔁 Gradually introduce additional hooks after adoption

---

## 🔐 Bonus: Secure your repo

- detect-aws-credentials and detect-private-key are critical for preventing secrets from leaking
- `check-added-large-files` saves you from accidentally bloating your repo
- `no-commit-to-branch` avoids pushing directly to `main` or `trunk` by mistake

---

## 💬 Recommended Hook Order

1. Formatting (black, isort, ruff)
2. Syntax checks (check-yaml, check-toml)
3. Linting (flake8, pylint, ruff)
4. Security (detect-aws-credentials, private keys)
5. Repo hygiene (merge conflict, large files, submodules)

---

## 📦 Further Reading
- [https://pre-commit.com](https://pre-commit.com)
- [Ruff Docs](https://docs.astral.sh/ruff/)
- [Mypy Type Checker](https://mypy.readthedocs.io/)

> "Automated tooling is your first reviewer. Use it well, and let humans focus on the logic."

Happy coding! 🎯

