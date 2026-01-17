#!/bin/bash
#
# add-tier-prefixes.sh
# Adds tier prefixes to PatternFly migration rules for workshop
#
# Usage:
#   ./add-tier-prefixes.sh /path/to/rulesets
#
# Example:
#   ./add-tier-prefixes.sh ~/Workspace/Rulesets
#
# This script:
# 1. Creates a backup of original rules
# 2. Adds [Tier 1], [Tier 2], or [Tier 3] prefixes to rule messages
# 3. Creates a branch: patternfly-workshop-tiers
#

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Check arguments
if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/rulesets"
    echo ""
    echo "Example:"
    echo "  $0 ~/Workspace/Rulesets"
    exit 1
fi

RULESETS_DIR="$1"
PATTERNFLY_DIR="${RULESETS_DIR}/preview/nodejs/patternfly"

# Verify directory exists
if [ ! -d "$RULESETS_DIR" ]; then
    echo "Error: Directory not found: $RULESETS_DIR"
    exit 1
fi

if [ ! -d "$PATTERNFLY_DIR" ]; then
    echo "Error: PatternFly rules not found at: $PATTERNFLY_DIR"
    exit 1
fi

print_header "Adding Tier Prefixes to PatternFly Rules"

# Change to rulesets directory
cd "$RULESETS_DIR"
print_success "Changed to: $(pwd)"

# Check if we're in a git repo
if [ ! -d ".git" ]; then
    print_warning "Not a git repository. Continuing anyway..."
else
    # Create/checkout workshop branch
    CURRENT_BRANCH=$(git branch --show-current)

    if git show-ref --verify --quiet refs/heads/patternfly-workshop-tiers; then
        print_warning "Branch patternfly-workshop-tiers already exists"
        echo "Options:"
        echo "  1. Switch to existing branch"
        echo "  2. Delete and recreate"
        echo "  3. Cancel"
        read -p "Choose (1/2/3): " -n 1 -r
        echo

        case $REPLY in
            1)
                git checkout patternfly-workshop-tiers
                print_success "Switched to patternfly-workshop-tiers"
                ;;
            2)
                git checkout main || git checkout master
                git branch -D patternfly-workshop-tiers
                git checkout -b patternfly-workshop-tiers
                print_success "Recreated patternfly-workshop-tiers branch"
                ;;
            3)
                echo "Cancelled"
                exit 0
                ;;
            *)
                echo "Invalid choice. Cancelled."
                exit 1
                ;;
        esac
    else
        git checkout -b patternfly-workshop-tiers
        print_success "Created branch: patternfly-workshop-tiers"
    fi
fi

# Create backup
BACKUP_DIR="${PATTERNFLY_DIR}.backup-$(date +%Y%m%d-%H%M%S)"
cp -r "$PATTERNFLY_DIR" "$BACKUP_DIR"
print_success "Backup created: $BACKUP_DIR"

# Process each YAML file
print_header "Processing Rule Files"

cd "$PATTERNFLY_DIR"

# Tier 1 Rules (Simple - High confidence)
declare -A TIER1_PATTERNS=(
    ["Text component renamed"]="[Tier 1]"
    ["Chip component renamed"]="[Tier 1]"
    ["isDisabled"]="[Tier 1]"
    ["isOpen.*open"]="[Tier 1]"
    ["isActive.*isCurrent"]="[Tier 1]"
    ["isActive.*isCurrentPage"]="[Tier 1]"
    ["CSS class.*pf-v5-c"]="[Tier 1 - Bulk CSS]"
    ["CSS class.*pf-v5-u"]="[Tier 1 - Bulk CSS]"
    ["CSS variable.*--pf-v5-global"]="[Tier 1 - Bulk CSS]"
    ["pf-v5-c-.*should be.*pf-v6-c"]="[Tier 1 - Bulk CSS]"
    ["pf-v5-u-.*should be.*pf-v6-u"]="[Tier 1 - Bulk CSS]"
    ["--pf-v5-global.*should be.*--pf-t"]="[Tier 1 - Bulk CSS]"
    ["import.*Text.*should.*Content"]="[Tier 1]"
    ["import.*Chip.*should.*Label"]="[Tier 1]"
)

# Tier 2 Rules (Moderate - Review carefully)
declare -A TIER2_PATTERNS=(
    ["MenuToggle.*icon"]="[Tier 2 ⚠️  Review]"
    ["EmptyState"]="[Tier 2 ⚠️  Review]"
    ["Button.*icon prop"]="[Tier 2 ⚠️  Review]"
    ["IconButtons"]="[Tier 2 ⚠️  Review]"
    ["icon.*child.*icon prop"]="[Tier 2 ⚠️  Review]"
    ["structural.*change"]="[Tier 2 ⚠️  Review]"
)

# Tier 3 Rules (Edge cases - Manual review)
declare -A TIER3_PATTERNS=(
    ["Compatibility"]="[Tier 3 ❌ Manual]"
    ["compatibility"]="[Tier 3 ❌ Manual]"
    ["dynamic"]="[Tier 3 ❌ Manual]"
    ["Dynamic"]="[Tier 3 ❌ Manual]"
    ["template literal"]="[Tier 3 ❌ Manual]"
    ["custom wrapper"]="[Tier 3 ❌ Manual]"
    ["Custom wrapper"]="[Tier 3 ❌ Manual]"
    ["dual support"]="[Tier 3 ❌ Manual]"
)

# Function to add prefix to message
add_prefix_to_file() {
    local file="$1"
    local temp_file="${file}.tmp"
    local modified=0

    echo "Processing: $(basename "$file")"

    # Read file line by line
    while IFS= read -r line; do
        # Check if this is a message line
        if [[ "$line" =~ ^[[:space:]]*message:[[:space:]]*\"(.*)\"[[:space:]]*$ ]] || \
           [[ "$line" =~ ^[[:space:]]*message:[[:space:]]*\'(.*)\'[[:space:]]*$ ]]; then

            # Extract the message content
            message="${BASH_REMATCH[1]}"

            # Skip if already has a tier prefix
            if [[ "$message" =~ ^\[Tier ]]; then
                echo "$line" >> "$temp_file"
                continue
            fi

            # Check against patterns
            prefix=""

            # Check Tier 3 first (most specific)
            for pattern in "${!TIER3_PATTERNS[@]}"; do
                if [[ "$message" =~ $pattern ]]; then
                    prefix="${TIER3_PATTERNS[$pattern]}"
                    break
                fi
            done

            # Check Tier 2
            if [ -z "$prefix" ]; then
                for pattern in "${!TIER2_PATTERNS[@]}"; do
                    if [[ "$message" =~ $pattern ]]; then
                        prefix="${TIER2_PATTERNS[$pattern]}"
                        break
                    fi
                done
            fi

            # Check Tier 1
            if [ -z "$prefix" ]; then
                for pattern in "${!TIER1_PATTERNS[@]}"; do
                    if [[ "$message" =~ $pattern ]]; then
                        prefix="${TIER1_PATTERNS[$pattern]}"
                        break
                    fi
                done
            fi

            # Add prefix if matched
            if [ -n "$prefix" ]; then
                # Extract indentation and quote style
                indent="${line%%message*}"
                if [[ "$line" =~ message:[[:space:]]*\" ]]; then
                    echo "${indent}message: \"${prefix} ${message}\"" >> "$temp_file"
                else
                    echo "${indent}message: '${prefix} ${message}'" >> "$temp_file"
                fi
                modified=1
            else
                echo "$line" >> "$temp_file"
            fi
        else
            echo "$line" >> "$temp_file"
        fi
    done < "$file"

    # Replace original if modified
    if [ $modified -eq 1 ]; then
        mv "$temp_file" "$file"
        print_success "  Updated: $(basename "$file")"
        return 0
    else
        rm -f "$temp_file"
        echo "  No changes: $(basename "$file")"
        return 1
    fi
}

# Process all YAML files
TOTAL_FILES=0
MODIFIED_FILES=0

for yaml_file in *.yaml; do
    if [ -f "$yaml_file" ]; then
        TOTAL_FILES=$((TOTAL_FILES + 1))
        if add_prefix_to_file "$yaml_file"; then
            MODIFIED_FILES=$((MODIFIED_FILES + 1))
        fi
    fi
done

echo ""
print_header "Summary"
echo "Total files processed: $TOTAL_FILES"
echo "Files modified: $MODIFIED_FILES"
echo "Backup location: $BACKUP_DIR"

# Show sample changes
print_header "Sample Changes"
echo ""
echo "Example violations now show:"
echo "  [Tier 1] Text component renamed to Content in v6"
echo "  [Tier 1 - Bulk CSS] CSS class pf-v5-u-mt-md should be pf-v6-u-mt-md"
echo "  [Tier 2 ⚠️  Review] MenuToggle icon should use icon prop instead of child"
echo "  [Tier 3 ❌ Manual] Compatibility layer requires manual review"

# Git status
if [ -d "$RULESETS_DIR/.git" ]; then
    echo ""
    print_header "Git Status"
    cd "$RULESETS_DIR"
    git status --short

    echo ""
    print_success "Branch: patternfly-workshop-tiers created"
    echo ""
    echo "Next steps:"
    echo "  1. Review changes: git diff"
    echo "  2. Commit: git commit -am 'Add tier prefixes for workshop'"
    echo "  3. Push: git push -u origin patternfly-workshop-tiers"
    echo ""
    echo "Update workshop setup scripts to use:"
    echo "  git clone -b patternfly-workshop-tiers https://github.com/YOUR_FORK/rulesets.git"
fi

echo ""
print_success "Tier prefixes added successfully!"
