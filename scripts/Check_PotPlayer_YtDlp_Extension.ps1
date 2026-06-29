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

function Get-PotPlayerProfileNames {
    param([string]$Root)

    $names = New-Object System.Collections.Generic.List[string]

    if ((Test-Path -LiteralPath (Join-Path $Root "PotPlayerMini64.exe")) -or
        (Test-Path -LiteralPath (Join-Path $Root "PotPlayer64.exe"))) {
        $names.Add("PotPlayerMini64")
    }

    if ((Test-Path -LiteralPath (Join-Path $Root "PotPlayerMini.exe")) -or
        (Test-Path -LiteralPath (Join-Path $Root "PotPlayer.exe"))) {
        $names.Add("PotPlayerMini")
    }

    if ($names.Count -eq 0) {
        $names.Add("PotPlayerMini64")
    }

    return $names | Select-Object -Unique
}

function Get-IniValue {
    param(
        [string]$Text,
        [string]$Name
    )

    $match = [regex]::Match($Text, "(?m)^" + [regex]::Escape($Name) + "=(.*)$")
    if ($match.Success) {
        return $match.Groups[1].Value.Trim()
    }

    return ""
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

    if (Test-Path -LiteralPath $extension -PathType Leaf) {
        $extensionText = Get-Content -LiteralPath $extension -Raw
        if ($extensionText -match 'tx\.findI\(log, "\[debug\] Command-line config:"\) < 0 && tx\.findI\(output, "\[debug\] Command-line config:"\) >= 0') {
            Write-Host "[OK] yt-dlp log-order compatibility patch detected." -ForegroundColor Green
        }
        else {
            Write-Host "[WARN] yt-dlp log-order compatibility patch was not detected." -ForegroundColor Yellow
        }

        if ($extensionText -match 'data\.find\("}\\r\\n", pos1\)') {
            Write-Host "[OK] yt-dlp JSON line-ending compatibility patch detected." -ForegroundColor Green
        }
        else {
            Write-Host "[WARN] yt-dlp JSON line-ending compatibility patch was not detected." -ForegroundColor Yellow
        }

        if ($extensionText -match 'bool _IsTwitchStreamlinkHlsUrl\(string url\)' -and
            $extensionText -match '127' -and
            $extensionText -match 'localhost' -and
            $extensionText -match '_IsTwitchStreamlinkHlsUrl\(url\)') {
            Write-Host "[OK] Twitch Streamlink HLS/local HTTP passthrough patch detected." -ForegroundColor Green
        }
        else {
            Write-Host "[WARN] Twitch Streamlink HLS/local HTTP passthrough patch was not detected." -ForegroundColor Yellow
        }
    }

    Write-Host ""
    foreach ($profileName in Get-PotPlayerProfileNames -Root $root) {
        $userConfig = Join-Path $env:APPDATA (Join-Path $profileName "Extension\Media\PlayParse\yt-dlp.ini")
        if (-not (Test-Path -LiteralPath $userConfig -PathType Leaf)) {
            Write-Host "[MISSING] User config: $userConfig" -ForegroundColor Yellow
            continue
        }

        $text = Get-Content -LiteralPath $userConfig -Raw
        $liveChat = Get-IniValue -Text $text -Name "live_chat"
        $reduceFormats = Get-IniValue -Text $text -Name "reduce_formats"
        $criticalError = Get-IniValue -Text $text -Name "critical_error"

        Write-Host "User config: $userConfig"
        if ($liveChat -eq "0") {
            Write-Host "[OK] live_chat=0" -ForegroundColor Green
        }
        else {
            Write-Host "[WARN] live_chat=$liveChat (recommended: 0)" -ForegroundColor Yellow
        }

        if ($reduceFormats -eq "1") {
            Write-Host "[OK] reduce_formats=1" -ForegroundColor Green
        }
        else {
            Write-Host "[WARN] reduce_formats=$reduceFormats (recommended: 1)" -ForegroundColor Yellow
        }

        if ($criticalError -eq "0") {
            Write-Host "[OK] critical_error=0" -ForegroundColor Green
        }
        elseif ($criticalError -eq "") {
            Write-Host "[OK] critical_error=0 (default)" -ForegroundColor Green
        }
        else {
            Write-Host "[WARN] critical_error=$criticalError (recommended: 0)" -ForegroundColor Yellow
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
