# PatternFly Migration Workshop - Participant Guide

Welcome! This guide will walk you through today's hands-on exercises.

---

## Workshop Overview

**What You'll Do Today:**
- Apply AI-assisted fixes to ~200+ PatternFly v5→v6 violations
- Learn when to trust AI vs manual intervention
- Practice incremental migration with git branches

**Three Exercises:**
- **Exercise 1** (30 min): Tier 1 Bulk CSS - ultra-safe, high-volume (~120 fixes)
- **Exercise 2** (45 min): Component changes - Tier 1 simple + Tier 2 structural (~25-35 fixes)
- **Exercise 3** (30 min): Tier 3 edge cases - when AI needs your help (~5-10 decisions)

**How to Identify Tiers:**

Violations in VS Code will be prefixed with colored tier indicators:
- `🟢 [Tier 1]` - Simple changes, safe to auto-apply with quick review
- `🟢 [Tier 1 - Bulk CSS]` - CSS pattern updates, safe to batch-apply
- `🟡 [Tier 2]` - Structural changes, review carefully before applying
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
  "konveyor.analyzerPath": "../rulesets/preview/nodejs/patternfly",
  "konveyor.agentMode": false,
  "konveyor.autoReveal": true,
  "konveyor.showInlineDecorations": true
}
```

**Settings explained:**
- `analyzerPath` - Points to tier-labeled PatternFly rules
- `agentMode: false` - Manual review mode (you approve each fix)
- `autoReveal: true` - Automatically opens files with violations
- `showInlineDecorations: true` - Shows violation markers in code

**Or use your own API key:** See [AI_PROVIDERS.md](./AI_PROVIDERS.md)

**Alternative: Profile Manager UI**

You can also configure via the Konveyor UI:
1. Open Konveyor Analysis View (sidebar)
2. Click "Configure GenAI Settings" to set up AI provider
3. Click "Edit in Profile Manager" to create a PatternFly profile
4. Set Source: `patternfly-v5`, Target: `patternfly-v6`
5. Point Custom Rules to `../rulesets/preview/nodejs/patternfly`

For this workshop, the settings.json approach above is simpler and pre-configured.

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

## Exercise 1: Tier 1 - Bulk CSS Fixes (30 minutes)

**Goal**: Build confidence with ultra-safe, high-volume CSS pattern updates

**Why start with CSS?**
- **Highest AI success rate**: 98-99% (simple find/replace patterns)
- **Large volume**: ~123 CSS violations to batch-apply
- **Immediate feedback**: Tests still pass, UI looks identical
- **Builds confidence**: "AI got 120+ fixes correct in 20 minutes!"

### Step 1: Create Your Branch

```bash
git checkout -b tier1-css-fixes
```

### Step 2: Find CSS Violations

In Konveyor view, look for violations prefixed with **`🟢 [Tier 1 - Bulk CSS]`**:

- **`🟢 [Tier 1 - Bulk CSS]`** CSS class pf-v5-c-* should be pf-v6-c-*
- **`🟢 [Tier 1 - Bulk CSS]`** CSS class pf-v5-u-* should be pf-v6-u-*
- **`🟢 [Tier 1 - Bulk CSS]`** CSS variable --pf-v5-global--* should be --pf-t--global--*

**Where to find them:**
- `src/styles/components.css` - Class patterns and variables (~10 violations)
- `src/styles/tokens.css` - CSS custom properties (~10 violations)
- `src/components/tier1-simple/PageHeader.css` - Component styles (~7 violations)

**Tip:** Use VS Code's filter in Konveyor view to show only "Bulk CSS" violations

### Step 3: Apply Your First CSS Fix

**Example: CSS Variable --pf-v5-global--**

1. **Find and expand the violation rule in Konveyor view:**
   - Look for: **"🟢 [Tier 1 - Bulk CSS] --pf-v5-global-- should be replaced with --pf-t--global--"**
   - You'll see "24 incidents" badge
   - **Click to expand** the violation
   - The message shows: "CSS tokens have been updated. Global non-color tokens have been replaced with newer ones."

2. **View the incident list:**
   - After expanding, scroll down to see the "Issue" list
   - You'll see individual file:line violations:
     - `/src/styles/tokens.css:10`
     - `/src/components/tier1-simple/pageheader.css:2`
     - `/src/components/tier1-simple/pageheader.css:3`
     - `/src/components/tier1-simple/pageheader.css:4`
     - (and 20 more...)
   - Each incident has an AI wrench icon on the right

3. **Choose bulk fix or individual fix:**

   **Option A - Bulk Fix (Recommended for CSS):**
   - Click the AI wrench icon next to the violation rule title (top level)
   - Select **"Get solution for 24 incidents"**
   - Kai will generate fixes for ALL 24 incidents at once
   - Review the combined diff showing all CSS variable changes
   - Click "Apply" to fix all 24 violations in one go
   - ✅ **This is perfect for Tier 1 Bulk CSS!**

   **Option B - Individual Fix:**
   - Click the AI wrench icon next to a specific incident (e.g., `pageheader.css:2`)
   - Select **"Get solution"**
   - Review and apply that single fix
   - Repeat for other incidents

4. **Review AI reasoning (for bulk fix):**
   - AI will explain the pattern being changed
   - Shows before/after for the CSS variable pattern
   - Example: `--pf-v5-global--BackgroundColor--100` → `--pf-t--global--BackgroundColor--100`
   - Lists all 24 files being modified

5. **Review the diff:**
   - Check the proposed changes across all files
   - Verify it's only changing CSS variable prefixes
   - Make sure no actual styling logic changed
   - For bulk fixes, this might be a large diff - scan for any unexpected changes

6. **Apply the fix:**
   - Click "Apply"
   - All 24 incidents are fixed in one operation!
   - This is a safe pattern - just prefix updates

### Step 4: Batch Apply Remaining CSS Fixes

**Now use bulk fixes to knock out the remaining ~100+ CSS violations!**

**For each CSS violation rule, use "Get solution for X incidents":**

1. **CSS variables** (`--pf-v5-global--*` → `--pf-t--global--*`):
   - You just fixed 24 incidents - check if there are more!
   - Look for related rules with remaining incidents
   - Bulk fix each rule

2. **CSS classes** (`pf-v5-c-*` → `pf-v6-c-*`):
   - Find violations like "pf-v5-c-button should be replaced with pf-v6-c-button"
   - Use bulk fix to handle all incidents at once
   - Safe pattern - just version number changes

3. **CSS utilities** (`pf-v5-u-*` → `pf-v6-u-*`):
   - Find violations like "pf-v5-u-mt-lg should be replaced with pf-v6-u-mt-lg"
   - Bulk fix these as well
   - All utility class updates are safe

**What to look for when reviewing bulk fixes:**
- ✅ Only changing prefixes/version numbers
- ✅ No changes to actual values or styling logic
- ✅ Scan the diff for any unexpected changes
- ✅ Clear before/after examples in AI reasoning

**Pro tip:** For Tier 1 Bulk CSS, you can safely use "Get solution for X incidents" without deep review. Just verify the diff shows only prefix changes!

### Step 5: Test Your CSS Changes

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
- Navigate through all pages
- **Visual check**: Everything should look IDENTICAL to before
- No console errors ✅
- No broken styles ✅

**Why do tests still pass?** CSS variable and class name updates don't change functionality - they're just version number changes in the styling system.

### Step 6: Commit Your CSS Fixes

```bash
# Review what changed (should be CSS files only)
git status
git diff

# Commit your work
git add src/styles/ src/components/tier1-simple/PageHeader.css
git commit -s -m "Apply Tier 1 Bulk CSS fixes (v5→v6 prefixes)"
```

### ✅ Success Criteria - Exercise 1

- [ ] ~120+ CSS violations fixed (all `🟢 [Tier 1 - Bulk CSS]`)
- [ ] All tests pass (`npm test`)
- [ ] App runs without errors
- [ ] UI looks identical to before (no visual changes)
- [ ] Only CSS files modified (no `.tsx` files)
- [ ] Changes committed to `tier1-css-fixes` branch

**Key Insight**: You just applied 120+ AI fixes in 20-30 minutes with 99% accuracy. This is the power of complexity classification - knowing which patterns are "auto-apply safe" lets you move fast with confidence.

**Stuck? Compare with:** `git diff main..tier1-css-fixes` (or ask facilitator)

---

## Exercise 2: Component Changes - Tier 1 & Tier 2 (45 minutes)

**Goal**: Learn to differentiate simple component changes from structural refactoring

**What's different from Exercise 1?**
- **Exercise 1**: CSS only - ultra-safe, batch-apply
- **Exercise 2**: React components - requires reading AI reasoning carefully
- **Mix of complexity**: Tier 1 (95% safe) + Tier 2 (85% safe, needs careful review)

### Part A: Tier 1 Component Changes (20 minutes)

These are simple component/prop renames - similar confidence to CSS, but affecting TypeScript/React.

### Step 1: Create Component Fixes Branch

```bash
git checkout -b tier1-component-fixes
```

### Step 2: Find Tier 1 Component Violations

In Konveyor view, look for violations prefixed with **`🟢 [Tier 1]`** (NOT Bulk CSS):

- **`🟢 [Tier 1]`** Imports of Text should reference Content
- **`🟢 [Tier 1]`** Chip component should be replaced with Label
- **`🟢 [Tier 1]`** isDisabled prop should be updated to disabled
- **`🟢 [Tier 1]`** Text component="p" should use component="paragraph"

**Where to find them:**
- `src/components/tier1-simple/UserProfile.tsx` - Text → Content
- `src/components/tier1-simple/StatusBadge.tsx` - Chip → Label, isDisabled → disabled
- `src/pages/ProjectsPage.tsx` - Multiple simple component violations

### Step 3: Apply Your First Component Fix

**Example: Text → Content in UserProfile.tsx**

1. **Find the violation:**
   - Konveyor view → Expand "UserProfile.tsx"
   - Click on violation: **"🟢 [Tier 1] Imports of Text should reference Content"**

2. **Generate AI fix:**
   - Click "Get solution"
   - Wait for AI reasoning to appear

3. **Review AI reasoning:**
   ```
   The Text component was renamed to Content in PatternFly v6.

   Changes needed:
   - Line 3: Update import from 'Text' to 'Content'
   - Lines 19-21: Replace <Text> tags with <Content>
   - Props remain unchanged (component="h2", component="p", etc.)
   ```

4. **Review the diff:**
   - Check the proposed changes carefully
   - Verify import statement update
   - Verify all component usages updated
   - **Important**: Props should remain unchanged for simple renames

5. **Apply the fix:**
   - Click "Apply"

6. **Verify in editor:**
   - Open `src/components/tier1-simple/UserProfile.tsx`
   - Confirm changes look correct

**📝 Remember this fix!** You'll encounter this **same violation** later in Exercise 3 in `CompatibilityLayer.tsx`, but you'll need to **reject** it due to different business context. Same rule, different decision - this is the key lesson!

### Step 4: Apply More Tier 1 Component Fixes

**Repeat for these violations (~15-20 total):**

- ✅ **Text → Content** in UserProfile.tsx and ProjectsPage.tsx
- ✅ **Chip → Label** in StatusBadge.tsx
- ✅ **isDisabled → disabled** in StatusBadge.tsx and other components
- ✅ **component="p" → component="paragraph"** wherever Text is used

**What to look for in AI reasoning:**
- ✅ Simple find/replace pattern
- ✅ "Props remain unchanged" or minimal prop changes
- ✅ No logic restructuring
- ✅ Clear before/after examples

### Step 5: Test Tier 1 Component Changes

```bash
npm test
# All tests should PASS ✅

npm run dev
```

**Manual testing:**
- Navigate to Projects page
- Test StatusBadge interactions (click counter should work)
- Verify disabled badges don't increment
- No console errors ✅

### Step 6: Commit Tier 1 Component Fixes

```bash
git add .
git commit -s -m "Apply Tier 1 component renames (Text→Content, Chip→Label, props)"
```

---

### Part B: Tier 2 Structural Changes (25 minutes)

Now the complexity increases - these require careful review of structural changes.

### Step 7: Find Tier 2 Violations

In Konveyor view, look for violations prefixed with **`🟡 [Tier 2]`**:

- **`🟡 [Tier 2]`** MenuToggle icon should use icon prop instead of child
- **`🟡 [Tier 2]`** EmptyState structure consolidated in v6
- **`🟡 [Tier 2]`** Button icon props restructured

**Where to find them:**
- `src/components/tier2-moderate/ActionMenu.tsx` - MenuToggle icon restructuring
- `src/components/tier2-moderate/EmptyStateExample.tsx` - EmptyState component changes
- `src/components/tier2-moderate/IconButtons.tsx` - Button icon props
- `src/pages/WorkloadsPage.tsx` - Contains Tier 2 components

**Notice:** The 🟡 yellow circle indicates Tier 2 - structural changes that require careful review before applying!

### Step 8: MenuToggle Icon Restructuring

**Example: ActionMenu.tsx**

1. **Find violation:**
   - Konveyor view → "ActionMenu.tsx"
   - Violation: **"🟡 [Tier 2] MenuToggle icon should use icon prop instead of child"**
   - Notice the `🟡 [Tier 2]` prefix → structural change, review carefully

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

### Step 9: EmptyState Component

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

### Step 10: Button Icon Props

**Example: IconButtons.tsx**

Similar pattern to MenuToggle:
- Icons moved from children to `icon` prop
- Multiple instances in one file
- Good candidate for batch processing (if AI handles well)

**Review carefully:**
- Each button's icon moved correctly
- onClick handlers preserved
- Aria labels unchanged

### Step 11: Apply More Tier 2 Fixes

**Aim for 25-30 total fixes** (including Tier 1)

**Moderate complexity (review carefully):**
- 🟡 **`[Tier 2]`** MenuToggle changes - verify icon prop
- 🟡 **`[Tier 2]`** EmptyState changes - test interaction
- 🟡 **`[Tier 2]`** Button icon props - check multiple instances

**Red flags (reject or manual fix):**
- ❌ AI changes unrelated code
- ❌ Removes important props
- ❌ Changes logic, not just structure
- ❌ Explanation doesn't match diff
- ❌ You see `🟡 [Tier 2]` but the change looks too complex

### Step 12: Test Thoroughly

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

### Step 13: Commit Your Tier 2 Fixes

```bash
git add .
git commit -s -m "Apply Tier 2 structural changes (MenuToggle, EmptyState, Button icons)"
```

### ✅ Success Criteria - Exercise 2

**Part A (Tier 1 Components):**
- [ ] ~15-20 component fixes (Text→Content, Chip→Label, props)
- [ ] Tests pass after Part A
- [ ] Committed to `tier1-component-fixes` branch

**Part B (Tier 2 Structural):**
- [ ] ~10-15 structural fixes (MenuToggle, EmptyState, Button icons)
- [ ] All tests pass
- [ ] ActionMenu opens correctly
- [ ] EmptyState button works
- [ ] IconButtons all functional
- [ ] Committed to `tier1-component-fixes` branch (same branch, additional commit)

**Total: ~25-35 component fixes** across both parts

**Key Insight**: You learned the difference between Tier 1 (simple renames - 95% confidence) and Tier 2 (structural changes - 85% confidence requiring careful review). Both can be successfully automated, but Tier 2 requires reading AI reasoning thoroughly.

---

## Exercise 3: Tier 3 - Edge Cases (30 minutes)

---

## ⚠️ **SLOW DOWN HERE** ⚠️

**This is the most important 30 minutes of the workshop.**

**Why Tier 3 matters more than Tier 1 or Tier 2:**

Tier 1 taught you: "AI can automate simple patterns" ✅
Tier 2 taught you: "AI needs careful review for complex changes" ✅
**Tier 3 teaches you: "When to reject AI entirely - the skill that makes you valuable"** 🎯

**If you're running short on time:**
- ⏩ Skip some Tier 1 fixes (you get the idea)
- ⏩ Skip some Tier 2 fixes (you understand the pattern)
- **⏸️ DO NOT rush through Tier 3** - this is where judgment skills are learned

**The lesson you'll take home:**
> "Same violation, different context, different decision.
> AI provides rules. You provide judgment."

This is why Konveyor + human expertise beats AI alone at enterprise scale.

---

**Goal**: Recognize when AI needs your help

### Step 1: Create Tier 3 Branch

```bash
git checkout -b tier3-fixes
```

### Step 2: Find Tier 3 Violations

**⚠️ IMPORTANT - Understanding Tier 3:**

You will **NOT** see violations prefixed with `🔴 [Tier 3]`. Instead, you'll see `🟢 [Tier 1]` or `🟡 [Tier 2]` prefixes in these files:

- `src/components/tier3-edge-cases/CompatibilityLayer.tsx`
- `src/components/tier3-edge-cases/DynamicComponent.tsx`
- `src/components/tier3-edge-cases/CustomWrapper.tsx`
- `src/pages/StoragePage.tsx` - Contains edge case examples

**The lesson:** Even simple `🟢 [Tier 1]` rules require **human judgment** in certain contexts.

**How to identify Tier 3 scenarios:**
1. File location: `tier3-edge-cases/` directory
2. Code comments: Look for `IMPORTANT FOR WORKSHOP` comments
3. Context: Business logic, compatibility layers, dynamic code

### Step 3: CompatibilityLayer - REJECT AI Fix

**This is a test!** You'll see a familiar violation, but the correct action is different.

1. **Find violation:**
   - Open `CompatibilityLayer.tsx` in Konveyor view
   - You'll see: **"🟡 [Tier 2] Text component should be replaced with Content component"**
   - **Wait... you already fixed this in Exercise 1!** You successfully applied this fix in `UserProfile.tsx`
   - This looks exactly the same → straightforward replacement, right?

2. **Generate AI fix:**
   - AI will suggest: Replace Text with Content throughout
   - Same suggestion as before
   - **But this time it's WRONG for this context!**

3. **Review the code:**
   ```tsx
   // This component INTENTIONALLY uses Text for compatibility
   import { Text } from '@patternfly/react-core';

   /**
    * This is a compatibility wrapper to support gradual migration.
    * DO NOT auto-fix this component - it intentionally uses both old and new APIs.
    */
   export const CompatibilityLayer = ({ useV6, children }) => {
     // In real implementation, would conditionally use Content or Text
     // For this demo, just use Text to trigger the violation
     return <Text component="p">{children}</Text>;
   };
   ```

4. **Decision: REJECT ❌**
   - The comments warn: "DO NOT auto-fix this component"
   - This is intentional compatibility code for gradual migration
   - Replacing Text would break the intended dual-version support
   - **Same violation as Exercise 1, but OPPOSITE decision!**

5. **What to do:**
   - Click "Reject"
   - Add comment: "Intentional dual support - keeping both imports"
   - Move on

---

### 🎯 **KEY LEARNING MOMENT** 🎯

**The same violation can require different decisions based on context.**

In **Exercise 1**, you saw this violation:
- ✅ **"🟡 [Tier 2] Text component should be replaced with Content component"**
- ✅ File: `UserProfile.tsx`
- ✅ Decision: **APPLY** ← Correct!

In **Exercise 3**, you see the **identical violation**:
- ⚠️ **"🟡 [Tier 2] Text component should be replaced with Content component"**
- ⚠️ File: `CompatibilityLayer.tsx`
- ❌ Decision: **REJECT** ← Correct!

**Why the difference?**
- Same rule, same AI suggestion
- Different business context (compatibility layer vs. normal component)
- The code comments and file location provide the context clues

**The Lesson:** AI provides consistent rules and suggestions. **You** provide context-aware judgment. AI doesn't understand business requirements, intentional compatibility layers, or gradual migration strategies. **That's your job.**

---

### Step 4: DynamicComponent - Manual Review

**AI struggles with dynamic values and computed patterns**

1. **Find violations:**
   - Open `DynamicComponent.tsx` in Konveyor view
   - You'll see **`🟡 [Tier 2] Text component should be replaced with Content component`**
   - Looks straightforward, but the code uses dynamic patterns

2. **Review the code:**
   ```tsx
   // Dynamic CSS classes in template literals - may not be detected by rules
   const baseClass = `pf-v5-c-${componentType}`;
   const statusClass = `pf-v5-c-${componentType}--${status}`;

   // Text used conditionally
   const renderContent = () => {
     if (showDetails) {
       return <Text component="p">Detailed info...</Text>;
     }
     return <Text component="small">Summary view</Text>;
   };
   ```

3. **The problem:**
   - CSS classes use template literals with runtime values
   - `componentType` comes from props → could be anything
   - AI can fix `Text → Content`, but can't trace all dynamic CSS values
   - Manual review needed for template literal patterns

4. **Decision:**
   - ✅ Text → Content fix: Probably safe to apply
   - ⚠️ Any suggested CSS changes in template literals: Review very carefully
   - 📝 Note: Some patterns require manual migration outside of AI tools

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
- `🟢 [Tier 1]` = Simple change, safe to accept (quick review)
- `[Tier 1 - Bulk CSS]` = CSS pattern, safe to batch-apply
- `🟡 [Tier 2]` = Structural change, review carefully
- No `🔴 [Tier 3]` prefix = Identified by context (tier3-edge-cases directory)

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

- [ ] Violation shows **`🟢 [Tier 1]`** or **`🟢 [Tier 1 - Bulk CSS]`** prefix
- [ ] Simple component rename (1:1 replacement)
- [ ] Prop rename with no logic change
- [ ] CSS class/variable update
- [ ] AI reasoning is clear and specific
- [ ] Diff matches the explanation
- [ ] You understand what changed and why
- [ ] **NOT** in tier3-edge-cases directory

### ⚠️ Review Carefully - ACCEPT WITH CAUTION

- [ ] Violation shows **`🟡 [Tier 2]`** prefix
- [ ] Structural component changes
- [ ] Multiple related changes
- [ ] Icon/children restructuring
- [ ] AI explanation is detailed
- [ ] Test immediately after applying
- [ ] Watch for unintended side effects

### ❌ Reject or Manual - DO NOT ACCEPT

- [ ] File in `tier3-edge-cases/` directory (even if `🟢 [Tier 1]`!)
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
