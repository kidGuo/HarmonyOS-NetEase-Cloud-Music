/**
 * Author: Finn Guo
 * Date: 2025/12/28
 */
import { WaterFlowDataSource } from './WaterFlowDataSource';
import { WaterFlowItem } from './WaterFlowItem';

@ComponentV2
export struct WaterFlowComponent {
  @Param scroller: Scroller = new Scroller();
  @Param @Require waterFlowSections: WaterFlowSections = new WaterFlowSections();
  @BuilderParam itemBuilder?: (item: WaterFlowItem, index: number) => void = this.defaultItemBuilder;
  @BuilderParam headerBuilder?: (index: number) => void = this.defaultHeaderBuilder
  @Param dataSource: WaterFlowDataSource<WaterFlowItem> = new WaterFlowDataSource();

  @Builder
  defaultItemBuilder(item: WaterFlowItem, index: number) {

  }

  @Builder
  defaultHeaderBuilder(index: number) {

  }

  build() {
    WaterFlow({ scroller: this.scroller, sections: this.waterFlowSections }) {
      LazyForEach(this.dataSource, (item: WaterFlowItem, index: number) => {
        FlowItem() {
          if (index == 0 && this.headerBuilder) {
            this.headerBuilder?.(index);
          } else {
            this.itemBuilder?.(item, index);
          }
        }
        .width('100%')
      }, (item: WaterFlowItem) => item.id.toString())
    }
    .rowsGap(10)
    .columnsGap(10)
    .cachedCount(10)
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
  }
}