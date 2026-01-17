# Tier Mapping for PatternFly Rules

This document defines which PatternFly v5→v6 migration rules belong to which workshop tier.

---

## Tier 1: Simple Changes (High Confidence - Auto-apply Safe)

**Characteristics:**
- 1:1 component/prop renames
- No logic changes
- CSS updates
- AI success rate: ~95%

### Component Renames
- `Text` → `Content`
- `Chip` → `Label`

**Rule patterns:**
- "Text component renamed"
- "Chip component renamed"
- "import.*Text.*should.*Content"
- "import.*Chip.*should.*Label"

### Prop Renames
- `isDisabled` → `disabled`
- `isOpen` → `open`
- `isActive` → `isCurrent` (NavItem)
- `isActive` → `isCurrentPage` (BreadcrumbItem)

**Rule patterns:**
- "isDisabled"
- "isOpen.*open"
- "isActive.*isCurrent"
- "isActive.*isCurrentPage"

### CSS Updates (Bulk)
- `pf-v5-c-*` → `pf-v6-c-*` (component classes)
- `pf-v5-u-*` → `pf-v6-u-*` (utility classes)
- `--pf-v5-global-*` → `--pf-t--global-*` (CSS variables)

**Rule patterns:**
- "CSS class.*pf-v5-c"
- "CSS class.*pf-v5-u"
- "CSS variable.*--pf-v5-global"
- "pf-v5-c-.*should be.*pf-v6-c"
- "pf-v5-u-.*should be.*pf-v6-u"
- "--pf-v5-global.*should be.*--pf-t"

**Prefix:** `[Tier 1]` or `[Tier 1 - Bulk CSS]`

---

## Tier 2: Moderate Complexity (Review Carefully)

**Characteristics:**
- Structural component changes
- Icon prop restructuring
- Multiple related changes
- AI success rate: ~85%

### MenuToggle Icon Restructuring
**Old:**
```tsx
<MenuToggle>
  <EllipsisVIcon />
</MenuToggle>
```

**New:**
```tsx
<MenuToggle icon={<EllipsisVIcon />} />
```

**Rule patterns:**
- "MenuToggle.*icon"
- "icon.*child.*icon prop"

### EmptyState Changes
Structural consolidation of EmptyState components.

**Rule patterns:**
- "EmptyState"

### Button Icon Props
Similar to MenuToggle - icons move from children to props.

**Rule patterns:**
- "Button.*icon prop"
- "IconButtons"

### Generic Structural Changes
**Rule patterns:**
- "structural.*change"

**Prefix:** `[Tier 2 ⚠️  Review]`

---

## Tier 3: Edge Cases (Manual Review Required)

**Characteristics:**
- Business logic considerations
- Compatibility layers
- Dynamic code patterns
- AI success rate: ~50% (manual judgment needed)

### Compatibility Layers
Components that intentionally support both v5 and v6.

**Example:**
```tsx
import { Text, Content } from '@patternfly/react-core';

// Intentional dual support
const MyComponent = ({ version }) => {
  if (version === 'v5') return <Text>V5</Text>;
  return <Content>V6</Content>;
};
```

**Rule patterns:**
- "Compatibility"
- "compatibility"
- "dual support"

### Dynamic Components
Template literals, computed names, dynamic imports.

**Example:**
```tsx
const componentName = `pf-v5-c-${type}`;
```

**Rule patterns:**
- "dynamic"
- "Dynamic"
- "template literal"

### Custom Wrappers
Components that wrap PatternFly components but expose custom APIs.

**Example:**
```tsx
// Internal: Text → Content (OK)
// Public API: Keep stable (NOT OK to change)
export const MyText = (props) => <Text {...props} />;
```

**Rule patterns:**
- "custom wrapper"
- "Custom wrapper"

**Prefix:** `[Tier 3 ❌ Manual]`

---

## Special Cases

### React.FC Removals
**Decision:** Exclude from workshop (too many, not PatternFly-specific)

If included, should be Tier 1:
- "React.FC"
- "FunctionComponent"

### CSS Imports
Path changes for CSS imports.

**Tier:** 1 (simple find-replace)

**Rule patterns:**
- "CSS import"
- "@patternfly/react-core/dist/styles"

---

## Pattern Matching Logic

The script matches rules using this priority:

1. **Tier 3 first** (most specific edge cases)
2. **Tier 2 second** (moderate complexity)
3. **Tier 1 last** (catch-all for simple changes)

This ensures edge cases aren't incorrectly classified as simple changes.

---

## Examples of Final Rule Messages

### Before (Original):
```yaml
- message: "Text component renamed to Content in v6"
- message: "MenuToggle icon should use icon prop instead of child"
- message: "CSS class pf-v5-u-mt-md should be pf-v6-u-mt-md"
```

### After (With Tier Prefixes):
```yaml
- message: "[Tier 1] Text component renamed to Content in v6"
- message: "[Tier 2 ⚠️  Review] MenuToggle icon should use icon prop instead of child"
- message: "[Tier 1 - Bulk CSS] CSS class pf-v5-u-mt-md should be pf-v6-u-mt-md"
```

---

## Validation

After running the script, verify:

1. **Tier 1 rules (~50-60 violations expected)**
   - All component renames tagged
   - All prop renames tagged
   - All CSS updates tagged with "Bulk CSS"

2. **Tier 2 rules (~10-15 violations expected)**
   - MenuToggle tagged
   - EmptyState tagged
   - Button icon props tagged
   - All show ⚠️  emoji

3. **Tier 3 rules (~5 violations expected)**
   - Compatibility layer tagged
   - Dynamic component tagged
   - Custom wrapper tagged
   - All show ❌ emoji

4. **Run analysis and check counts**
   ```bash
   kantra analyze \
     --input ../patternfly-migration-workshop \
     --rules ./preview/nodejs/patternfly \
     --output ./test-results

   # Check distribution
   grep -r "\[Tier 1\]" test-results/output.yaml | wc -l
   grep -r "\[Tier 2" test-results/output.yaml | wc -l
   grep -r "\[Tier 3" test-results/output.yaml | wc -l
   ```

---

## Updating Workshop Documentation

After applying tier prefixes, update:

### 1. SETUP.md and setup scripts
```bash
# Change from:
git clone https://github.com/konveyor/rulesets.git

# To:
git clone -b patternfly-workshop-tiers https://github.com/tsanders-rh/rulesets.git
```

### 2. README.md
Add note about custom ruleset branch:

```markdown
**Note**: This workshop uses a fork of the official ruleset with tier
indicators ([Tier 1], [Tier 2], [Tier 3]) added to violation messages
to guide participants through exercises. The underlying rules are
identical to the official PatternFly ruleset.
```

### 3. PARTICIPANT_GUIDE.md
Update screenshots to show tier prefixes in VS Code.

Add note:
```markdown
Look for violations prefixed with:
- **[Tier 1]** - Simple changes, safe to auto-apply
- **[Tier 2 ⚠️  Review]** - Moderate complexity, review carefully
- **[Tier 3 ❌ Manual]** - Edge cases, manual review required
```

---

## Maintenance

If PatternFly rules are updated:

1. Pull latest from upstream konveyor/rulesets
2. Merge into your fork
3. Re-run add-tier-prefixes.sh script
4. Re-validate tier distribution
5. Update workshop if tier counts change significantly
