# PatternFly Migration Workshop - Quick Reference

## Tier Indicators

- 🟢 **[Tier 1]** - Simple changes, safe to auto-apply with quick review
- 🟢 **[Tier 1 - Bulk CSS]** - CSS pattern updates, safe to batch-apply  
- 🟡 **[Tier 2]** - Structural changes, review carefully before applying
- **No tier prefix** - Tier 3 edge cases, requires manual intervention

---

## Exercise Git Workflow

**Exercise 1: Tier 1 Bulk CSS**
```bash
git checkout -b tier1-css-fixes
# ... apply ~120 CSS fixes ...
git add src/styles/ src/components/tier1-simple/PageHeader.css
git commit -s -m "Apply Tier 1 Bulk CSS fixes (v5→v6 prefixes)"
```

**Exercise 2: Component Changes**
```bash
git checkout -b tier1-component-fixes
# Part A: Tier 1 component renames (~15-20 fixes)
git add .
git commit -s -m "Apply Tier 1 component renames (Text→Content, Chip→Label)"

# Part B: Tier 2 structural changes (~10-15 fixes)
git add .
git commit -s -m "Apply Tier 2 structural changes (MenuToggle, EmptyState)"
```

**Exercise 3: Edge Cases**
```bash
# Continue on tier1-component-fixes branch
# ... manual fixes and rejections ...
git add .
git commit -s -m "Handle Tier 3 edge cases (manual review)"
```

---

## Common Commands

**Run Analysis:**
```bash
kantra analyze \
  --input . \
  --rules ../rulesets/preview/nodejs/patternfly \
  --output ./analysis-results \
  --source patternfly-v5 \
  --target patternfly-v6 \
  --enable-default-rulesets=false
```

**Test Your Code:**
```bash
npm test                    # Run unit tests
npm run dev                 # Start dev server
```

**Verify Migration:**
```bash
npm run build              # Production build
```

---

## VS Code - Konveyor AI (Kai)

**Configure & Run Analysis:**
1. Add AI credentials to `.vscode/settings.json`
2. Open Konveyor sidebar
3. Click "Analyze workspace"
4. Wait ~30-60 seconds for Kai to analyze

**Get AI Solution:**
1. Expand a violation
2. Click "Get solution"
3. Review AI reasoning carefully
4. Click "Apply" if correct

**Keyboard Shortcuts:**
- `Cmd/Ctrl + Shift + P` - Command palette
- `Cmd/Ctrl + P` - Quick file open
- `Cmd/Ctrl + B` - Toggle sidebar

---

## Troubleshooting

**AI not responding:**
- Check API key in `.vscode/settings.json`
- Verify internet connection
- Try regenerating solution

**Tests failing:**
- Read error message carefully
- Check for syntax errors
- Verify imports are correct
- Run `npm run dev` to see runtime errors

**Can't find violation:**
- Use Konveyor search/filter
- Check file path matches
- Reload analysis if needed

---

## Resources

- Full Guide: `docs/PARTICIPANT_GUIDE.md`
- AI Setup: `docs/AI_PROVIDERS.md`
- Workshop Guide: `docs/facilitator/WORKSHOP_GUIDE.md`
- Help: Ask facilitator or check Slack

---

## Workshop Goals

✅ Fix ~200+ violations across 3 exercises
✅ Build confidence with CSS bulk fixes (~120 violations, 99% success)
✅ Learn when to trust AI vs manual review
✅ Practice incremental git workflow
✅ Understand complexity tiers: ultra-safe → careful review → manual

**Remember:** Exercise 1 builds confidence with high-volume, ultra-safe fixes. Exercise 2 teaches careful review. Exercise 3 demonstrates when to reject AI suggestions!
