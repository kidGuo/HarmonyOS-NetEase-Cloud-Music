/**
 * Author: Finn Guo
 * Date: 2026/1/17
 */

export class MusicUtil {
  static musicSourceUrl(songId: string): string {
    return `https://music.163.com/song/media/outer/url?id=${songId}.mp3`
  }

  static musicTimeFormatter(time: number) {
    if (time > 60 * 1000) {
      const s = Math.floor(time / 1000 % 60);
      const m = Math.floor(time / 1000 / 60);
      const second = s.toString().padStart(2, '0');
      const minute = m.toString().padStart(2, '0');
      return minute + ':' + second
    } else {
      const s = Math.floor(time / 1000 % 60);
      const second = s.toString().padStart(2, '0');
      return '00:' + second;
    }
  }
}