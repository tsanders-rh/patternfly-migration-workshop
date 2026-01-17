# AI Provider Configuration for Konveyor

The Konveyor VS Code extension uses AI to generate migration fixes. You can use several different AI providers:

## Workshop Default: AWS Bedrock (Provided)

For workshop participants, we provide shared AWS Bedrock access:

```json
// .vscode/settings.json
{
  "konveyor.ai.provider": "bedrock",
  "konveyor.ai.bedrock.region": "us-east-1",
  "konveyor.ai.bedrock.model": "anthropic.claude-sonnet-4-5-20250929-v1:0",
  "konveyor.ai.bedrock.accessKeyId": "SHARED_AT_WORKSHOP",
  "konveyor.ai.bedrock.secretAccessKey": "SHARED_AT_WORKSHOP"
}
```

**Note**: Workshop credentials expire 24 hours after the event.

---

## Option 1: OpenAI (GPT-4)

**Requirements:**
- OpenAI account
- API key from [platform.openai.com/api-keys](https://platform.openai.com/api-keys)
- ~$0.50-1.00 credit for workshop exercises

**Configuration:**
```json
// .vscode/settings.json
{
  "konveyor.ai.provider": "openai",
  "konveyor.ai.openai.apiKey": "sk-...",
  "konveyor.ai.openai.model": "gpt-4o"
}
```

**Recommended Models:**
- `gpt-4o` - Best balance (recommended)
- `gpt-4-turbo` - Faster, slightly cheaper
- `gpt-4` - Classic, slower but reliable

---

## Option 2: Anthropic (Claude)

**Requirements:**
- Anthropic account
- API key from [console.anthropic.com](https://console.anthropic.com)
- ~$0.30-0.50 credit for workshop exercises

**Configuration:**
```json
// .vscode/settings.json
{
  "konveyor.ai.provider": "anthropic",
  "konveyor.ai.anthropic.apiKey": "sk-ant-...",
  "konveyor.ai.anthropic.model": "claude-sonnet-4-5-20250929"
}
```

**Recommended Models:**
- `claude-sonnet-4-5-20250929` - Best for code (recommended)
- `claude-3-5-haiku-20241022` - Faster, cheaper, good quality

---

## Option 3: Local Ollama (Free, Offline)

**Requirements:**
- Ollama installed locally
- ~4GB RAM for model
- No API key needed (free!)

**Setup:**
```bash
# Install Ollama
# macOS: brew install ollama
# Linux: curl https://ollama.ai/install.sh | sh
# Windows: Download from ollama.ai

# Pull a code model
ollama pull codellama:13b
# or
ollama pull deepseek-coder:6.7b

# Start Ollama server (if not auto-started)
ollama serve
```

**Configuration:**
```json
// .vscode/settings.json
{
  "konveyor.ai.provider": "ollama",
  "konveyor.ai.ollama.endpoint": "http://localhost:11434",
  "konveyor.ai.ollama.model": "codellama:13b"
}
```

**Pros:**
- ✅ Free
- ✅ Works offline
- ✅ Private (no data sent to cloud)

**Cons:**
- ❌ Lower quality than Claude/GPT-4
- ❌ Slower generation
- ❌ May struggle with complex migrations

---

## Option 4: Azure OpenAI

**Requirements:**
- Azure account with OpenAI access
- Deployed GPT-4 model
- API key from Azure portal

**Configuration:**
```json
// .vscode/settings.json
{
  "konveyor.ai.provider": "azure-openai",
  "konveyor.ai.azureOpenai.endpoint": "https://YOUR_RESOURCE.openai.azure.com",
  "konveyor.ai.azureOpenai.apiKey": "...",
  "konveyor.ai.azureOpenai.deployment": "gpt-4",
  "konveyor.ai.azureOpenai.apiVersion": "2024-02-15-preview"
}
```

---

## Option 5: Your Own AWS Bedrock

**Requirements:**
- AWS account with Bedrock access
- Claude 3.5 Sonnet model enabled
- IAM credentials

**Configuration:**
```json
// .vscode/settings.json
{
  "konveyor.ai.provider": "bedrock",
  "konveyor.ai.bedrock.region": "us-east-1",
  "konveyor.ai.bedrock.model": "anthropic.claude-sonnet-4-5-20250929-v1:0",
  "konveyor.ai.bedrock.accessKeyId": "YOUR_ACCESS_KEY",
  "konveyor.ai.bedrock.secretAccessKey": "YOUR_SECRET_KEY"
}
```

**Cost**: ~$0.30 per workshop (very affordable)

---

## Comparison

| Provider | Cost (Workshop) | Quality | Speed | Setup |
|----------|----------------|---------|-------|-------|
| **Bedrock (Shared)** | Free* | ★★★★★ | Fast | Easy ✅ |
| **OpenAI** | ~$1.00 | ★★★★★ | Fast | Easy |
| **Anthropic** | ~$0.50 | ★★★★★ | Fast | Easy |
| **Ollama** | Free | ★★★☆☆ | Slow | Medium |
| **Azure OpenAI** | ~$1.00 | ★★★★★ | Fast | Hard |
| **Your Bedrock** | ~$0.30 | ★★★★★ | Fast | Medium |

*Workshop shared key - expires after event

---

## Recommendations

**For this workshop:**
1. **Use shared Bedrock** (provided) - easiest, fastest
2. **Bring your own Anthropic key** - if you already have one
3. **Use Ollama** - if you want free/offline, accept lower quality

**For production use after workshop:**
1. **AWS Bedrock** - best if already using AWS
2. **Anthropic Direct** - best for startups/small teams
3. **Azure OpenAI** - best for enterprises already on Azure
4. **Ollama** - best for air-gapped environments

---

## Testing Your Configuration

After configuring, test in VS Code:

1. Open Konveyor Analysis view
2. Load analysis results
3. Click "Get solution" on any violation
4. If you see AI-generated reasoning → ✅ Working!
5. If you see an error → Check API key/configuration

**Common Issues:**

**"API key invalid"**
- Double-check key format
- Ensure no extra spaces
- Verify key hasn't expired

**"Rate limit exceeded"**
- Wait a few minutes
- Try different provider
- Contact workshop facilitators

**"Model not found"**
- Check model name spelling
- Ensure model is enabled (Bedrock requires enabling models)

---

## Security Best Practices

❌ **Don't:**
- Commit API keys to git
- Share keys publicly
- Use production AWS credentials

✅ **Do:**
- Use `.vscode/settings.json` (gitignored)
- Rotate keys after workshop
- Set spending limits on accounts

---

## After the Workshop

**Workshop Bedrock key expires**, so you'll need to:

1. Set up your own provider (see options above)
2. Or continue with Ollama (free)
3. Or add to `.gitignore` and configure locally

**Recommended for ongoing use:**
- Small projects: Anthropic direct ($5/month credit)
- Enterprise: AWS Bedrock (pay-as-you-go)
- Air-gapped: Ollama (free, offline)

---

## Need Help?

- Slack: #workshop-help
- Documentation: [Konveyor AI Docs](https://konveyor.io/docs)
- During workshop: Ask facilitators!
