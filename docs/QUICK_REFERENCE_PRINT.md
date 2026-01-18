---
title: PatternFly Migration Workshop
subtitle: Quick Reference Card
geometry: margin=0.75in
fontsize: 10pt
colorlinks: true
---

# Tier Indicators

| Indicator | Description |
|-----------|-------------|
| 🟢 **[Tier 1]** | Simple changes, safe to auto-apply with quick review |
| 🟢 **[Tier 1 - Bulk CSS]** | CSS pattern updates, safe to batch-apply |
| 🟡 **[Tier 2]** | Structural changes, review carefully before applying |
| **No tier prefix** | Tier 3 edge cases, requires manual intervention |

# Exercise Git Workflow

**Exercise 1: Bulk CSS (~120 fixes)**
```bash
git checkout -b tier1-css-fixes
# ... apply CSS fixes ...
git add src/styles/ src/components/tier1-simple/PageHeader.css
git commit -s -m "Apply Tier 1 Bulk CSS fixes"
```

**Exercise 2: Components (~25-35 fixes)**
```bash
git checkout -b tier1-component-fixes
# Part A: Component renames
git add . && git commit -s -m "Tier 1 component renames"
# Part B: Structural changes
git add . && git commit -s -m "Tier 2 structural changes"
```

**Exercise 3: Edge Cases (~5-10 decisions)**
```bash
# Continue on tier1-component-fixes
# ... manual review and rejections ...
git add . && git commit -s -m "Tier 3 edge cases"
```

# Common Commands

**Run Konveyor Analysis**
```bash
kantra analyze \
  --input . \
  --rules ../rulesets/preview/nodejs/patternfly \
  --output ./analysis-results \
  --source patternfly-v5 \
  --target patternfly-v6 \
  --enable-default-rulesets=false
```

**Test Your Code**
```bash
npm test                # Run unit tests
npm run dev            # Start dev server (http://localhost:3000)
npm run build          # Production build
```

\newpage

# VS Code - Konveyor AI (Kai)

**Configure & Run Analysis**

1. Add AI credentials to `.vscode/settings.json`
2. Open Konveyor view in sidebar
3. Click "Analyze workspace"
4. Wait ~30-60 seconds for Kai to analyze

**Generate AI Solution**

1. Expand a violation
2. Click "Get solution"
3. Review AI reasoning carefully
4. Click "Apply" if correct

**Keyboard Shortcuts**

| Shortcut | Action |
|----------|--------|
| `Cmd/Ctrl + Shift + P` | Command palette |
| `Cmd/Ctrl + P` | Quick file open |
| `Cmd/Ctrl + B` | Toggle sidebar |
| `Cmd/Ctrl + /` | Toggle comment |
| `Cmd/Ctrl + D` | Select next occurrence |

# Troubleshooting

**AI Not Responding**

- Check API key in `.vscode/settings.json`
- Verify internet connection
- Try regenerating solution
- Ask facilitator for help

**Tests Failing**

- Read error message carefully
- Check for syntax errors (missing commas, brackets)
- Verify imports are correct
- Run `npm run dev` to see runtime errors in browser

**Can't Find Violation**

- Use search/filter in Konveyor view
- Check file path matches exactly
- Reload analysis if needed (`Cmd/Ctrl + Shift + P` → "Reload")

# Workshop Goals

✅ Fix ~200+ violations across 3 exercises
✅ Build confidence with CSS bulk fixes (~120, 99% success)
✅ Learn when to trust AI vs manual review
✅ Practice incremental git workflow
✅ Understand complexity tiers: ultra-safe → careful → manual

**Remember:** Ex1 builds confidence (bulk CSS). Ex2 teaches review (components). Ex3 shows when to reject AI!

# Resources

- **Full Guide:** `docs/PARTICIPANT_GUIDE.md`
- **AI Setup:** `docs/AI_PROVIDERS.md`
- **Workshop Guide:** `docs/facilitator/WORKSHOP_GUIDE.md`
- **GitHub Repo:** https://github.com/tsanders-rh/patternfly-migration-workshop
- **Help:** Ask facilitator or check Slack #konveyor
