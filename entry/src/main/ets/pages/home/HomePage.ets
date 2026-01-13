/**
 * Author: Finn Guo
 * Date: 2025/12/20
 */
import { SegmentItem } from '../../models/home/SegmentItem';
import { Logger } from '../../utils/Logger';
import { HomeViewModel } from '../../viewModels/home/HomeViewModel';
import { SegmentController, SegmentedView } from '../../views/commonViews/SegmentView/SegmentedView';
import { AudiobookPlayerPage } from './AudiobookPlayerPage';
import { DiscoveryPage } from './DiscoveryPage';
import { MusicPlayerPage } from './MusicPlayerPage';
import { MusicsPage } from './MusicsPage';
import { PodcastPage } from './PodcastPage';
import { JSON } from '@kit.ArkTS';
import { AIWriterPage } from './AIWriterPage';
import { MidnightFlightPage } from './MidnightFlightPage';
import { WebComponent } from '../web/WebComponent';
import { HomeNavBar } from '../../views/homePage/HomeNavBar';

@ComponentV2
export struct HomePage {
  @Provider() viewModel: HomeViewModel = new HomeViewModel();
  private swiperController: SwiperController = new SwiperController();
  private segmentController: SegmentController = new SegmentController();
  private swiperWidth: number = 360;

  aboutToAppear(): void {
    this.viewModel.segmentItems.forEach((item): void => Logger.info({ domain: 'Home' },
      `name:${item.name}, id:${item.id}`))
  }

  @Builder
  navBarBuilder() {
    HomeNavBar({
      titleView: () => {
        this.titleViewBuilder()
      },
      rightView: () => {
        this.rightActionsBuilder()
      }
    })
      .width('100%')
      .height(48)
  }

  @Builder
  titleViewBuilder() {
    SegmentedView({
      items: this.viewModel.segmentItems,
      selectedIndex: 1,
      segmentController: this.segmentController,
      onSegmentSelect: (index: number) => {
        this.swiperController.changeIndex(index, true);
      }
    })
      .height('100%')
      .backgroundColor(Color.White)
      .padding({ bottom: 6 })
  }

  @Builder
  rightActionsBuilder() {
    Row() {
      Image($r('app.media.search_icon'))
        .objectFit(ImageFit.Contain)
        .size({ width: 44, height: 44 })
        .padding({
          top: 9,
          left: 9,
          bottom: 9,
          right: 9
        })
    }
  }

  @Builder
  segmentPageBuilder(segmentItem: SegmentItem) {
    if (segmentItem.id === '20025002') {
      DiscoveryPage()
    } else if (segmentItem.id === '20025003') {
      MusicsPage()
    } else if (segmentItem.id === '20025004') {
      PodcastPage()
    } else if (segmentItem.id === '20025005') {
      AudiobookPlayerPage()
    } else if (segmentItem.id === '20025006') {
      AIWriterPage()
    } else if (segmentItem.id === '20025007') {
      WebComponent({ url: 'https://juejin.cn/column/7474163872614629439' })
    } else if (segmentItem.id === '20025008') {
      MidnightFlightPage()
    } else {
      MusicPlayerPage()
    }
  }

  build() {
    Column() {
      this.navBarBuilder()

      Swiper(this.swiperController) {
        LazyForEach(this.viewModel.pagesDataSource, (item: SegmentItem, index: number) => {
          Column() {
            this.segmentPageBuilder(item);
          }
          .width('100%')
          .height('100%')
        }, (item: SegmentItem) => item.id);
      }
      .index(1)
      .indicator(false)
      .loop(false)
      .layoutWeight(1)
      .width('100%')
      .cachedCount(1)
      .onChange((index: number) => {
        Logger.info({ domain: 'Home' }, 'swiper change idx:%d', index);
        this.segmentController.selectIndex(index, true);
      })
      .onGestureSwipe((index: number, extraInfo: SwiperAnimationEvent) => {
        Logger.info({ domain: 'Home' }, `Gesture swipe index:${index}, extra:${JSON.stringify(extraInfo)}`);
        const progress = index - (extraInfo.currentOffset / this.swiperWidth);
        this.segmentController.setScrollOffset(progress);
      })
      .onAnimationStart((index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) => {
        this.getUIContext().animateTo({
          duration: 250,
          curve: Curve.EaseOut
        }, () => {
          this.segmentController.setScrollOffset(targetIndex);
        })
      })
      .onAreaChange((oldValue: Area, newValue: Area) => {
        this.swiperWidth = newValue.width as number;
        Logger.info({ domain: 'Home' }, 'Swipe width:%d', this.swiperWidth);
      })
    }
    .backgroundColor('#F4F6F9')
    .width('100%')
    .height('100%')
  }
}