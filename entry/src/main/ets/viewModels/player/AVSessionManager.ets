/**
 * Author: Finn Guo
 * Date: 2026/1/17
 */
import { avSession } from '@kit.AVSessionKit';
import { MusicPlaybackState } from '../../models/player/MusicPlaybackState';
import { AppStorageV2 } from '@kit.ArkUI';
import { Logger } from '../../utils/Logger';
import { JSON } from '@kit.ArkTS';
import { SongItem } from '../../models/home/SongItem';
import { playerController } from './MusicPlayerController';
import { common, wantAgent } from '@kit.AbilityKit';
import backgroundTaskManager from '@ohos.resourceschedule.backgroundTaskManager';

export class AVSessionManager {
  session: avSession.AVSession | undefined;
  private context: common.UIAbilityContext | undefined;
  playbackState: MusicPlaybackState =
    AppStorageV2.connect(MusicPlaybackState, 'MusicPlaybackState', () => new MusicPlaybackState())!

  async init(context: common.UIAbilityContext) {
    this.context = context;
    try {
      this.session = await avSession.createAVSession(context, 'musicPlayer', 'audio');
      await this.session.activate();
      this.registerControlCommands();
    } catch (error) {
      Logger.info({ domain: 'AVSession' }, `init error:${JSON.stringify(error)}`);
    }
  }

  registerControlCommands() {
    if (!this.session) {
      Logger.error({ domain: 'AVSession' }, 'Session is null, cannot register commands');
      return;
    }

    try {
      this.session.on('play', () => this.handleCommand('play'));
      this.session.on('pause', () => this.handleCommand('pause'));
      this.session.on('playPrevious', () => this.handleCommand('playPrevious'))
      this.session.on('playNext', () => this.handleCommand('playNext'))
      this.session.on('seek', (time: number) => this.handleCommand('seek', time))
    } catch (error) {
      Logger.error({ domain: 'AVSession' }, `Failed to register commands: ${JSON.stringify(error)}`);
    }
  }

  private async handleCommand(command: string, extra?: number) {
    Logger.info({ domain: 'AVSession' }, `Received command from system: [${command}]`);
    try {
      switch (command) {
        case 'play':
          playerController.play();
          break;
        case 'pause':
          playerController.pause();
          break;
        case 'playNext':
          playerController.playNext(true);
          break;
        case 'playPrevious':
          playerController.playPrevious();
          break;
        case 'seek':
          const time = extra as number;
          if (time) {
            playerController.seek(time);
          }
          break;
      }
    } catch (error) {
      Logger.error({ domain: 'AVSession' }, `Execute ${command} error: ${JSON.stringify(error)}`);
    }
  }

  async startBackgroundTask() {
    if (!this.context) {
      return;
    }

    let wantInfo: wantAgent.WantAgentInfo = {
      wants: [
        {
          bundleName: this.context.abilityInfo.bundleName,
          abilityName: this.context.abilityInfo.name
        }
      ],
      actionType: wantAgent.OperationType.START_ABILITY,
      requestCode: 100,
      actionFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
    }
    try {
      const want = await wantAgent.getWantAgent(wantInfo);
      await backgroundTaskManager.startBackgroundRunning(this.context,
        backgroundTaskManager.BackgroundMode.AUDIO_PLAYBACK, want);
      Logger.info({ domain: 'AVSession' }, 'Background task started successfully');
    } catch (error) {
      Logger.error({ domain: 'AVSession' }, `Start background task error: ${JSON.stringify(error)}`);
    }
  }

  async stopBackgroundTask() {
    if (!this.context) {
      return;
    }
    try {
      await backgroundTaskManager.stopBackgroundRunning(this.context);
    } catch (error) {
      Logger.error({ domain: 'AVSession' }, `Stop background task error: ${JSON.stringify(error)}`);
    }
  }

  setMetaData(song: SongItem) {
    if (!this.session) {
      return;
    }
    this.session.setAVMetadata({
      assetId: song.id.toString(),
      title: song.name,
      mediaImage: song.album.picUrl,
      artist: song.artists.map((item) => item.name).join('/'),
      duration: this.playbackState.duration
    })
      .catch((error: Error) => {
        Logger.info({ domain: 'AVSession' }, `set meta data error:${JSON.stringify(error)}`);
      })
  }

  setPlaybackStatus() {
    if (!this.session) {
      return;
    }
    this.session.setAVPlaybackState({
      state: this.playbackState.isPlaying ? avSession.PlaybackState.PLAYBACK_STATE_PLAY :
        avSession.PlaybackState.PLAYBACK_STATE_PAUSE,
      speed: 1,
      position: { elapsedTime: this.playbackState.time, updateTime: Date.now() },
      duration: this.playbackState.duration
    })
      .catch((error: Error) => {
        Logger.info({ domain: 'AVSession' }, `set playback state error:${JSON.stringify(error)}`);
      })
  }

  async destroy() {
    await this.stopBackgroundTask();
    await this.session?.destroy().catch((error: Error) => {
      Logger.info({ domain: 'AVSession' }, `Destroy error:${JSON.stringify(error)}`);
    });
    this.session = undefined;
  }
}

export const sessionManager: AVSessionManager = new AVSessionManager();