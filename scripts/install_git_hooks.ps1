# PowerShell script to install and configure global anti-AI git hooks on Windows
# Usage: powershell -ExecutionPolicy Bypass -File scripts/install_git_hooks.ps1
$ErrorActionPreference = "Stop"

Write-Host "Configuring global Git hooks..." -ForegroundColor Cyan

$HomeDir = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::UserProfile)
$DotfilesDir = Join-Path $HomeDir ".dotfiles"

$GitHooksDir = Join-Path $HomeDir ".git_hooks"
$GitTemplateHooksDir = Join-Path $HomeDir ".git_template\hooks"
$HuskyConfigDir = Join-Path $HomeDir ".config\husky"

New-Item -ItemType Directory -Force -Path $GitHooksDir | Out-Null
New-Item -ItemType Directory -Force -Path $GitTemplateHooksDir | Out-Null
New-Item -ItemType Directory -Force -Path $HuskyConfigDir | Out-Null

$SourceHooks = Join-Path $DotfilesDir "link\.git_hooks"
if (Test-Path $SourceHooks) {
    Copy-Item -Path "$SourceHooks\*" -Destination $GitHooksDir -Force
    Copy-Item -Path "$SourceHooks\*" -Destination $GitTemplateHooksDir -Force
}

$SourceHusky = Join-Path $DotfilesDir "config\husky\init.sh"
if (Test-Path $SourceHusky) {
    Copy-Item -Path $SourceHusky -Destination (Join-Path $HuskyConfigDir "init.sh") -Force
}

git config --global core.hooksPath "$HomeDir/.git_hooks"
git config --global init.templateDir "$HomeDir/.git_template"

Write-Host "Global Git hooks successfully installed and configured in $GitHooksDir" -ForegroundColor Green
