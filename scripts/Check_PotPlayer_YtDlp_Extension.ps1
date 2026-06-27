param(
    [string]$PotPlayerRoot = "",
    [switch]$NoPause
)

$ErrorActionPreference = "Stop"

function Pause-IfNeeded {
    if (-not $NoPause) {
        Write-Host ""
        Read-Host "Press Enter to close"
    }
}

function Get-DefaultPotPlayerRoots {
    $roots = New-Object System.Collections.Generic.List[string]

    if ($env:ProgramFiles) {
        $roots.Add((Join-Path $env:ProgramFiles "DAUM\PotPlayer"))
    }

    $programFilesX86 = [Environment]::GetFolderPath("ProgramFilesX86")
    if ($programFilesX86) {
        $roots.Add((Join-Path $programFilesX86 "DAUM\PotPlayer"))
    }

    $appPathKeys = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\PotPlayerMini64.exe",
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\PotPlayerMini.exe",
        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\PotPlayerMini64.exe",
        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\PotPlayerMini.exe"
    )

    foreach ($key in $appPathKeys) {
        try {
            $item = Get-Item -LiteralPath $key -ErrorAction Stop
            $exePath = [string]$item.GetValue("")
            if ($exePath) {
                $roots.Add((Split-Path -Parent $exePath))
            }
        }
        catch {
            # Registry key not present.
        }
    }

    return $roots | Where-Object { $_ } | Select-Object -Unique
}

function Resolve-PotPlayerRoot {
    if ($PotPlayerRoot) {
        $resolved = $PotPlayerRoot
        if (Test-Path -LiteralPath $resolved -PathType Leaf) {
            $resolved = Split-Path -Parent $resolved
        }
        if (-not (Test-Path -LiteralPath $resolved -PathType Container)) {
            throw "PotPlayer path does not exist: $PotPlayerRoot"
        }
        return $resolved
    }

    foreach ($root in Get-DefaultPotPlayerRoots) {
        if (-not (Test-Path -LiteralPath $root -PathType Container)) {
            continue
        }
        $hasPotPlayer = (Test-Path -LiteralPath (Join-Path $root "PotPlayerMini64.exe")) -or
                        (Test-Path -LiteralPath (Join-Path $root "PotPlayerMini.exe"))
        if ($hasPotPlayer) {
            return $root
        }
    }

    throw "PotPlayer was not found."
}

try {
    $root = Resolve-PotPlayerRoot
    $extension = Join-Path $root "Extension\Media\PlayParse\MediaPlayParse - yt-dlp.as"
    $config = Join-Path $root "Extension\Media\PlayParse\yt-dlp_default.ini"
    $ytDlpExe = Join-Path $root "Module\yt-dlp.exe"

    Write-Host "PotPlayer root: $root"
    Write-Host ""

    foreach ($path in @($extension, $config, $ytDlpExe)) {
        if (Test-Path -LiteralPath $path -PathType Leaf) {
            $item = Get-Item -LiteralPath $path
            Write-Host "[OK] $($item.FullName) ($($item.Length) bytes)" -ForegroundColor Green
        }
        else {
            Write-Host "[MISSING] $path" -ForegroundColor Red
        }
    }

    if (Test-Path -LiteralPath $ytDlpExe -PathType Leaf) {
        Write-Host ""
        $version = (& $ytDlpExe --version) -join ""
        Write-Host "yt-dlp version: $version"

        $extractors = (& $ytDlpExe --list-extractors) -join "`n"
        if ($extractors -match "(?m)^chzzk:live$" -and $extractors -match "(?m)^chzzk:video$") {
            Write-Host "[OK] Chzzk live/video extractors detected." -ForegroundColor Green
        }
        else {
            Write-Host "[MISSING] Chzzk extractors were not detected. Update yt-dlp." -ForegroundColor Red
        }
    }
}
catch {
    Write-Host ""
    Write-Host "[ERROR] $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
finally {
    Pause-IfNeeded
}
