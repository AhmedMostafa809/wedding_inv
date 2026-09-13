$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
Push-Location $projectRoot
try {
    flutter build web --release
    if ($LASTEXITCODE -ne 0) { throw 'Flutter release build failed.' }
    $releasePath = Join-Path $projectRoot ('build/vercel-release-' + (Get-Date -Format 'yyyyMMdd-HHmmss'))
    New-Item -ItemType Directory -Path $releasePath | Out-Null
    $webRoot = (Resolve-Path -LiteralPath 'build/web').Path
    $files = Get-ChildItem -LiteralPath $webRoot -Recurse -File
    foreach ($file in $files) {
        $relative = $file.FullName.Substring($webRoot.Length + 1)
        if ($relative -match '(?i)(^|[\\/])photos([\\/]|$)|\.(jpg|jpeg|xlsx|csv|env|map)$') {
            throw "Unexpected private or source file in build: $relative"
        }
        $destination = Join-Path $releasePath $relative
        New-Item -ItemType Directory -Force -Path (Split-Path $destination -Parent) | Out-Null
        Copy-Item -LiteralPath $file.FullName -Destination $destination
    }
    Copy-Item -LiteralPath 'tool/vercel-static.json' -Destination (Join-Path $releasePath 'vercel.json')
    Write-Output "Verified release directory: $releasePath"
    Write-Output "Release files: $($files.Count); bytes: $(($files | Measure-Object Length -Sum).Sum)"
} finally { Pop-Location }
