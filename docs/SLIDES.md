# PatternFly v5→v6 Migration Workshop
## Slide Deck Outline

---

## Slide 1: Title

# PatternFly v5→v6 Migration Workshop
## AI-Assisted Migration with Konveyor

**Facilitators**: [Your Name]
**Date**: [Workshop Date]
**Duration**: 4-5 hours hands-on

---

## Slide 2: Welcome & Agenda

# Today's Journey

**Morning**
- 9:00 - Introduction & The Migration Challenge
- 9:30 - Live Demo: Three-Part Pipeline
- 10:45 - PatternFly Team Presentation
- 12:00 - Working Lunch

**Afternoon**
- 1:00 - Hands-On Lab (Tiers 1, 2, 3)
- 3:15 - Feedback & Discussion
- 4:45 - Wrap-Up & Next Steps

**Goal**: Learn when to trust AI, when to intervene, and how to migrate confidently

---

## Slide 3: The Migration Challenge

# The PatternFly v5→v6 Migration Problem

**Real-World Example: tackle2-ui**
- 3,557 violations across 400+ files
- Weeks of manual, tedious work
- Error-prone find-and-replace
- Easy to miss edge cases

**Common Patterns to Migrate:**
- Component renames: `Text` → `Content`
- Prop changes: `isDisabled` → `disabled`
- CSS updates: `pf-v5-*` → `pf-v6-*`
- Structural changes: EmptyState, MenuToggle

**Manual Process:**
1. Read PatternFly docs
2. Search codebase
3. Update each instance
4. Test everything
5. Repeat 100s of times

---

## Slide 4: The Opportunity

# What If We Could Automate This?

**Time Savings**
- Manual migration: 2-4 weeks
- AI-assisted migration: 2-4 days
- **87% time reduction**

**Quality Improvements**
- Semantic analysis finds violations text search misses
- AI reasoning explains each fix
- Automated testing validates changes
- Incremental migration with git checkpoints

**Developer Experience**
- Focus on edge cases, not repetitive work
- Learn PatternFly v6 patterns through AI explanations
- Confidence through automated validation

---

## Slide 5: Learning Objectives

# What You'll Accomplish Today

✅ **Understand the three-part pipeline**
- AI-generated rules from documentation
- Semantic code analysis
- AI-assisted fix generation

✅ **Apply 50+ migrations hands-on**
- 🟢 Simple renames and CSS (Tier 1)
- 🟡 Structural refactoring (Tier 2)
- 🔴 Edge cases requiring judgment (Tier 3)

✅ **Learn when to trust AI vs manual intervention**
- High-confidence patterns (accept)
- Complex logic (review carefully)
- Compatibility layers (reject)

✅ **Practice real-world migration workflow**
- Incremental changes with git branches
- Test after each tier
- Build migration confidence

---

## Slide 6: Your Workshop App

# Workshop Console Application

**What It Is:**
- React app built with PatternFly v5
- Console-style interface (like OpenShift)
- 211 intentional violations for practice

**Violation Distribution:**
- 123 CSS violations (classes & variables)
- 88 code violations (components & props)
- Organized across 3 complexity tiers

**Three Pages for Practice:**
- **Projects** - 🟢 Tier 1 (simple changes)
- **Workloads** - 🟡 Tier 2 (moderate complexity)
- **Storage** - 🔴 Tier 3 (edge cases)

*[Screenshot of Workshop Console app]*

---

## Slide 7: The Three-Part Pipeline

# How Konveyor Automates Migrations

```
┌─────────────────────┐
│  1. AI-Generated    │
│     Rules           │  From PatternFly docs
│                     │  → YAML rulesets
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  2. Semantic        │
│     Analysis        │  Scan your codebase
│     (Kantra)        │  → Find violations
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  3. AI-Assisted     │
│     Fixes           │  Generate solutions
│     (VS Code)       │  → Apply with review
└─────────────────────┘
```

**Result**: Weeks of work → Days of work

---

## Slide 8: Part 1 - AI-Generated Rules

# From Docs to Executable Rules

**Input**: PatternFly upgrade documentation
```
"The Text component has been renamed to Content"
```

**Output**: Konveyor rule (YAML)
```yaml
- category: mandatory
  message: "Text component renamed to Content in v6"
  ruleID: patternfly-v5-v6-text-to-content
  when:
    builtin.filecontent:
      pattern: "from '@patternfly/react-core'"
      filePattern: "*.{tsx,jsx}"
```

**Benefits:**
- Rules generated in minutes, not days
- Consistent with official PatternFly guidance
- Easy to update as docs evolve

---

## Slide 9: Part 2 - Semantic Analysis

# Finding Violations Accurately

**Semantic Analysis > Text Matching**

❌ **Text/Regex Search**:
```bash
grep -r "isDisabled" .
# Returns: 1,247 results (comments, strings, unrelated code)
```

✅ **Semantic Analysis**:
```bash
kantra analyze --rules patternfly --source v5 --target v6
# Returns: 88 actual PatternFly violations
```

**Why It's Better:**
- Understands TypeScript/React AST
- Filters out comments and strings
- Finds violations in complex code structures
- Language-aware (not just text matching)

**Result**: 211 violations found in seconds, zero false positives

*[Screenshot of Konveyor analysis results]*

---

## Slide 10: Part 3 - AI-Assisted Fixes

# From Violation to Solution

**VS Code Konveyor Extension**

1. **See violations** in sidebar grouped by file
2. **Click "Get solution"** on a violation
3. **Review AI reasoning**:
   ```
   The Text component was renamed to Content in PatternFly v6.

   Changes needed:
   - Update import: Text → Content
   - Update JSX: <Text> → <Content>
   - Props remain the same
   ```
4. **Review diff** before accepting
5. **Apply fix** or reject if incorrect

*[Screenshot of VS Code extension showing violation → AI fix → diff]*

---

## Slide 11: Workshop Structure - Three Tiers

# Complexity-Based Learning Path

**🟢 Tier 1: Quick Wins (30 min)**
- ~50-60 violations
- Component renames: `Text` → `Content`, `Chip` → `Label`
- Prop changes: `isDisabled` → `disabled`
- CSS updates: `pf-v5-*` → `pf-v6-*`
- **AI Success Rate: ~95%**

**🟡 Tier 2: Moderate Complexity (45 min)**
- ~10-15 violations
- MenuToggle icon restructuring
- EmptyState component changes
- Button icon props
- **AI Success Rate: ~85%** (review carefully)

**🔴 Tier 3: Edge Cases (30 min)**
- ~5 violations
- Compatibility layers (intentional dual support)
- Dynamic imports (template literals)
- Custom wrappers
- **AI Success Rate: ~50%** (manual intervention needed)

---

## Slide 12: Git Branching Strategy

# Safe, Incremental Migration

```
main (original v5 code)
  │
  ├─── tier1-fixes
  │      ├─ Apply simple changes
  │      ├─ npm test
  │      └─ git commit
  │
  ├─── tier2-fixes
  │      ├─ Apply structural changes
  │      ├─ npm test
  │      └─ git commit
  │
  └─── tier3-fixes
         ├─ Handle edge cases
         ├─ npm test
         └─ git commit
```

**Benefits:**
- ✅ Safe rollback points
- ✅ Test after each tier
- ✅ Real-world migration practice
- ✅ Can compare with reference branches

---

## Slide 13: What Success Looks Like

# Expected Outcomes by Exercise

**After Tier 1 (Exercise 1):**
- ✅ 15-20 fixes accepted
- ✅ All tests pass
- ✅ CSS updates complete
- ✅ Simple renames working
- ⏱️ Manual time saved: 3-4 hours

**After Tier 2 (Exercise 2):**
- ✅ 25-30 total fixes accepted
- ✅ Structural changes applied
- ✅ Complex components migrated
- ⏱️ Manual time saved: 6-8 hours

**After Tier 3 (Exercise 3):**
- ✅ Understanding of AI limitations
- ✅ Know when to reject suggestions
- ✅ Confidence in migration decisions
- ⏱️ Total time saved: 10-15 hours

---

## Slide 14: When to Trust AI

# Decision Framework

**✅ High Confidence - Accept AI Fix:**
- Simple component renames
- Straightforward prop changes
- CSS class/variable updates
- 1:1 replacements with no logic changes

**🟡 Review Carefully (Tier 2):**
- Structural component changes
- Multiple related changes in one file
- Icon prop restructuring
- Anything affecting component behavior

**❌ Reject or Manual Fix:**
- Compatibility layers (intentional dual support)
- Dynamic string construction
- Complex conditional logic
- Custom wrapper APIs

**Golden Rule**: If you don't understand the fix, don't apply it!

---

## Slide 15: Hands-On Time!

# Let's Get Started

**Before Exercise 1:**
1. ✅ Workshop app running (`npm run dev`)
2. ✅ VS Code with Konveyor extension open
3. ✅ Analysis results loaded
4. ✅ Create `tier1-fixes` branch

**During exercises:**
- Work at your own pace
- Ask questions anytime
- Compare with reference branches if stuck
- Celebrate wins, learn from mistakes

**Remember:**
- Test after each tier (`npm test`)
- Commit your progress
- AI mistakes are learning opportunities

---

## Slide 16: Exercise Checkpoints

# Testing & Validation

**After Each Tier, Run:**

```bash
# 1. Run automated tests
npm test
# All 15 tests should pass

# 2. Run the app
npm run dev
# Open http://localhost:3000

# 3. Manual testing checklist
# - Click buttons, verify interactions
# - Check console for errors
# - Verify visual appearance unchanged

# 4. Commit your work
git add .
git commit -s -m "Apply Tier X migration fixes"
```

**Success Criteria:**
- ✅ Tests pass
- ✅ No console errors
- ✅ Interactions still work
- ✅ Visual appearance intact

---

## Slide 17: Discussion Questions

# Throughout the Workshop

**During Tier 1:**
- How long would this take you manually?
- Do you trust this AI fix? Why or why not?
- What would make you more confident?

**During Tier 2:**
- How does AI reasoning help you verify the fix?
- Would you have spotted this pattern without AI?
- What's missing from the explanation?

**During Tier 3:**
- When should you reject AI suggestions?
- How do you know AI can't handle this safely?
- What would help AI succeed here?

**Key Insight**: AI is a powerful assistant, not a replacement for developer judgment

---

## Slide 18: What We Want From You

# Feedback Goals

**What Worked:**
- Which violation types did AI handle best?
- Which patterns felt safe to auto-apply?
- Where did you trust the AI most?

**What Needs Improvement:**
- Which patterns did AI struggle with?
- Where did you lose confidence?
- Any false positives encountered?

**PatternFly-Specific:**
- Missing patterns to add to ruleset
- Documentation gaps that would help AI
- Integration ideas with PatternFly tooling

**Your feedback shapes the future of this tool!**

---

## Slide 19: Resources & Next Steps

# Continue Your Journey

**Documentation:**
- 📚 Workshop Guide: [github.com/tsanders-rh/patternfly-migration-workshop](https://github.com/tsanders-rh/patternfly-migration-workshop)
- 📝 Blog Series: [Automating UI Migrations](https://www.migandmod.net/2025/10/22/automating-ui-migrations-ai-analyzer-rules/)
- 🔧 Konveyor Docs: [konveyor.io/docs](https://konveyor.io/docs)
- 🎨 PatternFly v6 Guide: [patternfly.org/get-started/upgrade](https://www.patternfly.org/get-started/upgrade/)

**Community:**
- 💬 Slack: #konveyor on Kubernetes Slack
- 🐛 Issues: [github.com/konveyor/kai/issues](https://github.com/konveyor/kai/issues)
- 📧 Email: konveyor-community@googlegroups.com

**Follow-Up:**
- 4-6 weeks: Demo of improvements based on your feedback
- Ongoing: Contribute rules, report issues, share success stories

---

## Slide 20: Questions Before We Dive In?

# Let's Make This Interactive

**Feel free to ask about:**
- The technology stack
- Your specific migration scenarios
- Integration with your workflow
- Customizing rules for your patterns

**Remember:**
- This is hands-on and collaborative
- No question is too basic
- Share your screen if you hit issues
- We're all learning together

**Ready to transform weeks of work into days?**

**Let's get started!**

---

# Backup Slides

---

## Backup: Why Not Just Use AI?

# "Can't I Just Ask Claude Code to Migrate My App?"

**Prompt-Driven Approach:**
```
"Please migrate this codebase from PatternFly v5 to v6"
```

**Challenges:**

❓ **Completeness Unknown**
- Did it find everything?
- How do you verify nothing was missed?
- "I think I got them all" ≠ certainty

⚠️ **LLM Attention Limits**
- Might miss violations in files it doesn't read
- No guarantee of systematic coverage
- Token limits prevent full codebase scanning

📊 **No Progress Tracking**
- Can't measure % complete
- Hard to resume if interrupted
- Difficult to prioritize work

🔄 **Not Repeatable**
- Different results each run
- Hard to scale across projects
- No codified rules to share

---

## Backup: The Hybrid Advantage

# Static Analysis + AI = Better Together

```
┌─────────────────────────┐
│  Static Analysis        │  Finds ALL violations
│  (Kantra)               │  ✅ Complete
│                         │  ✅ Precise (no false positives)
│  🔍 Semantic scanning   │  ✅ Repeatable
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  AI Fix Generation      │  Generates intelligent solutions
│  (Kai)                  │  ✅ Context-aware
│                         │  ✅ Explains reasoning
│  🤖 LLM reasoning       │  ✅ Complex refactoring
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  Human Judgment         │  Applies business context
│  (You!)                 │  ✅ Compatibility decisions
│                         │  ✅ Architecture choices
│  👤 Final decision      │  ✅ Quality validation
└─────────────────────────┘
```

**Why This Works:**
- Static analysis ensures **nothing is missed**
- AI provides **intelligent fixes** (not just find/replace)
- Human provides **business context** AI can't understand

---

## Backup: Static Analysis Precision

# Semantic Analysis vs. Text Matching

**Problem:** Find all `isDisabled` prop usages that need migration

**❌ Text Search (grep/find):**
```bash
grep -r "isDisabled" .
```
**Result:** 1,247 matches
- Comments mentioning "isDisabled"
- String literals: `"Check if isDisabled"`
- Unrelated variables: `const isDisabled = true`
- Test mocks and snapshots
- **88 actual violations** buried in noise

**✅ Semantic Analysis (Kantra):**
```bash
kantra analyze --rules patternfly --source v5 --target v6
```
**Result:** 88 violations
- Only PatternFly component props
- AST-aware (understands React structure)
- Filters out comments, strings, tests
- Precise line numbers and context
- **Zero false positives**

**Time Saved:** Hours of manual filtering → Seconds of accurate results

---

## Backup: Enterprise Scale Example

# Real-World: Migrating 50 Applications

**Scenario:** Enterprise with 50 apps using PatternFly v5

### Claude Code Alone:
```bash
# For each app:
1. Open in Claude Code
2. Prompt: "Migrate to PatternFly v6"
3. Hope it finds everything
4. Test manually
5. ❓ Is it complete?
6. Repeat 50 times (inconsistent each time)
```

**Problems:**
- No visibility into total scope upfront
- Can't prioritize apps by effort
- Inconsistent approach across apps
- Hard to verify completeness
- Difficult to track team progress

### Konveyor Approach:
```bash
# Step 1: Analyze all apps
for app in app{1..50}; do
  kantra analyze --rules patternfly --input $app/
done

# Step 2: Generate report
App1: 234 violations → Est. 12 hours
App2: 89 violations  → Est. 4 hours  ⭐ Start here
App3: 567 violations → Est. 20 hours
...

# Step 3: Migrate with AI assistance
# - Systematic, repeatable
# - Track: violations fixed / total
# - Verify: Re-run → 0 violations ✅
```

**Benefits:**
- ✅ Know scope upfront (no surprises)
- ✅ Prioritize by business value + effort
- ✅ Consistent approach across all apps
- ✅ Track team progress objectively
- ✅ Verify completeness (0 violations = done)
- ✅ Reuse rules/lessons learned

---

## Backup: Troubleshooting Quick Reference

# Common Issues & Solutions

**Kantra won't run:**
- ✅ Check Podman/Docker is running: `podman --version`
- ✅ Verify rules path: `ls ../rulesets/preview/nodejs/patternfly`
- ✅ Use pre-generated analysis results

**VS Code extension not working:**
- ✅ Verify API key is set in settings
- ✅ Check extension version (latest)
- ✅ Reload VS Code: Cmd+Shift+P → "Reload Window"
- ✅ Fall back to command-line workflow

**AI fixes not generating:**
- ✅ Check AI provider status/rate limits
- ✅ Try different provider (OpenAI ↔ Anthropic)
- ✅ Use pre-generated fix examples

**Tests failing:**
- ✅ Check if violation was actually fixed
- ✅ Review diff for unintended changes
- ✅ Rollback to previous branch

---

## Backup: Architecture Deep Dive

# How Konveyor Works Under the Hood

**Rule Execution (Kantra):**
1. Parse TypeScript/React code into AST
2. Execute rules against AST
3. Generate violation list with locations
4. Output to YAML/JSON

**AI Fix Generation (KAI):**
1. Load violation context
2. Retrieve relevant documentation
3. Generate fix with LLM reasoning
4. Format as diff for review

**VS Code Extension:**
1. Parse analysis results
2. Display violations in tree view
3. Request AI fixes on demand
4. Apply diffs to files

**All open source**: [github.com/konveyor](https://github.com/konveyor)

---

## Backup: Enterprise Use Cases

# Scaling Across Organizations

**Scenario A: Enterprise with 50 PatternFly Apps**
- Run analysis across all repos
- Prioritize by violation count
- Apply high-confidence fixes automatically
- Manual review for edge cases
- Measure: time saved, bugs prevented

**Scenario B: ISV with Customer Apps**
- Create custom rulesets for your patterns
- Support gradual migrations
- Document migration path for customers
- CI/CD integration for ongoing validation

**Scenario C: Open Source Project**
- Version rules with code
- Community contribution workflows
- Public ruleset validation
- Share migration lessons learned

---

## Notes for Facilitators

### Slide Timing
- **Slides 1-6** (10 min): Welcome and context setting
- **Slides 7-10** (10 min): Pipeline overview
- **Slides 11-14** (5 min): Workshop structure and expectations
- **Slides 15-17** (5 min): Getting started and checkpoints
- **Slides 18-20** (Revisit during wrap-up)

### Key Points to Emphasize
- **Slide 4**: Real time savings - this resonates with busy teams
- **Slide 9**: Semantic analysis accuracy - this is Konveyor's superpower
- **Slide 14**: When to trust AI - critical for confidence
- **Slide 18**: Feedback is valuable - make them feel heard

### Visual Suggestions
- **Slide 3**: Screenshot of tackle2-ui violations report
- **Slide 6**: Screenshot of Workshop Console app
- **Slide 9**: Side-by-side comparison of analysis results
- **Slide 10**: Animated flow or screenshot of VS Code extension
- **Slide 12**: Tree diagram of git branches

### Speaking Tips
- Keep technical depth appropriate for audience (PatternFly team = technical)
- Pause after Slide 14 for questions before diving in
- Use Slide 17 questions throughout exercises, not just at end
- Reference slide numbers during exercises: "Remember slide 14's decision framework..."

### When to Use Backup Slides

**"Why Not Just Use AI?" slides** - Use if:
- Someone asks: "Can't we just use Claude/ChatGPT directly?"
- Need to justify the static analysis component
- Audience includes decision-makers evaluating tooling options
- Want to emphasize value of systematic approach

**Best timing:**
- After Slide 9 (Semantic Analysis) if question comes up
- During Q&A at end if not covered
- Include in follow-up materials for stakeholders

**Key message:** Static analysis + AI is more complete, precise, and repeatable than AI alone
