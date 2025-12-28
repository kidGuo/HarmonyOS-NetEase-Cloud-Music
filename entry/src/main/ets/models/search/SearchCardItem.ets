/**
 * Author: Finn Guo
 * Date: 2025/12/28
 */
import { WaterFlowItem } from '../../views/commonViews/WaterFlow/WaterFlowItem';

export class SearchCardItem implements WaterFlowItem {
  id: string | number = '';
  type: 'header' | 'content' = 'content';

  static fromJson(json: ESObject): SearchCardItem {
    const item = new SearchCardItem();
    item.id = json.id;

    return item;
  }
}