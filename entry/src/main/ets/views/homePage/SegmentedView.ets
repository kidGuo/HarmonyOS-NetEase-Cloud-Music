/**
 * Author: Finn Guo
 * Date: 2025/12/21
 */
import { SegmentItem } from '../../models/home/SegmentItem';
import { Logger } from '../../utils/Logger';

export class SegmentController {
  private callback: (index: number, animated: boolean) => void = () => {
  };

  scrollToIndex(index: number, animated: boolean) {
    this.callback(index, animated);
  }

  bindView(cb: (index: number, animated: boolean) => void) {
    this.callback = cb;
  }

  unbindView() {
    this.callback = () => {
    };
  }
}

@Preview
@ComponentV2
export struct SegmentedView {
  @Param items: SegmentItem[] = [];
  @Param @Once selectedIndex: number = 0;
  @Local indicatorWidth: number = 20;
  @Local indicatorOffset: number = 0;
  @Param segmentController: SegmentController = new SegmentController();
  // 事件回调
  @Event onSegmentSelect?: (index: number) => void;
  //
  private containerWidth: number = 0;
  private itemsArea: (Area | undefined)[] = [];
  private scroller: Scroller = new Scroller();

  aboutToAppear(): void {
    this.commonInitialization();
  }

  aboutToDisappear(): void {
    this.deinit();
  }

  private commonInitialization() {
    this.itemsArea = new Array(this.itemsArea.length).fill(undefined);
    this.segmentController.bindView((index: number, animated: boolean) => {
      this.doScrollToIndex(index, animated);
    })
  }

  private deinit() {
    this.segmentController.unbindView();
  }

  private updateIndicator(index: number, animated: boolean) {
    if (index < 0 || index >= this.items.length || this.items.length == 0) {
      return;
    }
    const area = this.itemsArea[index];
    if (area) {
      const realX = area.position.x as number;
      const itemWidth = area.width as number;

      if (animated) {
        this.getUIContext()?.animateTo({
          duration: 300,
          curve: Curve.FastOutSlowIn
        }, () => {
          this.indicatorWidth = itemWidth - 30;
          this.indicatorOffset = realX + itemWidth / 2.0 - this.indicatorWidth / 2.0;
        })
      } else {
        this.indicatorWidth = itemWidth - 30;
        this.indicatorOffset = realX + itemWidth / 2.0 - this.indicatorWidth / 2.0;
      }
    }
  }

  private scrollToCenter(index: number) {
    if (index < 0 || index >= this.items.length || this.items.length == 0) {
      return;
    }

    const area = this.itemsArea[index];
    if (area) {
      const itemOffset = area.position.x as number;
      const itemWidth = area.width as number;
      const targetX = itemOffset + itemWidth / 2.0 - this.containerWidth / 2.0;

      this.scroller.scrollTo({
        xOffset: targetX,
        yOffset: 0,
        animation: {
          duration: 300,
          curve: Curve.EaseOut
        }
      })
    }
  }

  private doScrollToIndex(index: number, animated: boolean) {
    if (index < 0 || index >= this.items.length || this.items.length == 0) {
      return;
    }
    this.selectedIndex = index;
    this.updateIndicator(index, true);
    this.scrollToCenter(index);
    this.onSegmentSelect?.(index);
  }

  build() {
    Column() {
      Scroll(this.scroller) {
        Stack({ alignContent: Alignment.BottomStart }) {
          Row() {
            ForEach(this.items, (segmentItem: SegmentItem, index: number) => {
              Column() {
                Text(segmentItem.name)
                  .textAlign(TextAlign.Center)
                  .fontSize(16)
                  .fontColor(this.selectedIndex === index ? Color.Black : '#8E8E93')
                  .fontWeight(this.selectedIndex === index ? FontWeight.Bold : FontWeight.Normal)
                  .padding({
                    left: 12,
                    right: 12,
                    top: 12
                  })
              }
              .onAreaChange((oldValue: Area, newValue: Area) => {
                this.itemsArea[index] = (newValue as Area);
                if (this.selectedIndex === index) {
                  this.updateIndicator(index, false);
                }
              })
              .onClick(() => {
                this.doScrollToIndex(index, true);
              })
            }, (segmentItem: SegmentItem) => segmentItem.id);
          }
          .height('100%')

          Line()
            .width(this.indicatorWidth)
            .height(3)
            .backgroundColor(Color.Black)
            .borderRadius(3)
            .offset({ x: this.indicatorOffset, y: 0 })
        }
      }
      .edgeEffect(EdgeEffect.Spring)
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .onAreaChange((oldValue: Area, newValue: Area) => {
        this.containerWidth = newValue.width as number;
        Logger.info({ domain: 'Segment' }, `Container width: ${this.containerWidth}`);
      })
      .width('100%')
      .height('100%')
    }
  }
}