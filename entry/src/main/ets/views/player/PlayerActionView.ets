/**
 * Author: Finn Guo
 * Date: 2026/1/17
 */
import { SongItem } from '../../models/home/SongItem';
import { MusicPlaybackState } from '../../models/player/MusicPlaybackState';
import { MusicUtil } from '../../utils/MusicUtil';
import { AppStorageV2 } from '@kit.ArkUI';

@Preview
@ComponentV2
export struct PlayerActionView {
  @Param songItem: SongItem | undefined = undefined;
  @Event actionCallback: (type: 'play' | 'pause' | 'prev' | 'next' | 'seek', value?: number) => void;
  // 进度条拖动状态锁，防止拖动时由于 timeUpdate 导致进度条跳动
  @Local isDragging: boolean = false;
  @Local dragValue: number = 0;
  playbackState: MusicPlaybackState =
    AppStorageV2.connect(MusicPlaybackState, 'MusicPlaybackState', () => new MusicPlaybackState())!

  build() {
    Column() {
      Slider({
        value: this.isDragging ? this.dragValue : this.playbackState.time,
        style: SliderStyle.OutSet,
        min: 0,
        max: this.playbackState.duration > 0 ? this.playbackState.duration : (this.songItem?.duration ?? 0)
      })
        .selectedColor('#FFFFFF')
        .trackColor('#80FFFFFF')
        .blockColor(Color.White)
        .blockSize({ width: 10, height: 10 })
        .margin({ left: 12, right: 12 })
        .onChange((value: number, mode: SliderChangeMode) => {
          if (mode === SliderChangeMode.Begin || mode === SliderChangeMode.Moving) {
            this.isDragging = true;
            this.dragValue = value;
          } else {
            this.isDragging = false;
            this.actionCallback('seek', value);
          }
        })

      Row() {
        Text(MusicUtil.musicTimeFormatter(this.isDragging ? this.dragValue : this.playbackState.time))
          .fontColor('#F2F2F2')
          .fontSize(10)
        Text(MusicUtil.musicTimeFormatter(this.songItem?.duration ?? 0))
          .fontColor('#F2F2F2')
          .fontSize(10)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ left: 16, right: 16 })
      .width('100%')

      Row() {
        this.controlButtonBuilder($r('app.media.white_pre_song'), () => this.actionCallback('prev'))
        Blank()
          .width(20)

        Image(this.playbackState.isPlaying ? $r('app.media.white_pause') : $r('app.media.white_play'))
          .size({ width: 44, height: 44 })
          .clickEffect({ level: ClickEffectLevel.LIGHT })
          .onClick(() => {
            this.actionCallback(this.playbackState.isPlaying ? 'pause' : 'play')
          })

        Blank()
          .width(20)
        this.controlButtonBuilder($r('app.media.white_next_song'), () => this.actionCallback('next'))
      }
      .justifyContent(FlexAlign.Center)
      .margin({ top: 20 })
      .width('100%')
    }
  }

  @Builder
  controlButtonBuilder(src: ResourceStr, onClick: () => void) {
    Image(src)
      .size({ width: 44, height: 44 })
      .padding(10)
      .clickEffect({ level: ClickEffectLevel.LIGHT })
      .onClick(onClick)
  }
}