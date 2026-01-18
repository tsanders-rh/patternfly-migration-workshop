# Workshop Documentation

This directory contains all workshop documentation and guides.

---

## For Participants

### [Participant Guide](./PARTICIPANT_GUIDE.md) 📝
**Use this on workshop day!**

Step-by-step instructions for all three exercises:
- Exercise 1: Tier 1 - Quick Wins (30 min)
- Exercise 2: Tier 2 - Moderate Complexity (45 min)
- Exercise 3: Tier 3 - Edge Cases (30 min)

Includes:
- Detailed walkthroughs with code examples
- Testing and verification steps
- Decision framework (when to accept/reject AI)
- Troubleshooting guide
- Quick reference commands

**Start here on workshop day** after completing setup.

---

### [AI Providers Configuration](./AI_PROVIDERS.md) 🤖
Complete guide to configuring AI providers for fix generation:

- **AWS Bedrock** (workshop default - shared key)
- **OpenAI** (GPT-4, bring your own key)
- **Anthropic** (Claude, bring your own key)
- **Ollama** (local, free, offline)
- **Azure OpenAI** (enterprise)

Use this if you want to use your own AI provider instead of the workshop's shared Bedrock credentials.

---

## For Facilitators

All facilitator materials are in [./facilitator/](./facilitator/):

### [Workshop Guide](./facilitator/WORKSHOP_GUIDE.md) 🎓
**Comprehensive facilitator guide** including:
- Pre-workshop setup checklist
- Detailed session-by-session schedule (with timing)
- Live demo instructions
- Exercise walkthrough with discussion prompts
- Git branching strategy
- Troubleshooting common issues

### [Slides](./facilitator/SLIDES.md) 📊
**Presentation deck** with:
- Value proposition and ROI messaging
- Three-part pipeline explanation
- Workshop structure and expectations
- Discussion questions
- Backup slides for common objections

### [Meeting Invite](./facilitator/MEETING_INVITE.txt) 📧
**Calendar invitation template** - copy/paste format with:
- Concise agenda and timing
- Prerequisites checklist
- Value proposition (time/cost savings)

### [Agenda](./facilitator/AGENDA.md) 📋
**Detailed workshop agenda** including:
- Complete schedule with descriptions
- Full prerequisites and setup instructions
- Learning objectives
- Post-workshop action plan

---

## Internal Documentation

### [Validation Summary](./VALIDATION_SUMMARY.md) ✅
Quick overview of violation validation results:
- 211 total violations (all legitimate)
- Breakdown by category
- Recommended workshop flow
- Approval for workshop use

### [Violation Validation](./VIOLATION_VALIDATION.md) 📊
Detailed validation of all 211 violations:
- Per-file breakdown
- Specific examples
- Validation notes
- False positive analysis (none found)

### [OpenShift Console Theme](./OPENSHIFT-CONSOLE-THEME.md) 🎨
Documentation about the console-style UI design:
- Design decisions
- Layout structure
- Benefits for workshop
- Migration violations preserved

---

## Quick Navigation

**Just starting?** → [../SETUP.md](../SETUP.md) (in repo root)

**Workshop day?** → [Participant Guide](./PARTICIPANT_GUIDE.md)

**Running the workshop?** → [Workshop Guide](./facilitator/WORKSHOP_GUIDE.md)

**Need AI setup?** → [AI Providers](./AI_PROVIDERS.md)

**Setting up AWS Bedrock?** → [../infrastructure/](../infrastructure/)

---

## File Organization

```
patternfly-migration-workshop/
├── README.md                    # Project overview
├── SETUP.md                     # Pre-workshop setup
│
├── docs/                        # 📁 YOU ARE HERE
│   ├── PARTICIPANT_GUIDE.md     # Day-of exercises
│   ├── AI_PROVIDERS.md          # AI configuration
│   ├── QUICK_REFERENCE.md       # Printable cheat sheet
│   │
│   ├── facilitator/             # 📁 Facilitator materials
│   │   ├── WORKSHOP_GUIDE.md    # Facilitator guide
│   │   ├── SLIDES.md            # Presentation deck
│   │   ├── MEETING_INVITE.txt   # Calendar invite template
│   │   └── AGENDA.md            # Detailed schedule
│   │
│   ├── VALIDATION_SUMMARY.md    # Violation validation
│   ├── VIOLATION_VALIDATION.md  # Detailed validation
│   └── OPENSHIFT-CONSOLE-THEME.md
│
└── infrastructure/              # AWS/cloud setup
    └── BEDROCK_SETUP.md
```
