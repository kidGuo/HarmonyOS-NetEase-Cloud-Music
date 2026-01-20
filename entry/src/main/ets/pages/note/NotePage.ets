/**
 * Author: Finn Guo
 * Date: 2025/12/20
 */
import { SegmentItem } from '../../models/home/SegmentItem';
import { NoteItem } from '../../models/note/NoteItem';
import { Logger } from '../../utils/Logger';
import { NoteViewModel } from '../../viewModels/note/NoteViewModel';
import { WaterFlowComponent } from '../../views/commonViews/WaterFlow/WaterFlowComponent';
import { WaterFlowItem } from '../../views/commonViews/WaterFlow/WaterFlowItem';
import { HomeNavBar } from '../../views/homePage/HomeNavBar';
import { SegmentedView } from '../../views/commonViews/SegmentView/SegmentedView';
import { NoteCard } from '../../views/note/NoteCard';
import { JSON } from '@kit.ArkTS';

@ComponentV2
export struct NotePage {
  @Consumer() pathStack: NavPathStack = new NavPathStack();
  viewModel: NoteViewModel = new NoteViewModel();

  aboutToAppear(): void {
    this.viewModel.loadData();
  }

  @Builder
  noteCardBuilder(item: WaterFlowItem, index: number) {
    NoteCard({ item: (item as NoteItem) })
      .backgroundColor(Color.White)
      .onClick(() => {
        const noteItem = item as NoteItem;
        if (noteItem) {
          this.pathStack.pushPathByName('NoteDetail', noteItem, false);
        }
      })
  }

  @Builder
  catesBuilder() {
    SegmentedView({
      items: this.viewModel.cates,
      selectedIndex: this.viewModel.currentIndex,
      segmentController: this.viewModel.getSegmentController(),
      onSegmentSelect: (index: number) => {
        this.viewModel.currentIndex = index;
      }
    })
      .height('100%')
  }

  @Builder
  navBarRightActionsBuilder() {
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
      Blank()
        .width(8)
      Image($r('app.media.plus_icon'))
        .objectFit(ImageFit.Contain)
        .size({ width: 44, height: 44 })
        .padding({
          top: 9,
          left: 9,
          bottom: 9,
          right: 9
        })
    }
    .alignItems(VerticalAlign.Center)
    .height('100%')
  }

  build() {
    Column() {
      HomeNavBar({
        titleView: () => {
          this.catesBuilder()
        },
        rightView: this.navBarRightActionsBuilder
      })
        .width('100%')
        .height(48)

      Swiper() {
        ForEach(this.viewModel.cates, (item: SegmentItem, index: number) => {
          if (index === 0) {
            Column() {
              Text('施工中...')
                .fontSize(20)
                .fontColor(Color.Black)
            }
            .justifyContent(FlexAlign.Center)
            .width('100%')
            .height('100%')
          } else {
            WaterFlowComponent({
              isRefreshing: this.viewModel.isRefreshing,
              isLoadingMore: this.viewModel.isLoadingMore,
              dataSource: this.viewModel.getDataSource(),
              waterFlowSections: this.viewModel.getSections(),
              itemBuilder: (item: WaterFlowItem, index: number) => {
                this.noteCardBuilder(item, index)
              },
              getItemReuseId: (item: WaterFlowItem, index: number) => "NoteCard",
              onRefresh: () => {
                this.viewModel.refreshData();
              },
              onLoadMore: () => {
                this.viewModel.loadMoreData();
              }
            })
              .width('100%')
              .height('100%')
          }
        }, (item: SegmentItem) => item.id)
      }
      .layoutWeight(1)
      .loop(false)
      .index(this.viewModel.currentIndex)
      .indicator(false)
      .onGestureSwipe((index: number, extraInfo: SwiperAnimationEvent) => {
        Logger.info({ domain: 'NotePage' }, `index:${index}, extra:${JSON.stringify(extraInfo)}`);
        const progress = index - (extraInfo.currentOffset / this.viewModel.swiperWidth);
        this.viewModel.getSegmentController().setScrollOffset(progress);
      })
      .onAnimationStart((index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) => {
        Logger.info({ domain: 'NotePage' }, `onAnimationStart index:${index}, extra:${JSON.stringify(extraInfo)}`);
        this.getUIContext()?.animateTo({
          duration: 250,
          curve: Curve.EaseOut
        }, () => {
          this.viewModel.getSegmentController().setScrollOffset(targetIndex);
        })
      })
      .onChange((index: number) => {
        this.viewModel.getSegmentController().selectIndex(index, true)
      })
      .onAnimationEnd((index: number, extraInfo: SwiperAnimationEvent) => {
        Logger.info({ domain: 'NotePage' }, `onAnimationEnd index:${index}, extra:${JSON.stringify(extraInfo)}`);
      })
      .onAreaChange((oldValue: Area, newValue: Area) => {
        this.viewModel.swiperWidth = newValue.width as number;
      })
    }
    .backgroundColor('#F4F6F9')
  }
}