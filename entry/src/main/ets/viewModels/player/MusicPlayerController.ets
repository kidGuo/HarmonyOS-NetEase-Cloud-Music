/**
 * Author: Finn Guo
 * Date: 2026/1/17
 */
import { AppStorageV2 } from '@kit.ArkUI';
import { MusicPlaybackState } from '../../models/player/MusicPlaybackState';
import { media } from '@kit.MediaKit';
import { Logger } from '../../utils/Logger';
import { sessionManager } from './AVSessionManager';
import { JSON } from '@kit.ArkTS';
import { MusicUtil } from '../../utils/MusicUtil';
import { SongItem } from '../../models/home/SongItem';

class MusicPlayerController {
  playbackState: MusicPlaybackState =
    AppStorageV2.connect(MusicPlaybackState, 'MusicPlaybackState', () => new MusicPlaybackState())!
  mPlayer: media.AVPlayer | null = null;

  async init() {
    if (this.mPlayer) {
      return;
    }

    try {
      this.mPlayer = await media.createAVPlayer();
      this.setupEvents();
      Logger.info({ domain: 'Playback' }, `Player created, current state: ${this.mPlayer.state}`);
    } catch (error) {
      Logger.error({ domain: 'Playback' }, `Init failed: ${JSON.stringify(error)}`);
    }
  }

  private setupEvents() {
    if (!this.mPlayer) {
      return;
    }

    this.mPlayer.on('stateChange', (state: string) => {
      Logger.info({ domain: 'Playback' }, 'on state change:', state);
      switch (state) {
        case 'initialized':
          this.mPlayer?.prepare().catch((error: Error) => {
            Logger.error({ domain: 'Playback' }, `avplayer prepare error:${JSON.stringify(error)}`);
          });
          break;
        case 'prepared':
          this.playbackState.isLoading = false;
          this.mPlayer?.play().catch((error: Error) => {
            Logger.error({ domain: 'Playback' }, `avplayer play error:${JSON.stringify(error)}`);
          });
          break;
        case 'playing':
          this.playbackState.isPlaying = true;
          this.playbackState.isPlayed = true;
          sessionManager.startBackgroundTask();
          sessionManager.setPlaybackStatus();
          break;
        case 'paused':
          this.playbackState.isPlaying = false;
          sessionManager.setPlaybackStatus();
          break;
        case 'completed':
          this.playNext(true);
          break;
        case 'error':
          this.playbackState.isPlaying = false;
          this.playbackState.isLoading = false;
          break;
      }
    });

    this.mPlayer.on('timeUpdate', (time: number) => {
      Logger.info({ domain: 'Playback' }, `On time update: ${time}`);
      this.playbackState.time = time;
      sessionManager.setPlaybackStatus();
    });

    this.mPlayer.on('durationUpdate', (duration: number) => {
      Logger.info({ domain: 'Playback' }, `On duration update: ${duration}`);
      this.playbackState.duration = duration;
      const songItem = this.playbackState.playlist[this.playbackState.currentIndex];
      if (songItem) {
        sessionManager.setMetaData(songItem)
      }
    })

    this.mPlayer.on('seekDone', (seekDoneTime: number) => {
      Logger.info({ domain: 'Playback' }, `On seek done at: ${seekDoneTime}`);
      sessionManager.setPlaybackStatus();
    })

    this.mPlayer.on('error', (error) => {
      Logger.error({ domain: 'Playback' }, `On avplayer error:${JSON.stringify(error)}`);
    });
  }

  /**
   * 核心：加载并播放
   */
  async loadSong(index: number) {
    if (index < 0 || index >= this.playbackState.playlist.length) {
      return;
    }
    if (!this.mPlayer) {
      return;
    }

    try {
      // 先重置
      await this.mPlayer.reset();

      this.playbackState.currentIndex = index;
      const song = this.playbackState.playlist[index];
      this.playbackState.cover = song.album.picUrl;
      this.playbackState.name = song.name || '云音乐';
      this.playbackState.author = song.artists.map((item) => item.name).join('/');
      this.playbackState.time = 0;
      this.playbackState.isLoading = true;
      this.mPlayer.url = MusicUtil.musicSourceUrl(song.id.toString());

    } catch (error) {
      Logger.error({ domain: 'Playback' }, `loadSong error: ${JSON.stringify(error)}`);
      this.playbackState.isLoading = false;
    }
  }

  async seek(time: number) {
    if (!this.mPlayer) {
      return;
    }

    const targetTime = Math.max(0, Math.min(time, this.playbackState.duration));
    try {
      this.mPlayer.seek(targetTime, media.SeekMode.SEEK_PREV_SYNC);
      this.playbackState.time = targetTime;
      Logger.info({ domain: 'Playback' }, `Seek to: ${targetTime}`);
    } catch (error) {
      Logger.error({ domain: 'Playback' }, `Seek error: ${JSON.stringify(error)}`);
    }
  }

  // 下一首
  playNext(isAuto: boolean = false) {
    if (this.playbackState.playlist.length === 0) {
      return;
    }

    if (isAuto && this.playbackState.playbackMode === '单曲循环') {
      this.loadSong(this.playbackState.currentIndex);
      return;
    }

    let nextIndex = 0;
    if (this.playbackState.playbackMode === '随机播放') {
      nextIndex = Math.floor(Math.random() * this.playbackState.playlist.length);
    } else {
      nextIndex = (this.playbackState.currentIndex + 1) % this.playbackState.playlist.length;
    }
    this.loadSong(nextIndex)
  }

  // 上一首
  playPrevious() {
    if (this.playbackState.playlist.length === 0) {
      return;
    }

    let preIndex = 0;
    if (this.playbackState.playbackMode === '随机播放') {
      preIndex = Math.floor(Math.random() * this.playbackState.playlist.length);
    } else {
      preIndex =
        (this.playbackState.currentIndex - 1 + this.playbackState.playlist.length) % this.playbackState.playlist.length;
    }
    this.loadSong(preIndex);
  }

  togglePlay() {
    if (!this.mPlayer) {
      return;
    }

    const state = this.mPlayer.state;
    Logger.info({ domain: 'Playback' }, `togglePlay, current state: ${state}`)
    try {
      if (state === 'playing') {
        this.mPlayer.pause().catch((error: Error) => {
          Logger.error({ domain: 'Playback' }, `togglePlay, pause error: ${JSON.stringify(error)}`);
        });
      } else if (state === 'paused' || state === 'prepared' || state === 'completed') {
        this.mPlayer.play().catch((error: Error) => {
          Logger.error({ domain: 'Playback' }, `togglePlay, play error: ${JSON.stringify(error)}`);
        });
      }
    } catch (e) {
      Logger.error({ domain: 'Playback' }, `togglePlay failed at state: ${state}`);
    }
  }

  play() {
    if (this.mPlayer?.state === 'paused' || this.mPlayer?.state === 'prepared') {
      this.mPlayer.play().catch((error: Error) => {
        Logger.error({ domain: 'Playback' }, `Play failed at state: ${JSON.stringify(error)}`);
      });
    }
  }

  pause() {
    if (this.mPlayer?.state === 'playing') {
      this.mPlayer.pause().catch((error: Error) => {
        Logger.error({ domain: 'Playback' }, `Pause failed at state: ${JSON.stringify(error)}`);
      });
    }
  }

  destroy() {
    if (!this.mPlayer) {
      return;
    }

    this.mPlayer.release()
      .then(() => {
        this.mPlayer = null;
        Logger.error({ domain: 'Playback' }, 'avplayer release');
      }).catch((error: Error) => {
      Logger.error({ domain: 'Playback' }, `avplayer release error:${JSON.stringify(error)}`);
    })
  }

  /**
   * 添加歌曲并立即播放
   */
  async addAndPlay(song: SongItem) {
    const index = this.playbackState.playlist.findIndex((item: SongItem) => item.id === song.id);
    if (index != -1) {
      this.loadSong(index);
    } else {
      // 插入当前播放下一曲
      const insertPos = this.playbackState.currentIndex + 1;
      this.playbackState.playlist.splice(insertPos, 0, song);
      this.loadSong(insertPos);
    }
  }

  async addSongsToEnd(songs: SongItem[], isPlayNow: boolean = false) {
    if (!songs || songs.length === 0) {
      return;
    }

    const filteredSongs =
      songs.filter(newSong => !this.playbackState.playlist.some(existingSong => existingSong.id === newSong.id));

    if (filteredSongs.length === 0) {
      Logger.info({ domain: 'Playback' }, '所有歌曲已在列表中，找第一首的位置播一下');
      if (isPlayNow) {
        const firstIdx = this.playbackState.playlist.findIndex(s => s.id === songs[0].id);
        await this.loadSong(firstIdx);
      }
      return;
    }

    const oldLength = this.playbackState.playlist.length;
    //
    this.playbackState.playlist.push(...filteredSongs);
    Logger.info({ domain: 'Playback' }, `成功添加 ${filteredSongs.length} 首歌曲到末尾`);

    //
    if (isPlayNow) {
      await this.loadSong(oldLength);
    }
  }

  /**
   * 删除歌曲
   */
  async removeSong(songId: number) {
    const list = this.playbackState.playlist;
    if (list.length === 0) {
      return;
    }
    const index = list.findIndex((item: SongItem) => item.id === songId);
    if (index === -1) {
      return;
    }

    if (index === this.playbackState.currentIndex) {
      // 删除当前
      const wasPlaying = this.playbackState.isPlaying;
      list.splice(index, 1);

      if (list.length > 0) {
        if (wasPlaying) {
          await this.loadSong(index);
        } else {
          this.updateMetadataOnly(index);
          await this.mPlayer?.reset().catch((error: Error) => {
            Logger.error({ domain: 'Playback' }, `remove song, avplayer reset error:${JSON.stringify(error)}`);
          });
        }
      } else {
        this.clearAllStates();
      }
    } else {
      //
      if (index < this.playbackState.currentIndex) {
        this.playbackState.currentIndex--;
      }
      this.playbackState.playlist.splice(index, 1);
    }
  }

  async removeAllSongs() {
    this.playbackState.playlist = [];
    await this.clearAllStates();
  }

  private updateMetadataOnly(index: number) {
    this.playbackState.currentIndex = index;
    const song = this.playbackState.playlist[index];
    this.playbackState.name = song.name;
    this.playbackState.cover = 'song.cover';
    this.playbackState.author = 'song.author';
    this.playbackState.time = 0;
    this.playbackState.duration = 0;
  }

  private async clearAllStates() {
    this.playbackState.currentIndex = 0;
    this.playbackState.name = '';
    this.playbackState.cover = '';
    this.playbackState.author = '';
    this.playbackState.time = 0;
    this.playbackState.duration = 0;
    this.playbackState.isPlaying = false;
    this.playbackState.isLoading = false;
    await this.mPlayer?.reset().catch((error: Error) => {
      Logger.error({ domain: 'Playback' }, `clear all states, avplayer reset error:${JSON.stringify(error)}`);
    });
  }
}

export const playerController = new MusicPlayerController();