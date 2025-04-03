# 🛠 Setup – How to Publish Release Notes to GitHub

This document provides a production-grade approach to managing release notes using `git-cliff`, GitHub Releases, and CI/CD practices for scaling with modern engineering teams.

---

## ✅ 1. Generate the Changelog with a Tag

Create a release tag and generate changelog entries grouped by commit type:

```bash
git tag -a v1.0.0 -m "release: v1.0.0 – production-ready bookbot"
git push origin v1.0.0

git-cliff -o CHANGELOG.md --tag v1.0.0
```

This outputs a structured section like:

```markdown
## [v1.0.0] – 2025-04-03

### 🚀 Features
- Add collaborative filtering engine for book suggestions

### 🛠 Chores
- Setup git-cliff changelog guide
```

> 🧠 Tip: This uses conventional commits (e.g., `feat:`, `fix:`, `docs:`) to auto-group changes.

---

## ✅ 2. Create a GitHub Release (Manual or Automated)

### A. Manual via GitHub UI
1. Go to your GitHub repo → **Releases** → **Draft a new release**
2. Fill in:
   - **Tag**: `v1.0.0`
   - **Title**: `v1.0.0 – Initial Production Setup`
   - **Body**: Paste the corresponding section from `CHANGELOG.md`

### B. Automated via GitHub Actions
Automate changelog creation and publishing:

```yaml
name: 🚀 GitHub Release

on:
  push:
    tags:
      - 'v*.*.*'

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install git-cliff
        uses: taiki-e/install-action@v2
        with:
          tool: git-cliff

      - name: Generate release notes
        run: git-cliff -o release-notes.md

      - name: Publish GitHub release
        uses: softprops/action-gh-release@v1
        with:
          body_path: release-notes.md
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

> 📌 This ensures changelog updates are CI-driven and always match the tag pushed.

---

## 🧩 How to Onboard Your Team

Use this developer-friendly reference to enforce consistency:

```markdown
# 📦 How We Do Releases

### 🔖 Step 1: Tag the release
```bash
git tag -a v1.2.0 -m "release: v1.2.0"
git push origin v1.2.0
```

### 📄 Step 2: Generate changelog
```bash
git-cliff -o CHANGELOG.md --tag v1.2.0
```

### 🚀 Step 3: Publish release notes
Copy the latest version block from `CHANGELOG.md` → GitHub → Releases → New Release
```

> ✅ Best used at the end of every sprint or feature freeze.

---

## ⚠️ Common Mistakes & Troubleshooting

### ❌ Problem: Duplicate version sections in `CHANGELOG.md`
```markdown
## [0.1.0] – 2025-04-03
### 📚 Documentation
...
## [0.1.0] – 2025-04-03
### 🚀 Features
...
```

### 📉 Root Cause
- The same tag (e.g., `v0.1.0`) was applied to **multiple commits**, causing `git-cliff` to duplicate the version block.

### ✅ Solution: Retag Properly
```bash
git tag -d v0.1.0
git push origin :refs/tags/v0.1.0

git tag -a v0.1.0 -m "release: v0.1.0 – feature + docs"
git push origin v0.1.0

git-cliff -o CHANGELOG.md --tag v0.1.0
```

### 🔍 Validate the tag scope
```bash
git show v0.1.0
```
Ensure it includes all intended commits (features, docs, fixes, etc.)

### 🧠 Rule of Thumb
> Always tag **only once**, at the **tip of the commit history**, after all PRs and merges are complete.

---

## ✅ Recap — Release Notes Lifecycle

```text
[Commits (feat/fix/docs)] → [Tag created] → [git-cliff generates version block] → [GitHub release published]
```

Benefits:
- 🔍 Full traceability of shipped changes
- 📢 Team visibility and external communication
- ✅ Audit & compliance-ready
- 🚀 CI/CD-ready automation pipeline

---

## 📚 Further Reading & Tools

- [`git-cliff` Documentation](https://git-cliff.org/docs)
- [Conventional Commits Standard](https://www.conventionalcommits.org/en/v1.0.0/)
- [GitHub Release Notes](https://docs.github.com/en/repositories/releasing-projects-on-github)
- [softprops/action-gh-release](https://github.com/softprops/action-gh-release)

> Consider linking this guide in your `README.md`, `CONTRIBUTING.md`, or `docs/index.md` for easy access.

