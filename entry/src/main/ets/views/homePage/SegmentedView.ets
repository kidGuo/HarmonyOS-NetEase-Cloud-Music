/**
 * Author: Finn Guo
 * Date: 2025/12/21
 */
import { SegmentItem } from '../../models/home/SegmentItem';
import { Logger } from '../../utils/Logger';
import { JSON } from '@kit.ArkTS';

export class SegmentController {
  private scrollIndexCallback: (index: number, animated: boolean) => void = () => {
  };
  private offsetCallback: (offset: number) => void = () => {
  };

  selectIndex(index: number, animated: boolean) {
    this.scrollIndexCallback(index, animated);
  }

  setScrollOffset(offset: number) {
    this.offsetCallback(offset);
  }

  onSelectIndex(cb: (index: number, animated: boolean) => void) {
    this.scrollIndexCallback = cb;
  }

  onOffsetUpdate(cb: (offset: number) => void) {
    this.offsetCallback = cb;
  }

  detachView() {
    this.scrollIndexCallback = () => {
    };
    this.offsetCallback = () => {

    };
  }
}

@Preview
@ComponentV2
export struct SegmentedView {
  @Param items: SegmentItem[] = [];
  @Param @Once selectedIndex: number = 0;
  @Local indicatorOffset: number = 0;
  @Param segmentController: SegmentController = new SegmentController();
  // 事件回调
  @Event onSegmentSelect?: (index: number) => void;
  // 私有
  private containerWidth: number = 0;
  private itemsArea: (Area | undefined)[] = [];
  private scroller: Scroller = new Scroller();
  private indicatorWidth: number = 20;

  aboutToAppear(): void {
    this.commonInitialization();
  }

  aboutToDisappear(): void {
    this.deinit();
  }

  private commonInitialization() {
    this.itemsArea = new Array(this.itemsArea.length).fill(undefined);
    this.segmentController.onSelectIndex((index: number, animated: boolean) => {
      this.doScrollToIndex(index, animated);
    })
    this.segmentController.onOffsetUpdate((offset: number) => {
      this.updateIndicatorByProgress(offset);
    })
  }

  private deinit() {
    this.segmentController.detachView();
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

  private updateIndicatorByProgress(progress: number) {
    // 1. 获取当前所在的起始索引
    const floorIndex = Math.floor(progress);
    // 2. 目标索引（确保不越界）
    const ceilIndex = Math.min(floorIndex + 1, this.items.length - 1);

    // 3. 计算在该区间内的百分比 (0 ~ 1)
    const percent = progress - floorIndex;

    const areaStart = this.itemsArea[floorIndex];
    const areaEnd = this.itemsArea[ceilIndex];

    if (!areaStart) {
      return;
    }

    Logger.info({ domain: 'Segment' },
      `Update indicator by progress, floor:${floorIndex}, ceil:${ceilIndex}, endArea:${JSON.stringify(areaEnd)}`);
    // 如果已经在最后一页或者起始和结束是同一位置，直接定位
    if (!areaEnd || floorIndex === ceilIndex) {
      const w = (areaStart.width as number) - 30;
      this.indicatorWidth = w;
      this.indicatorOffset = (areaStart.position.x as number) + (areaStart.width as number) / 2.0 - w / 2.0;
      return;
    }

    // 4. 线性插值计算 (LERP)
    const wStart = (areaStart.width as number) - 30;
    const wEnd = (areaEnd.width as number) - 30;
    this.indicatorWidth = wStart + (wEnd - wStart) * percent;

    const xStart = (areaStart.position.x as number) + (areaStart.width as number) / 2.0 - wStart / 2.0;
    const xEnd = (areaEnd.position.x as number) + (areaEnd.width as number) / 2.0 - wEnd / 2.0;
    this.indicatorOffset = xStart + (xEnd - xStart) * percent;
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