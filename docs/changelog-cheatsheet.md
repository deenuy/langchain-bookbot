# 🧾 Git Commit & Changelog Cheatsheet

## ✅ For Developers

Use conventional commit format:

| Type     | Purpose                         | Example Commit                                  |
|----------|----------------------------------|--------------------------------------------------|
| `feat:`  | New feature                     | `feat: add user profile card UI`               |
| `fix:`   | Bug fix                         | `fix: correct null pointer in scoring model`   |
| `docs:`  | Documentation only              | `docs: add setup guide for new devs`           |
| `chore:` | Tooling / no user impact change | `chore: update flake8 version`                 |
| `refactor:` | Non-breaking code change     | `refactor: simplify condition logic`           |

> ❗ Do **not** create version tags — let your team lead / release manager handle it.

---

## 🛠️ For Release Manager

```bash
# Run changelog preview
git-cliff -o CHANGELOG.md

# Tag the latest commit on main branch
git tag -a vX.Y.Z -m "release: vX.Y.Z"
git push origin vX.Y.Z

# Generate changelog for that release
git-cliff -o CHANGELOG.md --tag vX.Y.Z

## 🔁 Rule of Thumb
* Developers: Use proper commit types
* Leads: Tag only after all merges are done
* Don’t reuse tags. Always tag once per release.