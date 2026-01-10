/**
 * Author: Finn Guo
 * Date: 2025/12/28
 */
import { WaterFlowItem } from '../../views/commonViews/WaterFlow/WaterFlowItem';
import { AlbumItem } from '../home/AlbumItem';
import { SearchTopCate } from './SearchTopCate';

export interface SearchCardResultResponse {
  tracks: SearchCardItem[];
}

export class SearchCardItem implements WaterFlowItem {
  id: string | number = '';
  // 顶部分类
  topCates: SearchTopCate[] = [];
  //
  album: AlbumItem = new AlbumItem();

  static fromJson(json: ESObject): SearchCardItem {
    const item = new SearchCardItem();
    item.id = json.id;
    item.album = AlbumItem.fromJson(json.album)
    return item;
  }
}