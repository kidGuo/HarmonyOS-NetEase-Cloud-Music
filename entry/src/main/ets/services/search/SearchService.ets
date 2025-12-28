/**
 * Author: Finn Guo
 * Date: 2025/12/28
 */
import { SEARCH_TOP_CATES } from '../../../../mock/MockDataCenter';
import { SearchTopCate } from '../../models/search/SearchTopCate';
import { Logger } from '../../utils/Logger';
import { JSON } from '@kit.ArkTS';

export class SearchService {
  static async getTopCategories(): Promise<SearchTopCate[]> {
    return new Promise((resolve) => {
      setTimeout(() => {
        const items: SearchTopCate[] = SEARCH_TOP_CATES;
        Logger.info({ domain: 'Search' }, `top cates:${JSON.stringify(items)}`)
        resolve(items);
      }, 300)
    });
  }
}