# PatternFly Migration Workshop

A demonstration React application built with PatternFly v5 to showcase migration patterns for the PatternFly v5 → v6 upgrade using Konveyor automation tools.

## Purpose

This app contains carefully curated examples of migration patterns across three complexity tiers:

- **Tier 1: Simple Changes** - Component renames, prop changes, CSS updates
- **Tier 2: Moderate Complexity** - Structural changes, icon refactoring
- **Tier 3: Edge Cases** - Compatibility layers, dynamic imports, custom wrappers

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

After completing this workshop, you'll understand:

1. ✅ How Konveyor generates migration rules from documentation
2. ✅ How semantic analysis improves violation detection accuracy
3. ✅ Which patterns AI handles well vs. requiring manual review
4. ✅ How to review and apply AI-generated fixes confidently
5. ✅ When to accept, modify, or reject AI suggestions
6. ✅ How to integrate migration detection into CI/CD

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
- **[AI Providers](./docs/AI_PROVIDERS.md)** - Configure OpenAI, Anthropic, Bedrock, or Ollama

## Contributing

Found an edge case or have suggestions for additional examples? Open an issue or PR!

## License

Apache 2.0
