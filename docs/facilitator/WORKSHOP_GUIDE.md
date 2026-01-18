# PatternFly Migration Workshop - Facilitator Guide

## Workshop Overview

**Duration**: 4-5 hours hands-on
**Audience**: Developers familiar with React and PatternFly
**Prerequisites**: VS Code installed, Konveyor extension ready

## Pre-Workshop Setup (30 minutes before)

### For Facilitators

1. **Test the demo environment**
   ```bash
   git clone https://github.com/tsanders-rh/patternfly-migration-workshop.git
   cd patternfly-migration-workshop
   npm install
   npm run dev  # Verify app runs
   npm test     # Verify tests pass
   ```

2. **Pre-run analysis** (have results ready in case of network issues)
   ```bash
   kantra analyze \
     --input . \
     --rules ../rulesets/preview/nodejs/patternfly \
     --output ./analysis-results-backup \
     --source patternfly-v5 \
     --target patternfly-v6 \
     --enable-default-rulesets=false
   ```

3. **Prepare reference branches** (for participants who get stuck)
   - `main` - Original v5 code with violations
   - `reference/tier1-complete` - Tier 1 fixes applied (simple changes)
   - `reference/tier2-complete` - Tier 2 fixes applied (structural changes)
   - `reference/tier3-complete` - Tier 3 fixes applied (edge cases)

   See "Git Branching Strategy" in Facilitator Tips for detailed setup instructions.

### For Participants

**Send 1 week before:**
- Link to [SETUP.md](../SETUP.md) with automated setup scripts
- Automated setup scripts check and install:
  - [ ] Node.js 18+ installed
  - [ ] Podman or Docker installed
  - [ ] VS Code installed
  - [ ] Git installed
  - [ ] Workshop repository cloned
  - [ ] Dependencies installed
  - [ ] Tests passing
- Request they run the setup script and share `setup-validation-report.txt` if issues
- Request they bring a sample PatternFly codebase (optional)

**Send 1 day before:**
- Reminder to run setup script if not done
- AI provider API key requirements (OpenAI, Anthropic, or Ollama)
- Links to blog post series for background reading
- Optional office hours time for troubleshooting setup issues

## Workshop Schedule

### Session 1: Introduction & Context (30 minutes)

**9:00 - 9:15 - Introductions**
- Each team shares their PatternFly migration challenges
- Set expectations: hands-on, feedback-focused workshop
- Overview of the day's agenda

**9:15 - 9:30 - The Migration Challenge**
- Typical PatternFly v5→v6 migration: weeks of manual work
- Show tackle2-ui example: 3,557 violations across 400+ files
- The automation opportunity: 87% time savings

### Session 2: The Complete Pipeline (1 hour)

**9:30 - 10:30 - Live Demo: Three-Part Process**

**Part 1: AI-Generated Rules (10 min)**
```bash
# Show rule generation from PatternFly docs
python scripts/generate_rules.py \
  --guide https://www.patternfly.org/get-started/upgrade/ \
  --source patternfly-5 \
  --target patternfly-6
```

Show generated rules:
- Component renames (Text → Content)
- Prop changes (isDisabled → disabled)
- CSS updates (pf-v5 → pf-v6)

**Part 2: Semantic Analysis (10 min)**
```bash
# Run analysis on workshop app
kantra analyze \
  --input . \
  --rules ../rulesets/preview/nodejs/patternfly \
  --output ./analysis-results \
  --source patternfly-v5 \
  --target patternfly-v6 \
  --enable-default-rulesets=false
```

Show results:
- ~211 violations found in seconds (123 CSS, 88 code)
- High accuracy (semantic vs. text matching)
- Organized by component/pattern and file

**Part 3: AI-Assisted Fixes (30 min)**

Open in VS Code:
1. Load analysis results
2. Pick simple violation (Text → Content)
3. Click "Get solution"
4. Show AI reasoning
5. Review diff
6. Accept fix
7. Run tests to verify

Then show progression:
- Quick wins (CSS, simple renames)
- Moderate complexity (EmptyState, MenuToggle)
- Edge cases (compatibility layer - reject AI fix)

### Break (15 minutes)

### Session 3: PatternFly Team Presentation (1 hour)

**10:45 - 11:45 - AI-Assisted Upgrades from PatternFly**

Let PatternFly engineers present:
- Their approach to AI-assisted migrations
- Tools they've built
- Challenges encountered
- Areas where they need feedback

**Discussion Topics:**
- Compare Konveyor approach vs. PatternFly's tools
- Where do approaches overlap?
- Where are they complementary?
- Integration opportunities

### Lunch (1 hour working lunch)

**12:00 - 1:00 - Casual Discussion**
Continue conversations from morning, network, discuss specific use cases

### Session 4: Hands-On Lab (2 hours)

**1:00 - 3:00 - Participant Workshop**

**Setup Phase (15 min)**
- Ensure everyone has workshop app running
- Verify VS Code extension configured
- Run initial analysis

**Git Workflow: Create a branch for Tier 1 fixes**
```bash
git checkout -b tier1-fixes
```

**Exercise 1: Quick Wins (30 min)**

Work through Tier 1 violations:

1. **Text → Content (UserProfile.tsx)**
   - Find violations in Analysis view
   - Generate AI fix
   - Review reasoning
   - Accept changes
   - Verify in browser

2. **CSS Variable Updates**
   - Find CSS variable violations
   - Generate fixes
   - Note: 100% success rate expected
   - Accept batch

3. **Prop Renames (StatusBadge.tsx)**
   - isDisabled → disabled
   - Generate and accept
   - Run tests

**Checkpoint: Test and Commit Tier 1 Fixes**

Everyone should have ~15-20 fixes accepted successfully. Now verify and commit:

```bash
# Run tests to verify nothing broke
npm test

# Run the app and verify in browser
npm run dev

# Commit your Tier 1 fixes
git add .
git commit -s -m "Apply Tier 1 migration fixes (simple renames and props)"
```

**Git Workflow: Create a branch for Tier 2 fixes**
```bash
git checkout -b tier2-fixes
```

**Exercise 2: Moderate Complexity (45 min)**

1. **MenuToggle Icon Restructuring (ActionMenu.tsx)**
   - Icon as child → icon prop
   - More complex AI reasoning
   - Review carefully before accepting

2. **EmptyState Component (EmptyStateExample.tsx)**
   - Structural changes
   - Multiple violations in one component
   - Understand the v6 pattern
   - Accept if correct

3. **Button Icon Props (IconButtons.tsx)**
   - Similar pattern to MenuToggle
   - Multiple instances
   - Batch process with review

**Checkpoint: Test and Commit Tier 2 Fixes**

Should have ~25-30 total fixes accepted. Now verify and commit:

```bash
# Run tests to verify nothing broke
npm test

# Run the app and verify in browser
npm run dev

# Commit your Tier 2 fixes
git add .
git commit -s -m "Apply Tier 2 migration fixes (structural changes)"
```

**Git Workflow: Create a branch for Tier 3 fixes**
```bash
git checkout -b tier3-fixes
```

**Exercise 3: Edge Cases (30 min)**

1. **Compatibility Layer (CompatibilityLayer.tsx)**
   - AI will suggest removing Text import
   - **REJECT this fix**
   - Discussion: When to reject AI

2. **Custom Wrapper (CustomWrapper.tsx)**
   - Update internal implementation
   - Keep public API stable
   - May need manual adjustment

3. **Dynamic Component (DynamicComponent.tsx)**
   - AI can't handle template literals safely
   - Flag for manual review
   - Discussion: AI limitations

**Checkpoint: Test and Commit Tier 3 Fixes**

Everyone understands when AI needs help. Now verify and commit:

```bash
# Run tests to verify nothing broke
npm test

# Run the app and verify in browser
npm run dev

# Commit your Tier 3 fixes (note: some may be rejected or manually adjusted)
git add .
git commit -s -m "Apply Tier 3 migration fixes (edge cases with manual review)"
```

**Migration Complete!** You now have a complete migration trail with three checkpoints.

### Break (15 minutes)

### Session 5: Feedback & Discussion (1.5 hours)

**3:15 - 4:45 - Structured Feedback Session**

**Round 1: What Worked (30 min)**
- Which violation types had highest AI success rate?
- Which patterns felt safe to auto-apply?
- Where did you trust the AI most?

**Round 2: What Needs Improvement (30 min)**
- Which patterns did AI struggle with?
- Where did you lose confidence?
- False positives encountered?
- Missing violations?

**Round 3: Specific PatternFly Feedback (30 min)**
- PatternFly-specific patterns to add to ruleset
- Documentation gaps that would help AI
- Integration ideas with PatternFly's tooling
- Rule quality issues

**Capture Feedback:**
- Shared Google Doc for real-time notes
- GitHub issues for specific bugs/enhancements
- Priority ranking for improvements

### Session 6: Wrap-Up (15 minutes)

**4:45 - 5:00 - Action Items & Next Steps**

1. **Immediate Action Items**
   - Top 3 ruleset improvements
   - Top 3 AI fix quality issues
   - Top 3 VS Code extension UX improvements

2. **Collaboration Plan**
   - PatternFly team validates improved ruleset
   - Schedule follow-up demo in 4-6 weeks
   - Identify integration opportunities

3. **Resources**
   - Share workshop app repository
   - Links to Konveyor documentation
   - Slack/Discord channels for ongoing support

4. **Contribution Pathways**
   - How to contribute rules
   - How to report issues
   - How to share success stories

## Facilitator Tips

### Time Management
- **Stick to schedule** - Use timers
- **Have pre-analyzed results** ready if network fails
- **Prepare to skip exercises** if running behind
- Focus on Tier 1 + discussion if time is tight

### Git Branching Strategy

The workshop uses a **branch-per-tier approach** for several important reasons:

**Benefits:**
- **Safe experimentation** - Each tier has its own branch, so mistakes don't break previous work
- **Clean rollback points** - If Tier 2 goes wrong, participants can return to tier1-fixes
- **Testing checkpoints** - Tests run after each tier ensure nothing broke
- **Real-world practice** - Mirrors how migrations should be done incrementally in production
- **Catchup mechanism** - Participants who fall behind can checkout facilitator's branches

**Branch Structure:**
```
main (original v5 code with violations)
  ├─ tier1-fixes (simple renames, props, CSS)
     ├─ tier2-fixes (structural changes)
        ├─ tier3-fixes (edge cases with manual review)
```

**Facilitator Preparation:**
Create reference branches ahead of time so participants who get stuck can compare:
```bash
# Create reference branches with completed fixes
git checkout -b reference/tier1-complete
# ... apply tier 1 fixes ...
git commit -s -m "Reference: Tier 1 complete"

git checkout -b reference/tier2-complete
# ... apply tier 2 fixes ...
git commit -s -m "Reference: Tier 2 complete"

git checkout -b reference/tier3-complete
# ... apply tier 3 fixes ...
git commit -s -m "Reference: Tier 3 complete"
```

**If participants get stuck:**
- They can compare: `git diff tier1-fixes reference/tier1-complete`
- They can see what changed: `git log reference/tier1-complete`
- They can cherry-pick specific fixes if needed

### Technical Troubleshooting

**Common Issues:**

1. **Kantra won't run**
   - Check Podman/Docker is running
   - Verify path to rules is correct
   - Use pre-generated analysis results

2. **VS Code extension not working**
   - Verify API key is set
   - Check extension version
   - Reload VS Code
   - Fall back to command-line workflow

3. **AI fixes not generating**
   - Check AI provider status/rate limits
   - Try different provider
   - Use pre-generated fix examples

### Engagement Strategies

- **Pair programming** - Have participants work in pairs
- **Live debugging** - When someone hits an issue, debug together
- **Share screens** - Let participants show their results
- **Celebrate wins** - Call out successful automations
- **Embrace failures** - AI mistakes are learning opportunities

### Discussion Questions Throughout

**During Exercise 1:**
- "How long would this take manually?"
- "Do you trust this AI fix? Why or why not?"
- "What would make you more confident?"

**During Exercise 2:**
- "How does AI reasoning help you verify?"
- "Would you have spotted this without AI?"
- "What's missing from the explanation?"

**During Exercise 3:**
- "When should you reject AI suggestions?"
- "How do you know AI can't handle this?"
- "What would help AI succeed here?"

## Post-Workshop Follow-Up

### Within 1 Week

1. **Share workshop summary**
   - Key takeaways
   - Action items with owners
   - Timeline for improvements

2. **Publish feedback**
   - Anonymized feedback to GitHub
   - Blog post about workshop learnings
   - Updated documentation

3. **Start improvements**
   - Fix highest-priority rule issues
   - Address VS Code extension UX problems
   - Begin PatternFly-specific enhancements

### Within 1 Month

1. **Improved ruleset release**
   - Incorporate PatternFly team feedback
   - Add missing patterns
   - Fix false positives

2. **Case study documentation**
   - How PatternFly team validates Konveyor
   - Success metrics from real migrations
   - Lessons learned

3. **Follow-up session**
   - Demo improvements
   - Get feedback on changes
   - Plan next iteration

## Success Metrics

Track these metrics during the workshop:

| Metric | Target | Actual |
|--------|--------|--------|
| Participants completing Exercise 1 | 100% | ___ |
| Average fixes accepted per person | 20+ | ___ |
| Participants who encountered issues | <30% | ___ |
| "AI is helpful" rating (1-5) | 4+ | ___ |
| Would recommend to colleagues | 80%+ | ___ |

## Additional Resources

### For Deeper Dives

- [Konveyor Architecture](https://konveyor.io/docs)
- [Writing Custom Rules](https://github.com/konveyor/analyzer-lsp/blob/main/docs/rules.md)
- [Semantic Analysis Deep Dive](https://www.migandmod.net/2025/10/29/enhancing-ui-migrations-nodejs-provider/)
- [AI Fix Generation Internals](https://github.com/konveyor/kai)

### Example Scenarios

**Scenario A: Enterprise with 50 PatternFly Apps**
- How to scale Konveyor across org
- CI/CD integration patterns
- Measuring ROI

**Scenario B: ISV with Customer Apps**
- Creating custom rulesets
- Supporting gradual migrations
- Documentation strategies

**Scenario C: Open Source Project**
- Community contribution workflows
- Versioning rules with code
- Public ruleset validation

## Appendix: Quick Reference Commands

```bash
# Clone workshop app
git clone https://github.com/tsanders-rh/patternfly-migration-workshop.git
cd patternfly-migration-workshop

# Install and run
npm install
npm run dev

# Run tests
npm test

# Run analysis
kantra analyze \
  --input . \
  --rules ../rulesets/preview/nodejs/patternfly \
  --output ./analysis-results \
  --source patternfly-v5 \
  --target patternfly-v6 \
  --enable-default-rulesets=false

# Compare branches
git diff main..fixed-ai-accepted
git diff fixed-ai-accepted..fixed-hybrid
```

## Migration Success Validation

### Before Migration
```bash
# 1. Run app - everything works
npm run dev

# 2. Run tests - all pass
npm test

# 3. Run analysis - see ~35 violations
kantra analyze \
  --input . \
  --rules ../rulesets/preview/nodejs/patternfly \
  --output ./before-migration \
  --source patternfly-v5 \
  --target patternfly-v6 \
  --enable-default-rulesets=false
```

### After AI-Generated Fixes
```bash
# 1. Build succeeds
npm run build
# ✅ If build fails, migration broke something

# 2. Tests still pass
npm test
# ✅ All interactive tests should still pass

# 3. Lint passes
npm run lint
# ✅ No new warnings

# 4. Re-analyze - violations gone
kantra analyze \
  --input . \
  --rules ../rulesets/preview/nodejs/patternfly \
  --output ./after-migration \
  --source patternfly-v5 \
  --target patternfly-v6 \
  --enable-default-rulesets=false
# ✅ Should show 0-5 violations (edge cases only)
```

### Manual Testing Checklist

Open app at http://localhost:3000 and verify:

#### Tier 1 Components
- [ ] **StatusBadge**: Click each badge → See "Clicked Nx" counter
- [ ] **StatusBadge**: Disabled badge doesn't increment
- [ ] **PageHeader**: Click "Hide subtitle" → Subtitle disappears

#### Tier 2 Components
- [ ] **ActionMenu**: Click three-dot menu → Opens
- [ ] **ActionMenu**: Select "Edit" → Shows "Last action: Edit"
- [ ] **IconButtons**: Click Add → Shows "Added item" in log
- [ ] **IconButtons**: Click multiple buttons → All appear in log
- [ ] **EmptyState**: Click "Clear filters" → Shows "Filters cleared!"
- [ ] **EmptyState**: Wait 2 seconds → Returns to empty state

#### Overall Validation
- [ ] No console errors when interacting
- [ ] All counters/logs update correctly
- [ ] Global interaction counter at top increases
- [ ] Visual appearance unchanged from before migration

### Success Criteria

✅ **Migration Succeeded If:**
- All tests pass
- Build completes without errors
- Manual testing checklist complete
- Konveyor shows 0 violations (or only intentional edge cases)
- No TypeScript errors
- No console errors during interactions

❌ **Migration Failed If:**
- Tests fail
- Build errors
- Event handlers don't work
- State management broken
- Visual regressions

## Contact & Support

- **GitHub Issues**: [konveyor/kai](https://github.com/konveyor/kai/issues)
- **Slack**: #konveyor on Kubernetes Slack
- **Email**: konveyor-community@googlegroups.com
