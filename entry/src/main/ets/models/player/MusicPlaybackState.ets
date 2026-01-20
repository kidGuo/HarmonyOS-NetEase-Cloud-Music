/**
 * Author: Finn Guo
 * Date: 2026/1/17
 */
import { SongItem } from '../home/SongItem';

@ObservedV2
export class MusicPlaybackState {
  @Trace cover: string = ''; // 音乐封面
  @Trace name: string = ''; // 音乐名称
  @Trace author: string = ''; // 作者
  @Trace url: string = ''; // 歌曲url
  @Trace time: number = 0; // 播放时长
  @Trace duration: number = 0; // 歌曲时长
  @Trace playbackMode: '顺序播放' | '单曲循环' | '随机播放' = '顺序播放';
  @Trace isPlaying: boolean = false;
  @Trace isPlayed: boolean = false;
  @Trace isLoading: boolean = false;
  @Trace currentIndex: number = -1;
  // 播放列表
  @Trace playlist: SongItem[] = [];

  @Computed
  get currentSongId(): number {
    if (this.currentIndex >= 0 && this.currentIndex < this.playlist.length) {
      return this.playlist[this.currentIndex].id;
    }
    return -1;
  }
}