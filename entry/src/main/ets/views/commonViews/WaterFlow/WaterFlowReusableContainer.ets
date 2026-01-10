/**
 * Author: Finn Guo
 * Date: 2025/12/31
 */
import { WaterFlowItem } from './WaterFlowItem';

@ReusableV2
@ComponentV2
export struct WaterFlowReusableContainer {
  @Param item: WaterFlowItem | null = null;
  @Param index: number = -1;
  @BuilderParam content: (item: WaterFlowItem, index: number) => void = this.defaultContent;

  @Builder
  defaultContent(item: WaterFlowItem, index: number) {

  }

  build() {
    if (this.item !== null) {
      this.content(this.item, this.index);
    }
  }
}