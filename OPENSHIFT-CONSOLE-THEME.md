# OpenShift Console Theme Branch

This branch transforms the workshop app to look and feel like the OpenShift Console, providing a more realistic and relatable context for workshop participants.

## What Changed

### Layout & Navigation
- **Full Console Layout**: OpenShift-style masthead, vertical navigation sidebar, and page sections
- **Navigation Structure**:
  - **Projects** - Tier 1 migration examples (simple changes)
  - **Workloads → Pods/Deployments** - Tier 2 migration examples (moderate complexity)
  - **Storage** - Tier 3 migration examples (edge cases)
- **OpenShift Branding**: Red "OS" logo and "OpenShift Console" title in masthead
- **Collapsible Sidebar**: Toggle button to show/hide navigation

### Console-Style Pages

#### Projects Page (Tier 1)
Shows typical project-level components demonstrating simple migrations:
- Project members (UserProfile component)
- Project status badges (StatusBadge component)
- Demonstrates: Text → Content, Chip → Label, isDisabled → disabled

#### Workloads Page (Tier 2)
Displays resource details with tabs, similar to pod/deployment views:
- **Details Tab**: Resource actions with ActionMenu
- **Actions Tab**: Quick action buttons with IconButtons
- **Filters Tab**: Empty state for search results
- Demonstrates: MenuToggle migration, Button icon props, EmptyState restructuring

#### Storage Page (Tier 3)
Shows edge cases and scenarios requiring manual intervention:
- Compatibility layers (intentional dual support)
- Custom wrapper components (stable APIs)
- Dynamic imports (unsafe for AI)
- Clear warnings about when to reject AI suggestions

## Migration Violations Preserved

All original PatternFly v5 → v6 migration violations are intact:

✅ **Tier 1 violations** (6-8 total)
- Text → Content component
- Chip → Label component
- isDisabled → disabled prop
- CSS class updates

✅ **Tier 2 violations** (3-4 total)
- MenuToggle icon restructuring
- Button icon prop changes
- EmptyState consolidation

✅ **Tier 3 violations** (2-3 total)
- Compatibility layer patterns
- Custom wrapper internals
- Dynamic component imports

## Benefits for Workshop

1. **More Relatable**: Participants recognize OpenShift console patterns
2. **Realistic Context**: Real-world console component usage
3. **Better Organization**: Clear separation of tier 1/2/3 examples across pages
4. **Professional Look**: Polished console appearance increases engagement
5. **Familiar Workflows**: Navigation and page structure match what users know

## Running This Branch

```bash
# Switch to this branch
git checkout openshift-console-style

# Install dependencies (if not done)
npm install

# Start dev server
npm run dev

# Run tests (all should pass)
npm test
```

The app will open at http://localhost:3000 with full OpenShift console styling.

## Comparing to Main Branch

| Aspect | Main Branch | Console Theme Branch |
|--------|-------------|---------------------|
| Layout | Single-page list | Multi-page console |
| Navigation | None | Sidebar with sections |
| Branding | Generic PatternFly | OpenShift Console |
| Organization | Tier sections on one page | Tiers across pages |
| Context | Workshop demo | Production console |

## Workshop Usage

When using this branch for workshops:

1. **Start with Projects page** - Show simplest Tier 1 migrations
2. **Navigate to Workloads** - Demonstrate Tier 2 complexity
3. **Explore Storage** - Discuss Tier 3 edge cases and AI limitations
4. **Emphasize realism** - "This is how you'd see these patterns in actual console code"
5. **Use navigation** - Shows how migrations affect entire applications

## Switching Back to Main

```bash
git checkout main
```

The main branch preserves the original simpler layout if preferred.

## Future Enhancements

Potential additions to make it even more console-like:

- Add actual table components showing pod/deployment lists
- Include YAML editor tab with monaco
- Add resource creation forms
- Implement actual project switcher
- Add notification drawer
- Include console-specific PatternFly patterns

## Migration Analysis

Run Konveyor analysis the same way as main branch:

```bash
kantra analyze \
  --input . \
  --rules ./rulesets/preview/nodejs/patternfly \
  --output ./analysis-results \
  --source patternfly-v5 \
  --target patternfly-v6
```

Expected: Same ~30-35 violations as main branch, just organized differently in console pages.
