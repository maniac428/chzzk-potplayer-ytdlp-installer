# 치지직 팟플레이어 yt-dlp 설치기

치지직, 유튜브, 네이버, 기타 `yt-dlp` 지원 링크를 PotPlayer에서 열 수 있도록 PotPlayer용 `yt-dlp` 재생 확장을 설치/업데이트하는 Windows용 도구입니다.

관련 프로젝트:

- 치지직 PotPlayer yt-dlp 설치기: [chzzk-potplayer-ytdlp-installer](https://github.com/maniac428/chzzk-potplayer-ytdlp-installer)
- Twitch PotPlayer 720p Fix: [twitch-potplayer-720p-fix](https://github.com/maniac428/twitch-potplayer-720p-fix)

## 이런 사람에게 추천

- 치지직 링크를 PotPlayer에 붙여넣어 보고 싶은 사람
- 브라우저 플레이어 대신 외부 플레이어로 보고 싶은 사람
- 별도 고화질/그리드 프로그램 설치가 부담스러운 사람
- 브라우저 광고 화면이나 플레이어 UI 없이 PotPlayer에서 보고 싶은 사람
- 오래된 커뮤니티 글의 수동 설치 파일 대신 최신 `yt-dlp` 기반 파일을 쓰고 싶은 사람

## 설치되는 것

- PotPlayer `Extension\Media\PlayParse` 폴더에 `MediaPlayParse - yt-dlp.as` 설치
- PotPlayer `Module` 폴더에 최신 `yt-dlp.exe` 설치
- PotPlayer 사용자 설정 `yt-dlp.ini`에 시청용 기본값 적용: `live_chat=0`, `reduce_formats=1`
- 기존 파일은 `Backup_PotPlayer_yt-dlp_날짜` 폴더에 자동 백업
- 설치 후 `chzzk:live`, `chzzk:video` 지원 여부 확인

## 장점

- 공식 GitHub 원본에서 최신 파일을 받습니다.
- 설치, 업데이트, 확인을 각각 `.cmd` 파일 하나로 처리합니다.
- 기존 파일을 자동 백업하므로 문제가 생겼을 때 되돌리기 쉽습니다.
- 치지직뿐 아니라 YouTube, Naver 등 yt-dlp 지원 사이트에도 활용할 수 있습니다.

## 다운로드

초보자는 Releases에서 ZIP 파일을 받는 것을 권장합니다.

| 항목 | 링크 |
| --- | --- |
| 초보자용 ZIP | [chzzk-potplayer-ytdlp-installer-beginner.zip](https://github.com/maniac428/chzzk-potplayer-ytdlp-installer/releases/latest/download/chzzk-potplayer-ytdlp-installer-beginner.zip) |
| 전체 저장소 ZIP | [main.zip](https://github.com/maniac428/chzzk-potplayer-ytdlp-installer/archive/refs/heads/main.zip) |
| PotPlayer 공식 페이지 | [potplayer.tv](https://potplayer.tv/) |
| PotPlayer yt-dlp 확장 원본 | [hgcat-360/PotPlayer-Extension_yt-dlp](https://github.com/hgcat-360/PotPlayer-Extension_yt-dlp) |
| yt-dlp 공식 릴리스 | [yt-dlp/yt-dlp releases](https://github.com/yt-dlp/yt-dlp/releases/latest) |

## 사용법

1. PotPlayer를 종료합니다.
2. ZIP을 다운로드하고 압축을 풉니다.
3. `install-potplayer-ytdlp.cmd`를 실행합니다.
4. Windows 관리자 권한 요청이 뜨면 허용합니다.
5. 설치가 끝나면 PotPlayer를 다시 켭니다.
6. PotPlayer에서 치지직 라이브/다시보기 URL을 열어봅니다.

가장 안정적인 방식은 주소창의 `https://chzzk.naver.com/live/...` 또는 `https://chzzk.naver.com/video/...` URL을 PotPlayer에서 직접 여는 것입니다.

업데이트는 `update-potplayer-ytdlp.cmd`를 실행하면 됩니다. 최신 파일로 다시 받아오고 기존 파일은 백업합니다.

설치 확인만 하고 싶으면 `check-potplayer-ytdlp.cmd`를 실행하세요.

설치기는 치지직 시청용으로 `live_chat=0`, `reduce_formats=1`을 자동 적용합니다. 라이브 채팅용 WebView2를 같이 띄우지 않고, 품질 후보 메뉴를 줄여 PotPlayer가 더 가볍게 열리도록 하기 위한 설정입니다.

## 중요한 오해 방지

- 이 도구는 치지직 전용 불법 우회 도구가 아닙니다. PotPlayer에 yt-dlp 기반 URL 해석 확장을 설치하는 도구입니다.
- “그리드 프로그램 없이 보기”는 PotPlayer에서 yt-dlp가 링크를 정상 해석할 때 가능한 대안입니다. 로그인, 성인 인증, 지역 제한, 사이트 정책 변경이 있으면 실패할 수 있습니다.
- “광고 없이 보기”는 브라우저 플레이어 대신 PotPlayer로 열었을 때 광고 화면이나 웹 플레이어 UI가 나오지 않는 경우를 설명하는 것입니다. 플랫폼의 서버 삽입 광고, 정책 변경, 재생 방식 변경까지 영구적으로 막는 광고 차단 도구가 아닙니다.
- 치지직 방송 자체가 특정 화질까지만 제공하면 PotPlayer에서도 그 이상으로 올라가지 않습니다.
- Twitch 720p/source quality 문제 해결용 저장소가 아닙니다. Twitch 원본화질은 별도 방식이 필요합니다.
- 출처 불명의 exe 설치기를 피하고 싶다면 이 저장소처럼 원본 저장소와 공식 yt-dlp 릴리스 기준으로 설치하는 편이 안전합니다.

## 설치 위치

일반적인 64비트 PotPlayer 기준:

```text
C:\Program Files\DAUM\PotPlayer\Extension\Media\PlayParse\MediaPlayParse - yt-dlp.as
C:\Program Files\DAUM\PotPlayer\Extension\Media\PlayParse\yt-dlp_default.ini
C:\Program Files\DAUM\PotPlayer\Module\yt-dlp.exe
C:\Users\<name>\AppData\Roaming\PotPlayerMini64\Extension\Media\PlayParse\yt-dlp.ini
```

## Sweet Spot

대부분의 한국 사용자에게는 **PotPlayer 64비트 + 이 설치기 + 최신 yt-dlp** 조합이 가장 단순합니다. Streamlink나 별도 브릿지까지 얹는 방식은 버퍼/관리 포인트가 늘어날 수 있으므로, 치지직 링크를 PotPlayer로 여는 목적이라면 이 조합부터 시도하는 것이 비용 대비 효율이 좋습니다.

## English

**PotPlayer yt-dlp Chzzk Installer** installs or updates PotPlayer's yt-dlp media parser extension from official GitHub sources.

It is useful when old manual installation guides ship outdated files and Chzzk, YouTube, Naver, or other yt-dlp-supported URLs no longer open correctly in PotPlayer. For Korean Chzzk users, it can also be a simple external-player alternative when they do not want to install a separate browser high-quality/grid program or prefer watching outside the browser player.

### What It Installs

- `MediaPlayParse - yt-dlp.as` into PotPlayer's `Extension\Media\PlayParse` folder
- `yt-dlp_default.ini` and helper assets
- Latest `yt-dlp.exe` into PotPlayer's `Module` folder
- Viewing defaults in the PotPlayer user config: `live_chat=0`, `reduce_formats=1`
- A timestamped backup of existing files

### Usage

1. Close PotPlayer.
2. Download and extract the ZIP from Releases.
3. Run `install-potplayer-ytdlp.cmd`.
4. Allow the Windows administrator prompt.
5. Restart PotPlayer.
6. Open a Chzzk, YouTube, Naver, or other supported URL in PotPlayer.

For the most reliable flow, open the actual Chzzk page URL, such as `https://chzzk.naver.com/live/...` or `https://chzzk.naver.com/video/...`, directly in PotPlayer.

The installer applies `live_chat=0` and `reduce_formats=1` for Chzzk viewing. This avoids opening the live-chat WebView2 path and keeps the PotPlayer quality menu lighter.

### Notes

- This is not a Twitch 720p/source-quality bypass.
- This is not a guaranteed permanent ad blocker. It sets up PotPlayer playback through yt-dlp-supported URLs.
- Login, adult, or region-restricted content may still fail.
- The installer downloads only from official GitHub sources.

## Sources

- PotPlayer yt-dlp extension: [hgcat-360/PotPlayer-Extension_yt-dlp](https://github.com/hgcat-360/PotPlayer-Extension_yt-dlp)
- yt-dlp official project: [yt-dlp/yt-dlp](https://github.com/yt-dlp/yt-dlp)
- yt-dlp supported sites: [supported sites](https://github.com/yt-dlp/yt-dlp/blob/master/supportedsites.md)

## Search Keywords / 검색 키워드

한국어: 치지직 팟플레이어, 치지직 고화질 팟플레이어, 치지직 광고 없이, 치지직 그리드 설치 없이, 치지직 링크 PotPlayer, 팟플레이어 yt-dlp, 치지직 yt-dlp, 네이버 치지직 PotPlayer, 유튜브 팟플레이어 링크 열기.

English: Chzzk PotPlayer, Chzzk high quality PotPlayer, Chzzk ad-free, Chzzk no grid, Chzzk link PotPlayer, PotPlayer yt-dlp, Chzzk yt-dlp, Naver Chzzk PotPlayer, YouTube PotPlayer URL.

## License

MIT
