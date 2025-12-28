/**
 * Author: Finn Guo
 * Date: 2025/12/21
 */
import { RowEntity } from '../../views/commonViews/ScrollRow';
import { SongItem } from './SongItem';

export class RecommendItem implements RowEntity {
  id: number = 0;
  type: number = 0;
  name: string = '';
  picUrl: string = '';
  canDislike: boolean = false;
  alg: string = '';
  song: SongItem | undefined = undefined;

  static fromJson(json: ESObject): RecommendItem {
    const item = new RecommendItem();
    item.id = json.id;
    item.type = json.type;
    item.name = json.name ?? '';
    item.picUrl = json.picUrl ?? '';
    item.canDislike = json.canDislike ?? false;
    item.alg = json.alg ?? '';
    item.song = json.song;
    return item;
  }

  get title(): string {
    return this.name;
  }

  get coverImgUrl(): string {
    return this.picUrl;
  }

  get description(): string {
    return '';
  }
}