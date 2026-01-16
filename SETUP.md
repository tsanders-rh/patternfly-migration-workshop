# Workshop Setup Instructions

Welcome! This guide will help you prepare your laptop for the PatternFly Migration Workshop.

**Time required:** 15-20 minutes
**When to do this:** At least 2 days before the workshop

## Quick Setup (Recommended)

We've created automated setup scripts that will check and install everything you need.

### macOS / Linux

1. Download the setup script:
   ```bash
   curl -O https://raw.githubusercontent.com/tsanders-rh/patternfly-migration-workshop/main/setup-workshop.sh
   chmod +x setup-workshop.sh
   ```

2. Run the setup script:
   ```bash
   ./setup-workshop.sh
   ```

3. Follow any instructions for missing dependencies

4. When complete, you'll see a `setup-validation-report.txt` file

### Windows

1. Download the setup script:
   ```powershell
   Invoke-WebRequest -Uri https://raw.githubusercontent.com/tsanders-rh/patternfly-migration-workshop/main/setup-workshop.ps1 -OutFile setup-workshop.ps1
   ```

2. Run the setup script (you may need to allow script execution):
   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   .\setup-workshop.ps1
   ```

3. Follow any instructions for missing dependencies

4. When complete, you'll see a `setup-validation-report.txt` file

## What the Script Checks

The setup script verifies and helps install:

- ✅ **Node.js 18+** - Required to run the workshop app
- ✅ **npm** - Package manager (comes with Node.js)
- ✅ **Git** - Version control
- ✅ **Podman or Docker** - Container runtime for Konveyor analysis
- ✅ **Kantra CLI** - Konveyor analysis tool (automatically installed)
- ✅ **VS Code** - IDE for the workshop
- ✅ **Konveyor Extension** - AI-assisted migration tools
- ✅ **Workshop Repository** - Clones and sets up the demo app
- ✅ **Konveyor Rulesets** - Clones PatternFly v5→v6 migration rules
- ✅ **Dependencies** - Installs all npm packages
- ✅ **Tests** - Verifies the app works

## Manual Setup (If Script Fails)

If the automated script doesn't work for you, follow these manual steps:

### 1. Install Prerequisites

#### Node.js 18+
- Download from: https://nodejs.org/
- Verify: `node --version` (should show v18.x or higher)

#### Git
- macOS: `brew install git` or download from https://git-scm.com/
- Linux: `sudo apt-get install git` (Ubuntu/Debian) or `sudo yum install git` (RHEL/CentOS)
- Windows: Download from https://git-scm.com/download/win
- Verify: `git --version`

#### Podman or Docker
- **Podman** (recommended for Linux): https://podman.io/getting-started/installation
- **Docker Desktop** (recommended for Mac/Windows): https://docs.docker.com/get-docker/
- Verify: `podman ps` or `docker ps`

#### VS Code
- Download from: https://code.visualstudio.com/
- Verify: `code --version`
- On Mac, enable shell command: Open VS Code → Command Palette (Cmd+Shift+P) → "Shell Command: Install 'code' command in PATH"

#### Kantra CLI
- Download the latest release for your platform from: https://github.com/konveyor/kantra/releases
- **macOS/Linux**:
  ```bash
  # Download and install to ~/.local/bin
  mkdir -p ~/.local/bin
  curl -L -o ~/.local/bin/kantra https://github.com/konveyor/kantra/releases/download/v0.6.2/kantra-$(uname -s | tr '[:upper:]' '[:lower:]')-$(uname -m | sed 's/x86_64/amd64/')
  chmod +x ~/.local/bin/kantra

  # Add to PATH (add to ~/.bashrc or ~/.zshrc)
  export PATH="$HOME/.local/bin:$PATH"
  ```
- **Windows**:
  ```powershell
  # Download and install to AppData\Local\kantra
  $installDir = "$env:LOCALAPPDATA\kantra"
  New-Item -ItemType Directory -Path $installDir -Force
  Invoke-WebRequest -Uri "https://github.com/konveyor/kantra/releases/download/v0.6.2/kantra-windows-amd64.exe" -OutFile "$installDir\kantra.exe"

  # Add to PATH
  $env:Path = "$installDir;$env:Path"
  ```
- Verify: `kantra version`

### 2. Clone Workshop Repository

```bash
git clone https://github.com/tsanders-rh/patternfly-migration-workshop.git
cd patternfly-migration-workshop
```

### 3. Install Dependencies

```bash
npm install
```

### 4. Verify Setup

Run the tests:
```bash
npm test
```

Start the dev server:
```bash
npm run dev
```

Open http://localhost:3000 - you should see the workshop app.

### 5. Install VS Code Extensions

Open VS Code in the workshop directory:
```bash
code .
```

Install the Konveyor extension:
- Open Extensions panel (Cmd/Ctrl+Shift+X)
- Search for "Konveyor"
- Click Install

Or install from command line:
```bash
code --install-extension konveyor.konveyor-analyzer
```

## AI Provider Setup

You'll need an API key from one of these providers for the workshop:

### Option 1: OpenAI (Recommended for workshop)
1. Sign up at https://platform.openai.com/
2. Create an API key at https://platform.openai.com/api-keys
3. Keep the key handy - you'll enter it in VS Code during the workshop

### Option 2: Anthropic (Claude)
1. Sign up at https://console.anthropic.com/
2. Create an API key in Account Settings
3. Keep the key handy for the workshop

### Option 3: Ollama (Local/Free)
1. Install Ollama from https://ollama.ai/
2. Pull a model: `ollama pull llama2`
3. Start Ollama: `ollama serve`

**Note:** You don't need to configure the API key now - we'll do that together at the start of the workshop.

## Using Kantra in Hybrid Mode

Kantra supports hybrid mode, which combines static analysis with AI-assisted fixes. After setup, you can run:

```bash
# Run analysis with PatternFly rules only
kantra analyze \
  --input . \
  --rules ./rulesets/preview/nodejs/patternfly \
  --output ./analysis-results \
  --source patternfly-v5 \
  --target patternfly-v6 \
  --enable-default-rulesets=false

# Or use the VS Code Konveyor extension (recommended for workshop)
# which provides a GUI for reviewing and applying AI-generated fixes
```

**Note:** We'll configure AI providers and run kantra together during the workshop. The setup script just ensures kantra is installed and ready.

## Validation Checklist

Before the workshop, verify you can do all of these:

- [ ] Run `node --version` and see v18.x or higher
- [ ] Run `git --version` successfully
- [ ] Run `podman ps` or `docker ps` successfully
- [ ] Run `kantra version` successfully
- [ ] Run `code --version` successfully
- [ ] Clone the workshop repository
- [ ] Run `npm install` without errors
- [ ] Run `npm test` and see tests pass
- [ ] Run `npm run dev` and see the app at http://localhost:3000
- [ ] Open VS Code and see Konveyor extension installed
- [ ] Have an API key ready (or Ollama installed)

## Troubleshooting

### "Node.js version too old"
- Uninstall old Node.js
- Install latest LTS from https://nodejs.org/

### "docker/podman: command not found"
- **Mac**: Install Docker Desktop from https://docs.docker.com/desktop/install/mac-install/
- **Windows**: Install Docker Desktop from https://docs.docker.com/desktop/install/windows-install/
- **Linux**: Install Podman from your package manager or https://podman.io/

### "Cannot connect to Docker daemon"
- **Mac/Windows**: Start Docker Desktop application
- **Linux**: Start Docker service: `sudo systemctl start docker`

### "npm install fails"
- Clear npm cache: `npm cache clean --force`
- Delete `node_modules` and `package-lock.json`
- Run `npm install` again

### "'code' command not found" (VS Code installed)
- **Mac**: Open VS Code → Command Palette (Cmd+Shift+P) → "Shell Command: Install 'code' command in PATH"
- **Windows**: Reinstall VS Code with "Add to PATH" option checked
- **Linux**: Add VS Code to PATH or use full path to code binary

### "'kantra' command not found" (after script install)
- **macOS/Linux**: Add `~/.local/bin` to your PATH:
  ```bash
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
  source ~/.bashrc
  ```
- **Windows**: Restart PowerShell to pick up PATH changes
- **Alternative**: Download manually from https://github.com/konveyor/kantra/releases

### "Kantra fails to run analysis"
- Ensure Docker/Podman is running: `docker ps` or `podman ps`
- Check kantra version: `kantra version`
- Try running with `--verbose` flag to see detailed errors

### "Tests fail" or "App won't start"
- Ensure you're in the right directory: `cd patternfly-migration-workshop`
- Check Node.js version: `node --version` (must be 18+)
- Delete `node_modules` and run `npm install` again
- Check for error messages and search the issue tracker

## Getting Help

If you're stuck after trying the above:

1. **Check your setup report**: Look at `setup-validation-report.txt` for specific issues
2. **Search existing issues**: https://github.com/konveyor/kai/issues
3. **Contact organizers**: Share your `setup-validation-report.txt` file
4. **Day-before office hours**: We'll have optional troubleshooting session (check workshop invite for time)

## What to Bring to the Workshop

- [ ] Laptop with setup completed
- [ ] Laptop charger (4-5 hour workshop)
- [ ] API key for OpenAI/Anthropic/Ollama (written down or in password manager)
- [ ] Your `setup-validation-report.txt` (in case of issues)
- [ ] (Optional) A sample PatternFly codebase you'd like to migrate

## Workshop Day Quick Start

On workshop day, just run:

```bash
cd patternfly-migration-workshop
git pull  # Get any last-minute updates
npm run dev  # Start the app
```

Then open VS Code:
```bash
code .
```

We'll configure the Konveyor extension together at the start of the workshop.

---

**Questions?** Reach out to workshop organizers or open an issue at https://github.com/tsanders-rh/patternfly-migration-workshop/issues

See you at the workshop! 🚀
