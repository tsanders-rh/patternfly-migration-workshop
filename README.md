# PatternFly v5→v6 Migration Workshop

> **Transform weeks of manual migration work into days with AI-assisted semantic analysis**

A hands-on 4-5 hour workshop teaching developers how to migrate PatternFly v5 applications to v6 using [Konveyor](https://konveyor.io)'s AI-assisted migration platform.

## Why This Workshop?

**The Problem:**
- Manual PatternFly v5→v6 migrations take **2-4 weeks**
- Text search (`grep`) returns **1,247 false positives** for a single pattern
- "I think I got everything" ≠ production-ready
- Every missed violation = potential runtime error

**The Solution:**
```bash
kantra analyze → 234 violations found (100% complete ✅)
Apply AI fixes → Test → Verify
0 violations remaining = mathematical certainty
```

**Time Savings:** 87% reduction (2-4 weeks → 2-4 days)
**Cost Savings:** $13,600-19,200 per project | $680K-960K for 50 apps
**Quality:** Zero missed violations, verified completeness

---

## What You'll Learn

This workshop teaches the **three-part pipeline** that makes systematic migrations possible:

### 1. **Semantic Analysis** (Kantra)
- Find **ALL** violations automatically
- AST-aware (understands React/TypeScript structure)
- Zero false positives (88 violations, not 1,247 grep results)

### 2. **AI-Assisted Fixes** (Kai)
- Generate intelligent solutions with reasoning
- Context-aware refactoring (not just find/replace)
- Explains **why** each change is needed

### 3. **Human Judgment** (You!)
- Review AI suggestions with context
- Accept high-confidence patterns
- Reject edge cases (compatibility layers, dynamic code)

**The Key Insight:** Same violation can require different decisions based on context. AI provides rules. You provide judgment.

---

## Workshop Structure

### Three Complexity Tiers (Incremental Learning)

**🟢 Tier 1: Quick Wins** (30 min, ~60 violations)
- Component renames: `Text` → `Content`, `Chip` → `Label`
- Prop changes: `isDisabled` → `disabled`
- CSS updates: `pf-v5-*` → `pf-v6-*`
- **AI Success Rate: ~95%** - Build confidence

**🟡 Tier 2: Structural Changes** (45 min, ~15 violations)
- MenuToggle icon restructuring
- EmptyState component updates
- Button icon prop changes
- **AI Success Rate: ~85%** - Learn careful review

**🔴 Tier 3: Edge Cases** (30 min, ~5 violations)
- Compatibility layers (reject AI suggestions!)
- Dynamic imports (AI can't handle safely)
- Custom wrappers (partial fixes only)
- **AI Success Rate: ~50%** - Master human judgment

### The Teaching Moment

**Exercise 1:** Apply "Text → Content" fix to `UserProfile.tsx` ✅

**Exercise 3:** Reject "Text → Content" fix to `CompatibilityLayer.tsx` ❌

**Same violation. Different context. Different decision.**

This is why Konveyor + human expertise beats AI alone.

---

## ROI: Why Not Just Use AI Prompts?

**"Can't I just ask ChatGPT to migrate my codebase?"**

| Approach | Time | Cost (@$150/hr) | Completeness | Scale |
|----------|------|-----------------|--------------|-------|
| **Manual** | 3-4 weeks | $18K-24K | Unknown | Poor |
| **AI Prompts Only** | 1-2 weeks | $6K-12K | Unknown | Poor |
| **Konveyor** | **2-4 days** | **$2.4K-4.8K** | **Verified ✅** | **Excellent** |

### What Konveyor Provides That AI Alone Cannot:

1. **Completeness Certainty** - "0 violations remaining" vs. "I think I got everything"
2. **Enterprise Scale** - Consistent approach across 50 apps, not 50 different prompts
3. **Progress Tracking** - "234→150→0 violations (65% complete)" vs. "¯\_(ツ)_/¯"
4. **Reusability** - Rules codified once, reused across all projects
5. **Verification** - Re-run analysis to mathematically confirm completion

**Real Example (tackle2-ui):**
- 3,557 violations across 400+ files
- Manual estimate: 3-4 weeks
- Konveyor actual: 2-4 days
- **Savings: $13,600-19,200 per project**

**Enterprise Impact (50 apps):**
- **Total Savings: $680,000-960,000**
- Consistent quality across all teams
- Audit trail for compliance
- Reusable institutional knowledge

---

## Quick Start

### Automated Setup (Recommended for Workshop Participants)

**For workshop participants**, we provide automated setup scripts that verify and install all prerequisites:

- **macOS/Linux**: See [SETUP.md](./SETUP.md) for instructions
- **Windows**: See [SETUP.md](./SETUP.md) for PowerShell script

The scripts will check for Node.js, Docker/Podman, VS Code, and set up everything you need.

### Manual Installation

#### Prerequisites

- Node.js 18+ and npm
- Podman 4+ or Docker 24+ (for Konveyor analysis)
- VS Code with Konveyor extension (for workshop)

#### Steps

```bash
# Clone the repository
git clone https://github.com/tsanders-rh/patternfly-migration-workshop.git
cd patternfly-migration-workshop

# Install dependencies
npm install

# Start development server
npm run dev
```

The app will open at `http://localhost:3000`

### Run Tests

```bash
npm test
```

## Workshop Usage

### Step 1: Run Konveyor Analysis

```bash
# Download the PatternFly v5→v6 ruleset with tier labels to parent directory (skip if you used setup script)
cd ..
git clone -b patternfly-workshop-tiers https://github.com/tsanders-rh/rulesets.git
cd patternfly-migration-workshop

# Run analysis using the preview/nodejs/patternfly ruleset
kantra analyze \
  --input . \
  --rules ../rulesets/preview/nodejs/patternfly \
  --output ./analysis-results \
  --source patternfly-v5 \
  --target patternfly-v6 \
  --enable-default-rulesets=false
```

**Note:** If you used the automated setup script, the rulesets are already cloned to the parent directory (`../rulesets/`).

**Expected Results**: ~211 violations including:
- ~123 CSS migrations (classes and variables)
- ~88 code violations across 3 complexity tiers

### Step 2: Open in VS Code with Konveyor Extension

```bash
code .
```

1. Install the Konveyor extension from VS Code marketplace
2. Open the Konveyor Analysis view (sidebar icon)
3. Configure your AI provider (OpenAI, Anthropic, etc.)
4. Load the analysis results
5. Start generating AI-assisted fixes!

### Step 3: Process Violations by Tier

**Tier 1 (Quick Wins - Start Here):**
- Text → Content component
- Chip → Label component
- CSS class and variable updates
- Simple prop renames (isDisabled → disabled)

**Tier 2 (Moderate Complexity):**
- MenuToggle icon restructuring
- EmptyState component changes
- Button icon prop changes

**Tier 3 (Edge Cases - Learn When to Reject):**
- Compatibility layers (intentional dual support)
- Dynamic imports (AI can't handle safely)
- Custom wrappers (update internal, keep API stable)

## Project Structure

```
src/
├── components/
│   ├── tier1-simple/          # Simple renames and prop changes
│   ├── tier2-moderate/         # Structural refactoring
│   └── tier3-edge-cases/       # Manual intervention needed
├── styles/                     # CSS with v5 classes and variables
├── __tests__/                  # Test mocks that need updating
└── App.tsx                     # Main application
```

## Expected Violations Summary

| Category | Count | Examples |
|----------|-------|----------|
| **CSS Classes** | ~53 | pf-v5-c-* → pf-v6-c-*, pf-v5-u-* → pf-v6-u-* |
| **CSS Variables** | ~70 | --pf-v5-global → --pf-t--global |
| **Component Renames** | 6 | Text→Content, Chip→Label |
| **Prop Changes** | ~40 | isDisabled→disabled, isActive→isCurrent |
| **Structural Changes** | ~15 | MenuToggle icons, EmptyState, Button icons |
| **Edge Cases** | ~5 | CompatibilityLayer, DynamicComponent |
| | | |
| **Total CSS** | **~123** | Bulk migration patterns |
| **Total Code** | **~88** | Component & prop updates |
| **Grand Total** | **~211** | All violations combined |

## Learning Objectives

After completing this workshop, you'll be able to:

### Technical Skills

1. ✅ Run semantic analysis to find 100% of violations (not 50% like grep)
2. ✅ Generate AI-assisted fixes with context and reasoning
3. ✅ Review diffs and apply changes confidently
4. ✅ Test incrementally (branch → fix → test → commit)

### Judgment Skills

5. ✅ Identify high-confidence patterns (auto-accept safely)
6. ✅ Recognize patterns requiring careful review (verify AI reasoning)
7. ✅ Reject AI suggestions when context demands it (compatibility layers, dynamic code)
8. ✅ Understand **when** to apply rules, not just **how**

### Strategic Skills

9. ✅ Estimate migration scope upfront (violations → hours)
10. ✅ Track progress objectively (234→0 violations = done)
11. ✅ Scale approach across multiple projects (reusable rules)
12. ✅ Verify completeness mathematically (0 violations = ship it)

### Transferable Knowledge

- These patterns apply to ANY framework migration (Angular→React, Vue 2→3, React 17→18)
- Create custom Konveyor rules for your organization's patterns
- Apply systematic migration thinking to non-code changes

## Related Resources

- [Blog Series: Automating UI Migrations](https://www.migandmod.net/2025/10/22/automating-ui-migrations-ai-analyzer-rules/)
  - Part 1: AI-Generated Analyzer Rules
  - Part 2: Semantic Analysis for Precision
  - Part 3: AI-Assisted Fixes with Konveyor
- [Konveyor Project](https://konveyor.io)
- [PatternFly v6 Migration Guide](https://www.patternfly.org/get-started/upgrade/)
- [Konveyor Rulesets Repository](https://github.com/konveyor/rulesets) (upstream)
- [Workshop Rulesets with Tier Labels](https://github.com/tsanders-rh/rulesets/tree/patternfly-workshop-tiers) (used in this workshop)

## Documentation

- **[Participant Guide](./docs/PARTICIPANT_GUIDE.md)** - Step-by-step exercises for workshop day
- **[Workshop Guide](./docs/WORKSHOP_GUIDE.md)** - Facilitator instructions and timing
- **[Slides](./docs/SLIDES.md)** - Presentation deck with value proposition and ROI
- **[AI Providers](./docs/AI_PROVIDERS.md)** - Configure OpenAI, Anthropic, Bedrock, or Ollama
- **[Quick Reference](./docs/QUICK_REFERENCE.md)** - Printable cheat sheet

---

## Next Steps After the Workshop

### Within 1 Week
```bash
# Analyze your own PatternFly v5 codebase
cd your-app/
kantra analyze --rules patternfly --source v5 --target v6

# Review results and share with team
```

- [ ] Run analysis on one real project
- [ ] Identify top 10 violation patterns
- [ ] Migrate one small file (build confidence)
- [ ] Share violation count with team

### Within 1 Month
- [ ] Migrate a complete feature or page
- [ ] Measure: Time with Konveyor vs. estimated manual time
- [ ] Document patterns that worked well
- [ ] Share results: "We saved X hours using Konveyor"

### Within 3 Months
- [ ] Migrate production application to PatternFly v6
- [ ] Track metrics: violations fixed, time saved, bugs prevented
- [ ] Create internal case study for other teams
- [ ] Consider creating custom rules for organization-specific patterns

### Calculate Your ROI
```
Violations found: _______
Time with Konveyor: _______ hours
Estimated manual time: _______ hours
Time saved: _______ hours × $___/hour = $_______
```

---

## Community & Support

**Get Help:**
- 💬 Slack: #konveyor on Kubernetes Slack
- 🐛 GitHub Issues: [konveyor/kai/issues](https://github.com/konveyor/kai/issues)
- 📧 Email: konveyor-community@googlegroups.com

**Share Your Success:**
- Blog about your migration experience
- Present at team/company tech talks
- Contribute custom rules back to the community
- Share metrics: time saved, violations fixed, ROI achieved

**We Want to Hear From You:**
- What patterns did you migrate?
- How much time did you save?
- What would make Konveyor better?

---

## Contributing

Found an edge case or have suggestions for additional examples? Open an issue or PR!

**Ideas for contributions:**
- Additional Tier 3 edge cases
- Custom migration patterns
- Documentation improvements
- Test coverage expansion

## License

Apache 2.0
