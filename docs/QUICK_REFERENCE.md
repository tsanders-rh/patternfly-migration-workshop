# PatternFly Migration Workshop - Quick Reference

## Tier Indicators

- 🟢 **[Tier 1]** - Simple changes, safe to auto-apply with quick review
- 🟢 **[Tier 1 - Bulk CSS]** - CSS pattern updates, safe to batch-apply  
- 🟡 **[Tier 2]** - Structural changes, review carefully before applying
- **No tier prefix** - Tier 3 edge cases, requires manual intervention

---

## Exercise Git Workflow

**Exercise 1: Tier 1**
```bash
git checkout -b tier1-fixes
# ... make fixes ...
git add -A
git commit -m "Apply Tier 1 fixes"
```

**Exercise 2: Tier 2**
```bash
git checkout -b tier2-fixes
# ... make fixes ...
git add -A
git commit -m "Apply Tier 2 fixes"
```

**Exercise 3: Tier 3**
```bash
git checkout -b tier3-fixes
# ... make fixes ...
git add -A
git commit -m "Apply Tier 3 manual fixes"
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

✅ Fix ~150+ violations across 3 tiers
✅ Learn when to trust AI vs manual review
✅ Practice incremental git workflow
✅ Understand PatternFly v5→v6 migration patterns

**Remember:** The goal isn't perfection - it's learning when AI helps and when you need to intervene!
