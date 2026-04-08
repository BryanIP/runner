$ErrorActionPreference = 'Stop'

$version = if ($env:VERSION) { $env:VERSION } else { 'v0.0.1' }
$outDir = 'dist/bin'

if (-not (Test-Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir | Out-Null
}

Push-Location 'apps/assinatura-cli'
$targets = @(
    @{ GOOS = 'windows'; GOARCH = 'amd64'; Output = "../../$outDir/assinatura-$version-windows-amd64.exe" },
    @{ GOOS = 'linux'; GOARCH = 'amd64'; Output = "../../$outDir/assinatura-$version-linux-amd64" },
    @{ GOOS = 'darwin'; GOARCH = 'amd64'; Output = "../../$outDir/assinatura-$version-darwin-amd64" }
)

foreach ($target in $targets) {
    $env:GOOS = $target.GOOS
    $env:GOARCH = $target.GOARCH
    go build -o $target.Output ./cmd/assinatura
}

Remove-Item Env:GOOS -ErrorAction SilentlyContinue
Remove-Item Env:GOARCH -ErrorAction SilentlyContinue
Pop-Location

Write-Host "Build concluído em $outDir"
