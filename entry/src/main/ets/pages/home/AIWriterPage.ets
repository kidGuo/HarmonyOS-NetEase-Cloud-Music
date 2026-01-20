/**
 * Author: Finn Guo
 * Date: 2025/12/21
 */
import { Logger } from '../../utils/Logger';
import { AIWriterViewModel } from '../../viewModels/home/AIWriterViewModel';

@Preview
@ComponentV2
export struct AIWriterPage {
  @Provider() writerViewModel: AIWriterViewModel = new AIWriterViewModel();

  @Computed
  get isValidContent(): boolean {
    return this.writerViewModel.prompt.trim().length > 0;
  }

  @Computed
  get isValidLyrics(): boolean {
    return this.writerViewModel.lyricsText.trim().length > 0;
  }

  @Monitor('writerViewModel.errorMessage')
  onErrorMessageChanged(monitor: IMonitor) {
    const errorMsg = this.writerViewModel.errorMessage;
    if (errorMsg && errorMsg.length > 0) {
      this.showErrorAlert(errorMsg);
    }
  }

  aboutToAppear(): void {
    Logger.info({ domain: 'AIWriterPage' }, 'about to appear')
  }

  build() {
    Column() {
      Row({ space: 12 }) {
        this.actionButtonBuilder($r('app.media.my_music'), '我的创作')
        this.actionButtonBuilder($r('app.media.my_prize'), '我的积分')
      }
      .margin({ top: 2, bottom: 16 })
      .padding({ left: 12, right: 12 })
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height(58)

      this.segmentBuilder()

      this.textContentBuilder()
    }
    .backgroundColor('#F7F8FA')
    .width('100%')
    .height('100%')
  }

  @Builder
  actionButtonBuilder(icon: ResourceStr, title: string) {
    Row() {
      Image(icon)
        .objectFit(ImageFit.Cover)
        .size({ width: 20, height: 20 })
        .margin({ right: 6 })
      Text(title)
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
    }
    .layoutWeight(1)
    .backgroundColor('#C8CAD1')
    .borderRadius(8)
    .height(48)
    .justifyContent(FlexAlign.Center)
    .stateStyles({
      pressed: {
        .opacity(0.8)
      },
      normal: {
        .opacity(1.0)
      }
    })
    .onClick(() => {

    })
  }

  @Builder
  segmentBuilder() {
    Row() {
      Text('一句话写歌词')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .layoutWeight(1)
        .height('100%')
        .textAlign(TextAlign.Center)
        .backgroundColor(Color.White)
        .borderRadius({
          topLeft: 8,
          topRight: 8
        })

      this.segmentItemBuilder('填词写歌')
      this.segmentItemBuilder('纯音乐')
    }
    .width('100%')
    .height(56)
    .padding({ left: 12, right: 12 })
  }

  @Builder
  segmentItemBuilder(title: string) {
    Text(title)
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .layoutWeight(1)
      .height('100%')
      .textAlign(TextAlign.Center)
      .backgroundColor('#F7F8FA')
  }

  @Builder
  textContentBuilder() {
    Column() {
      Stack({ alignContent: Alignment.Center }) {
        TextArea({
          placeholder: '分享你的创作灵感，让AI为你谱写歌词。例如：我想写一首关于追梦的摇滚歌曲，场景是深夜的录音室，我想表达"即使无人喝彩，也要唱到天亮"的坚持',
          text: $$this.writerViewModel.prompt
        })
          .placeholderColor('#A8AAB3')
          .fontWeight(FontWeight.Medium)
          .borderRadius(0)
          .backgroundColor(Color.White)
          .caretColor('#F44336')
          .width('100%')
          .height('100%')

        if (this.isValidLyrics) {
          this.resultContentBuilder()
        }
      }
      .backgroundColor(Color.White)
      .width('100%')
      .height('70%')

      Stack({ alignContent: Alignment.Center }) {
        Button('生成歌词 (3积分）')
          .type(ButtonType.Capsule)
          .width('80%')
          .constraintSize({ maxWidth: 300 })
          .backgroundColor('#F44336')
          .fontColor(Color.White)
          .fontSize(18)
          .height(50)
          .enabled(this.isValidContent && !this.writerViewModel.isLoading)
          .onClick(() => {
            this.writerViewModel.requestDeepSeekStream(this.writerViewModel.prompt)
          })

        if (this.writerViewModel.isLoading) {
          LoadingProgress()
            .height(50)
            .aspectRatio(1)
            .padding(6)
            .backgroundColor(Color.Transparent)
        }
      }
      .width('100%')
      .height(50)
    }
    .margin({ left: 12, right: 12 })
    .height(300)
    .backgroundColor(Color.White)
    .borderRadius({
      topLeft: 0,
      topRight: 0,
      bottomLeft: 8,
      bottomRight: 8
    })
  }

  @Builder
  resultContentBuilder() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Scroll() {
        Text(this.writerViewModel.lyricsText)
          .fontSize(16)
          .lineHeight(24)
          .fontColor('#333333')
          .width('100%')
          .padding({
            left: 16,
            right: 32,
            top: 16,
            bottom: 16
          })
          .copyOption(CopyOptions.LocalDevice)
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.White)
      .scrollBar(BarState.Auto)
      .edgeEffect(EdgeEffect.Spring)
      .nestedScroll({
        scrollForward: NestedScrollMode.SELF_ONLY,
        scrollBackward: NestedScrollMode.SELF_ONLY
      })

      Image($r('app.media.cm5_empty_recommend_delete_Normal'))
        .size({ width: 30, height: 30 })
        .margin({ top: 8, right: 8 })
        .onClick(() => {
          this.writerViewModel.clearLyrics();
        })
    }
    .width('100%')
    .height('100%')
  }

  private showErrorAlert(message: string) {
    AlertDialog.show({
      title: '出错啦',
      message: message,
      alignment: DialogAlignment.Center,
      primaryButton: {
        value: '知道了',
        action: () => {
          this.writerViewModel.clearError();
        }
      }
    })
  }
}