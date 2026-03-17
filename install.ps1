# ccv installer for Windows — Claude Code Vault
# Usage: irm https://raw.githubusercontent.com/takielias/ccv/main/install.ps1 | iex

$ErrorActionPreference = "Stop"

$Version = "0.1.0"
$Repo = "takielias/claude-code-vault"
$Binary = "ccv"
$InstallDir = "$env:LOCALAPPDATA\ccv"

function Write-Info($msg)  { Write-Host "[ccv] $msg" -ForegroundColor Cyan }
function Write-Ok($msg)    { Write-Host "[ccv] $msg" -ForegroundColor Green }
function Write-Warn($msg)  { Write-Host "[ccv] $msg" -ForegroundColor Yellow }
function Write-Err($msg)   { Write-Host "[ccv] $msg" -ForegroundColor Red; exit 1 }

# Detect architecture
function Get-Arch {
    $arch = $env:PROCESSOR_ARCHITECTURE
    if ($env:PROCESSOR_ARCHITEW6432) {
        $arch = $env:PROCESSOR_ARCHITEW6432
    }
    switch ($arch) {
        "AMD64" { return "amd64" }
        "ARM64" { return "arm64" }
        default { Write-Err "Unsupported architecture: $arch" }
    }
}

function Install-Ccv {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "   ccv - Claude Code Vault Installer    " -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""

    $arch = Get-Arch
    Write-Info "Detected: windows/$arch"

    $archive = "$Binary-$Version-windows-$arch.tar.gz"
    $url = "https://github.com/$Repo/releases/download/v$Version/$archive"

    Write-Info "Downloading ccv v$Version..."

    $tmpDir = New-Item -ItemType Directory -Path "$env:TEMP\ccv-install-$(Get-Random)"
    $tmpFile = Join-Path $tmpDir $archive

    try {
        Invoke-WebRequest -Uri $url -OutFile $tmpFile -UseBasicParsing
    } catch {
        Write-Err "Download failed. Check https://github.com/$Repo/releases"
    }

    Write-Info "Extracting..."
    tar -xzf $tmpFile -C $tmpDir

    # Create install directory
    if (-not (Test-Path $InstallDir)) {
        New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
    }

    $binaryPath = Join-Path $InstallDir "$Binary.exe"
    Move-Item -Path (Join-Path $tmpDir "$Binary.exe") -Destination $binaryPath -Force

    # Add to PATH if not already there
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($userPath -notlike "*$InstallDir*") {
        Write-Info "Adding $InstallDir to user PATH..."
        [Environment]::SetEnvironmentVariable("Path", "$userPath;$InstallDir", "User")
        $env:Path = "$env:Path;$InstallDir"
    }

    # Cleanup
    Remove-Item -Recurse -Force $tmpDir

    # Verify
    try {
        $ver = & $binaryPath --version 2>&1
        Write-Ok "Installed successfully: $ver"
    } catch {
        Write-Ok "Installed to $binaryPath"
    }

    Write-Host ""
    Write-Host "Get started:" -ForegroundColor Green
    Write-Host "  cd your-project"
    Write-Host "  ccv init"
    Write-Host ""
    Write-Warn "Restart your terminal for PATH changes to take effect."
}

Install-Ccv
