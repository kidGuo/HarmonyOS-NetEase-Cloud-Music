/**
 * Author: Finn Guo
 * Date: 2026/1/4
 */
import { GlobalDrawerState } from '../../models/main/GlobalDrawerState';
import { AppStorageV2 } from '@kit.ArkUI';

@ComponentV2
export struct HomeNavBar {
  @BuilderParam titleView: () => void = this.titleBuilder
  @BuilderParam rightView: () => void = this.rightViewBuilder
  drawerState: GlobalDrawerState = AppStorageV2.connect(GlobalDrawerState, () => new GlobalDrawerState())!;

  @Builder
  titleBuilder() {

  }

  @Builder
  rightViewBuilder() {

  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        this.titleView()
      }
      .constraintSize({ maxWidth: '70%' })
      .height('100%')

      Row() {
        Image($r('app.media.icon_directory'))
          .objectFit(ImageFit.Contain)
          .width(34)
          .aspectRatio(1)
      }
      .width(46)
      .height('100%')
      .position({ x: 0 })
      .margin({ left: 8 })
      .onClick(() => {
        this.getUIContext().animateTo({
          duration: 300,
          curve: Curve.EaseOut
        }, () => {
          this.drawerState.isDrawerOpen = true;
        })
      })

      Row() {
        this.rightView()
      }
      .height('100%')
      .position({ right: 8 })
    }
    .backgroundColor(Color.White)
    .width('100%')
    .height('100%')
  }
}