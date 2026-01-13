/**
 * Author: Finn Guo
 * Date: 2026/1/11
 */
import { GlobalDrawerState } from '../../models/main/GlobalDrawerState';
import { AppStorageV2 } from '@kit.ArkUI';

@ComponentV2
export struct MineNavBar {
  @Param isDark: boolean = false;
  @Param bgAlpha: number = 0;
  drawerState: GlobalDrawerState = AppStorageV2.connect(GlobalDrawerState, () => new GlobalDrawerState())!;

  build() {
    Column() {
      Row() {
        Row() {
          Image($r('app.media.icon_directory'))
            .objectFit(ImageFit.Contain)
            .width(34)
            .aspectRatio(1)
        }
        .height('100%')
        .margin({ left: 8 })
        .onClick(() => {
          this.getUIContext().animateTo({
            duration: 300,
            curve: Curve.EaseOut
          }, () => {
            this.drawerState.isDrawerOpen = true;
          })
        })
        .height('100%')

        Row() {
          Image($r('app.media.xmzd'))
            .width(28)
            .aspectRatio(1)
            .borderRadius(14)
            .margin({ right: 8 })

          Text('朽木自雕')
            .fontSize(16)
            .fontColor(Color.Black)
        }
        .height('100%')

        Row() {
          Image($r('app.media.search_icon'))
            .objectFit(ImageFit.Contain)
            .width(28)
            .aspectRatio(1)
            .margin({ right: 8 })
          Image($r('app.media.more'))
            .objectFit(ImageFit.Contain)
            .width(28)
            .aspectRatio(1)
            .margin({ right: 8 })
        }
        .height('100%')
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .height('100%')
    }
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Color.White)
    .opacity(this.bgAlpha)
  }
}