# PatternFly Migration Workshop - Setup Script (Windows PowerShell)
# This script verifies and installs all prerequisites for the workshop

$ErrorActionPreference = "Continue"

# Tracking
$script:Errors = @()
$script:Warnings = @()
$script:Success = @()

function Print-Header {
    param([string]$Message)
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Blue
    Write-Host $Message -ForegroundColor Blue
    Write-Host "========================================" -ForegroundColor Blue
    Write-Host ""
}

function Print-Success {
    param([string]$Message)
    Write-Host "✓ " -ForegroundColor Green -NoNewline
    Write-Host $Message
    $script:Success += $Message
}

function Print-Error {
    param([string]$Message)
    Write-Host "✗ " -ForegroundColor Red -NoNewline
    Write-Host $Message
    $script:Errors += $Message
}

function Print-Warning {
    param([string]$Message)
    Write-Host "⚠ " -ForegroundColor Yellow -NoNewline
    Write-Host $Message
    $script:Warnings += $Message
}

function Print-Info {
    param([string]$Message)
    Write-Host "ℹ " -ForegroundColor Blue -NoNewline
    Write-Host $Message
}

function Test-CommandExists {
    param([string]$Command)
    $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

function Compare-Versions {
    param(
        [string]$Version1,
        [string]$Version2
    )
    [version]$v1 = $Version1
    [version]$v2 = $Version2
    return $v1 -ge $v2
}

Print-Header "PatternFly Migration Workshop Setup"

Write-Host "This script will verify and help you set up everything needed for the workshop."
Write-Host "Estimated time: 5-10 minutes"
Write-Host ""

# System Information
Print-Header "System Information"
Write-Host "Operating System: Windows"
Write-Host "PowerShell Version: $($PSVersionTable.PSVersion)"
Write-Host "Architecture: $env:PROCESSOR_ARCHITECTURE"

# Check Node.js
Print-Header "Checking Node.js"
if (Test-CommandExists "node") {
    $nodeVersion = (node --version) -replace 'v', ''
    Write-Host "Node.js version: $nodeVersion"

    if (Compare-Versions $nodeVersion "18.0.0") {
        Print-Success "Node.js 18+ is installed"
    } else {
        Print-Error "Node.js version must be 18 or higher (found: $nodeVersion)"
        Write-Host "  Install from: https://nodejs.org/"
    }
} else {
    Print-Error "Node.js is not installed"
    Write-Host "  Install from: https://nodejs.org/"
}

# Check npm
if (Test-CommandExists "npm") {
    $npmVersion = npm --version
    Print-Success "npm is installed (version: $npmVersion)"
} else {
    Print-Error "npm is not installed (usually comes with Node.js)"
}

# Check Git
Print-Header "Checking Git"
if (Test-CommandExists "git") {
    $gitVersion = (git --version) -replace 'git version ', ''
    Print-Success "Git is installed (version: $gitVersion)"
} else {
    Print-Error "Git is not installed"
    Write-Host "  Install from: https://git-scm.com/download/win"
}

# Check Docker
Print-Header "Checking Container Runtime (Docker)"
$containerRuntime = ""

if (Test-CommandExists "docker") {
    $dockerVersion = (docker --version) -replace 'Docker version ', '' -replace ',.*', ''
    Print-Success "Docker is installed (version: $dockerVersion)"
    $containerRuntime = "docker"

    # Test Docker
    Write-Host "Testing Docker..."
    try {
        docker ps | Out-Null
        Print-Success "Docker is running and accessible"
    } catch {
        Print-Warning "Docker is installed but not running"
        Write-Host "  Please start Docker Desktop"
    }
} else {
    Print-Error "Docker is not installed"
    Write-Host "  Install Docker Desktop from: https://docs.docker.com/desktop/install/windows-install/"
}

# Check/Install Kantra
Print-Header "Checking Kantra CLI"

$kantraVersion = "v0.6.2"
$installDir = "$env:LOCALAPPDATA\kantra"

if (Test-CommandExists "kantra") {
    $currentKantraVersion = (kantra version 2>$null | Select-String -Pattern 'v\d+\.\d+\.\d+').Matches.Value
    if (-not $currentKantraVersion) { $currentKantraVersion = "unknown" }
    Print-Success "Kantra is already installed (version: $currentKantraVersion)"
} else {
    Write-Host "Kantra not found. Installing kantra CLI..."

    # Detect architecture
    $kantraArch = if ($env:PROCESSOR_ARCHITECTURE -eq "AMD64") { "amd64" } else { "arm64" }
    $kantraBinary = "kantra-windows-$kantraArch.exe"
    $downloadUrl = "https://github.com/konveyor/kantra/releases/download/$kantraVersion/$kantraBinary"

    Write-Host "Downloading kantra from: $downloadUrl"

    try {
        # Create install directory if it doesn't exist
        if (-not (Test-Path $installDir)) {
            New-Item -ItemType Directory -Path $installDir -Force | Out-Null
        }

        $kantraPath = "$installDir\kantra.exe"

        # Download kantra
        Invoke-WebRequest -Uri $downloadUrl -OutFile $kantraPath -UseBasicParsing

        # Check if install dir is in PATH
        $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
        if ($userPath -notlike "*$installDir*") {
            Print-Warning "Kantra installed to $installDir but not in PATH"
            Write-Host "  Adding $installDir to your PATH..."

            # Add to user PATH
            $newPath = "$installDir;$userPath"
            [Environment]::SetEnvironmentVariable("Path", $newPath, "User")

            # Add to current session PATH
            $env:Path = "$installDir;$env:Path"

            Write-Host "  PATH updated. You may need to restart your terminal."
        } else {
            # Still add to current session
            $env:Path = "$installDir;$env:Path"
        }

        # Verify installation
        if (Test-CommandExists "kantra") {
            $installedVersion = (kantra version 2>$null | Select-String -Pattern 'v\d+\.\d+\.\d+').Matches.Value
            if (-not $installedVersion) { $installedVersion = $kantraVersion }
            Print-Success "Kantra installed successfully (version: $installedVersion)"
        } else {
            Print-Error "Kantra downloaded but not accessible in PATH"
            Write-Host "  Try restarting PowerShell or manually add $installDir to PATH"
        }
    } catch {
        Print-Error "Failed to download kantra: $_"
        Write-Host "  You can manually download from: https://github.com/konveyor/kantra/releases"
    }
}

# Test kantra if available
if (Test-CommandExists "kantra") {
    Write-Host "Testing kantra..."
    try {
        kantra version | Out-Null
        Print-Success "Kantra is working correctly"
    } catch {
        Print-Warning "Kantra is installed but 'kantra version' failed"
    }
}

# Check VS Code
Print-Header "Checking VS Code"
$vscodeFound = $false

if (Test-CommandExists "code") {
    $vscodeVersion = (code --version | Select-Object -First 1)
    Print-Success "VS Code is installed (version: $vscodeVersion)"
    $vscodeFound = $true
} elseif (Test-Path "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe") {
    Print-Warning "VS Code is installed but 'code' command not in PATH"
    Write-Host "  Add VS Code to PATH or reinstall with 'Add to PATH' option"
    $vscodeFound = $true
} else {
    Print-Warning "VS Code not detected"
    Write-Host "  Install from: https://code.visualstudio.com/"
}

# Check for Konveyor extension
if ($vscodeFound -and (Test-CommandExists "code")) {
    Write-Host ""
    Write-Host "Checking for Konveyor extension..."
    $extensions = code --list-extensions
    if ($extensions -match "konveyor") {
        Print-Success "Konveyor extension is installed"
    } else {
        Print-Warning "Konveyor extension not found"
        Write-Host "  Install from VS Code marketplace: search for 'Konveyor'"
        Write-Host "  Or install from command line:"
        Write-Host "  code --install-extension konveyor.konveyor-analyzer"
    }
}

# Workshop repository setup
Print-Header "Workshop Repository Setup"

$repoUrl = "https://github.com/tsanders-rh/patternfly-migration-workshop.git"
$workshopDir = "patternfly-migration-workshop"

if (Test-Path $workshopDir) {
    Print-Info "Workshop directory already exists"
    Set-Location $workshopDir

    # Check if it's the right repo
    $remoteUrl = git remote get-url origin 2>$null
    if ($remoteUrl -match "patternfly-migration-workshop") {
        Print-Success "Existing workshop repository found"

        Write-Host "Updating repository..."
        try {
            git pull
            Print-Success "Repository updated"
        } catch {
            Print-Warning "Could not update repository (may have local changes)"
        }
    } else {
        Print-Warning "Directory exists but is not the workshop repository"
        Write-Host "  Please rename or remove the directory and run this script again"
        exit 1
    }
} else {
    Write-Host "Cloning workshop repository..."
    try {
        git clone $repoUrl
        Print-Success "Repository cloned successfully"
        Set-Location $workshopDir
    } catch {
        Print-Error "Failed to clone repository"
        exit 1
    }
}

# Clone Konveyor rulesets (to parent directory to avoid analyzing test data)
Print-Header "Konveyor Rulesets Setup"

$rulesetsDir = "..\rulesets"
$rulesetsUrl = "https://github.com/tsanders-rh/rulesets.git"
$rulesetsBranch = "patternfly-workshop-tiers"

if (Test-Path $rulesetsDir) {
    Print-Info "Rulesets directory already exists in parent directory"
    Set-Location $rulesetsDir

    $remoteUrl = git remote get-url origin 2>$null
    if ($remoteUrl -match "(konveyor/rulesets|tsanders-rh/rulesets)") {
        Print-Success "Existing rulesets repository found"

        Write-Host "Updating rulesets and checking out $rulesetsBranch branch..."
        try {
            git fetch origin
            git checkout $rulesetsBranch
            git pull origin $rulesetsBranch
            Print-Success "Rulesets updated to $rulesetsBranch branch with tier labels"
        } catch {
            Print-Warning "Could not update rulesets (may have local changes)"
        }
        Set-Location ..
    } else {
        Set-Location ..
        Print-Warning "Directory '..\rulesets' exists but is not the Konveyor rulesets repository"
        Write-Host "  Skipping rulesets clone. You may need to clone manually."
    }
} else {
    Write-Host "Cloning PatternFly workshop rulesets repository (with tier labels) to parent directory..."
    try {
        git clone -b $rulesetsBranch $rulesetsUrl $rulesetsDir
        Print-Success "Rulesets cloned successfully on $rulesetsBranch branch"
        Print-Info "PatternFly ruleset location: ..\rulesets\preview\nodejs\patternfly"
        Print-Info "Rules include tier labels: 🟢 [Tier 1] for simple changes, 🟡 [Tier 2] for review"
    } catch {
        Print-Warning "Failed to clone rulesets repository"
        Write-Host "  You can clone manually later with:"
        Write-Host "  cd .. && git clone -b $rulesetsBranch $rulesetsUrl"
    }
}

# Install dependencies
Print-Header "Installing Dependencies"
Write-Host "Running npm install (this may take a few minutes)..."

try {
    npm install
    Print-Success "Dependencies installed successfully"
} catch {
    Print-Error "Failed to install dependencies"
    exit 1
}

# Run tests
Print-Header "Running Tests"
Write-Host "Running test suite to verify setup..."

try {
    $testOutput = npm test 2>&1 | Out-String
    if ($testOutput -match "Tests:.*passed") {
        Print-Success "All tests passed"
    } else {
        Print-Warning "Tests completed but results unclear"
    }
} catch {
    Print-Warning "Tests encountered issues (this may be expected for workshop violations)"
}

# Try to build
Print-Header "Testing Build"
Write-Host "Running build to verify configuration..."

try {
    npm run build 2>&1 | Out-Null
    Print-Success "Build successful"
} catch {
    Print-Warning "Build had issues (may be expected for workshop)"
}

# Summary
Print-Header "Setup Summary"

if ($script:Success.Count -gt 0) {
    Write-Host "Successful checks:" -ForegroundColor Green
    foreach ($item in $script:Success) {
        Write-Host "  ✓ $item"
    }
    Write-Host ""
}

if ($script:Warnings.Count -gt 0) {
    Write-Host "Warnings:" -ForegroundColor Yellow
    foreach ($item in $script:Warnings) {
        Write-Host "  ⚠ $item"
    }
    Write-Host ""
}

if ($script:Errors.Count -gt 0) {
    Write-Host "Errors that need attention:" -ForegroundColor Red
    foreach ($item in $script:Errors) {
        Write-Host "  ✗ $item"
    }
    Write-Host ""
}

# Final instructions
Print-Header "Next Steps"

if ($script:Errors.Count -eq 0) {
    Write-Host "🎉 Setup is complete!" -ForegroundColor Green
    Write-Host ""
    Write-Host "To start the development server:"
    Write-Host "  cd $workshopDir"
    Write-Host "  npm run dev"
    Write-Host ""
    Write-Host "The app will be available at: http://localhost:3000"
    Write-Host ""
    Write-Host "To run tests:"
    Write-Host "  npm test"
    Write-Host ""
    Write-Host "To run Konveyor analysis:"
    Write-Host "  kantra analyze --input . --rules ..\rulesets\preview\nodejs\patternfly --output .\analysis-results --source patternfly-v5 --target patternfly-v6 --enable-default-rulesets=false"
    Write-Host ""
    Write-Host "Before the workshop, please also:"
    Write-Host "  1. Get an API key from your AI provider (OpenAI, Anthropic, or setup Ollama)"
    Write-Host "  2. Ensure VS Code Konveyor extension is installed"
    Write-Host "  3. Review the README.md for workshop overview"
    Write-Host ""
    Write-Host "Everything is ready! See you at the workshop!"
} else {
    Write-Host "⚠ Setup incomplete" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please resolve the errors above before the workshop."
    Write-Host "If you need help, please reach out to the workshop organizers."
    Write-Host ""
    Write-Host "Common solutions:"
    Write-Host "  - Install missing software using links provided above"
    Write-Host "  - Ensure Docker Desktop is running"
    Write-Host "  - Check that you have a stable internet connection"
    Write-Host ""
}

# Create validation report
$reportFile = "setup-validation-report.txt"
$reportContent = @"
PatternFly Migration Workshop - Setup Validation Report
Generated: $(Get-Date)
==========================================

System: Windows ($env:PROCESSOR_ARCHITECTURE)
PowerShell: $($PSVersionTable.PSVersion)

SUCCESS ($($script:Success.Count)):
$($script:Success | ForEach-Object { "  ✓ $_" } | Out-String)

WARNINGS ($($script:Warnings.Count)):
$($script:Warnings | ForEach-Object { "  ⚠ $_" } | Out-String)

ERRORS ($($script:Errors.Count)):
$($script:Errors | ForEach-Object { "  ✗ $_" } | Out-String)
"@

$reportContent | Out-File -FilePath $reportFile -Encoding UTF8

Write-Host ""
Write-Host "Validation report saved to: $reportFile"
Write-Host "Please share this report with workshop organizers if you encounter issues."
