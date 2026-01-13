/**
 * Author: Finn Guo
 * Date: 2026/1/4
 */
import { AppStorageV2, display } from '@kit.ArkUI';
import { GlobalDrawerState } from '../../models/main/GlobalDrawerState';

@Preview
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
      this.optionsBuilder()
      this.bottomBuilder()
    }
    .backgroundColor('#F4F6F9')
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
    .backgroundColor(Color.White)
  }

  @Builder
  optionsBuilder() {
    Scroll() {
      Column() {
        Image($r('app.media.no_vip'))
          .width('90%')
          .aspectRatio(1.5)

        this.optionItemBuilder('top', false, $r('app.media.cm4_list_subscribed_Normal'), '我的消息')
        this.optionItemBuilder('middle', false, $r('app.media.cm6_lay_icn_shopping_cart_Normal'), '我的云贝',
          '免费兑换黑胶VIP')
        this.optionItemBuilder('middle', false, $r('app.media.cm8_setting_skinSquare_Normal'), '装扮中心',
          '守护甜心装扮')
        this.optionItemBuilder('middle', false, $r('app.media.album_normal'), '创作者中心')
        this.optionItemBuilder('middle', true, $r('app.media.cm4_leaveInfo_Normal'), 'AI写歌')
        this.optionItemBuilder('middle', false, $r('app.media.cm7_more_icon_giftcard_Normal'), '最近播放')
        this.optionItemBuilder('middle', true, $r('app.media.cm6_set_icn_ring_tone_Normal'), '定时开关')
        this.optionItemBuilder('middle', false, $r('app.media.cm8_playlist_menu_delete_Normal'), '商城')
        this.optionItemBuilder('middle', false, $r('app.media.cm6_set_icn_coupon_Normal'), '云村有票')
        this.optionItemBuilder('middle', false, $r('app.media.cm4_edit_keyboard_prs_Normal'), '云推歌')
        this.optionItemBuilder('bottom', false, $r('app.media.cm8_btm_icn_event_Normal'), '我的客服')
      }
    }
    .backgroundColor('#F4F6F9')
    .width('100%')
    .scrollBar(BarState.Off)
    .layoutWeight(1)
  }

  @Builder
  optionItemBuilder(position: 'top' | 'middle' | 'bottom', hasDivider: boolean, icon: Resource, title: string,
    desc?: string) {
    Column() {
      Row() {
        Row() {
          Image(icon)
            .objectFit(ImageFit.Fill)
            .size({ width: 18, height: 18 })
            .margin({ left: 20, right: 16 })

          Text(title)
            .fontSize(16)
            .fontColor(Color.Black)
        }
        .layoutWeight(1)

        if (desc) {
          Text(desc)
            .fontSize(12)
            .fontColor(Color.Gray)
            .margin({ right: 16 })
        }
      }
      .layoutWeight(1)

      if (hasDivider) {
        Divider()
          .color('#F2F2F2')
          .strokeWidth(1)
          .margin({ left: 20, right: 20 })
      }
    }
    .backgroundColor(Color.White)
    .width('88%')
    .margin({ left: '6%', right: '6%' })
    .borderRadius({
      topLeft: position === 'top' ? 8 : 0,
      topRight: position === 'top' ? 8 : 0,
      bottomLeft: position === 'bottom' ? 8 : 0,
      bottomRight: position === 'bottom' ? 8 : 0
    })
    .height(50)
  }

  @Builder
  bottomBuilder() {
    Row() {
      Row() {
        Image($r('app.media.cm6_set_icn_siri_shortcuts_Normal'))
          .objectFit(ImageFit.Fill)
          .width(18)
          .aspectRatio(1)
          .margin({ right: 6 })
        Text('设置')
          .fontColor(Color.Black)
          .fontSize(16)
      }
      .justifyContent(FlexAlign.Center)
      .backgroundColor(Color.White)
      .width('46%')
      .aspectRatio(3)
      .borderRadius(8)
      .shadow({
        radius: 8,
        color: Color.Black,
        offsetX: -2,
        offsetY: 1,
        type: ShadowType.BLUR
      })

      Row() {
        Image($r('app.media.cm_playlist_hall_moretag_icon_Normal'))
          .objectFit(ImageFit.Fill)
          .width(20)
          .aspectRatio(1)
          .margin({ right: 6 })
        Text('更多')
          .fontColor(Color.Black)
          .fontSize(16)
      }
      .justifyContent(FlexAlign.Center)
      .backgroundColor(Color.White)
      .width('46%')
      .aspectRatio(3)
      .borderRadius(8)
      .shadow({
        radius: 8,
        color: Color.Black,
        offsetX: -2,
        offsetY: 1,
        type: ShadowType.BLUR
      })
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('88%')
    .height(55)
    .margin({
      left: '6%',
      bottom: 10,
      right: '6%'
    })
    .padding({ top: 5 })
    .shadow({
      radius: 10,
      color: '#0D000000',
      offsetX: 0,
      offsetY: -2
    })
  }
}