# Installs or updates the PotPlayer yt-dlp media parser extension.
# Official sources:
# - PotPlayer extension: https://github.com/hgcat-360/PotPlayer-Extension_yt-dlp
# - yt-dlp: https://github.com/yt-dlp/yt-dlp

param(
    [string]$PotPlayerRoot = "",
    [switch]$NoPause
)

$ErrorActionPreference = "Stop"
$script:SkipFinalPause = $false

function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message"
}

function Write-Ok {
    param([string]$Message)
    Write-Host "[OK] $Message" -ForegroundColor Green
}

function Write-WarnLine {
    param([string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Pause-IfNeeded {
    if ((-not $script:SkipFinalPause) -and (-not $NoPause)) {
        Write-Host ""
        Read-Host "Press Enter to close"
    }
}

function Test-IsAdmin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Restart-Elevated {
    $argList = @(
        "-NoProfile",
        "-ExecutionPolicy", "Bypass",
        "-File", ('"{0}"' -f $PSCommandPath)
    )

    if ($PotPlayerRoot) {
        $argList += "-PotPlayerRoot"
        $argList += ('"{0}"' -f $PotPlayerRoot)
    }
    if ($NoPause) {
        $argList += "-NoPause"
    }

    Write-Info "Requesting administrator permission..."
    Start-Process -FilePath "powershell.exe" -ArgumentList ($argList -join " ") -Verb RunAs
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

    throw "PotPlayer was not found. Install PotPlayer first, or run this script with -PotPlayerRoot `"C:\Path\To\PotPlayer`"."
}

function Backup-ExistingFile {
    param(
        [string]$Path,
        [string]$BackupRoot
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return
    }

    if (-not (Test-Path -LiteralPath $BackupRoot -PathType Container)) {
        New-Item -ItemType Directory -Path $BackupRoot | Out-Null
    }

    $backupPath = Join-Path $BackupRoot (Split-Path -Leaf $Path)
    Copy-Item -LiteralPath $Path -Destination $backupPath -Force
}

function Download-FileChecked {
    param(
        [string]$Url,
        [string]$Destination,
        [int64]$MinBytes
    )

    $tempDir = Join-Path $env:TEMP ("potplayer-ytdlp-" + [Guid]::NewGuid().ToString("N"))
    New-Item -ItemType Directory -Path $tempDir | Out-Null
    $tempFile = Join-Path $tempDir (Split-Path -Leaf $Destination)

    try {
        Write-Info ("Downloading " + (Split-Path -Leaf $Destination))
        Invoke-WebRequest -Uri $Url -OutFile $tempFile -UseBasicParsing -Headers @{ "User-Agent" = "PotPlayer-yt-dlp-installer" } -TimeoutSec 120

        $item = Get-Item -LiteralPath $tempFile
        if ($item.Length -lt $MinBytes) {
            throw "Downloaded file is too small: $($item.Length) bytes"
        }

        Move-Item -LiteralPath $tempFile -Destination $Destination -Force
    }
    finally {
        Remove-Item -LiteralPath $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor
                                                   [Net.SecurityProtocolType]::Tls11 -bor
                                                   [Net.SecurityProtocolType]::Tls

    if (-not (Test-IsAdmin)) {
        Restart-Elevated
        $script:SkipFinalPause = $true
        exit 0
    }

    $root = Resolve-PotPlayerRoot
    $playParseDir = Join-Path $root "Extension\Media\PlayParse"
    $moduleDir = Join-Path $root "Module"

    New-Item -ItemType Directory -Path $playParseDir -Force | Out-Null
    New-Item -ItemType Directory -Path $moduleDir -Force | Out-Null

    $backupRoot = Join-Path $root ("Backup_PotPlayer_yt-dlp_" + (Get-Date -Format "yyyyMMdd_HHmmss"))

    $files = @(
        @{
            Url = "https://raw.githubusercontent.com/hgcat-360/PotPlayer-Extension_yt-dlp/main/MediaPlayParse%20-%20yt-dlp.as"
            Destination = Join-Path $playParseDir "MediaPlayParse - yt-dlp.as"
            MinBytes = 100000
        },
        @{
            Url = "https://raw.githubusercontent.com/hgcat-360/PotPlayer-Extension_yt-dlp/main/MediaPlayParse%20-%20yt-dlp.ico"
            Destination = Join-Path $playParseDir "MediaPlayParse - yt-dlp.ico"
            MinBytes = 500
        },
        @{
            Url = "https://raw.githubusercontent.com/hgcat-360/PotPlayer-Extension_yt-dlp/main/yt-dlp_default.ini"
            Destination = Join-Path $playParseDir "yt-dlp_default.ini"
            MinBytes = 10000
        },
        @{
            Url = "https://raw.githubusercontent.com/hgcat-360/PotPlayer-Extension_yt-dlp/main/yt-dlp_radio1.jpg"
            Destination = Join-Path $playParseDir "yt-dlp_radio1.jpg"
            MinBytes = 1000
        },
        @{
            Url = "https://raw.githubusercontent.com/hgcat-360/PotPlayer-Extension_yt-dlp/main/yt-dlp_radio2.jpg"
            Destination = Join-Path $playParseDir "yt-dlp_radio2.jpg"
            MinBytes = 1000
        },
        @{
            Url = "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"
            Destination = Join-Path $moduleDir "yt-dlp.exe"
            MinBytes = 10000000
        }
    )

    Write-Info "PotPlayer root: $root"
    Write-Info "Existing files will be backed up to: $backupRoot"

    foreach ($file in $files) {
        Backup-ExistingFile -Path $file.Destination -BackupRoot $backupRoot
        Download-FileChecked -Url $file.Url -Destination $file.Destination -MinBytes $file.MinBytes
    }

    $ytDlpExe = Join-Path $moduleDir "yt-dlp.exe"
    $version = (& $ytDlpExe --version) -join ""
    $extractors = (& $ytDlpExe --list-extractors) -join "`n"

    if ($extractors -notmatch "(?m)^chzzk:live$") {
        throw "yt-dlp was installed, but the chzzk:live extractor was not found."
    }
    if ($extractors -notmatch "(?m)^chzzk:video$") {
        throw "yt-dlp was installed, but the chzzk:video extractor was not found."
    }

    Write-Ok "PotPlayer yt-dlp extension installed or updated."
    Write-Ok "yt-dlp version: $version"
    Write-Ok "Chzzk live/video support detected."
    Write-WarnLine "Restart PotPlayer before testing Chzzk, YouTube, or other URLs."
}
catch {
    Write-Host ""
    Write-Host "[ERROR] $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
finally {
    Pause-IfNeeded
}
