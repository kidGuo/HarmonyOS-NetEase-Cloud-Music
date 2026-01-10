/**
 * Author: Finn Guo
 * Date: 2025/12/28
 */
import { ALBUMS_JSON_STRING, SEARCH_TOP_CATES } from '../../../../mock/MockDataCenter';
import { SearchTopCate } from '../../models/search/SearchTopCate';
import { Logger } from '../../utils/Logger';
import { JSON } from '@kit.ArkTS';
import { httpClient } from '../../network/NetworkManager';
import { SearchCardItem, SearchCardResultResponse } from '../../models/search/SearchCardItem';
import { AppResultResponse, BaseResponse } from '../../network/BaseResponse';
import { IS_DEBUG } from '../../utils/EnvConfig';

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

  /*
  id=19723756，云音乐飙升榜
  id=3779629，云音乐新歌榜
  id=3778678，云音乐热歌榜
  id=2250011882，抖音排行榜
  * */
  static async getPlaylistDetail(id: string): Promise<SearchCardItem[]> {
    if (IS_DEBUG) {
      return new Promise((resolve) => {
        setTimeout(() => {
          try {
            const tracks = JSON.parse(ALBUMS_JSON_STRING) as SearchCardItem[];
            const items = tracks.map((item) => SearchCardItem.fromJson(item));
            resolve(items);
          } catch (error) {
            Logger.error({ domain: 'SearchService' }, `Parse error: ${JSON.stringify(error)}`);
            resolve([]); // 返回空数组
          }
        }, 300);
      });
    }

    try {
      const response =
        await httpClient.get <BaseResponse<AppResultResponse<SearchCardResultResponse>>>('/playlist/detail',
          { id: id })
      Logger.info({ domain: 'Net', tag: 'SearchService' },
        `Get playlist details:${JSON.stringify(response.data)}`);
      if (response.data !== undefined && response.data !== null) {
        const tracks = response.data.result.tracks;
        const items = tracks.map((item) => SearchCardItem.fromJson(item));
        return items;
      }
      return [];
    } catch (error) {
      Logger.error({ domain: 'Net', tag: 'SearchService' }, `Get playlist error:${JSON.stringify(error)}`)
      return [];
    }
  }
}