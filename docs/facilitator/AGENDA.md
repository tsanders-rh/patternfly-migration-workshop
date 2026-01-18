# PatternFly v5→v6 Migration Workshop
## AI-Assisted Migration with Konveyor

**Duration:** 4-5 hours (hands-on)
**Who Should Attend:** Developers, architects, and tech leads working with PatternFly applications

---

## What You'll Gain

Transform weeks of manual migration work into days with AI-assisted semantic analysis.

**Time Savings:** 87% reduction (2-4 weeks → 2-4 days)
**Cost Savings:** $13,600-19,200 per project | $680K-960K for 50 apps
**Skills:** Learn when to trust AI, when to review carefully, and when to reject suggestions

---

## Agenda

### Morning Session

**9:00-9:30 | Introduction & The Migration Challenge**
- The PatternFly v5→v6 migration problem (real examples)
- Why manual and AI-only approaches fall short
- The Konveyor value proposition

**9:30-10:45 | Live Demo: Three-Part Pipeline**
- Part 1: AI-generated rules from PatternFly docs
- Part 2: Semantic analysis finds ALL violations (zero false positives)
- Part 3: AI-assisted fix generation with reasoning

**10:45-12:00 | PatternFly Team Presentation**
- Official PatternFly v6 changes and rationale
- Common migration patterns and gotchas
- Q&A with PatternFly maintainers

**12:00-1:00 | Working Lunch** (provided)

### Afternoon Session

**1:00-1:45 | Hands-On: Tier 1 - Quick Wins**
- Component renames: Text → Content, Chip → Label
- CSS updates: pf-v5-* → pf-v6-*
- Simple prop changes: isDisabled → disabled
- **Goal:** Build confidence with 95% AI success rate

**1:45-2:45 | Hands-On: Tier 2 - Structural Changes**
- MenuToggle icon restructuring
- EmptyState component updates
- Button icon prop changes
- **Goal:** Learn to review AI reasoning carefully (85% success rate)

**2:45-3:15 | Break**

**3:15-3:45 | Hands-On: Tier 3 - Edge Cases**
- Compatibility layers (reject AI!)
- Dynamic imports (AI limitations)
- Custom wrapper APIs
- **Goal:** Master human judgment (50% success rate - this is intentional!)

**3:45-4:30 | Feedback & Discussion**
- What worked well? What needs improvement?
- Share experiences and insights
- PatternFly-specific feedback session

**4:30-4:45 | Wrap-Up & Next Steps**
- Take Konveyor back to your team (action plan)
- Community resources and support
- ROI tracking template

---

## Prerequisites

**Before the Workshop:**

1. **Run the Setup Script** (15-20 minutes)
   - macOS/Linux: See setup instructions at [workshop repo]
   - Windows: PowerShell script provided
   - Installs: Node.js, Docker/Podman, VS Code, Konveyor extension

2. **Clone the Workshop Repo**
   ```bash
   git clone https://github.com/tsanders-rh/patternfly-migration-workshop.git
   cd patternfly-migration-workshop
   npm install
   ```

3. **AI Provider** (Choose one)
   - **Option 1:** Use shared workshop credentials (provided day-of)
   - **Option 2:** Bring your own API key (OpenAI ~$1, Anthropic ~$0.50, or free Ollama)
   - See `docs/AI_PROVIDERS.md` for details

4. **Test Your Setup** (Recommended)
   ```bash
   npm run dev  # Should open http://localhost:3000
   npm test     # Should pass 15 tests
   ```

**What to Bring:**
- Laptop with setup completed
- Questions about your own PatternFly migration challenges
- Examples of patterns you want to migrate

---

## What You'll Learn

### Technical Skills
- Run semantic analysis to find 100% of violations
- Generate AI-assisted fixes with context
- Review diffs and apply changes confidently
- Test incrementally (branch → fix → test → commit)

### Judgment Skills
- Identify high-confidence patterns (auto-accept safely)
- Recognize patterns requiring careful review
- Reject AI suggestions when context demands it
- Understand **when** to apply rules, not just **how**

### Strategic Skills
- Estimate migration scope upfront (violations → hours)
- Track progress objectively (234→0 violations = done)
- Scale approach across multiple projects
- Verify completeness mathematically

---

## After the Workshop

**Within 1 Week:**
- Run analysis on your own PatternFly v5 codebase
- Share violation count with your team
- Migrate one small file to build confidence

**Within 1 Month:**
- Migrate a complete feature or page
- Measure and share ROI: "We saved X hours using Konveyor"

**Within 3 Months:**
- Production migration complete
- Create internal case study for other teams
- Consider custom rules for your organization

---

## Resources

**Documentation:**
- Workshop Repo: https://github.com/tsanders-rh/patternfly-migration-workshop
- Participant Guide: `docs/PARTICIPANT_GUIDE.md`
- AI Provider Setup: `docs/AI_PROVIDERS.md`
- Quick Reference Card: `docs/QUICK_REFERENCE.md` (printable)

**Community:**
- Slack: #konveyor on Kubernetes Slack
- GitHub Issues: https://github.com/konveyor/kai/issues
- Email: konveyor-community@googlegroups.com

**Related:**
- Konveyor Docs: https://konveyor.io/docs
- PatternFly v6 Guide: https://www.patternfly.org/get-started/upgrade/
- Blog Series: https://www.migandmod.net/2025/10/22/automating-ui-migrations-ai-analyzer-rules/

---

## Questions?

Contact: [Your email]
Slack: #workshop-help (invitation sent separately)

**We're excited to help you transform your PatternFly migrations!**
