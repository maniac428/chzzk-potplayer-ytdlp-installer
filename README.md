# PotPlayer yt-dlp Chzzk Installer

치지직 팟플레이어, PotPlayer 치지직, 팟플레이어 yt-dlp, Chzzk PotPlayer, 치지직 링크 붙여넣기, 유튜브 팟플레이어 링크 열기.

**PotPlayer yt-dlp Chzzk Installer**는 오래된 수동 설치 글처럼 파일을 직접 찾아 넣는 대신, PotPlayer에 필요한 `yt-dlp` 재생 확장을 공식 GitHub에서 최신 파일로 설치하거나 업데이트하는 원클릭 도구입니다.

## 한국어

### 이게 하는 일

- PotPlayer의 `Extension\Media\PlayParse` 폴더에 `MediaPlayParse - yt-dlp.as` 확장을 설치합니다.
- PotPlayer의 `Module` 폴더에 최신 `yt-dlp.exe`를 설치합니다.
- 기존 파일은 `Backup_PotPlayer_yt-dlp_날짜` 폴더에 백업합니다.
- 설치 후 `chzzk:live`, `chzzk:video` 지원 여부를 확인합니다.

### 이런 사람에게 추천

- 치지직 링크를 PotPlayer에 붙여넣어서 보고 싶은 사람
- 예전 커뮤니티 글에 올라온 파일이 오래돼서 최신 치지직이 안 열리는 사람
- YouTube, 네이버, 기타 yt-dlp 지원 사이트 링크를 PotPlayer에서 열고 싶은 사람
- 랜덤 블로그/미러 파일 말고 공식 원본 기준으로 업데이트하고 싶은 사람

### 다운로드

초보자는 Releases에서 ZIP 파일을 받는 것을 권장합니다.

| 항목 | 링크 |
| --- | --- |
| 초보자용 ZIP | [potplayer-ytdlp-chzzk-installer-beginner.zip](https://github.com/maniac428/potplayer-ytdlp-chzzk-installer/releases/latest/download/potplayer-ytdlp-chzzk-installer-beginner.zip) |
| 전체 저장소 ZIP | [main.zip](https://github.com/maniac428/potplayer-ytdlp-chzzk-installer/archive/refs/heads/main.zip) |
| PotPlayer 공식 페이지 | [potplayer.tv](https://potplayer.tv/) |
| PotPlayer yt-dlp 확장 원본 | [hgcat-360/PotPlayer-Extension_yt-dlp](https://github.com/hgcat-360/PotPlayer-Extension_yt-dlp) |
| yt-dlp 공식 릴리스 | [yt-dlp/yt-dlp releases](https://github.com/yt-dlp/yt-dlp/releases/latest) |

### 사용법

1. PotPlayer를 종료합니다.
2. ZIP을 다운로드하고 압축을 풉니다.
3. `install-potplayer-ytdlp.cmd`를 실행합니다.
4. Windows 관리자 권한 요청이 뜨면 허용합니다.
5. 설치가 끝나면 PotPlayer를 다시 켭니다.
6. PotPlayer에서 치지직 라이브/다시보기 URL을 열어봅니다.

업데이트도 같습니다. `update-potplayer-ytdlp.cmd`를 실행하면 공식 최신 파일로 다시 덮어쓰고 기존 파일은 백업합니다.

설치 확인만 하고 싶으면 `check-potplayer-ytdlp.cmd`를 실행하세요.

### 중요한 오해 방지

- 이 도구는 치지직 전용 불법 우회 도구가 아닙니다. PotPlayer에 yt-dlp 기반 URL 해석 확장을 설치하는 도구입니다.
- 치지직 방송 자체가 낮은 화질이면 PotPlayer에서도 그 이상으로 올라가지 않습니다.
- 성인/로그인/지역 제한이 걸린 영상은 yt-dlp가 URL을 못 풀 수 있습니다.
- Twitch 720p/source quality 문제는 이 저장소의 목적이 아닙니다. Twitch 원본화질은 별도 방식이 필요합니다.
- exe 파일을 랜덤 사이트에서 받지 마세요. 이 설치기는 PotPlayer 확장 원본 저장소와 yt-dlp 공식 릴리스만 사용합니다.

### 설치되는 위치

일반적인 64비트 PotPlayer 기준:

```text
C:\Program Files\DAUM\PotPlayer\Extension\Media\PlayParse\MediaPlayParse - yt-dlp.as
C:\Program Files\DAUM\PotPlayer\Extension\Media\PlayParse\yt-dlp_default.ini
C:\Program Files\DAUM\PotPlayer\Module\yt-dlp.exe
```

### Sweet Spot

대부분의 한국 사용자에게는 **PotPlayer 64비트 + 이 설치기 + 최신 yt-dlp** 조합이 가장 단순합니다. Streamlink까지 얹는 방식은 버퍼 옵션을 세밀하게 만질 수 있지만, 치지직 링크 붙여넣기만 목적이면 관리 포인트가 늘어납니다.

## English

**PotPlayer yt-dlp Chzzk Installer** installs or updates PotPlayer's yt-dlp media parser extension from official GitHub sources.

It is useful when old manual installation guides ship outdated files and Chzzk, YouTube, Naver, or other yt-dlp-supported URLs no longer open correctly in PotPlayer.

### What It Installs

- `MediaPlayParse - yt-dlp.as` into PotPlayer's `Extension\Media\PlayParse` folder
- `yt-dlp_default.ini` and small helper assets
- Latest `yt-dlp.exe` into PotPlayer's `Module` folder
- A timestamped backup of existing files

### Usage

1. Close PotPlayer.
2. Download and extract the ZIP from Releases.
3. Run `install-potplayer-ytdlp.cmd`.
4. Allow the Windows administrator prompt.
5. Restart PotPlayer.
6. Open a Chzzk, YouTube, Naver, or other supported URL in PotPlayer.

### Notes

- This is not a Twitch 720p/source-quality bypass.
- Login, adult, or region-restricted content may still fail.
- The installer downloads only from official GitHub sources.

## Sources

- PotPlayer yt-dlp extension: [hgcat-360/PotPlayer-Extension_yt-dlp](https://github.com/hgcat-360/PotPlayer-Extension_yt-dlp)
- yt-dlp official project: [yt-dlp/yt-dlp](https://github.com/yt-dlp/yt-dlp)
- yt-dlp supported sites: [supported sites](https://github.com/yt-dlp/yt-dlp/blob/master/supportedsites.md)

## License

MIT
