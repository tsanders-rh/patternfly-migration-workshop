# PatternFly v5 → v6 Migration Plan

**Project:** PatternFly Migration Workshop  
**Current Version:** PatternFly v5.3.4  
**Target Version:** PatternFly v6.x.x  
**Date:** January 19, 2026  
**Status:** Planning Phase

---

## Table of Contents
1. [Executive Summary](#executive-summary)
2. [Migration Overview](#migration-overview)
3. [Detailed Phase Breakdown](#detailed-phase-breakdown)
4. [Component-by-Component Changes](#component-by-component-changes)
5. [Risk Assessment](#risk-assessment)
6. [Testing Strategy](#testing-strategy)
7. [Rollback Plan](#rollback-plan)

---

## Executive Summary

### Scope
- **Files to Modify:** 23 TypeScript/CSS files (~1,255 LOC)
- **Components Affected:** 9 React components
- **CSS Updates:** 76+ instances of `pf-v5` prefixes
- **Estimated Effort:** 8-12 hours
- **Risk Level:** Medium (due to Tier 3 edge cases)

### Migration Breakdown by Tier
| Tier | Complexity | Components | Risk Level | Automation |
|------|------------|------------|------------|------------|
| 1    | Simple     | 3          | Low        | 90%        |
| 2    | Moderate   | 3          | Medium     | 60%        |
| 3    | Edge Cases | 3          | High       | 10%        |

### Success Criteria
- ✅ All tests pass post-migration
- ✅ No visual regressions
- ✅ Application builds without errors
- ✅ Workshop functionality preserved
- ✅ Edge cases properly documented

---

## Migration Overview

### Key Changes in PatternFly v6

#### Component Renames
```tsx
Text → Content
Chip → Label
```

#### Prop Changes
```tsx
isDisabled → disabled
isReadOnly → readOnly
```

#### Structural Changes
```tsx
// MenuToggle: Icon as child → icon prop
<MenuToggle><Icon /></MenuToggle>  // v5
<MenuToggle icon={<Icon />} />      // v6

// Button: Icon as child → icon prop
<Button><Icon /></Button>           // v5
<Button icon={<Icon />} />          // v6

// EmptyState: Component consolidation
<EmptyState>
  <EmptyStateIcon />
  <Title />
  <EmptyStateBody />
</EmptyState>                       // v5

<EmptyState>
  <EmptyStateHeader 
    icon={<EmptyStateIcon />}
    titleText="..."
  />
  <EmptyStateBody />
</EmptyState>                       // v6
```

#### CSS Changes
```css
pf-v5-c-*       → pf-v6-c-*        (Component classes)
pf-v5-u-*       → pf-v6-u-*        (Utility classes)
--pf-v5-global- → --pf-v6-global-  (CSS tokens)
```

---

## Detailed Phase Breakdown

### Phase 1: Pre-Migration Setup ✅ (CURRENT)

**Estimated Time:** 1-2 hours

**Tasks:**
- [x] Analyze codebase structure
- [x] Identify migration tiers
- [x] Document edge cases
- [x] Install dependencies
- [ ] Run baseline tests
- [ ] Create migration branch
- [ ] Create backup
- [ ] Document current application state (screenshots)

**Commands:**
```bash
# Create migration branch
git checkout -b feature/patternfly-v6-migration

# Backup current state
git tag pre-migration-v5

# Run baseline tests
npm test -- --coverage --json --outputFile=test-results-v5.json

# Document current state
npm run build
npm run dev  # Take screenshots
```

**Deliverables:**
- ✅ Migration plan document (this file)
- ✅ TODO checklist
- [ ] Baseline test results
- [ ] Visual regression baseline (screenshots)

---

### Phase 2: Dependency Updates

**Estimated Time:** 30 minutes  
**Risk:** Medium (breaking changes may occur)

**Tasks:**
1. Update `package.json` dependencies
2. Install new versions
3. Resolve peer dependency conflicts
4. Attempt initial build

**File Changes:**
```json
// package.json
{
  "dependencies": {
    "@patternfly/react-core": "^6.4.0",  // was 5.3.4
    "@patternfly/react-icons": "^6.4.0"  // was 5.3.2
  }
}
```

**Commands:**
```bash
# Update dependencies
npm install @patternfly/react-core@^6.4.0 @patternfly/react-icons@^6.4.0

# Check for conflicts
npm ls @patternfly/react-core
npm ls @patternfly/react-icons

# Attempt build (expected to fail)
npm run build 2>&1 | tee build-errors-post-update.log
```

**Expected Failures:**
- TypeScript errors for renamed components
- Runtime errors for deprecated props
- CSS class mismatches

**Rollback:**
```bash
git checkout package.json package-lock.json
npm install
```

---

### Phase 3: Tier 1 Migration (Simple Changes)

**Estimated Time:** 2-3 hours  
**Risk:** Low  
**Automation Potential:** 90%

#### 3.1 UserProfile.tsx

**File:** `src/components/tier1-simple/UserProfile.tsx`

**Changes Required:**
```diff
  import React from 'react';
  import {
-   Text,
-   TextContent,
+   Content,
    Card,
    CardBody
  } from '@patternfly/react-core';

  export const UserProfile: React.FC<UserProfileProps> = ({ name, role, email }) => {
    return (
      <Card>
        <CardBody>
-         <TextContent>
-           <Text component="h2">{name}</Text>
-           <Text component="p">{role}</Text>
-           <Text component="small">{email}</Text>
-         </TextContent>
+         <Content>
+           <Content component="h2">{name}</Content>
+           <Content component="p">{role}</Content>
+           <Content component="small">{email}</Content>
+         </Content>
        </CardBody>
      </Card>
    );
  };
```

**Test Verification:**
```bash
npm test -- UserProfile.test.tsx
```

**Manual Testing:**
- Navigate to Projects page
- Verify "Jane Doe" profile renders correctly
- Verify text hierarchy (h2, p, small)

---

#### 3.2 StatusBadge.tsx

**File:** `src/components/tier1-simple/StatusBadge.tsx`

**Changes Required:**
```diff
  import React, { useState } from 'react';
- import { Chip } from '@patternfly/react-core';
+ import { Label } from '@patternfly/react-core';

  export const StatusBadge: React.FC<StatusBadgeProps> = ({
    status,
-   isDisabled = false
+   disabled = false
  }) => {
    const [clickCount, setClickCount] = useState(0);

    const handleClick = () => {
-     if (!isDisabled) {
+     if (!disabled) {
        setClickCount(prev => prev + 1);
      }
    };

    return (
      <div style={{ display: 'inline-flex', alignItems: 'center', gap: '8px' }}>
-       <Chip
-         isReadOnly
-         isDisabled={isDisabled}
+       <Label
+         isCompact
+         isDisabled={disabled}
          onClick={handleClick}
        >
          {status}
-       </Chip>
+       </Label>
        {clickCount > 0 && (
          <span data-testid="click-count">
            Clicked {clickCount}x
          </span>
        )}
      </div>
    );
  };
```

**Note:** Check PatternFly v6 Label docs for exact prop mapping:
- `Chip.isReadOnly` → `Label.isCompact` or remove if not needed
- Color props may have changed

**Test Verification:**
```bash
npm test -- StatusBadge
```

**Manual Testing:**
- Verify all three status badges render
- Click enabled badges, verify counter increments
- Click disabled badge, verify no increment

---

#### 3.3 CSS Files Updates

**Files to Update:**
- `src/components/tier1-simple/PageHeader.css`
- `src/styles/components.css`
- `src/styles/tokens.css`

**Pattern (Global Find & Replace):**
```bash
# Component classes
pf-v5-c-  →  pf-v6-c-

# Utility classes
pf-v5-u-  →  pf-v6-u-

# CSS tokens
--pf-v5-global-  →  --pf-v6-global-
```

**PageHeader.css Changes:**
```diff
  .page-header {
-   background-color: var(--pf-v5-global--BackgroundColor--100);
-   padding: var(--pf-v5-global--spacer--lg);
-   border-bottom: 1px solid var(--pf-v5-global--BorderColor--100);
+   background-color: var(--pf-v6-global--BackgroundColor--100);
+   padding: var(--pf-v6-global--spacer--lg);
+   border-bottom: 1px solid var(--pf-v6-global--BorderColor--100);
  }

  .page-header h1 {
-   color: var(--pf-v5-global--Color--100);
-   margin-bottom: var(--pf-v5-global--spacer--md);
+   color: var(--pf-v6-global--Color--100);
+   margin-bottom: var(--pf-v6-global--spacer--md);
  }
```

**Automated Script:**
```bash
# Create a script for CSS updates
cat > migrate-css.sh << 'EOF'
#!/bin/bash
find src -name "*.css" -type f -exec sed -i \
  -e 's/pf-v5-c-/pf-v6-c-/g' \
  -e 's/pf-v5-u-/pf-v6-u-/g' \
  -e 's/--pf-v5-global-/--pf-v6-global-/g' \
  {} +
echo "CSS migration complete"
EOF

chmod +x migrate-css.sh
./migrate-css.sh
```

**Verification:**
```bash
# Check for any remaining v5 references
grep -r "pf-v5" src/ --include="*.css"
```

---

#### 3.4 JSX/TSX Utility Classes

**Files with inline className props:**
- `App.tsx`
- `ProjectsPage.tsx`
- `WorkloadsPage.tsx`
- `StoragePage.tsx`

**Changes Required:**
```bash
# Find all v5 utility classes in TSX files
grep -rn "pf-v5-u-" src/ --include="*.tsx" --include="*.ts"

# Update using sed
find src -name "*.tsx" -type f -exec sed -i 's/pf-v5-u-/pf-v6-u-/g' {} +
```

**Manual Review Required for:**
- Dynamic class names
- Template literals
- Conditional classes

---

### Phase 4: Tier 2 Migration (Moderate Complexity)

**Estimated Time:** 3-4 hours  
**Risk:** Medium  
**Automation Potential:** 60%

#### 4.1 ActionMenu.tsx

**File:** `src/components/tier2-moderate/ActionMenu.tsx`

**Current Code:**
```tsx
<MenuToggle
  variant="plain"
  isDisabled={isDisabled}
  onClick={() => setIsOpen(!isOpen)}
>
  <EllipsisVIcon />
</MenuToggle>
```

**Migrated Code:**
```tsx
<MenuToggle
  variant="plain"
  isDisabled={disabled}  // Also update prop name
  onClick={() => setIsOpen(!isOpen)}
  icon={<EllipsisVIcon />}  // Icon moved to prop
/>
```

**Full Component Changes:**
```diff
  export const ActionMenu: React.FC<ActionMenuProps> = ({
    onEdit,
    onDelete,
-   isDisabled = false
+   disabled = false
  }) => {
    return (
      <Dropdown
        isOpen={isOpen}
        onOpenChange={setIsOpen}
        toggle={
          <MenuToggle
            variant="plain"
-           isDisabled={isDisabled}
+           isDisabled={disabled}
            onClick={() => setIsOpen(!isOpen)}
+           icon={<EllipsisVIcon />}
          >
-           <EllipsisVIcon />
          </MenuToggle>
        }
      >
        <DropdownList>
          <DropdownItem onClick={handleEdit}>Edit</DropdownItem>
          <DropdownItem onClick={handleDelete}>Delete</DropdownItem>
        </DropdownList>
      </Dropdown>
    );
  };
```

**Testing:**
- Click menu toggle
- Verify dropdown opens
- Click Edit, verify callback
- Click Delete, verify callback
- Verify disabled state works

---

#### 4.2 IconButtons.tsx

**File:** `src/components/tier2-moderate/IconButtons.tsx`

**Changes Required:**
```diff
  <Button
    variant="plain"
    onClick={() => handleAction('Added item', onAdd)}
    aria-label="Add"
+   icon={<PlusCircleIcon />}
  >
-   <PlusCircleIcon />
  </Button>
  
  <Button
    variant="plain"
    onClick={() => handleAction('Edited item', onEdit)}
    aria-label="Edit"
+   icon={<EditIcon />}
  >
-   <EditIcon />
  </Button>
  
  <Button
    variant="plain"
    onClick={() => handleAction('Deleted item', onDelete)}
    isDanger
    aria-label="Delete"
+   icon={<TrashIcon />}
  >
-   <TrashIcon />
  </Button>
```

**Testing:**
- Click all three buttons
- Verify action log updates
- Verify icons display correctly
- Check isDanger styling on delete button

---

#### 4.3 EmptyStateExample.tsx

**File:** `src/components/tier2-moderate/EmptyStateExample.tsx`

**Current Structure (v5):**
```tsx
<EmptyState>
  <EmptyStateHeader
    titleText="No results found"
    headingLevel="h2"
    icon={<EmptyStateIcon icon={SearchIcon} />}
  />
  <EmptyStateBody>
    Try adjusting your search criteria or filters.
  </EmptyStateBody>
  <Button variant="primary" onClick={handleClearFilters}>
    Clear filters
  </Button>
</EmptyState>
```

**v6 Structure (Check Docs):**
The structure may remain similar in v6, but verify:
- EmptyStateHeader API
- EmptyStateIcon usage
- Primary action placement

**Action Required:**
1. Check PatternFly v6 EmptyState documentation
2. Update if structure changed
3. Verify both empty and success states

**Testing:**
- Initial state shows "No results found"
- Click "Clear filters"
- Success state appears
- State resets after 2 seconds

---

### Phase 5: Tier 3 Edge Cases (Manual Review)

**Estimated Time:** 2-3 hours  
**Risk:** High  
**Automation Potential:** 10%

#### 5.1 CompatibilityLayer.tsx ⚠️ DO NOT MIGRATE

**File:** `src/components/tier3-edge-cases/CompatibilityLayer.tsx`

**Current Code:**
```tsx
/**
 * This is a compatibility wrapper to support gradual migration.
 * DO NOT auto-fix this component - it intentionally uses both old and new APIs.
 */
export const CompatibilityLayer: React.FC<CompatibilityLayerProps> = ({
  useV6,
  children
}) => {
  return <Text component="p">{children}</Text>;
};
```

**Action:** 
- **SKIP THIS FILE** from automated migration
- Add comment explaining why it stays on v5
- Update workshop documentation

**Updated Comment:**
```tsx
/**
 * ⚠️ MIGRATION EXCEPTION ⚠️
 * 
 * This component intentionally maintains v5 compatibility for the workshop.
 * It demonstrates scenarios where gradual migration is needed.
 * 
 * DO NOT migrate this file during bulk updates.
 * Last reviewed: 2026-01-19
 */
```

---

#### 5.2 CustomWrapper.tsx (Partial Migration)

**File:** `src/components/tier3-edge-cases/CustomWrapper.tsx`

**Strategy:**
- Migrate internal implementation (Text → Content)
- Keep external API stable (CustomText stays CustomText)
- Update TextVariants import if needed

**Changes:**
```diff
  import React from 'react';
- import { Text, TextVariants } from '@patternfly/react-core';
+ import { Content, ContentVariants } from '@patternfly/react-core';

  interface CustomTextProps {
    children: React.ReactNode;
    emphasis?: boolean;
-   variant?: TextVariants;
+   variant?: ContentVariants;
  }

  /**
   * Custom wrapper that adds organization-specific behavior.
   * External API remains stable (CustomText), but internal implementation
   * has been migrated to PatternFly v6.
   */
  export const CustomText: React.FC<CustomTextProps> = ({
    children,
    emphasis = false,
-   variant = TextVariants.p
+   variant = ContentVariants.p
  }) => {
    return (
-     <Text
+     <Content
        component={variant}
        className={emphasis ? 'custom-emphasis' : ''}
      >
        {children}
-     </Text>
+     </Content>
    );
  };

  export const ConsumerComponent: React.FC = () => {
    return (
      <div>
        <CustomText emphasis>Important text</CustomText>
-       <CustomText variant={TextVariants.h3}>Heading</CustomText>
+       <CustomText variant={ContentVariants.h3}>Heading</CustomText>
      </div>
    );
  };
```

**Testing:**
- Verify CustomText still works in StoragePage
- Check emphasis styling
- Verify variant prop works

---

#### 5.3 DynamicComponent.tsx (Manual Review)

**File:** `src/components/tier3-edge-cases/DynamicComponent.tsx`

**Issues:**
1. Dynamic CSS class construction
2. Template literals with runtime values
3. Conditional component usage

**Current Code:**
```tsx
// Dynamic CSS class construction - AI can't safely refactor
const baseClass = `pf-v5-c-${componentType}`;
const statusClass = `pf-v5-c-${componentType}--${status}`;

// Conditional component usage
const renderContent = () => {
  if (showDetails) {
    return (
      <Text component="p">
        Detailed information for {componentType} with {status} status.
      </Text>
    );
  }
  return <Text component="small">Summary view</Text>;
};
```

**Migration Strategy:**
```diff
  // Update static imports
- import { Text } from '@patternfly/react-core';
+ import { Content } from '@patternfly/react-core';

  // Update dynamic classes (manual review each usage)
- const baseClass = `pf-v5-c-${componentType}`;
- const statusClass = `pf-v5-c-${componentType}--${status}`;
+ const baseClass = `pf-v6-c-${componentType}`;
+ const statusClass = `pf-v6-c-${componentType}--${status}`;

  // Update conditional component
  const renderContent = () => {
    if (showDetails) {
      return (
-       <Text component="p">
+       <Content component="p">
          Detailed information for {componentType} with {status} status.
-       </Text>
+       </Content>
      );
    }
-   return <Text component="small">Summary view</Text>;
+   return <Content component="small">Summary view</Content>;
  };
```

**Manual Verification Required:**
- Trace all possible `componentType` values
- Verify CSS classes exist in v6
- Test all status combinations

---

### Phase 6: App-Level Component Updates

**Estimated Time:** 1-2 hours  
**Risk:** Medium

#### Files to Review:
1. `App.tsx` - Main navigation
2. `ProjectsPage.tsx` - Uses Tier 1 components
3. `WorkloadsPage.tsx` - Uses Tier 2 components
4. `StoragePage.tsx` - Uses Tier 3 components

**App.tsx Changes:**
```diff
  // Check for any inline utility classes
- className="pf-v5-u-mt-md"
+ className="pf-v6-u-mt-md"

  // Check for any deprecated props
- isDisabled={false}
+ disabled={false}
```

**Page Component Updates:**
- Update breadcrumb components if API changed
- Update PageSection if API changed
- Update utility classes in classNames
- Verify all imported components work

---

### Phase 7: Testing & Validation

**Estimated Time:** 2-3 hours  
**Risk:** Low

#### 7.1 Automated Testing

**Run Full Test Suite:**
```bash
# Run all tests
npm test -- --coverage

# Generate coverage report
npm test -- --coverage --coverageReporters=html

# Update snapshots (after visual verification)
npm test -- -u
```

**Expected Test Results:**
- All existing tests should pass
- Snapshot tests will need updating
- Coverage should remain similar

**Test Checklist:**
- [ ] UserProfile.test.tsx passes
- [ ] MigrationValidation.test.tsx passes
- [ ] All snapshot tests updated
- [ ] No console errors/warnings
- [ ] Test coverage >80%

---

#### 7.2 Build Verification

```bash
# Clean build
rm -rf dist/
npm run build

# Check bundle size
ls -lh dist/

# Preview production build
npm run preview
```

**Verification Points:**
- [ ] Build completes without errors
- [ ] No TypeScript errors
- [ ] No ESLint errors
- [ ] Bundle size comparable to v5
- [ ] Preview server works

---

#### 7.3 Manual Testing Checklist

**Navigation:**
- [ ] Sidebar opens/closes
- [ ] Projects page loads
- [ ] Workloads page loads
- [ ] Storage page loads
- [ ] Navigation between pages works
- [ ] Expandable nav items work

**Projects Page (Tier 1):**
- [ ] UserProfile displays correctly
- [ ] StatusBadge renders all states
- [ ] StatusBadge click counter works
- [ ] Disabled badge doesn't increment
- [ ] PageHeader toggle works
- [ ] All text hierarchy correct

**Workloads Page (Tier 2):**
- [ ] Tabs switch correctly
- [ ] ActionMenu dropdown works
- [ ] ActionMenu edit/delete work
- [ ] IconButtons all clickable
- [ ] IconButtons action log displays
- [ ] EmptyState shows correctly
- [ ] EmptyState success transition works

**Storage Page (Tier 3):**
- [ ] Edge cases section displays
- [ ] CompatibilityLayer renders (v5)
- [ ] CustomWrapper components work
- [ ] Toggle edge cases works

**Cross-Browser Testing:**
- [ ] Chrome/Chromium
- [ ] Firefox
- [ ] Safari (if available)
- [ ] Edge

---

#### 7.4 Visual Regression Testing

**Manual Screenshots:**
```bash
# Before migration (already done)
npm run dev
# Take screenshots of all pages

# After migration
npm run dev
# Take screenshots again
# Compare side-by-side
```

**Screenshot Checklist:**
- [ ] Projects page - desktop
- [ ] Projects page - mobile
- [ ] Workloads page - all tabs
- [ ] Storage page - edge cases shown/hidden
- [ ] Navigation sidebar - expanded/collapsed

---

### Phase 8: Documentation & Cleanup

**Estimated Time:** 1-2 hours

#### 8.1 Create Migration Summary

**File:** `MIGRATION_SUMMARY.md`

```markdown
# PatternFly v5 → v6 Migration Summary

## Completed: [Date]

### Changes Made
- Updated 23 files
- Migrated 9 components
- Updated 76+ CSS references
- All tests passing

### Breaking Changes
- Text → Content
- Chip → Label
- isDisabled → disabled
- CSS prefixes: pf-v5 → pf-v6

### Known Issues
- None

### Exceptions
- CompatibilityLayer.tsx intentionally kept on v5

### Performance Impact
- Bundle size: [before] → [after]
- Build time: [before] → [after]
```

---

#### 8.2 Update README

**File:** `README.md` (Create if not exists)

```markdown
# PatternFly Migration Workshop

## Overview
Workshop application demonstrating PatternFly v5 → v6 migration patterns.

## Current Version
- **PatternFly:** v6.4.0
- **React:** 18.2.0
- **TypeScript:** 5.2.2

## Getting Started
\`\`\`bash
npm install
npm run dev
\`\`\`

## Migration Tiers
### Tier 1: Simple (Automated)
- Component renames
- Prop renames
- CSS prefix updates

### Tier 2: Moderate (Semi-Automated)
- Structural changes
- Icon prop restructuring

### Tier 3: Edge Cases (Manual)
- Compatibility layers
- Dynamic patterns
- Custom wrappers

## Testing
\`\`\`bash
npm test
npm run test:watch
\`\`\`

## Building
\`\`\`bash
npm run build
npm run preview
\`\`\`
```

---

#### 8.3 Update Workshop Materials

**Files to Update:**
- Comments in components
- Test descriptions
- Migration tier documentation

**Example Updates:**
```tsx
/**
 * WORKSHOP TIER 1: Simple Migration
 * 
 * This component demonstrates:
 * - Text → Content migration ✅
 * - Props remain the same ✅
 * - No structural changes ✅
 * 
 * Migration completed: 2026-01-19
 */
```

---

#### 8.4 Git Cleanup

```bash
# Review all changes
git status
git diff

# Stage files by tier
git add src/components/tier1-simple/
git commit -m "feat: migrate Tier 1 components to PatternFly v6"

git add src/components/tier2-moderate/
git commit -m "feat: migrate Tier 2 components to PatternFly v6"

git add src/components/tier3-edge-cases/
git commit -m "feat: review and update Tier 3 edge cases for v6"

git add src/styles/
git commit -m "feat: update CSS to PatternFly v6 tokens"

git add src/pages/ src/App.tsx
git commit -m "feat: update page components to PatternFly v6"

git add package.json package-lock.json
git commit -m "chore: upgrade PatternFly dependencies to v6"

git add MIGRATION_PLAN.md MIGRATION_SUMMARY.md README.md
git commit -m "docs: add migration documentation"

# Create merge request
git push origin feature/patternfly-v6-migration
```

---

## Risk Assessment

### High Risk Items
| Item | Risk Level | Mitigation |
|------|------------|------------|
| Dependency conflicts | High | Test in isolated branch |
| Breaking API changes | High | Review v6 changelog thoroughly |
| Dynamic CSS classes | High | Manual review and testing |
| Test failures | Medium | Update snapshots carefully |
| Visual regressions | Medium | Screenshot comparison |

### Mitigation Strategies
1. **Isolated Branch:** All work in feature branch
2. **Incremental Commits:** Commit by tier/component
3. **Test-Driven:** Run tests after each component
4. **Backup:** Git tag before starting
5. **Rollback Plan:** Ready at each phase

---

## Rollback Plan

### Complete Rollback
```bash
# Abandon all changes
git checkout main
git branch -D feature/patternfly-v6-migration

# Restore to tag
git checkout pre-migration-v5
```

### Partial Rollback (Per Phase)
```bash
# Rollback to specific commit
git log --oneline
git reset --hard <commit-hash>

# Rollback specific files
git checkout HEAD -- src/components/tier2-moderate/
```

### Dependency Rollback
```bash
# Restore package.json
git checkout HEAD -- package.json package-lock.json
npm install
```

---

## Testing Strategy

### Test Pyramid
```
           /\
          /  \  E2E (Manual Browser Testing)
         /----\
        /      \  Integration (Jest + RTL)
       /--------\
      /          \  Unit (Component Tests)
     /------------\
```

### Test Coverage Goals
- **Unit Tests:** >80% coverage
- **Integration Tests:** All user flows
- **Manual Tests:** Cross-browser, visual

### Test Execution Order
1. Run existing tests (baseline)
2. Update component
3. Run component tests
4. Run full suite
5. Update snapshots
6. Manual verification
7. Move to next component

---

## Success Metrics

### Technical Metrics
- ✅ Zero TypeScript errors
- ✅ Zero ESLint errors
- ✅ All tests passing (100%)
- ✅ Test coverage maintained (>80%)
- ✅ Build time < 2x baseline
- ✅ Bundle size within 10% of baseline

### Functional Metrics
- ✅ All pages load correctly
- ✅ All interactions work
- ✅ No visual regressions
- ✅ No console errors
- ✅ Cross-browser compatible

### Documentation Metrics
- ✅ Migration plan complete
- ✅ Migration summary created
- ✅ README updated
- ✅ Component comments updated
- ✅ Workshop materials updated

---

## Resources & References

### PatternFly Documentation
- [PatternFly v6 Docs](https://www.patternfly.org/v6/)
- [Migration Guide](https://www.patternfly.org/v6/get-started/migrate/)
- [Component Documentation](https://www.patternfly.org/v6/components/)
- [Release Notes](https://www.patternfly.org/v6/get-started/release-notes/)

### Useful Commands
```bash
# Search for v5 references
grep -r "pf-v5" src/
grep -r "@patternfly/react-core" src/ -A 2

# Count migration items
find src -name "*.tsx" | wc -l
grep -r "pf-v5" src/ | wc -l

# Check for deprecated imports
grep -r "import.*Text.*from.*react-core" src/

# Run specific test
npm test -- UserProfile.test.tsx --verbose

# Watch mode for development
npm test -- --watch --verbose
```

---

## Timeline

### Estimated Schedule (8-12 hours)

| Phase | Duration | Start | End | Status |
|-------|----------|-------|-----|--------|
| Phase 1: Pre-Migration | 1-2h | Day 1 | Day 1 | ✅ Current |
| Phase 2: Dependencies | 0.5h | Day 1 | Day 1 | Pending |
| Phase 3: Tier 1 | 2-3h | Day 1 | Day 1 | Pending |
| Phase 4: Tier 2 | 3-4h | Day 1-2 | Day 2 | Pending |
| Phase 5: Tier 3 | 2-3h | Day 2 | Day 2 | Pending |
| Phase 6: App-Level | 1-2h | Day 2 | Day 2 | Pending |
| Phase 7: Testing | 2-3h | Day 2 | Day 2 | Pending |
| Phase 8: Documentation | 1-2h | Day 2 | Day 2 | Pending |

**Total Estimated Time:** 13-22 hours  
**Recommended Schedule:** 2-3 days with breaks

---

## Contact & Support

For questions about this migration:
- **Workshop Repository:** https://github.com/konveyor/patternfly-migration-workshop
- **PatternFly Community:** https://patternfly.org/community/
- **Konveyor Community:** https://www.konveyor.io/community/

---

## Appendix

### A. Complete File List

**Components (9 files):**
```
src/components/tier1-simple/
  - UserProfile.tsx
  - StatusBadge.tsx
  - PageHeader.tsx

src/components/tier2-moderate/
  - ActionMenu.tsx
  - IconButtons.tsx
  - EmptyStateExample.tsx

src/components/tier3-edge-cases/
  - CompatibilityLayer.tsx
  - CustomWrapper.tsx
  - DynamicComponent.tsx
```

**Pages (3 files):**
```
src/pages/
  - ProjectsPage.tsx
  - WorkloadsPage.tsx
  - StoragePage.tsx
```

**Styles (3 files):**
```
src/styles/
  - components.css
  - tokens.css

src/components/tier1-simple/
  - PageHeader.css
```

**App Files (2 files):**
```
src/
  - App.tsx
  - main.tsx
```

**Tests (2 files):**
```
src/__tests__/
  - UserProfile.test.tsx
  - MigrationValidation.test.tsx
```

### B. Search Patterns

**Find all Text imports:**
```bash
grep -rn "import.*Text.*from.*@patternfly/react-core" src/
```

**Find all Chip imports:**
```bash
grep -rn "import.*Chip.*from.*@patternfly/react-core" src/
```

**Find all isDisabled props:**
```bash
grep -rn "isDisabled" src/
```

**Find all v5 CSS:**
```bash
grep -rn "pf-v5-" src/
```

### C. Automated Migration Scripts

**Script 1: CSS Token Migration**
```bash
#!/bin/bash
# migrate-css-tokens.sh

echo "Migrating CSS tokens from v5 to v6..."

find src -type f \( -name "*.css" -o -name "*.tsx" \) -exec sed -i.bak \
  -e 's/pf-v5-c-/pf-v6-c-/g' \
  -e 's/pf-v5-u-/pf-v6-u-/g' \
  -e 's/--pf-v5-global-/--pf-v6-global-/g' \
  {} +

echo "Done! Backup files created with .bak extension"
echo "Review changes and remove .bak files when satisfied"
```

**Script 2: Component Import Migration**
```bash
#!/bin/bash
# migrate-imports.sh

echo "Migrating component imports..."

# Text → Content
find src -type f -name "*.tsx" -exec sed -i.bak \
  -e 's/import { Text,/import { Content,/g' \
  -e 's/import { Text }/import { Content }/g' \
  -e 's/, Text,/, Content,/g' \
  {} +

# Chip → Label
find src -type f -name "*.tsx" -exec sed -i.bak \
  -e 's/import { Chip,/import { Label,/g' \
  -e 's/import { Chip }/import { Label }/g' \
  -e 's/, Chip,/, Label,/g' \
  {} +

echo "Done! Review changes before committing"
```

---

**Document Version:** 1.0  
**Last Updated:** 2026-01-19  
**Next Review:** After Phase 2 completion
