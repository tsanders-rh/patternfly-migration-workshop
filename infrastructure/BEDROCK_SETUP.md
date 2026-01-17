# AWS Bedrock Setup for Workshop

This guide helps you set up AWS Bedrock with shared credentials for workshop participants.

## Overview

The setup creates:
- ✅ IAM user with Bedrock-only access
- ✅ Time-based credential expiration (auto-expires after workshop)
- ✅ Cost budget alerts
- ✅ Access keys for sharing with participants

**Estimated Cost**: $10-50 for entire workshop (30 participants)

---

## Prerequisites

Before running the setup script:

1. **AWS CLI installed and configured**
   ```bash
   aws --version
   # Should show: aws-cli/2.x.x or higher

   aws configure
   # Enter your AWS credentials with admin access
   ```

2. **jq installed** (for JSON parsing)
   ```bash
   # macOS
   brew install jq

   # Linux
   sudo apt-get install jq  # Debian/Ubuntu
   sudo yum install jq      # RHEL/CentOS

   # Windows (WSL)
   sudo apt-get install jq
   ```

3. **Admin access to AWS account**
   - Your AWS credentials need permission to:
     - Create IAM users and policies
     - Create budgets
     - Access Bedrock

4. **Enable Claude Sonnet 4.5 in Bedrock**
   - Visit: https://console.aws.amazon.com/bedrock/home?region=us-east-1#/modelaccess
   - Click "Enable specific models"
   - Enable: **Claude Sonnet 4.5**
   - Wait 2-3 minutes for activation

---

## Setup Instructions

### Step 1: Update Workshop Date

Edit `setup-bedrock.sh` and change the workshop date:

```bash
WORKSHOP_DATE="2026-02-01"  # CHANGE THIS to your workshop date
```

This ensures credentials auto-expire 24 hours after your workshop.

### Step 2: Run Setup Script

```bash
chmod +x setup-bedrock.sh
./setup-bedrock.sh
```

The script will:
1. ✅ Check prerequisites
2. ✅ Create IAM policy (Bedrock-only access with expiration)
3. ✅ Create IAM user: `patternfly-workshop-bedrock`
4. ✅ Generate access keys
5. ✅ Set up cost budget ($50 default)
6. ✅ Save credentials to `bedrock-credentials.txt`
7. ✅ Create `cleanup-bedrock.sh` for post-workshop cleanup

**Output:**
```
================================
Setup Complete!
================================

✓ AWS Bedrock is ready for workshop!

What to do next:
1. Share credentials with participants
2. Verify model access in AWS Console
3. After workshop: ./cleanup-bedrock.sh
```

### Step 3: Test Credentials

```bash
chmod +x test-bedrock.sh
./test-bedrock.sh
```

This verifies:
- ✅ AWS credentials are valid
- ✅ Bedrock model is accessible
- ✅ Can invoke the model successfully
- ✅ Time-based expiration is working

**Expected Output:**
```
✓ Credentials are valid
✓ Can access Bedrock service
✓ Model anthropic.claude-sonnet-4-5-20250929-v1:0 is available
✓ Model invocation successful!
✓ Credentials valid for 48 more hours
```

---

## Sharing Credentials with Participants

### Option 1: Slack/Discord (Recommended)

On workshop day, share in private channel:

```
🔐 AWS Bedrock Credentials for Workshop

Add to .vscode/settings.json:

{
  "konveyor.ai.provider": "bedrock",
  "konveyor.ai.bedrock.region": "us-east-1",
  "konveyor.ai.bedrock.model": "anthropic.claude-sonnet-4-5-20250929-v1:0",
  "konveyor.ai.bedrock.accessKeyId": "AKIA...",
  "konveyor.ai.bedrock.secretAccessKey": "..."
}

⚠️ These credentials expire tonight at 11:59 PM
⚠️ Do not share outside this workshop
```

### Option 2: Display on Slide

Create a slide showing the VS Code settings.json configuration.

**DO NOT:**
- ❌ Commit credentials to GitHub
- ❌ Share in public channels
- ❌ Email to distribution list
- ❌ Post on social media

---

## Monitoring During Workshop

### AWS Console

**Monitor usage:**
https://console.aws.amazon.com/cloudwatch/home?region=us-east-1

**Check costs:**
https://console.aws.amazon.com/billing/home#/

**Bedrock metrics:**
- Invocations per minute
- Token usage
- Error rates

### Expected Usage

**Per participant (3 hours):**
- ~50-60 AI fix generations
- ~400K tokens total (input + output)
- ~$0.30 cost

**For 30 participants:**
- ~1,500 invocations
- ~12M tokens
- ~$10 total cost

### Red Flags

🚨 **Alert if you see:**
- Spike to 100+ requests/minute (someone looping?)
- Unusual error rate (configuration issue?)
- Cost exceeding $25 in first hour

---

## After Workshop Cleanup

### Within 24 Hours

```bash
./cleanup-bedrock.sh
```

This script:
1. Deletes access keys
2. Detaches IAM policy
3. Deletes IAM user
4. Deletes IAM policy

**Manual cleanup** (if script fails):

```bash
# Delete access keys
aws iam delete-access-key \
  --user-name patternfly-workshop-bedrock \
  --access-key-id AKIA...

# Detach policy
aws iam detach-user-policy \
  --user-name patternfly-workshop-bedrock \
  --policy-arn arn:aws:iam::ACCOUNT_ID:policy/PatternFlyWorkshopBedrockAccess

# Delete user
aws iam delete-user --user-name patternfly-workshop-bedrock

# Delete policy
aws iam delete-policy --policy-arn arn:aws:iam::ACCOUNT_ID:policy/PatternFlyWorkshopBedrockAccess
```

### Verify Cleanup

```bash
# Check no users remain
aws iam get-user --user-name patternfly-workshop-bedrock
# Should return: NoSuchEntity error ✅

# Check no active keys
aws iam list-access-keys --user-name patternfly-workshop-bedrock
# Should return: NoSuchEntity error ✅
```

---

## Security Best Practices

### What We Do ✅

- **Time-based expiration**: Credentials auto-expire 24 hours after workshop
- **Least privilege**: Access limited to Bedrock InvokeModel only
- **No console access**: User cannot log into AWS console
- **Single model**: Only Claude 3.5 Sonnet accessible
- **Cost limits**: Budget alerts at $10, $25, $50
- **CloudTrail logging**: All API calls logged

### What You Should Do ✅

- **Rotate after workshop**: Delete user within 24 hours
- **Monitor during workshop**: Watch CloudWatch metrics
- **Share securely**: Use private Slack/Discord, not email
- **Test before event**: Run test-bedrock.sh 1 week before
- **Have backup**: Keep personal API key ready

### Red Flags 🚨

If you see during workshop:
- ❌ Requests from unexpected IPs
- ❌ Usage continuing after workshop hours
- ❌ Errors about expired credentials (extend time if needed)
- ❌ Spike in costs

**Action**: Rotate keys immediately:
```bash
./cleanup-bedrock.sh
./setup-bedrock.sh  # Creates new keys
```

---

## Troubleshooting

### "Model not found" error

**Problem**: Claude Sonnet 4.5 not enabled in Bedrock

**Solution**:
1. Visit: https://console.aws.amazon.com/bedrock/home?region=us-east-1#/modelaccess
2. Click "Modify model access"
3. Enable "Claude Sonnet 4.5"
4. Wait 2-3 minutes
5. Run `./test-bedrock.sh` again

### "Access Denied" error

**Problem**: IAM policy too restrictive or credentials expired

**Solution**:
```bash
# Check policy
aws iam get-policy-version \
  --policy-arn arn:aws:iam::ACCOUNT_ID:policy/PatternFlyWorkshopBedrockAccess \
  --version-id v1

# Check expiration date in output
# If expired, update WORKSHOP_DATE in setup-bedrock.sh and rerun
```

### Participants can't connect

**Problem**: Network/firewall blocking Bedrock endpoints

**Solution**:
- Ensure outbound HTTPS (443) allowed
- Bedrock endpoint: `bedrock-runtime.us-east-1.amazonaws.com`
- Fallback: Have participants use their own OpenAI/Anthropic keys

### High costs

**Problem**: Unexpected usage or errors causing retries

**Solution**:
```bash
# Check CloudWatch for error patterns
aws logs tail /aws/bedrock/modelinvocations --follow

# If abuse suspected, rotate keys immediately
./cleanup-bedrock.sh
./setup-bedrock.sh
```

---

## Cost Breakdown

### Claude Sonnet 4.5 Pricing (Bedrock)

- **Input**: $3.00 per 1M tokens
- **Output**: $15.00 per 1M tokens

### Workshop Estimate

**Per AI fix generation:**
- Input: ~500 tokens (violation context + code)
- Output: ~300 tokens (reasoning + fixed code)
- Cost: ~$0.006 per fix

**Per participant (50 fixes):**
- Input: 25K tokens = $0.075
- Output: 15K tokens = $0.225
- Total: **~$0.30 per participant**

**For 30 participants:**
- **~$10 total cost**

**Budget with buffer: $20-50**

---

## Alternative: Individual Keys

If shared key feels risky, create individual keys per participant:

```bash
# In setup-bedrock.sh, change:
for i in {1..30}; do
  aws iam create-user --user-name "workshop-participant-${i}"
  # ... attach policy, create key ...
done
```

**Pros:**
- Per-user rate limiting
- Better tracking
- Isolated blast radius

**Cons:**
- More setup complexity
- Need to distribute 30 keys
- More cleanup work

**Recommendation**: Shared key is fine for 4-hour workshop with trusted participants.

---

## Files Created

After running `setup-bedrock.sh`:

```
bedrock-credentials.txt    # AWS credentials (DO NOT COMMIT!)
cleanup-bedrock.sh         # Cleanup script (DO NOT COMMIT!)
```

These files are in `.gitignore` to prevent accidental commits.

---

## Quick Reference Commands

```bash
# Setup
./setup-bedrock.sh

# Test
./test-bedrock.sh

# Monitor (during workshop)
aws cloudwatch get-metric-statistics \
  --namespace AWS/Bedrock \
  --metric-name Invocations \
  --dimensions Name=ModelId,Value=anthropic.claude-sonnet-4-5-20250929-v1:0 \
  --start-time $(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%S) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
  --period 300 \
  --statistics Sum

# Cleanup
./cleanup-bedrock.sh
```

---

## Need Help?

- **AWS Bedrock Docs**: https://docs.aws.amazon.com/bedrock/
- **Pricing**: https://aws.amazon.com/bedrock/pricing/
- **Model Access**: https://console.aws.amazon.com/bedrock/home#/modelaccess
- **Support**: AWS Support or #konveyor Slack

---

## Summary Checklist

**Before Workshop:**
- [ ] AWS CLI configured with admin access
- [ ] jq installed
- [ ] Claude 3.5 Sonnet enabled in Bedrock console
- [ ] Update WORKSHOP_DATE in setup-bedrock.sh
- [ ] Run ./setup-bedrock.sh
- [ ] Run ./test-bedrock.sh to verify
- [ ] Prepare slide/message to share credentials
- [ ] Set up CloudWatch dashboard for monitoring

**During Workshop:**
- [ ] Share credentials via Slack (private)
- [ ] Monitor CloudWatch metrics
- [ ] Watch for error spikes or cost issues
- [ ] Have backup API keys ready

**After Workshop:**
- [ ] Run ./cleanup-bedrock.sh within 24 hours
- [ ] Verify user/policy deleted
- [ ] Check final costs in billing dashboard
- [ ] Document lessons learned
