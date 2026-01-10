/**
 * Author: Finn Guo
 * Date: 2026/1/4
 */
import { WaterFlowDataSource } from '../../views/commonViews/WaterFlow/WaterFlowDataSource';
import { WaterFlowItem } from '../../views/commonViews/WaterFlow/WaterFlowItem';
import { UIUtils } from '@kit.ArkUI';

@ObservedV2
export class BaseWaterFlowViewModel {
  // 数据源
  protected dataSource: WaterFlowDataSource<WaterFlowItem> = new WaterFlowDataSource();
  //
  protected waterFlowSections: WaterFlowSections = UIUtils.makeObserved(new WaterFlowSections());

  /**
   * 获取数据源
   */
  getDataSource(): WaterFlowDataSource<WaterFlowItem> {
    return this.dataSource;
  }

  /**
   * 获取 sections 配置
   */
  getSections(): WaterFlowSections {
    return this.waterFlowSections;
  }
}