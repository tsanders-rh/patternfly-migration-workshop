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

**Exercise 1: Tier 1 Fixes**
```bash
git checkout -b tier1-fixes
# ... make fixes ...
git add -A && git commit -m "Apply Tier 1 fixes"
```

**Exercise 2: Tier 2 Fixes**
```bash
git checkout -b tier2-fixes
# ... make fixes ...
git add -A && git commit -m "Apply Tier 2 fixes"
```

**Exercise 3: Tier 3 Manual Fixes**
```bash
git checkout -b tier3-fixes
# ... make fixes ...
git add -A && git commit -m "Apply Tier 3 manual fixes"
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

# VS Code - Konveyor Extension

**Load Analysis Results**

1. Open Konveyor view in sidebar
2. Click "Load Analysis Results"
3. Select `analysis-results/output.yaml`

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

✅ Fix ~150+ violations across 3 tiers  
✅ Learn when to trust AI vs manual review  
✅ Practice incremental git workflow  
✅ Understand PatternFly v5→v6 migration patterns

**Remember:** The goal isn't perfection—it's learning when AI helps and when you need to intervene!

# Resources

- **Full Guide:** `docs/PARTICIPANT_GUIDE.md`
- **AI Setup:** `docs/AI_PROVIDERS.md`
- **Workshop Guide:** `docs/WORKSHOP_GUIDE.md`
- **GitHub Repo:** https://github.com/tsanders-rh/patternfly-migration-workshop
- **Help:** Ask facilitator or check Slack #konveyor
