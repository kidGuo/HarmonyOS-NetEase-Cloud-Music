/**
 * Author: Finn Guo
 * Date: 2025/12/21
 */
import { Logger } from '../../utils/Logger';
import { JSON } from '@kit.ArkTS';
import { RecommendItem } from '../../models/home/RecommendItem';
import { httpClient } from '../../network/NetworkManager';
import { AppAlbumResponse, AppListResponse, AppResultResponse, BaseResponse } from '../../network/BaseResponse';
import { TopListItem } from '../../models/home/TopListItem';
import { PersonalItem } from '../../models/home/PersonalItem';
import { MVItem } from '../../models/home/MVItem';
import { IS_DEBUG } from '../../utils/EnvConfig';
import {
  BANNER_DATA,
  CATE_LIST,
  NEW_SONG,
  PRIVATE_CONTENT,
  PRIVATE_MV,
  RAW_RECOMMEND_JSON_STR,
  TOP_LIST_DATA
} from '../../../../mock/MockDataCenter';
import { AlbumItem } from '../../models/home/AlbumItem';
import { BannerItem } from '../../models/home/BannerItem';
import { CateItem } from '../../models/home/CateItem';

export class HomeService {
  static async getTopList(): Promise<TopListItem[]> {
    if (IS_DEBUG) {
      return new Promise((resolve) => {
        setTimeout(() => {
          const topList: TopListItem[] = TOP_LIST_DATA.map((item: ESObject) => TopListItem.fromJson(item));
          resolve(topList)
        }, 300);
      });
    }

    try {
      const response = await httpClient.get<BaseResponse<AppListResponse<TopListItem>>>('/toplist');
      Logger.info({ domain: 'Net', tag: 'HomeService' },
        `Top list:${JSON.stringify(response.data)}`);
      if (response.data.code === 200) {
        const rawList = response.data.list;
        return rawList.map((item: ESObject) => TopListItem.fromJson(item));
      }
      return [];
    } catch (error) {
      Logger.error({ domain: 'Net', tag: 'HomeService' }, `Top list error:${JSON.stringify(error)}`)
      return [];
    }
  }

  static async getRecommendPlaylist(): Promise<RecommendItem[]> {
    if (IS_DEBUG) {
      return new Promise((resolve) => {
        setTimeout(() => {
          const recommendRawList: ESObject[] = JSON.parse(RAW_RECOMMEND_JSON_STR) as ESObject[];
          const recommendList: RecommendItem[] =
            recommendRawList.map((item: ESObject) => RecommendItem.fromJson(item));
          resolve(recommendList)
        }, 300);
      });
    }

    try {
      const response =
        await httpClient.get<BaseResponse<AppResultResponse<RecommendItem>>>('/personalized/playlist', { limit: 10 });
      Logger.info({ domain: 'Net', tag: 'HomeService' },
        `Recommend playlist result:${JSON.stringify(response.data.result)}`);
      if (response.data.code === 200) {
        const rawList = response.data.result;
        return rawList.map((item: ESObject) => RecommendItem.fromJson(item));
      }
      return [];
    } catch (error) {
      Logger.error({ domain: 'Net', tag: 'HomeService' }, `Recommend playlist error:${JSON.stringify(error)}`)
      return [];
    }
  }

  static async getNewSongs(): Promise<RecommendItem[]> {
    if (IS_DEBUG) {
      return new Promise((resolve) => {
        setTimeout(() => {
          const newSongsRawList: ESObject[] = JSON.parse(NEW_SONG) as ESObject[];
          const items: RecommendItem[] =
            newSongsRawList.map((item: ESObject) => RecommendItem.fromJson(item));
          resolve(items)
        }, 300);
      });
    }

    try {
      const response = await httpClient.get<BaseResponse<AppResultResponse<RecommendItem>>>('/personalized/newsong');
      Logger.info({ domain: 'Net', tag: 'HomeService' },
        `New songs list:${JSON.stringify(response.data.result)}`);
      if (response.data.code === 200) {
        const rawList = response.data.result;
        return rawList.map((item: ESObject) => RecommendItem.fromJson(item));
      }
      return [];
    } catch (error) {
      Logger.error({ domain: 'Net', tag: 'HomeService' }, `New songs list error:${JSON.stringify(error)}`)
      return [];
    }
  }

  static async getPrivateContent(): Promise<PersonalItem[]> {
    if (IS_DEBUG) {
      return new Promise((resolve) => {
        setTimeout(() => {
          const contentRawList: ESObject[] = JSON.parse(PRIVATE_CONTENT) as ESObject[];
          const items: PersonalItem[] =
            contentRawList.map((item: ESObject) => PersonalItem.fromJson(item));
          resolve(items)
        }, 300);
      });
    }

    try {
      const response =
        await httpClient.get<BaseResponse<AppResultResponse<PersonalItem>>>('/personalized/privatecontent');
      Logger.info({ domain: 'Net', tag: 'HomeService' },
        `Private contet:${JSON.stringify(response.data)}`);
      if (response.data.code === 200) {
        const rawList = response.data.result;
        return rawList.map((item: ESObject) => PersonalItem.fromJson(item));
      }
      return [];
    } catch (error) {
      Logger.error({ domain: 'Net', tag: 'HomeService' }, `Private content error:${JSON.stringify(error)}`)
      return [];
    }
  }

  static async getPersonalMV(): Promise<MVItem[]> {
    if (IS_DEBUG) {
      return new Promise((resolve) => {
        setTimeout(() => {
          const contentRawList: ESObject[] = JSON.parse(PRIVATE_MV) as ESObject[];
          const items: MVItem[] =
            contentRawList.map((item: ESObject) => MVItem.fromJson(item));
          resolve(items)
        }, 300);
      });
    }

    try {
      const response = await httpClient.get<BaseResponse<AppResultResponse<MVItem>>>('/personalized/mv');
      Logger.info({ domain: 'Net', tag: 'HomeService' },
        `Personal mv:${JSON.stringify(response.data)}`);
      if (response.data.code === 200) {
        const rawList = response.data.result;
        return rawList.map((item: ESObject) => MVItem.fromJson(item));
      }
      return [];
    } catch (error) {
      Logger.error({ domain: 'Net', tag: 'HomeService' }, `Personal mv error:${JSON.stringify(error)}`)
      return [];
    }
  }

  static async getNewAlbums(): Promise<AlbumItem[]> {
    try {
      const response =
        await httpClient.get<BaseResponse<AppAlbumResponse<AlbumItem>>>('/top/playlist', { limit: 10, order: 'new' })
      Logger.info({ domain: 'Net', tag: 'HomeService' },
        `New albums:${JSON.stringify(response.data)}`);
      if (response.data.code === 200) {
        const rawData = response.data.albums;
        return rawData.map((item: ESObject) => AlbumItem.fromJson(item));
      }
      return [];
    } catch (error) {
      Logger.error({ domain: 'Net', tag: 'HomeService' }, `New albums error:${JSON.stringify(error)}`)
      return [];
    }
  }

  static async getBanners(): Promise<BannerItem[]> {
    try {
      return new Promise((resolve) => {
        setTimeout(() => {
          const bannersRawData: BannerItem[] = JSON.parse(BANNER_DATA) as BannerItem[];
          Logger.info({ domain: 'Net', tag: 'HomeService' }, `Banners data:${JSON.stringify(bannersRawData)}`);
          return resolve(bannersRawData);
        }, 300)
      })
    } catch (error) {
      Logger.error({ domain: 'Net', tag: 'HomeService' }, `Banners data error:${JSON.stringify(error)}`)
      return [];
    }
  }

  static async getCateList(): Promise<CateItem[][]> {
    try {
      return new Promise((resolve) => {
        setTimeout(() => {
          const cateItems: CateItem[][] = CATE_LIST;
          resolve(cateItems);
        }, 300)
      })
    } catch (error) {
      Logger.error({ domain: 'Net', tag: 'HomeService' }, `Cate list error:${JSON.stringify(error)}`)
      return [];
    }
  }
}