/**
 * Author: Finn Guo
 * Date: 2025/12/21
 */
import { RowEntity } from '../../views/commonViews/ScrollRow';
import { ArtistItem } from './ArtistItem';

export class MVItem implements RowEntity {
  id: number = 0;
  type: number = 0;
  name: string = '';
  copywriter: string = '';
  picUrl: string = '';
  playCount: number = 0;
  artists: ArtistItem[] = [];
  artistName: string = '';
  artistId: number = 0;
  alg: string = '';

  static fromJson(json: ESObject): MVItem {
    const item = new MVItem();
    item.id = json.id;
    item.type = json.type;
    item.name = json.name;
    item.copywriter = json.copywriter;
    item.picUrl = json.picUrl;
    item.playCount = json.playCount;
    item.artists = json.artists;
    item.artistName = json.artistName;
    item.artistId = json.artistId;
    item.alg = json.alg;
    return item;
  }

  get title(): string {
    return this.name;
  }

  get coverImgUrl(): string {
    return this.picUrl;
  }

  get description(): string {
    return this.copywriter;
  }
}