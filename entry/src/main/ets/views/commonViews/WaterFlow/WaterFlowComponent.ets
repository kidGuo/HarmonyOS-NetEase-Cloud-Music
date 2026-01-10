/**
 * Author: Finn Guo
 * Date: 2025/12/28
 */
import { Logger } from '../../../utils/Logger';
import { WaterFlowDataSource } from './WaterFlowDataSource';
import { WaterFlowItem } from './WaterFlowItem';
import { UIUtils } from '@kit.ArkUI';
import { WaterFlowReusableContainer } from './WaterFlowReusableContainer';

@ComponentV2
export struct WaterFlowComponent {
  // Component
  @BuilderParam itemBuilder?: (item: WaterFlowItem, index: number) => void = this.defaultItemBuilder;
  @BuilderParam headerBuilder?: (item: WaterFlowItem, index: number) => void = this.defaultHeaderBuilder;
  @BuilderParam footerBuilder?: () => void = this.defaultFooterBuilder;
  @Event getItemReuseId: (item: WaterFlowItem, index: number) => string = () => 'Default';
  // 数据源
  @Param waterFlowSections: WaterFlowSections = UIUtils.makeObserved(new WaterFlowSections());
  @Param dataSource: WaterFlowDataSource<WaterFlowItem> = new WaterFlowDataSource();
  // 刷新加载
  @Param isRefreshing: boolean = false;
  @Event onRefresh: () => void = () => {
  };
  // 加载更多
  @Param preloadThreshold: number = 8;
  @Param isLoadingMore: boolean = false;
  @Event $isLoadingMore: (val: boolean) => void = () => {
  };
  @Event onLoadMore: () => void;

  @Builder
  defaultItemBuilder(item: WaterFlowItem, index: number) {

  }

  @Builder
  defaultHeaderBuilder(item: WaterFlowItem, index: number) {

  }

  @Builder
  defaultFooterBuilder() {

  }

  aboutToAppear(): void {
    Logger.info({ domain: 'WaterFlowComponent' }, `sections value:${this.waterFlowSections.values()}`);
  }

  build() {
    Refresh({ refreshing: this.isRefreshing }) {
      WaterFlow({
        footer: this.footerBuilder,
        sections: this.waterFlowSections
      }) {
        LazyForEach(this.dataSource, (item: WaterFlowItem, index: number) => {
          if (index === 0 && this.headerBuilder) {
            FlowItem() {
              this.headerBuilder?.(item, index);
            }
            .width('100%')
            .reuseId(this.getItemReuseId(item, index))
          } else {
            FlowItem() {
              WaterFlowReusableContainer({
                item: item,
                index: index,
                content: this.itemBuilder
              })
            }
            .width('100%')
            .reuseId(this.getItemReuseId(item, index))
          }
        }, (item: WaterFlowItem) => item.id.toString())
      }
      .cachedCount(5)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .layoutWeight(1)
      .onScrollIndex((first: number, last: number) => {
        Logger.info({ domain: 'WaterFlowComponent' },
          `onScrollIndex first:${first}, last:${last}, isLoadingMore:${this.isLoadingMore}`);
        const totalCount = this.dataSource.totalCount();
        if (last >= totalCount - this.preloadThreshold && !this.isLoadingMore) {
          this.onLoadMore?.();
        }
      })
    }
    .onRefreshing(() => {
      Logger.info({ domain: 'WaterFlowComponent' }, `on refreshing:${this.isRefreshing}`)
      this.onRefresh?.();
    })
  }
}