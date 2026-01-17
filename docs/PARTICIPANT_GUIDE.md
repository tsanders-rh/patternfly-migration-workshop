# PatternFly Migration Workshop - Participant Guide

Welcome! This guide will walk you through today's hands-on exercises.

---

## Workshop Overview

**What You'll Do Today:**
- Apply AI-assisted fixes to ~50+ PatternFly v5→v6 violations
- Learn when to trust AI vs manual intervention
- Practice incremental migration with git branches

**Three Tiers:**
- **Tier 1** (30 min): Simple changes - component renames, props, CSS
- **Tier 2** (45 min): Moderate complexity - structural refactoring
- **Tier 3** (30 min): Edge cases - when AI needs your help

**How to Identify Tiers:**

Violations in VS Code will be prefixed with colored tier indicators:
- **🟢 `[Tier 1]`** - Simple changes, safe to auto-apply with quick review
- **🟢 `[Tier 1 - Bulk CSS]`** - CSS pattern updates, safe to batch-apply
- **🟡 `[Tier 2]`** - Structural changes, review carefully before applying
- **No tier prefix** - You'll identify Tier 3 by context (see Exercise 3)

---

## Day-of Quick Start

### Before Exercise 1

**1. Verify your setup:**

```bash
# Should be in workshop directory
cd patternfly-migration-workshop

# Verify app runs
npm run dev
# Open http://localhost:3000 in browser

# Verify tests pass (Ctrl+C to stop dev server first)
npm test
```

**2. Run Kantra Analysis:**

```bash
# Run analysis on the codebase
kantra analyze \
  --input . \
  --rules ../rulesets/preview/nodejs/patternfly \
  --output ./analysis-results \
  --source patternfly-v5 \
  --target patternfly-v6 \
  --enable-default-rulesets=false
```

**Note:** This should take 30-60 seconds. Kantra will:
- Scan all your source files
- Apply PatternFly v5→v6 migration rules
- Generate a report with ~274 violations (including ~123 CSS)

**3. Explore the Static HTML Report:**

Open the report in your browser:

```bash
open analysis-results/static-report/index.html
# On Windows: start analysis-results/static-report/index.html
# On Linux: xdg-open analysis-results/static-report/index.html
```

**What you'll see:**
- **Summary page**: Overview of all violations by rule
- **24 issues** with **274 total incidents** (violations)
- Click on any issue to see:
  - Affected files
  - Specific line numbers
  - Migration guidance
  - Code snippets

**Take 5 minutes to explore:**
- Which rules have the most violations?
- What files are most affected?
- Notice the tier prefixes: 🟢 [Tier 1] vs 🟡 [Tier 2]

**4. Open in VS Code:**

```bash
code .
```

**5. Configure Konveyor AI (Kai):**

The Konveyor VS Code extension runs its own analysis with AI integration.

Add shared Bedrock credentials to `.vscode/settings.json`:

```json
{
  "konveyor.ai.provider": "bedrock",
  "konveyor.ai.bedrock.region": "us-east-1",
  "konveyor.ai.bedrock.model": "anthropic.claude-sonnet-4-5-20250929-v1:0",
  "konveyor.ai.bedrock.accessKeyId": "GET_FROM_FACILITATOR",
  "konveyor.ai.bedrock.secretAccessKey": "GET_FROM_FACILITATOR",
  "konveyor.analyzerPath": "../rulesets/preview/nodejs/patternfly"
}
```

**Or use your own API key:** See [AI_PROVIDERS.md](./AI_PROVIDERS.md)

**6. Run Kai Analysis:**

- Open Konveyor view in VS Code (sidebar icon)
- Click "Analyze workspace" or select the workspace folder
- Kai will run analysis using the PatternFly rules (~30-60 seconds)
- You should see ~274 violations organized by file with AI-powered context

**7. Test AI Integration:**

- In Konveyor view, expand any violation
- Click "Get solution"
- If you see AI-generated reasoning → ✅ You're ready!

---

## Exercise 1: Tier 1 - Quick Wins (30 minutes)

**Goal**: Apply simple, high-confidence AI fixes

### Step 1: Create Your Branch

```bash
git checkout -b tier1-fixes
```

### Step 2: Find Tier 1 Violations

In Konveyor view, look for violations prefixed with **`[Tier 1]`** or **`[Tier 1 - Bulk CSS]`**:

- **`[Tier 1]`** Imports of Text should reference Content
- **`[Tier 1]`** Chip component should be replaced with Label
- **`[Tier 1]`** isDisabled prop should be updated to disabled
- **`[Tier 1 - Bulk CSS]`** CSS class pf-v5-c-* should be pf-v6-c-*
- **`[Tier 1 - Bulk CSS]`** CSS class pf-v5-u-* should be pf-v6-u-*
- **`[Tier 1 - Bulk CSS]`** CSS variable --pf-v5-global-* should be --pf-t--global-*

**Where to find them:**
- `src/components/tier1-simple/UserProfile.tsx` - Text → Content
- `src/components/tier1-simple/StatusBadge.tsx` - Chip → Label, isDisabled
- `src/styles/*.css` - CSS classes and variables
- `src/pages/ProjectsPage.tsx` - Multiple Tier 1 violations

**Tip:** Use VS Code's filter/search in Konveyor view to show only `[Tier 1]` violations

### Step 3: Apply Your First Fix

**Example: Text → Content in UserProfile.tsx**

1. **Find the violation:**
   - Konveyor view → Expand "UserProfile.tsx"
   - Click on violation: **"[Tier 1] Imports of Text should reference Content"**
   - Notice the `[Tier 1]` prefix → indicates simple change

2. **Generate AI fix:**
   - Click "Get solution"
   - Wait for AI reasoning to appear

3. **Review AI reasoning:**
   ```
   The Text component was renamed to Content in PatternFly v6.

   Changes needed:
   - Line 3: Update import from 'Text' to 'Content'
   - Lines 20-22: Replace <Text> with <Content>
   - Props remain unchanged
   ```

4. **Review the diff:**
   - Check the proposed changes carefully
   - Verify import statement update
   - Verify component usage updates
   - Make sure nothing unexpected changed

5. **Apply the fix:**
   - If the fix looks good, click "Apply"
   - If something looks wrong, click "Reject" and flag for manual review

6. **Verify in editor:**
   - Open `src/components/tier1-simple/UserProfile.tsx`
   - Confirm changes look correct

### Step 4: Apply More Tier 1 Fixes

**Repeat for these violations (aim for 15-20 total):**

**Quick wins (high confidence - accept):**
- ✅ **`[Tier 1 - Bulk CSS]`** CSS variable updates in `styles/tokens.css`
- ✅ **`[Tier 1 - Bulk CSS]`** CSS class updates in `styles/components.css`
- ✅ **`[Tier 1]`** Chip → Label in `StatusBadge.tsx`
- ✅ **`[Tier 1]`** isDisabled → disabled throughout codebase

**What to look for in AI reasoning:**
- ✅ Violation shows `[Tier 1]` prefix → simple change
- ✅ Clear explanation of the change
- ✅ Specific line numbers mentioned
- ✅ "Props remain unchanged" for simple renames
- ✅ No complex logic changes

### Step 5: Test Your Changes

```bash
# Stop dev server if running (Ctrl+C)

# Run tests
npm test
# All 15 tests should PASS ✅

# Run the app
npm run dev
```

**Manual testing checklist:**
- Open http://localhost:3000
- Navigate to "Projects" page
- Click on StatusBadge components → Should still increment counter
- Disabled badge should not increment
- No console errors ✅

### Step 6: Commit Your Tier 1 Fixes

```bash
# Review what changed
git status
git diff

# Commit your work
git add .
git commit -s -m "Apply Tier 1 migration fixes (simple renames and props)"
```

### ✅ Success Criteria - Exercise 1

- [ ] 15-20 AI fixes accepted
- [ ] All tests pass (`npm test`)
- [ ] App runs without errors
- [ ] StatusBadge interactions still work
- [ ] Changes committed to `tier1-fixes` branch

**Stuck? Compare with:** `git diff main..tier1-fixes` (or ask facilitator)

---

## Exercise 2: Tier 2 - Moderate Complexity (45 minutes)

**Goal**: Apply structural changes with careful review

### Step 1: Create Tier 2 Branch

```bash
git checkout -b tier2-fixes
```

### Step 2: Find Tier 2 Violations

In Konveyor view, look for violations prefixed with **`[Tier 2 ⚠️ Review]`**:

- **`[Tier 2 ⚠️ Review]`** MenuToggle icon should use icon prop instead of child
- **`[Tier 2 ⚠️ Review]`** EmptyState structure consolidated in v6
- **`[Tier 2 ⚠️ Review]`** Button icon props restructured

**Where to find them:**
- `src/components/tier2-moderate/ActionMenu.tsx` - MenuToggle icon restructuring
- `src/components/tier2-moderate/EmptyStateExample.tsx` - EmptyState component changes
- `src/components/tier2-moderate/IconButtons.tsx` - Button icon props
- `src/pages/WorkloadsPage.tsx` - Contains Tier 2 components

**Notice:** The ⚠️ emoji warns you to review carefully before applying!

### Step 3: MenuToggle Icon Restructuring

**Example: ActionMenu.tsx**

1. **Find violation:**
   - Konveyor view → "ActionMenu.tsx"
   - Violation: **"[Tier 2 ⚠️ Review] MenuToggle icon should use icon prop instead of child"**
   - Notice the `[Tier 2 ⚠️ Review]` prefix → structural change, review carefully

2. **Generate AI fix:**
   - Click "Get solution"
   - Read AI reasoning carefully

3. **Review AI reasoning (example):**
   ```
   In PatternFly v6, MenuToggle changed how icons are passed:

   OLD (v5):
   <MenuToggle>
     <EllipsisVIcon />
   </MenuToggle>

   NEW (v6):
   <MenuToggle icon={<EllipsisVIcon />} />

   Changes:
   - Line 45: Move icon from child to icon prop
   - Ensure icon is imported
   ```

4. **Review carefully:**
   - ⚠️ This changes component structure (not just a rename)
   - ✅ Check: Icon moved from child to prop
   - ✅ Check: Import statement still present
   - ✅ Check: No other children affected
   - ❌ Reject if: AI changed other props unexpectedly

5. **Apply if correct:**
   - If reasoning makes sense → "Apply"
   - If uncertain → Ask facilitator to review with you

### Step 4: EmptyState Component

**Example: EmptyStateExample.tsx**

1. **Find violation:**
   - "EmptyState structure consolidated in v6"

2. **Review AI fix carefully:**
   - EmptyState has significant structural changes in v6
   - AI should explain the new component hierarchy
   - Multiple related changes in one fix

3. **What to verify:**
   - ✅ Icon handling updated correctly
   - ✅ Title and body components restructured
   - ✅ Actions placement correct
   - ✅ No functionality lost

4. **Test immediately after applying:**
   ```bash
   npm test
   npm run dev
   ```
   - Click "Clear filters" button → Should show "Filters cleared!"
   - Wait 2 seconds → Should return to empty state

### Step 5: Button Icon Props

**Example: IconButtons.tsx**

Similar pattern to MenuToggle:
- Icons moved from children to `icon` prop
- Multiple instances in one file
- Good candidate for batch processing (if AI handles well)

**Review carefully:**
- Each button's icon moved correctly
- onClick handlers preserved
- Aria labels unchanged

### Step 6: Apply More Tier 2 Fixes

**Aim for 25-30 total fixes** (including Tier 1)

**Moderate complexity (review carefully):**
- ⚠️ **`[Tier 2 ⚠️ Review]`** MenuToggle changes - verify icon prop
- ⚠️ **`[Tier 2 ⚠️ Review]`** EmptyState changes - test interaction
- ⚠️ **`[Tier 2 ⚠️ Review]`** Button icon props - check multiple instances

**Red flags (reject or manual fix):**
- ❌ AI changes unrelated code
- ❌ Removes important props
- ❌ Changes logic, not just structure
- ❌ Explanation doesn't match diff
- ❌ You see `[Tier 2]` but the change looks too complex

### Step 7: Test Thoroughly

```bash
# Run tests
npm test
# All tests should PASS ✅

# Run app
npm run dev
```

**Manual testing checklist:**
- Navigate to "Workloads" page
- Test all tabs (Details, Actions, Filters)
- Click ActionMenu (three dots) → Opens correctly
- Click IconButtons → All work and log correctly
- EmptyState → "Clear filters" button works
- No console errors ✅

### Step 8: Commit Your Tier 2 Fixes

```bash
git add .
git commit -s -m "Apply Tier 2 migration fixes (structural changes)"
```

### ✅ Success Criteria - Exercise 2

- [ ] 25-30 total fixes accepted (Tier 1 + Tier 2)
- [ ] All tests pass
- [ ] ActionMenu opens correctly
- [ ] EmptyState button works
- [ ] IconButtons all functional
- [ ] Changes committed to `tier2-fixes` branch

---

## Exercise 3: Tier 3 - Edge Cases (30 minutes)

**Goal**: Recognize when AI needs your help

### Step 1: Create Tier 3 Branch

```bash
git checkout -b tier3-fixes
```

### Step 2: Find Tier 3 Violations

**⚠️ IMPORTANT - Understanding Tier 3:**

You will **NOT** see violations prefixed with `[Tier 3]`. Instead, you'll see `[Tier 1]` or `[Tier 2]` prefixes in these files:

- `src/components/tier3-edge-cases/CompatibilityLayer.tsx`
- `src/components/tier3-edge-cases/DynamicComponent.tsx`
- `src/components/tier3-edge-cases/CustomWrapper.tsx`
- `src/pages/StoragePage.tsx` - Contains edge case examples

**The lesson:** Even simple `[Tier 1]` rules require **human judgment** in certain contexts.

**How to identify Tier 3 scenarios:**
1. File location: `tier3-edge-cases/` directory
2. Code comments: Look for `IMPORTANT FOR WORKSHOP` comments
3. Context: Business logic, compatibility layers, dynamic code

### Step 3: CompatibilityLayer - REJECT AI Fix

**This is a test!** The AI will suggest removing the v5 Text import.

1. **Find violation:**
   - Open `CompatibilityLayer.tsx` in Konveyor view
   - You'll see: **"[Tier 1] Imports of Text should reference Content"**
   - Notice it says `[Tier 1]` → looks like a simple change!

2. **Generate AI fix:**
   - AI will suggest: Remove Text import, use only Content
   - **But this is WRONG for this context!**

3. **Review the code:**
   ```tsx
   // This component INTENTIONALLY supports both v5 and v6
   import { Text, Content } from '@patternfly/react-core';

   export const CompatibilityLayer = ({ version }) => {
     if (version === 'v5') {
       return <Text>V5 mode</Text>;
     }
     return <Content>V6 mode</Content>;
   };
   ```

4. **Decision: REJECT ❌**
   - This component intentionally supports both versions
   - Removing Text would break v5 compatibility
   - **Even though it says `[Tier 1]`, you must REJECT this fix!**

5. **What to do:**
   - Click "Reject"
   - Add comment: "Intentional dual support - keeping both imports"
   - Move on

**Key lesson:** The `[Tier 1]` prefix means the **rule** is simple, but **context** determines whether to apply it. AI doesn't understand business context - you do!

### Step 4: DynamicComponent - Manual Review

**AI struggles with template literals and dynamic values**

1. **Find violations:**
   - Open `DynamicComponent.tsx` in Konveyor view
   - You'll see multiple **`[Tier 1]`** and **`[Tier 1 - Bulk CSS]`** violations
   - They look simple, but the code uses runtime-computed values

2. **Generate AI fix:**
   - AI will detect the static `Text` import → suggests changing to `Content`
   - AI will detect CSS classes in template literals → suggests changing patterns
   - But AI can't trace all possible runtime values!

3. **Review carefully:**
   ```tsx
   const componentName = `pf-v5-c-${type}`;
   // AI may not safely handle this pattern
   ```

4. **Decision:**
   - If AI fix looks correct → Apply with extra testing
   - If AI fix looks risky → Flag for manual review
   - Better safe than sorry!

### Step 5: CustomWrapper - Partial Fix

**Update internal implementation, preserve public API**

1. **The situation:**
   - CustomWrapper uses Text internally
   - But exports a stable public API
   - Internal fix is OK, API change is NOT OK

2. **Review AI fix:**
   - ✅ Internal Text → Content: OK
   - ❌ Changes to exported props: NOT OK
   - ⚠️ Changes to component name: Check if breaking

3. **Apply selectively:**
   - You may need to manually edit the AI suggestion
   - Apply internal changes only
   - Keep public API stable

### Step 6: Understanding When to Reject

**REJECT AI fixes when:**
- ❌ Compatibility layers (intentional dual support)
- ❌ Dynamic/computed component names
- ❌ Complex conditional logic
- ❌ Changes to public APIs
- ❌ You don't understand the reasoning
- ❌ Tests fail after applying

**GOLDEN RULE: If you don't understand the fix, don't apply it!**

### Step 7: Test Edge Cases

```bash
npm test
npm run dev
```

**Manual testing:**
- Navigate to "Storage" page
- Verify warnings are displayed
- Check that edge case components still work
- Test CompatibilityLayer with both modes (if applicable)

### Step 8: Commit Your Tier 3 Fixes

```bash
git add .
git commit -s -m "Apply Tier 3 migration fixes (edge cases with manual review)"
```

### ✅ Success Criteria - Exercise 3

- [ ] Understand when to REJECT AI suggestions
- [ ] CompatibilityLayer kept with dual imports
- [ ] Edge cases flagged for manual review
- [ ] Tests still pass
- [ ] No breaking changes to public APIs

---

## 🎉 Migration Complete!

You've successfully migrated a PatternFly v5 app to v6 with AI assistance!

**What you learned:**
- ✅ When AI excels (simple patterns, renames, CSS)
- ✅ When AI needs review (structural changes)
- ✅ When to reject AI (edge cases, business logic)
- ✅ How to validate AI-generated code

**Your migration trail:**
```
main
 └─ tier1-fixes (simple changes)
     └─ tier2-fixes (structural changes)
         └─ tier3-fixes (edge cases)
```

---

## Quick Reference

### Git Commands

```bash
# Create branch
git checkout -b branch-name

# Check status
git status
git diff

# Commit changes
git add .
git commit -s -m "Your message"

# See your branches
git branch

# Compare branches
git diff main..tier1-fixes
```

### Testing Commands

```bash
# Run all tests
npm test

# Run dev server
npm run dev

# Build (final check)
npm run build

# Lint
npm run lint
```

### VS Code Konveyor

```
Load analysis: Konveyor view → "Load Analysis Results"
Generate fix: Click violation → "Get solution"
Apply fix: Review diff → "Apply"
Reject fix: "Reject" or "Skip"
```

**Tier Prefix Guide:**
- `[Tier 1]` = Simple change, safe to accept (quick review)
- `[Tier 1 - Bulk CSS]` = CSS pattern, safe to batch-apply
- `[Tier 2 ⚠️ Review]` = Structural change, review carefully
- No `[Tier 3]` prefix = Identified by context (tier3-edge-cases directory)

### Common File Locations

```
Tier 1 (Simple):
- src/components/tier1-simple/UserProfile.tsx
- src/components/tier1-simple/StatusBadge.tsx
- src/components/tier1-simple/PageHeader.tsx
- src/styles/*.css
- src/pages/ProjectsPage.tsx

Tier 2 (Moderate):
- src/components/tier2-moderate/ActionMenu.tsx
- src/components/tier2-moderate/EmptyStateExample.tsx
- src/components/tier2-moderate/IconButtons.tsx
- src/pages/WorkloadsPage.tsx

Tier 3 (Edge Cases):
- src/components/tier3-edge-cases/CompatibilityLayer.tsx
- src/components/tier3-edge-cases/DynamicComponent.tsx
- src/components/tier3-edge-cases/CustomWrapper.tsx
- src/pages/StoragePage.tsx
```

---

## Troubleshooting

### "AI fix not generating"

**Possible causes:**
- API key not configured
- Rate limit reached
- Network issue

**Solutions:**
1. Check `.vscode/settings.json` has correct credentials
2. Wait 30 seconds and try again
3. Try different AI provider (see [AI_PROVIDERS.md](./AI_PROVIDERS.md))
4. Ask facilitator for help

### "Tests failing after applying fix"

**What to do:**
1. Don't panic! This is a learning opportunity
2. Review what changed: `git diff`
3. Check the error message carefully
4. Options:
   - Rollback: `git checkout -- path/to/file`
   - Fix manually based on test output
   - Ask facilitator to review with you

### "Can't find violations in Konveyor view"

**Checklist:**
1. Analysis loaded? Check "Load Analysis Results"
2. Correct file: `analysis-results/output.yaml`
3. Try reloading VS Code: Cmd/Ctrl+Shift+P → "Reload Window"

### "Dev server won't start"

```bash
# Kill any existing processes
killall node

# Clear cache
rm -rf node_modules/.vite

# Restart
npm run dev
```

### "Behind and can't catch up"

**Don't worry!** You can jump to a reference branch:

```bash
# See reference branches
git branch -r

# Start from Tier 1 complete
git checkout origin/reference/tier1-complete -b my-tier2-fixes

# Continue with Tier 2
```

Ask facilitator for help!

---

## Decision Framework

When reviewing AI fixes, ask yourself:

### ✅ High Confidence - ACCEPT

- [ ] Violation shows **`[Tier 1]`** or **`[Tier 1 - Bulk CSS]`** prefix
- [ ] Simple component rename (1:1 replacement)
- [ ] Prop rename with no logic change
- [ ] CSS class/variable update
- [ ] AI reasoning is clear and specific
- [ ] Diff matches the explanation
- [ ] You understand what changed and why
- [ ] **NOT** in tier3-edge-cases directory

### ⚠️ Review Carefully - ACCEPT WITH CAUTION

- [ ] Violation shows **`[Tier 2 ⚠️ Review]`** prefix
- [ ] Structural component changes
- [ ] Multiple related changes
- [ ] Icon/children restructuring
- [ ] AI explanation is detailed
- [ ] Test immediately after applying
- [ ] Watch for unintended side effects

### ❌ Reject or Manual - DO NOT ACCEPT

- [ ] File in `tier3-edge-cases/` directory (even if `[Tier 1]`!)
- [ ] Compatibility layers (intentional dual support)
- [ ] Dynamic/computed values (template literals, runtime props)
- [ ] Complex conditional logic
- [ ] Public API changes
- [ ] You don't understand the reasoning
- [ ] Explanation doesn't match diff
- [ ] "Feels wrong" (trust your instincts!)

**Remember:** It's better to flag for manual review than to break something!

---

## Post-Workshop

**Want to continue learning?**

- 📚 [PatternFly v6 Upgrade Guide](https://www.patternfly.org/get-started/upgrade/)
- 📝 [Blog: Automating UI Migrations](https://www.migandmod.net/2025/10/22/automating-ui-migrations-ai-analyzer-rules/)
- 🔧 [Konveyor Documentation](https://konveyor.io/docs)
- 💬 [Slack: #konveyor](https://kubernetes.slack.com/messages/konveyor)

**Migrate your own codebase:**

1. Clone the rulesets with tier labels: [github.com/tsanders-rh/rulesets/tree/patternfly-workshop-tiers](https://github.com/tsanders-rh/rulesets/tree/patternfly-workshop-tiers)
2. Run analysis on your code
3. Apply the techniques you learned today
4. Share your success story!

---

## Feedback

We want to hear from you! After the workshop:

**What worked well?**
- Which violation types did AI handle best?
- Which patterns felt safe to auto-apply?

**What needs improvement?**
- Which patterns did AI struggle with?
- Where did you lose confidence?
- Any false positives?

**Help us improve:** [Workshop feedback form](#) (facilitator will share)

---

## Thank You!

You've learned valuable skills for working with AI-assisted code changes. These principles apply beyond PatternFly migrations:

- Know when to trust automation
- Know when to intervene
- Always validate AI-generated code
- Use incremental changes with testing

**Keep learning, keep building!** 🚀
