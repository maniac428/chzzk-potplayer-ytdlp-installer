# Chzzk PotPlayer yt-dlp Installer

Languages: [한국어](#한국어) | [English](#english)

Related project:

- Twitch PotPlayer 720p Fix: [twitch-potplayer-720p-fix](https://github.com/maniac428/twitch-potplayer-720p-fix)

## 한국어

**Chzzk PotPlayer yt-dlp Installer**는 치지직, 네이버, 유튜브 등 `yt-dlp` 지원 링크를 PotPlayer에서 열 수 있게 해주는 Windows용 설치 도구입니다.

복잡한 수동 설치 대신 ZIP을 받고 `install-potplayer-ytdlp.cmd`를 실행하면, PotPlayer용 `yt-dlp` 재생 확장과 최신 `yt-dlp.exe`를 설치/업데이트합니다.

### 필요한 것

| 항목 | 링크 |
| --- | --- |
| 최신 릴리스 ZIP | [GitHub Releases](https://github.com/maniac428/chzzk-potplayer-ytdlp-installer/releases/latest) |
| PotPlayer 64비트 | [potplayer.tv](https://potplayer.tv/) |
| PotPlayer yt-dlp 확장 원본 | [hgcat-360/PotPlayer-Extension_yt-dlp](https://github.com/hgcat-360/PotPlayer-Extension_yt-dlp) |
| yt-dlp 공식 릴리스 | [yt-dlp/yt-dlp releases](https://github.com/yt-dlp/yt-dlp/releases/latest) |

랜덤 블로그나 출처 불명의 exe 설치기를 피하세요. 가장 단순한 조합은 공식 PotPlayer 64비트 + 공식 GitHub 원본 파일 + 이 설치기 ZIP입니다.

### 사용법

1. PotPlayer를 종료합니다.
2. 최신 릴리스 ZIP을 받고 압축을 풉니다.
3. `install-potplayer-ytdlp.cmd`를 실행합니다.
4. Windows 관리자 권한 요청이 뜨면 허용합니다.
5. 설치가 끝나면 PotPlayer를 다시 켭니다.
6. PotPlayer에서 치지직 라이브/다시보기 URL을 엽니다.

가장 안정적인 주소 형식:

```text
https://chzzk.naver.com/live/...
https://chzzk.naver.com/video/...
```

업데이트는 `update-potplayer-ytdlp.cmd`, 설치 확인은 `check-potplayer-ytdlp.cmd`를 실행하면 됩니다.

### 설치되는 것

- `MediaPlayParse - yt-dlp.as`
- `yt-dlp_default.ini` 및 보조 파일
- 최신 `yt-dlp.exe`
- 치지직 시청용 기본값: `live_chat=0`, `reduce_formats=1`, `critical_error=0`
- 최신 `yt-dlp` 로그 순서 호환 패치
- Windows 줄바꿈 환경의 `yt-dlp` JSON 파싱 호환 패치
- Twitch Streamlink HLS/로컬 HTTP 주소 통과 패치
- 기존 파일 자동 백업

### 주의

- 이 도구는 치지직 전용 불법 우회 도구가 아닙니다. PotPlayer에 yt-dlp 기반 URL 해석 확장을 설치하는 도구입니다.
- 그리드 프로그램 없이 보는 대안이 될 수 있지만, 로그인, 성인 인증, 지역 제한, 사이트 정책 변경이 있으면 실패할 수 있습니다.
- "광고 없이 보기"는 PotPlayer로 직접 열 때 웹 플레이어 광고 화면이나 UI를 피할 수 있다는 뜻입니다. 모든 광고를 영구 차단한다고 보장하는 도구는 아닙니다.
- 방송 자체가 특정 화질까지만 제공하면 PotPlayer에서도 그 이상으로 올라가지 않습니다.
- Twitch 720p/source quality 문제는 별도 프로젝트를 사용하세요. 이 설치기는 해당 프로젝트의 Streamlink HLS/로컬 HTTP 주소를 yt-dlp 확장이 가로채지 않도록만 처리합니다.

### 설치 위치

일반적인 64비트 PotPlayer 기준:

```text
C:\Program Files\DAUM\PotPlayer\Extension\Media\PlayParse\MediaPlayParse - yt-dlp.as
C:\Program Files\DAUM\PotPlayer\Extension\Media\PlayParse\yt-dlp_default.ini
C:\Program Files\DAUM\PotPlayer\Module\yt-dlp.exe
C:\Users\<name>\AppData\Roaming\PotPlayerMini64\Extension\Media\PlayParse\yt-dlp.ini
```

## English

**Chzzk PotPlayer yt-dlp Installer** is a small Windows installer that lets PotPlayer open Chzzk, Naver, YouTube, and other `yt-dlp` supported URLs.

Instead of following old manual installation guides, download the ZIP and run `install-potplayer-ytdlp.cmd`. It installs or updates PotPlayer's yt-dlp media parser extension and the latest `yt-dlp.exe`.

### Requirements

| Item | Link |
| --- | --- |
| Latest release ZIP | [GitHub Releases](https://github.com/maniac428/chzzk-potplayer-ytdlp-installer/releases/latest) |
| PotPlayer 64-bit | [potplayer.tv](https://potplayer.tv/) |
| PotPlayer yt-dlp extension source | [hgcat-360/PotPlayer-Extension_yt-dlp](https://github.com/hgcat-360/PotPlayer-Extension_yt-dlp) |
| yt-dlp official release | [yt-dlp/yt-dlp releases](https://github.com/yt-dlp/yt-dlp/releases/latest) |

Avoid random mirror sites and unknown exe installers. The practical sweet spot is official PotPlayer 64-bit + official GitHub source files + this installer ZIP.

### Usage

1. Close PotPlayer.
2. Download and extract the latest release ZIP.
3. Run `install-potplayer-ytdlp.cmd`.
4. Allow the Windows administrator prompt.
5. Restart PotPlayer.
6. Open a Chzzk live or replay URL in PotPlayer.

Most reliable URL formats:

```text
https://chzzk.naver.com/live/...
https://chzzk.naver.com/video/...
```

Run `update-potplayer-ytdlp.cmd` to update, or `check-potplayer-ytdlp.cmd` to check the installation.

### What It Installs

- `MediaPlayParse - yt-dlp.as`
- `yt-dlp_default.ini` and helper files
- Latest `yt-dlp.exe`
- Chzzk viewing defaults: `live_chat=0`, `reduce_formats=1`, `critical_error=0`
- Compatibility patch for recent `yt-dlp` log ordering
- Compatibility patch for `yt-dlp` JSON parsing with Windows line endings
- Passthrough patch for Twitch Streamlink HLS/local HTTP URLs
- Automatic backup of existing files

### Notes

- This is not an illegal Chzzk bypass tool. It installs a yt-dlp based URL parser for PotPlayer.
- It can be a no-grid external-player alternative, but login, adult, region, or site policy restrictions may still fail.
- "No ads" means opening directly in PotPlayer may avoid web-player ad screens or UI in some setups. It is not a guaranteed permanent ad blocker.
- PotPlayer cannot exceed the quality actually provided by the stream.
- Use the separate Twitch project for Twitch 720p/source-quality issues. This installer only prevents PotPlayer's yt-dlp extension from intercepting that project's Streamlink HLS/local HTTP URLs.

## Sources

- PotPlayer yt-dlp extension: [hgcat-360/PotPlayer-Extension_yt-dlp](https://github.com/hgcat-360/PotPlayer-Extension_yt-dlp)
- yt-dlp official project: [yt-dlp/yt-dlp](https://github.com/yt-dlp/yt-dlp)
- yt-dlp supported sites: [supported sites](https://github.com/yt-dlp/yt-dlp/blob/master/supportedsites.md)

## Search Keywords / 검색 키워드

한국어: 치지직 팟플레이어, 치지직 고화질 팟플레이어, 치지직 광고 없이, 치지직 그리드 설치 없이, 치지직 링크 PotPlayer, 팟플레이어 yt-dlp, 치지직 yt-dlp, 네이버 치지직 PotPlayer, 유튜브 팟플레이어 링크 열기.

English: Chzzk PotPlayer, Chzzk high quality PotPlayer, Chzzk ad-free, Chzzk no grid, Chzzk link PotPlayer, PotPlayer yt-dlp, Chzzk yt-dlp, Naver Chzzk PotPlayer, YouTube PotPlayer URL.

## License

MIT
