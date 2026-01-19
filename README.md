# PatternFly Migration Workshop

[![PatternFly](https://img.shields.io/badge/PatternFly-v6.4.0-blue)](https://www.patternfly.org/v6/)
[![React](https://img.shields.io/badge/React-18.2.0-blue)](https://react.dev/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.2.2-blue)](https://www.typescriptlang.org/)
[![Tests](https://img.shields.io/badge/Tests-15%2F15%20passing-green)](./src/__tests__)
[![License](https://img.shields.io/badge/License-Apache%202.0-green)](./LICENSE)

> **Educational workshop application demonstrating PatternFly v5 → v6 migration patterns and AI-assisted migration strategies.**

Created by the [Konveyor Community](https://www.konveyor.io/) to help developers understand migration complexity tiers and when to trust automated tools vs. manual review.

---

## 🎯 Project Overview

This application serves as a **hands-on learning tool** for understanding PatternFly migrations. It contains intentionally diverse patterns across **three complexity tiers** to demonstrate:

- ✅ **When AI migration is safe** (Tier 1)
- ⚠️ **When AI needs verification** (Tier 2)
- 🚨 **When manual review is required** (Tier 3)

### Current Status

**✅ Successfully migrated from PatternFly v5.3.4 → v6.4.0**

- 🎉 **9 components** migrated
- ✅ **15/15 tests** passing
- 🏗️ **Zero build errors**
- 📦 **Production ready**

See [MIGRATION_SUMMARY.md](./MIGRATION_SUMMARY.md) for complete migration details.

---

## 📚 Table of Contents

- [Quick Start](#quick-start)
- [Application Structure](#application-structure)
- [Migration Tiers Explained](#migration-tiers-explained)
- [Running the Application](#running-the-application)
- [Testing](#testing)
- [Migration Guide](#migration-guide)
- [Workshop Learning Objectives](#workshop-learning-objectives)
- [Contributing](#contributing)

---

## 🚀 Quick Start

### Prerequisites

- **Node.js** 18+ and npm
- Basic understanding of React and TypeScript
- Familiarity with PatternFly components (helpful but not required)

### Installation

```bash
# Clone the repository
git clone https://github.com/konveyor/patternfly-migration-workshop.git
cd patternfly-migration-workshop

# Install dependencies
npm install

# Start development server
npm run dev
```

The application will open automatically at `http://localhost:3000`

---

## 🏗️ Application Structure

```
patternfly-migration-workshop/
├── src/
│   ├── App.tsx                      # Main application with navigation
│   ├── main.tsx                     # Entry point
│   ├── components/
│   │   ├── tier1-simple/            # Simple migration patterns
│   │   │   ├── UserProfile.tsx      # Text → Content
│   │   │   ├── StatusBadge.tsx      # Chip → Label
│   │   │   └── PageHeader.tsx       # CSS classes
│   │   ├── tier2-moderate/          # Moderate complexity
│   │   │   ├── ActionMenu.tsx       # MenuToggle icon prop
│   │   │   ├── IconButtons.tsx      # Button icon prop
│   │   │   └── EmptyStateExample.tsx # EmptyState restructure
│   │   └── tier3-edge-cases/        # Manual review required
│   │       ├── CompatibilityLayer.tsx # Gradual migration
│   │       ├── CustomWrapper.tsx    # Stable API wrapper
│   │       └── DynamicComponent.tsx # Dynamic patterns
│   ├── pages/                       # Three demo pages
│   │   ├── ProjectsPage.tsx         # Tier 1 demos
│   │   ├── WorkloadsPage.tsx        # Tier 2 demos
│   │   └── StoragePage.tsx          # Tier 3 demos
│   ├── styles/                      # CSS tokens and components
│   └── __tests__/                   # Jest + React Testing Library
├── MIGRATION_PLAN.md                # Detailed migration strategy
├── MIGRATION_SUMMARY.md             # Migration results and lessons
└── package.json
```

---

## 🎓 Migration Tiers Explained

### Tier 1: Simple Migrations (Low Risk)

**Characteristics:**
- Direct component/prop renames
- CSS class prefix updates
- High confidence for automation

**Examples:**
- `Text` → `Content`
- `Chip` → `Label`
- `pf-v5-u-*` → `pf-v6-u-*`

**AI Success Rate:** ~90%

**Files to Study:**
- `src/components/tier1-simple/UserProfile.tsx`
- `src/components/tier1-simple/StatusBadge.tsx`
- `src/components/tier1-simple/PageHeader.tsx`

---

### Tier 2: Moderate Complexity (Medium Risk)

**Characteristics:**
- Structural component changes
- Icon prop restructuring
- Requires understanding of component API

**Examples:**
- `MenuToggle`: Icon as child → icon prop
- `Button`: Icon component → icon prop
- `EmptyState`: Flattened structure

**AI Success Rate:** ~60%

**Files to Study:**
- `src/components/tier2-moderate/ActionMenu.tsx`
- `src/components/tier2-moderate/IconButtons.tsx`
- `src/components/tier2-moderate/EmptyStateExample.tsx`

---

### Tier 3: Edge Cases (High Risk)

**Characteristics:**
- Dynamic/computed values
- Compatibility layers
- Custom wrappers with stable APIs
- Business logic tied to versions

**Examples:**
- Dynamic CSS class construction
- Gradual migration support
- Template literals in component paths

**AI Success Rate:** ~10%

**Files to Study:**
- `src/components/tier3-edge-cases/CompatibilityLayer.tsx`
- `src/components/tier3-edge-cases/CustomWrapper.tsx`
- `src/components/tier3-edge-cases/DynamicComponent.tsx`

---

## 🎮 Running the Application

### Development Mode

```bash
npm run dev
```

Opens development server with hot reload at `http://localhost:3000`

### Production Build

```bash
npm run build
npm run preview
```

Builds optimized production bundle and previews it

### Available Scripts

| Command | Description |
|---------|-------------|
| `npm run dev` | Start development server |
| `npm run build` | Build for production |
| `npm run preview` | Preview production build |
| `npm test` | Run tests once |
| `npm run test:watch` | Run tests in watch mode |
| `npm run lint` | Run ESLint |

---

## 🧪 Testing

### Running Tests

```bash
# Run all tests
npm test

# Run tests in watch mode
npm run test:watch

# Update snapshots (after verifying changes)
npm test -- -u

# Run specific test file
npm test -- UserProfile.test.tsx
```

### Test Coverage

- **Test Suites:** 2
- **Tests:** 15 total
- **Coverage:** Tier 1 and Tier 2 components

**Test Files:**
- `src/__tests__/UserProfile.test.tsx` - Basic component tests
- `src/__tests__/MigrationValidation.test.tsx` - Comprehensive suite

### Writing Tests

Tests use **Jest** with **React Testing Library**:

```tsx
import { render, screen } from '@testing-library/react';
import { UserProfile } from '../components/tier1-simple/UserProfile';

it('renders user information correctly', () => {
  render(<UserProfile name="Jane" role="Engineer" email="jane@example.com" />);
  
  expect(screen.getByText('Jane')).toBeInTheDocument();
  expect(screen.getByText('Engineer')).toBeInTheDocument();
  expect(screen.getByText('jane@example.com')).toBeInTheDocument();
});
```

---

## 📖 Migration Guide

### For Workshop Participants

#### Step 1: Understand Current State
```bash
# Check out pre-migration state
git checkout pre-migration-v5

# Run the v5 application
npm install
npm run dev
```

#### Step 2: Review Migration Plan
Read `MIGRATION_PLAN.md` to understand:
- What changes are needed
- Why each change is necessary
- Expected challenges

#### Step 3: Follow Migration Branch
```bash
# View migration commit history
git log feature/patternfly-v6-migration --oneline

# Review specific commit
git show a0e6e43  # Tier 1 migration
```

#### Step 4: Study Migration Patterns
Compare before/after for each tier:

```bash
# View specific file changes
git diff pre-migration-v5 feature/patternfly-v6-migration -- src/components/tier1-simple/UserProfile.tsx
```

---

### Migration Checklist Template

Use this for your own PatternFly migrations:

```markdown
## Pre-Migration
- [ ] Create feature branch
- [ ] Run baseline tests
- [ ] Document current state
- [ ] Create rollback tag

## Dependencies
- [ ] Update package.json
- [ ] npm install
- [ ] Document expected errors

## Tier 1: Simple
- [ ] Component renames
- [ ] Prop renames  
- [ ] CSS prefix updates
- [ ] Test and commit

## Tier 2: Moderate
- [ ] Structural changes
- [ ] Icon prop updates
- [ ] Test and commit

## Tier 3: Edge Cases
- [ ] Review dynamic patterns
- [ ] Document exceptions
- [ ] Manual verification
- [ ] Test and commit

## Validation
- [ ] All tests passing
- [ ] Build successful
- [ ] Manual testing
- [ ] Update snapshots

## Documentation
- [ ] Update README
- [ ] Create migration summary
- [ ] Document lessons learned
```

---

## 🎯 Workshop Learning Objectives

By studying this project, you will learn:

### 1. Migration Pattern Recognition

- ✅ Identify simple vs. complex migrations
- ✅ Recognize when automation is safe
- ✅ Spot patterns requiring manual review

### 2. Testing Strategies

- ✅ Test-driven migration approach
- ✅ Snapshot testing for visual changes
- ✅ Integration testing across components

### 3. Risk Management

- ✅ Tier-based migration planning
- ✅ Incremental commits for easy rollback
- ✅ Edge case documentation

### 4. Real-World Scenarios

- ✅ Compatibility layers
- ✅ Custom wrapper components
- ✅ Dynamic pattern handling
- ✅ Performance considerations

---

## 🎨 Application Features

### Navigation

Three main sections demonstrating different tier patterns:

1. **Projects** - Tier 1 simple migrations
2. **Workloads** - Tier 2 moderate complexity
3. **Storage** - Tier 3 edge cases

### Interactive Components

- Collapsible sidebar navigation
- Tabbed interfaces
- Action dropdowns
- Icon buttons with action logging
- Empty state with transitions
- Toggle controls

### Styling

- PatternFly v6 components
- PatternFly v6 CSS tokens
- PatternFly v6 utility classes
- Custom theming examples

---

## 🔧 Tech Stack

| Technology | Version | Purpose |
|------------|---------|---------|
| **React** | 18.2.0 | UI framework |
| **TypeScript** | 5.2.2 | Type safety |
| **PatternFly** | 6.4.0 | Component library |
| **Vite** | 5.0.8 | Build tool |
| **Jest** | 29.7.0 | Testing framework |
| **RTL** | 14.1.2 | Component testing |
| **ESLint** | 8.55.0 | Code linting |

---

## 📊 Key Migration Metrics

| Metric | Value |
|--------|-------|
| **Components Migrated** | 9 |
| **Files Changed** | 23 |
| **TypeScript Errors Fixed** | 24 |
| **CSS Updates** | 76+ |
| **Test Pass Rate** | 100% (15/15) |
| **Build Time Impact** | -4% improvement |
| **Migration Time** | ~8-10 hours |

---

## 🤝 Contributing

This is an educational project maintained by the Konveyor Community.

### How to Contribute

1. **Report Issues**: Found a bug or have a suggestion? [Open an issue](https://github.com/konveyor/patternfly-migration-workshop/issues)

2. **Improve Documentation**: See areas for clarification? Submit a PR

3. **Add Examples**: Have additional migration patterns to share? Contribute them!

4. **Share Feedback**: Let us know how the workshop helped you

### Development Setup

```bash
# Fork the repository
git clone https://github.com/YOUR_USERNAME/patternfly-migration-workshop.git
cd patternfly-migration-workshop

# Create a feature branch
git checkout -b feature/your-feature-name

# Make changes and test
npm install
npm run dev
npm test

# Commit and push
git commit -m "feat: your feature description"
git push origin feature/your-feature-name
```

---

## 📄 License

This project is licensed under the **Apache License 2.0**. See [LICENSE](./LICENSE) for details.

---

## 🔗 Related Resources

### PatternFly

- [PatternFly v6 Documentation](https://www.patternfly.org/v6/)
- [PatternFly Migration Guide](https://www.patternfly.org/v6/get-started/migrate/)
- [PatternFly Community](https://www.patternfly.org/community/)

### Konveyor

- [Konveyor Website](https://www.konveyor.io/)
- [Konveyor GitHub](https://github.com/konveyor)
- [Konveyor Community](https://www.konveyor.io/community/)

### Migration Tools

- [PatternFly Codemods](https://github.com/patternfly/pf-codemods)
- [Konveyor Analyzer](https://www.konveyor.io/tools/analyzer/)

---

## 💡 Tips for Success

### For Learning

1. **Start with Tier 1** - Build confidence with simple patterns
2. **Compare before/after** - Use git diff to see exact changes
3. **Run tests frequently** - Catch issues early
4. **Read component docs** - Understand why changes are needed

### For Real Migrations

1. **Plan thoroughly** - Use the migration plan template
2. **Test incrementally** - Don't migrate everything at once
3. **Commit by tier** - Easy rollback if needed
4. **Document edge cases** - Help your future self

### Red Flags 🚩

Watch out for these patterns that need manual review:

- Template literals in imports/classes
- Dynamic component selection
- Compatibility layers
- Custom wrappers with public APIs
- Runtime-computed values

---

## 🙏 Acknowledgments

Created by the **Konveyor Community** with contributions from:

- PatternFly team for excellent documentation
- React community for testing libraries
- Open source contributors

Special thanks to everyone who provided feedback and suggestions!

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/konveyor/patternfly-migration-workshop/issues)
- **Discussions**: [GitHub Discussions](https://github.com/konveyor/patternfly-migration-workshop/discussions)
- **Community**: [Konveyor Community Forums](https://www.konveyor.io/community/)
- **Documentation**: See [MIGRATION_PLAN.md](./MIGRATION_PLAN.md) and [MIGRATION_SUMMARY.md](./MIGRATION_SUMMARY.md)

---

## 🎓 Workshop Materials

This repository includes:

- ✅ **Complete migration example** (v5 → v6)
- ✅ **Detailed migration plan** with step-by-step guide
- ✅ **Comprehensive test suite** with examples
- ✅ **Edge case documentation** for real-world scenarios
- ✅ **Git history** showing incremental progress
- ✅ **Migration summary** with lessons learned

Perfect for:
- Learning PatternFly migrations
- Understanding AI-assisted migration capabilities
- Training team members on migration strategies
- Reference for your own migrations

---

**Happy Migrating! 🚀**

If this workshop helped you, consider ⭐ starring the repository and sharing it with others!

---

*Last Updated: January 19, 2026*  
*PatternFly Version: v6.4.0*  
*Migration Status: ✅ Complete*
