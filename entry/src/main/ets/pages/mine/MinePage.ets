/**
 * Author: Finn Guo
 * Date: 2025/12/20
 */
import { Logger } from '../../utils/Logger';
import { MineViewModel } from '../../viewModels/mine/MineViewModel';
import { JSON } from '@kit.ArkTS';
import { MenuItem } from '../../models/mine/MenuItem';
import { SegmentedView } from '../../views/commonViews/SegmentView/SegmentedView';
import { SegmentItem } from '../../models/home/SegmentItem';
import { MineMusicComponent } from '../../views/mine/MineMusicComponent';
import { MinePodcastComponent } from '../../views/mine/MinePodcastComponent';
import { MineNoteComponent } from '../../views/mine/MineNoteComponent';
import { MineNavBar } from '../../views/mine/MineNavBar';

@Preview
@ComponentV2
export struct MinePage {
  viewModel: MineViewModel = new MineViewModel();

  aboutToAppear(): void {
    this.viewModel.loadData();
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      this.headerBackgroundBuilder()
      this.navBarBuilder()

      Scroll(this.viewModel.getScroller()) {
        Column() {
          Column() {
            this.userInfoBuilder()
            this.menusBuilder()
          }
          .width('100%')
          .justifyContent(FlexAlign.End)
          .height(this.viewModel.headerHeight)
          .hitTestBehavior(HitTestMode.None)

          SegmentedView({
            items: this.viewModel.cates,
            selectedIndex: this.viewModel.currentIndex,
            segmentController: this.viewModel.getSegmentController(),
            style: this.viewModel.getSegmentedStyle(),
            onSegmentSelect: (index: number) => {
              this.viewModel.currentIndex = index;
            }
          })
            .width('100%')
            .height(44)
            .backgroundColor(Color.White)
            .borderRadius({
              topLeft: 8,
              topRight: 8
            })

          Swiper() {
            ForEach(this.viewModel.cates, (item: SegmentItem, index: number) => {
              if (item.id === '2000811') {
                MineMusicComponent({ items: this.viewModel.favItems })
                  .backgroundColor(Color.White)
              } else if (item.id === '2000812') {
                MinePodcastComponent()
                  .backgroundColor(Color.White)
              } else if (item.id === '2000813') {
                MineNoteComponent()
                  .backgroundColor(Color.White)
              }
            }, (item: SegmentItem) => item.id);
          }
          .indicator(false)
          .width('100%')
          .constraintSize({ minHeight: 480 })
          .layoutWeight(1)
          .loop(false)
          .index(this.viewModel.currentIndex)
          .onChange((index: number) => {
            this.viewModel.getSegmentController().selectIndex(index, true);
          })
          .onGestureSwipe((index: number, extraInfo: SwiperAnimationEvent) => {
            const progress = index - (extraInfo.currentOffset / this.viewModel.swiperWidth);
            this.viewModel.getSegmentController().setScrollOffset(progress);
          })
          .onAreaChange((oldValue: Area, newValue: Area) => {
            this.viewModel.swiperWidth = newValue.width as number;
          })
          .onAnimationStart((index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) => {
            this.getUIContext()?.animateTo({
              duration: 250,
              curve: Curve.EaseOut
            }, () => {
              this.viewModel.getSegmentController().setScrollOffset(targetIndex);
            })
          })
        }
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .onDidScroll((xOffset: number, yOffset: number, scrollState: ScrollState) => {

        this.viewModel.scrollY = this.viewModel.getScroller().currentOffset().yOffset;
        this.viewModel.navBgAlpha =
          Math.max(0,
            Math.min(1, (this.viewModel.getScroller().currentOffset().yOffset - this.viewModel.navBarThreshold) /
            this.viewModel.navBarThreshold));

        Logger.info({ domain: 'MinePage' },
          `on did scroll yoffset:${yOffset}, currenoffset:${this.viewModel.getScroller()
            .currentOffset()
            .yOffset}, navalph:${this.viewModel.navBgAlpha}`);
      })

    }
    .width('100%')
    .height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
    .onAreaChange((oldValue: Area, newValue: Area) => {
      Logger.info({ domain: 'MinePage' }, `on area change:${JSON.stringify(newValue)}`);
    })
  }

  @Builder
  headerBackgroundBuilder() {
    Image($r('app.media.profile_background'))
      .objectFit(ImageFit.Cover)
      .width('100%')
      .height(this.viewModel.scrollY < 0 ? this.viewModel.headerHeight - this.viewModel.scrollY :
        this.viewModel.headerHeight)
  }

  @Builder
  navBarBuilder() {
    MineNavBar({
      isDark: false,
      bgAlpha: this.viewModel.navBgAlpha
    })
      .width('100%')
      .height(64)
      .zIndex(10)
  }

  @Builder
  userInfoBuilder() {
    Column() {
      Image($r('app.media.xmzd'))
        .objectFit(ImageFit.Cover)
        .width(80)
        .aspectRatio(1)
        .border({
          color: Color.White,
          width: 3,
          radius: 40
        })
        .margin({ bottom: 10 })

      Text('朽木自雕')
        .fontSize(20)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bolder)
        .textAlign(TextAlign.Center)
      Blank()
        .height(20)

      Text('地球之所以是圆的，是为了让那些走散的人，在绕过大半个世界后，还能在同一首歌里重逢')
        .fontSize(16)
        .fontColor('#E6E6E6')
        .textAlign(TextAlign.Center)
      Blank()
        .height(18)

      Row() {
        Text('18枚勋章')
          .fontSize(14)
          .fontColor('#CCCCCC')
      }

      Blank()
        .height(22)

      Row() {
        this.honorInfoBuilder('30', '关注')
        Blank()
          .width(16)

        this.honorInfoBuilder('9', '粉丝')
        Blank()
          .width(16)

        Text('Lv.8')
          .fontColor(Color.White)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
        Blank()
          .width(16)

        this.honorInfoBuilder('1520', '小时')
      }
    }
    .padding({ top: 80, bottom: 22 })
    .backgroundColor(Color.Transparent)
  }

  @Builder
  honorInfoBuilder(desc: string, title: string) {
    Text() {
      Span(desc)
        .fontColor(Color.White)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
      Span(' ' + title)
        .fontColor('#B3FFFFFF')
        .fontSize(14)
    }
  }

  @Builder
  menusBuilder() {
    Row() {
      ForEach(this.viewModel.menus, (item: MenuItem, index: number) => {
        this.menuItemBuilder(item.title)
      }, (item: MenuItem) => item.id);
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ left: 40, bottom: 26, right: 40 })
    .width('100%')
    .backgroundColor(Color.Transparent)
  }

  @Builder
  menuItemBuilder(title: string) {
    Row() {
      Text(title)
        .fontColor('#B3FFFFFF')
        .fontSize(14)
    }
    .backgroundColor('#4D000000')
    .padding(6)
    .borderRadius(6)
    .onClick(() => {
      Logger.info({ domain: 'MinePage' }, `menu:${title}`)
    })
  }
}