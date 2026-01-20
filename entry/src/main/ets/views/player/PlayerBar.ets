/**
 * Author: Finn Guo
 * Date: 2026/1/17
 */
import { MusicPlaybackState } from '../../models/player/MusicPlaybackState';
import { AppStorageV2 } from '@kit.ArkUI';
import { playerController } from '../../viewModels/player/MusicPlayerController';
import { SongItem } from '../../models/home/SongItem';

@ComponentV2
export struct PlayerBar {
  playbackSate: MusicPlaybackState =
    AppStorageV2.connect(MusicPlaybackState, 'MusicPlaybackState', () => new MusicPlaybackState())!
  @Local isSheetShow: boolean = false;
  @Local rotateAngle: number = 0
  private timer: number = -1

  @Monitor("playbackSate.isPlaying")
  onPlayStatusChange(monitor: IMonitor) {
    if (this.playbackSate.isPlaying) {
      this.startRotation()
    } else {
      this.stopRotation()
    }
  }

  aboutToAppear(): void {
    if (this.playbackSate.isPlaying) {
      this.startRotation();
    } else {
      this.stopRotation();
    }
  }

  aboutToDisappear(): void {
    this.stopRotation();
  }

  startRotation() {
    this.stopRotation();
    this.timer = setInterval(() => {
      this.rotateAngle += 2
    }, 150)
  }

  stopRotation() {
    if (this.timer !== -1) {
      clearInterval(this.timer);
      this.timer = -1;
    }
  }

  build() {
    Column() {
      Row() {
        Column() {
          Image(this.playbackSate.cover)
            .margin(8)
            .borderRadius('50%')
            .clip(true)
        }
        .justifyContent(FlexAlign.Center)
        .height(46)
        .aspectRatio(1)
        .backgroundColor(Color.Black)
        .borderRadius(23)
        .clip(true)
        .rotate({ angle: this.rotateAngle })
        .animation({
          duration: 150,
          curve: Curve.Linear,
          iterations: 1
        })

        Row() {
          Text() {
            Span(this.playbackSate.name)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)

            Span(' - ' + this.playbackSate.author)
              .fontSize(18)
              .fontColor('#8E8E93')
          }
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.MARQUEE })
          .marqueeOptions({
            start: this.playbackSate.isPlaying ? true : false,
            loop: -1,
            step: 2,
            delay: 500
          })
        }
        .margin({ left: 12 })
        .height('100%')
        .layoutWeight(1)

        Row() {
          Stack({ alignContent: Alignment.Center }) {
            Progress({
              value: this.playbackSate.time,
              total: this.playbackSate.duration,
              type: ProgressType.Ring
            })
              .color(Color.Black)
              .backgroundColor('#D8D8D8')
              .width('100%')
              .style({
                strokeWidth: 2
              })
              .aspectRatio(1)

            Image(this.playbackSate.isPlaying ? $r('app.media.dark_pause_icon') :
              $r('app.media.dark_play_icon'))
              .size({ width: 30, height: 30 })
              .padding(this.playbackSate.isPlaying ? 6 : 4)
          }
          .size({ width: 32, height: 32 })
          .onClick(() => {
            playerController.togglePlay();
          })

          Blank()
            .width(8)

          Image($r('app.media.cm8_btn_tabbar_playlist_Normal'))
            .size({ width: 32, height: 32 })
            .onClick(() => {
              this.isSheetShow = true;
            })
            .bindSheet($$this.isSheetShow, this.sheetContentBuilder(), {
              showClose: false,
              height: this.playbackSate.playlist.length > 8 ? '70%' : (this.playbackSate.playlist.length + 2) * 60,
              dragBar: true,
              backgroundColor: Color.White,
              maskColor: '#80000000',
              title: this.sheetTitleBuilder(),
              onDisappear: () => {
                this.isSheetShow = false;
              }
            })
        }
        .margin({ left: 4 })
      }
      .backgroundColor(Color.White)
      .padding({ right: 20 })
      .margin({ left: 12, right: 12 })
      .borderRadius(24)
      .clip(true)
    }
    .linearGradient({
      angle: 0,
      colors: [
        ['#F2F2F2', 0.0],
        ['#00F2F2F2', 1.0]
      ]
    })
    .shadow({
      radius: 10,
      color: '#10000000',
      offsetX: 1,
      offsetY: 2
    })
    .backgroundBlurStyle(BlurStyle.Thin)
    .width('100%')
    .height(48)
  }

  @Builder
  sheetTitleBuilder() {
    Row() {
      Stack({ alignContent: Alignment.Bottom }) {
        Text('当前播放')
          .fontSize(18)
          .fontColor(Color.Black)
          .height('100%')
          .textAlign(TextAlign.Center)
          .padding({ top: 8 })

        Rect()
          .width('100%')
          .height(2)
          .fill(Color.Black)
          .padding({ left: 10, right: 10 })
      }
      .width(100)
      .margin({ right: 8 })
      .height('100%')

      Text('历史播放')
        .fontSize(18)
        .fontColor('#8E8E93')
        .height('100%')
        .textAlign(TextAlign.Center)
        .padding({ top: 8 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
    .border({ width: { bottom: 1 }, color: '#F2F2F2' })
  }

  @Builder
  sheetContentBuilder() {
    List() {
      ForEach(this.playbackSate.playlist, (item: SongItem, index: number) => {
        ListItem() {
          Row() {
            Row() {
              Text(item.name)
                .fontColor(this.playbackSate.currentSongId === item.id ? Color.Red : Color.Black)
                .fontSize(16)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .flexShrink(0)
                .maxLines(1)
              Text(' • ' + this.getAuthorsName(item))
                .fontColor(this.playbackSate.currentSongId === item.id ? Color.Red : '#8E8E93')
                .fontSize(14)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .flexShrink(1)
                .maxLines(1)
            }
            .height('100%')
            .layoutWeight(1)

            Image($r('app.media.cm5_empty_recommend_delete_Normal'))
              .size({ width: 20, height: 20 })
              .flexShrink(0)
              .margin(10)
              .onClick(() => {
                playerController.removeSong(item.id);
              })
          }
          .backgroundColor(this.playbackSate.currentSongId === item.id ? '#F2F2F2' : Color.White)
          .width('100%')
          .height(60)
          .padding({ left: 20, right: 10 })
          .justifyContent(FlexAlign.SpaceBetween)
          .onClick(() => {
            playerController.loadSong(index);
          })
        }
      }, (item: SongItem) => item.id.toString())
    }
    .backgroundColor(Color.White)
    .cachedCount(5)
    .edgeEffect(EdgeEffect.Spring)
    .width('100%')
    .height('100%')
  }

  getAuthorsName(songItem: SongItem): string {
    return songItem.artists.map((item) => item.name).join('/');
  }
}