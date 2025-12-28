/**
 * Author: Finn Guo
 * Date: 2025/12/28
 */
import { SearchTopCate } from '../../models/search/SearchTopCate';
import { SearchService } from '../../services/search/SearchService';
import { Logger } from '../../utils/Logger';

@ObservedV2
export class SearchViewModel {
  @Trace topCates: SearchTopCate[] = [];

  async getSearchTopCates() {
    const items = await SearchService.getTopCategories();
    Logger.info({ domain: 'SearchVM' }, `top cates:${JSON.stringify(items)}`)
    this.topCates = items;
  }
}