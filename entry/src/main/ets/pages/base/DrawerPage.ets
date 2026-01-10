/**
 * Author: Finn Guo
 * Date: 2026/1/4
 */
import { AppStorageV2, display } from '@kit.ArkUI';
import { GlobalDrawerState } from '../../models/main/GlobalDrawerState';

@ComponentV2
export struct DrawerPage {
  @Local contentOffset: number = 0;
  drawerState: GlobalDrawerState = AppStorageV2.connect(GlobalDrawerState, () => new GlobalDrawerState())!;
  contentWidth: number = 0;

  aboutToAppear(): void {
    try {
      const screenWidth = display.getDefaultDisplaySync().width;
      this.contentWidth = this.getUIContext().px2vp(screenWidth) * 0.8;
    } catch (error) {
      this.contentWidth = 300;
    }
    this.contentOffset = -this.contentWidth;
  }

  build() {
    Stack({ alignContent: Alignment.Start }) {
      if (this.drawerState.isDrawerOpen) {
        this.backgroundBuilder()
      }
      this.contentBuilder()
    }
    .hitTestBehavior(this.drawerState.isDrawerOpen ? HitTestMode.Default : HitTestMode.None)
    .expandSafeArea()
    .width('100%')
    .height('100%')
  }

  @Builder
  backgroundBuilder() {
    Column() {

    }
    .backgroundColor('#33000000')
    .expandSafeArea()
    .width('100%')
    .height('100%')
    .transition(TransitionEffect.OPACITY.animation({ duration: 300 }))
    .onClick(() => {
      this.getUIContext().animateTo({
        duration: 300,
        curve: Curve.EaseOut
      }, () => {
        this.drawerState.isDrawerOpen = false
      })
    })
  }

  @Builder
  contentBuilder() {
    Column() {
      this.headerBuilder()
    }
    .backgroundColor(Color.White)
    .expandSafeArea()
    .offset({ x: (this.drawerState.isDrawerOpen ? 0 : this.contentOffset) })
    // .shadow({ radius: 20, color: 'rgba(0,0,0,0.1)', offsetX: 10 })
    .width('80%')
    .height('100%')
  }

  @Builder
  headerBuilder() {
    Row() {
      Row() {
        Image($r('app.media.xmzd'))
          .size({ width: 36, height: 36 })
          .clip(true)
          .borderRadius(8)
          .margin({ right: 8 })
        Column() {
          Text('朽木自雕')
            .fontSize(18)
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Bolder)
          Text('vx:xmzd2522')
            .fontSize(16)
            .fontColor(Color.Black)
        }
        .alignItems(HorizontalAlign.Start)
      }

      Row() {
        Image($r('app.media.voice_icon'))
          .objectFit(ImageFit.Cover)
          .size({ width: 24, height: 24 })
          .margin({ right: 8 })
        Image($r('app.media.scan'))
          .objectFit(ImageFit.Cover)
          .size({ width: 24, height: 24 })
      }
    }
    .padding({ left: 12, right: 12, top: 20 })
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }
}