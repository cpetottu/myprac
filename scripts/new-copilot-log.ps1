param(
    [Parameter(Mandatory = $true)]
    [string]$Topic,

    [string]$Prompt = "",
    [string]$Summary = ""
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$logsDir = Join-Path $repoRoot "notes\copilot-history"
$templatePath = Join-Path $logsDir "TEMPLATE.md"

if (-not (Test-Path $logsDir)) {
    New-Item -ItemType Directory -Path $logsDir | Out-Null
}

if (-not (Test-Path $templatePath)) {
    throw "Template file not found: $templatePath"
}

$now = Get-Date
$dateStamp = $now.ToString("yyyy-MM-dd")
$timeStamp = $now.ToString("HHmm")
$slug = ($Topic.ToLower() -replace "[^a-z0-9]+", "-").Trim("-")
if ([string]::IsNullOrWhiteSpace($slug)) {
    $slug = "session"
}

$fileName = "$dateStamp-$timeStamp-$slug.md"
$outPath = Join-Path $logsDir $fileName

$branch = "unknown"
try {
    $branch = (git -C $repoRoot rev-parse --abbrev-ref HEAD).Trim()
} catch {
    # Keep unknown when not in a git repo.
}

$template = Get-Content -Path $templatePath -Raw
$content = $template
$content = $content.Replace("{{DATE}}", $now.ToString("yyyy-MM-dd"))
$content = $content.Replace("{{TIME}}", $now.ToString("HH:mm"))
$content = $content.Replace("{{TOPIC}}", $Topic)
$content = $content.Replace("{{BRANCH}}", $branch)
$content = $content.Replace("{{PROMPT}}", $(if ($Prompt) { $Prompt } else { "(paste your prompt)" }))
$content = $content.Replace("{{RESPONSE_SUMMARY}}", $(if ($Summary) { $Summary } else { "(paste a short summary)" }))
$content = $content.Replace("{{DECISION_1}}", "")
$content = $content.Replace("{{FOLLOW_UP_1}}", "")

Set-Content -Path $outPath -Value $content -Encoding utf8
Write-Output "Created: $outPath"
