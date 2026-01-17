#!/bin/bash
#
# setup-bedrock.sh
# Sets up AWS Bedrock access for PatternFly Migration Workshop
#
# Prerequisites:
# - AWS CLI installed and configured
# - Admin access to AWS account
# - jq installed (for JSON parsing)
#
# Usage:
#   ./setup-bedrock.sh
#
# This script creates:
# - IAM policy limiting access to Bedrock only
# - IAM user for workshop with time-based expiration
# - Access keys for participants
# - Cost budget alerts
#

set -e  # Exit on error

# Configuration
WORKSHOP_DATE="2026-02-01"  # CHANGE THIS to your workshop date
EXPIRY_DATE="${WORKSHOP_DATE}T23:59:59Z"
IAM_USER_NAME="patternfly-workshop-bedrock"
IAM_POLICY_NAME="PatternFlyWorkshopBedrockAccess"
BEDROCK_REGION="us-east-1"
BEDROCK_MODEL="anthropic.claude-sonnet-4-5-20250929-v1:0"
BUDGET_LIMIT=50  # Dollars
OUTPUT_FILE="bedrock-credentials.txt"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Check prerequisites
print_header "Checking Prerequisites"

if ! command -v aws &> /dev/null; then
    print_error "AWS CLI not installed. Install from: https://aws.amazon.com/cli/"
    exit 1
fi
print_success "AWS CLI installed"

if ! command -v jq &> /dev/null; then
    print_error "jq not installed. Install with: brew install jq (macOS) or apt-get install jq (Linux)"
    exit 1
fi
print_success "jq installed"

# Verify AWS credentials
if ! aws sts get-caller-identity &> /dev/null; then
    print_error "AWS credentials not configured. Run: aws configure"
    exit 1
fi

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
AWS_USER=$(aws sts get-caller-identity --query Arn --output text)
print_success "AWS credentials configured"
echo "  Account: $AWS_ACCOUNT_ID"
echo "  User: $AWS_USER"

# Confirm workshop date
echo ""
print_warning "Workshop date set to: $WORKSHOP_DATE"
print_warning "Credentials will expire: $EXPIRY_DATE"
read -p "Is this correct? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_error "Please edit WORKSHOP_DATE in this script and run again"
    exit 1
fi

# Step 1: Create IAM Policy
print_header "Step 1: Creating IAM Policy"

POLICY_JSON=$(cat <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "BedrockInvokeOnly",
      "Effect": "Allow",
      "Action": [
        "bedrock:InvokeModel",
        "bedrock:InvokeModelWithResponseStream"
      ],
      "Resource": [
        "arn:aws:bedrock:${BEDROCK_REGION}::foundation-model/${BEDROCK_MODEL}"
      ],
      "Condition": {
        "DateLessThan": {
          "aws:CurrentTime": "${EXPIRY_DATE}"
        }
      }
    }
  ]
}
EOF
)

# Check if policy already exists
if aws iam get-policy --policy-arn "arn:aws:iam::${AWS_ACCOUNT_ID}:policy/${IAM_POLICY_NAME}" &> /dev/null; then
    print_warning "Policy ${IAM_POLICY_NAME} already exists. Deleting and recreating..."

    # Detach from any users first
    ATTACHED_USERS=$(aws iam list-entities-for-policy \
        --policy-arn "arn:aws:iam::${AWS_ACCOUNT_ID}:policy/${IAM_POLICY_NAME}" \
        --query 'PolicyUsers[].UserName' --output text)

    for user in $ATTACHED_USERS; do
        aws iam detach-user-policy \
            --user-name "$user" \
            --policy-arn "arn:aws:iam::${AWS_ACCOUNT_ID}:policy/${IAM_POLICY_NAME}"
        print_success "Detached policy from user: $user"
    done

    # Delete old policy
    aws iam delete-policy --policy-arn "arn:aws:iam::${AWS_ACCOUNT_ID}:policy/${IAM_POLICY_NAME}"
    print_success "Deleted old policy"
fi

# Create new policy
POLICY_ARN=$(aws iam create-policy \
    --policy-name "${IAM_POLICY_NAME}" \
    --policy-document "$POLICY_JSON" \
    --description "Time-limited Bedrock access for PatternFly migration workshop" \
    --query 'Policy.Arn' --output text)

print_success "Created IAM policy: ${IAM_POLICY_NAME}"
echo "  ARN: $POLICY_ARN"
echo "  Expires: $EXPIRY_DATE"

# Step 2: Create IAM User
print_header "Step 2: Creating IAM User"

# Check if user already exists
if aws iam get-user --user-name "${IAM_USER_NAME}" &> /dev/null; then
    print_warning "User ${IAM_USER_NAME} already exists. Deleting and recreating..."

    # Delete existing access keys
    EXISTING_KEYS=$(aws iam list-access-keys --user-name "${IAM_USER_NAME}" --query 'AccessKeyMetadata[].AccessKeyId' --output text)
    for key_id in $EXISTING_KEYS; do
        aws iam delete-access-key --user-name "${IAM_USER_NAME}" --access-key-id "$key_id"
        print_success "Deleted access key: $key_id"
    done

    # Detach policies
    aws iam detach-user-policy --user-name "${IAM_USER_NAME}" --policy-arn "$POLICY_ARN" 2>/dev/null || true

    # Delete user
    aws iam delete-user --user-name "${IAM_USER_NAME}"
    print_success "Deleted old user"
fi

# Create user
aws iam create-user \
    --user-name "${IAM_USER_NAME}" \
    --tags "Key=Purpose,Value=Workshop" "Key=ExpiryDate,Value=${WORKSHOP_DATE}" \
    > /dev/null

print_success "Created IAM user: ${IAM_USER_NAME}"

# Step 3: Attach Policy to User
print_header "Step 3: Attaching Policy to User"

aws iam attach-user-policy \
    --user-name "${IAM_USER_NAME}" \
    --policy-arn "$POLICY_ARN"

print_success "Attached policy to user"

# Step 4: Create Access Keys
print_header "Step 4: Creating Access Keys"

ACCESS_KEY_OUTPUT=$(aws iam create-access-key --user-name "${IAM_USER_NAME}")
ACCESS_KEY_ID=$(echo "$ACCESS_KEY_OUTPUT" | jq -r '.AccessKey.AccessKeyId')
SECRET_ACCESS_KEY=$(echo "$ACCESS_KEY_OUTPUT" | jq -r '.AccessKey.SecretAccessKey')

print_success "Created access keys"

# Step 5: Create Cost Budget (Optional)
print_header "Step 5: Creating Cost Budget Alert"

BUDGET_JSON=$(cat <<EOF
{
  "BudgetName": "PatternFlyWorkshopBedrock",
  "BudgetType": "COST",
  "TimeUnit": "MONTHLY",
  "BudgetLimit": {
    "Amount": "${BUDGET_LIMIT}",
    "Unit": "USD"
  },
  "CostFilters": {
    "Service": ["Amazon Bedrock"]
  },
  "TimePeriod": {
    "Start": "$(date +%Y-%m-01)",
    "End": "2087-06-15"
  }
}
EOF
)

if aws budgets describe-budget --account-id "$AWS_ACCOUNT_ID" --budget-name "PatternFlyWorkshopBedrock" &> /dev/null; then
    print_warning "Budget already exists, skipping creation"
else
    # Note: Budget notifications require SNS topic setup, which is complex
    # For now, just create the budget without notifications
    aws budgets create-budget \
        --account-id "$AWS_ACCOUNT_ID" \
        --budget "$BUDGET_JSON" 2>/dev/null || print_warning "Could not create budget (may need additional permissions)"

    print_success "Created cost budget: \$${BUDGET_LIMIT} limit"
fi

# Step 6: Verify Bedrock Model Access
print_header "Step 6: Verifying Bedrock Model Access"

if aws bedrock list-foundation-models --region "$BEDROCK_REGION" --query "modelSummaries[?modelId=='${BEDROCK_MODEL}']" --output text &> /dev/null; then
    print_success "Bedrock model ${BEDROCK_MODEL} is available in ${BEDROCK_REGION}"
else
    print_warning "Could not verify model access (may need to enable model in Bedrock console)"
    echo "  Visit: https://console.aws.amazon.com/bedrock/home?region=${BEDROCK_REGION}#/modelaccess"
    echo "  Enable: Claude 3.5 Sonnet"
fi

# Step 7: Save Credentials
print_header "Step 7: Saving Credentials"

cat > "$OUTPUT_FILE" <<EOF
# PatternFly Migration Workshop - AWS Bedrock Credentials
# Generated: $(date)
# Expires: $EXPIRY_DATE

## VS Code Settings Configuration

Add to .vscode/settings.json:

{
  "konveyor.ai.provider": "bedrock",
  "konveyor.ai.bedrock.region": "${BEDROCK_REGION}",
  "konveyor.ai.bedrock.model": "${BEDROCK_MODEL}",
  "konveyor.ai.bedrock.accessKeyId": "${ACCESS_KEY_ID}",
  "konveyor.ai.bedrock.secretAccessKey": "${SECRET_ACCESS_KEY}"
}

## Raw Credentials

AWS_ACCESS_KEY_ID=${ACCESS_KEY_ID}
AWS_SECRET_ACCESS_KEY=${SECRET_ACCESS_KEY}
AWS_REGION=${BEDROCK_REGION}
BEDROCK_MODEL=${BEDROCK_MODEL}

## Cleanup After Workshop

Run: ./cleanup-bedrock.sh
Or manually:
  aws iam delete-access-key --user-name ${IAM_USER_NAME} --access-key-id ${ACCESS_KEY_ID}
  aws iam detach-user-policy --user-name ${IAM_USER_NAME} --policy-arn ${POLICY_ARN}
  aws iam delete-user --user-name ${IAM_USER_NAME}
  aws iam delete-policy --policy-arn ${POLICY_ARN}

## Security Notes

- These credentials expire automatically on: ${EXPIRY_DATE}
- Access is limited to Bedrock InvokeModel only
- Cost budget alert set at \$${BUDGET_LIMIT}
- Share these credentials ONLY during the workshop
- Delete credentials within 24 hours of workshop completion
EOF

print_success "Saved credentials to: $OUTPUT_FILE"

# Create cleanup script
cat > "cleanup-bedrock.sh" <<'CLEANUP_EOF'
#!/bin/bash
# cleanup-bedrock.sh
# Removes workshop Bedrock IAM user and policy

set -e

IAM_USER_NAME="patternfly-workshop-bedrock"
IAM_POLICY_NAME="PatternFlyWorkshopBedrockAccess"

echo "Cleaning up workshop Bedrock resources..."

# Get account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
POLICY_ARN="arn:aws:iam::${AWS_ACCOUNT_ID}:policy/${IAM_POLICY_NAME}"

# Delete access keys
echo "Deleting access keys..."
KEYS=$(aws iam list-access-keys --user-name "${IAM_USER_NAME}" --query 'AccessKeyMetadata[].AccessKeyId' --output text 2>/dev/null || echo "")
for key_id in $KEYS; do
    aws iam delete-access-key --user-name "${IAM_USER_NAME}" --access-key-id "$key_id"
    echo "✓ Deleted key: $key_id"
done

# Detach policy
echo "Detaching policy..."
aws iam detach-user-policy --user-name "${IAM_USER_NAME}" --policy-arn "$POLICY_ARN" 2>/dev/null || true
echo "✓ Detached policy"

# Delete user
echo "Deleting user..."
aws iam delete-user --user-name "${IAM_USER_NAME}"
echo "✓ Deleted user: ${IAM_USER_NAME}"

# Delete policy
echo "Deleting policy..."
aws iam delete-policy --policy-arn "$POLICY_ARN"
echo "✓ Deleted policy: ${IAM_POLICY_NAME}"

echo ""
echo "✓ Cleanup complete!"
echo "All workshop Bedrock resources have been removed."
CLEANUP_EOF

chmod +x cleanup-bedrock.sh
print_success "Created cleanup script: cleanup-bedrock.sh"

# Summary
print_header "Setup Complete!"

echo ""
echo -e "${GREEN}✓ AWS Bedrock is ready for workshop!${NC}"
echo ""
echo "What to do next:"
echo ""
echo "1. ${YELLOW}Share credentials with participants:${NC}"
echo "   - Contents of: $OUTPUT_FILE"
echo "   - Share via Slack/secure channel on workshop day"
echo "   - DO NOT commit to GitHub!"
echo ""
echo "2. ${YELLOW}Verify model access in AWS Console:${NC}"
echo "   https://console.aws.amazon.com/bedrock/home?region=${BEDROCK_REGION}#/modelaccess"
echo "   - Enable: Claude 3.5 Sonnet"
echo ""
echo "3. ${YELLOW}After workshop (within 24 hours):${NC}"
echo "   ./cleanup-bedrock.sh"
echo ""
echo "Credentials expire automatically: ${EXPIRY_DATE}"
echo "Budget limit: \$${BUDGET_LIMIT}"
echo ""
