#!/bin/bash
#
# add-tier-by-complexity.sh
# Adds tier prefixes based on migration_complexity field
#
# Usage: ./add-tier-by-complexity.sh /path/to/rulesets
#

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠ $1${NC}"; }
print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
}

if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/rulesets"
    echo "Example: $0 ~/Workspace/rulesets"
    exit 1
fi

RULESETS_DIR="$1"
PATTERNFLY_DIR="${RULESETS_DIR}/preview/nodejs/patternfly"

if [ ! -d "$PATTERNFLY_DIR" ]; then
    echo "Error: PatternFly rules not found at: $PATTERNFLY_DIR"
    exit 1
fi

print_header "Adding Tier Prefixes Based on migration_complexity"

cd "$RULESETS_DIR"

# Reset branch if exists
if git show-ref --verify --quiet refs/heads/patternfly-workshop-tiers; then
    print_warning "Resetting existing branch"
    git checkout main 2>/dev/null || git checkout master
    git branch -D patternfly-workshop-tiers
fi

git checkout -b patternfly-workshop-tiers
print_success "Created branch: patternfly-workshop-tiers"

# Backup
BACKUP_DIR="${PATTERNFLY_DIR}.backup-$(date +%Y%m%d-%H%M%S)"
cp -r "$PATTERNFLY_DIR" "$BACKUP_DIR"
print_success "Backup: $BACKUP_DIR"

print_header "Processing Rules by Complexity"

cd "$PATTERNFLY_DIR"

# Process each file with awk to add tiers based on migration_complexity
for yaml_file in *.yaml; do
    [ -f "$yaml_file" ] || continue

    awk '
    BEGIN { in_rule=0; has_desc=0; complexity="" }

    # Start of a new rule
    /^- ruleID:/ {
        if (in_rule && has_desc && complexity != "") {
            # Print buffered lines with tier prefix
            if (complexity == "low") {
                # Check if CSS-related for Bulk CSS tag
                if (desc ~ /pf-v5-[cu]-/ || desc ~ /--pf-v5-global/) {
                    prefix = "🟢 [Tier 1 - Bulk CSS] "
                } else {
                    prefix = "🟢 [Tier 1] "
                }
            } else if (complexity == "medium") {
                prefix = "🟡 [Tier 2] "
            } else {
                prefix = ""
            }

            # Print buffered rule with prefix
            for (i = 0; i < buffer_count; i++) {
                if (buffer[i] ~ /^  description:/ && prefix != "" && buffer[i] !~ /\[Tier/) {
                    # Add prefix to description and quote it (YAML requires quotes when starting with [)
                    desc_text = desc  # Use the merged description
                    sub(/^  description: /, "", desc_text)
                    # Escape any existing double quotes in the description
                    gsub(/"/, "\\\"", desc_text)
                    buffer[i] = "  description: \"" prefix desc_text "\""
                }
                # Skip empty buffer lines (continuation lines that were merged)
                if (buffer[i] != "") {
                    print buffer[i]
                }
            }
        } else if (in_rule) {
            # Print buffered lines without modification
            for (i = 0; i < buffer_count; i++) {
                print buffer[i]
            }
        }

        # Reset for new rule
        in_rule=1
        has_desc=0
        complexity=""
        buffer_count=0
        buffer[buffer_count++] = $0
        next
    }

    # Inside a rule
    in_rule {
        buffer[buffer_count++] = $0

        if (/^  description:/) {
            has_desc=1
            desc=$0
        }

        # Handle continuation lines for description (indented lines after description:)
        if (has_desc && prev_was_desc && /^    [^ ]/) {
            # This is a continuation line - merge it with description
            desc = desc " " substr($0, 5)  # Remove leading spaces and append
            buffer[buffer_count-1] = ""  # Mark continuation line for removal
        }

        prev_was_desc = /^  description:/

        if (/^  migration_complexity: /) {
            complexity=$NF
        }
    }

    # Not in a rule
    !in_rule {
        print
    }

    END {
        # Handle last rule
        if (in_rule && has_desc && complexity != "") {
            if (complexity == "low") {
                if (desc ~ /pf-v5-[cu]-/ || desc ~ /--pf-v5-global/) {
                    prefix = "🟢 [Tier 1 - Bulk CSS] "
                } else {
                    prefix = "🟢 [Tier 1] "
                }
            } else if (complexity == "medium") {
                prefix = "🟡 [Tier 2] "
            } else {
                prefix = ""
            }

            for (i = 0; i < buffer_count; i++) {
                if (buffer[i] ~ /^  description:/ && prefix != "" && buffer[i] !~ /\[Tier/) {
                    # Add prefix to description and quote it (YAML requires quotes when starting with [)
                    desc_text = desc  # Use the merged description
                    sub(/^  description: /, "", desc_text)
                    # Escape any existing double quotes in the description
                    gsub(/"/, "\\\"", desc_text)
                    buffer[i] = "  description: \"" prefix desc_text "\""
                }
                # Skip empty buffer lines (continuation lines that were merged)
                if (buffer[i] != "") {
                    print buffer[i]
                }
            }
        } else if (in_rule) {
            for (i = 0; i < buffer_count; i++) {
                print buffer[i]
            }
        }
    }
    ' "$yaml_file" > "${yaml_file}.new"

    # Check if file changed
    if ! cmp -s "$yaml_file" "${yaml_file}.new"; then
        mv "${yaml_file}.new" "$yaml_file"
        print_success "  Modified: $yaml_file"
    else
        rm "${yaml_file}.new"
    fi
done

print_header "Summary"

cd "$RULESETS_DIR"
CHANGED=$(git diff --name-only preview/nodejs/patternfly/ | wc -l | tr -d ' ')

echo "Files changed: $CHANGED"
echo "Backup: $BACKUP_DIR"
echo ""

if [ "$CHANGED" -gt 0 ]; then
    echo "Sample Tier 1 (low complexity):"
    git diff | grep "^+.*🟢 \[Tier 1\]" | head -3
    echo ""
    echo "Sample Tier 2 (medium complexity):"
    git diff | grep "^+.*🟡 \[Tier 2\]" | head -3
    echo ""
    echo "Total by tier:"
    echo "  🟢 Tier 1: $(git diff | grep -c "^+.*🟢 \[Tier 1\]" || echo 0)"
    echo "  🟢 Tier 1 Bulk CSS: $(git diff | grep -c "^+.*🟢 \[Tier 1 - Bulk CSS\]" || echo 0)"
    echo "  🟡 Tier 2: $(git diff | grep -c "^+.*🟡 \[Tier 2\]" || echo 0)"
fi

print_header "Next Steps"
echo "1. Review: git diff preview/nodejs/patternfly/"
echo "2. Commit: git commit -am 'Add tier prefixes based on migration_complexity'"
echo "3. Push: git push -u origin patternfly-workshop-tiers"
