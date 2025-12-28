/**
 * Author: Finn Guo
 * Date: 2025/12/21
 */
import { RowEntity } from '../../views/commonViews/ScrollRow';
import { ArtistItem } from './ArtistItem';

export class AlbumItem implements RowEntity {
  id: number = 0;
  name: string = '';
  type: string = '';
  size: number = 0;
  picId: number = 0;
  blurPicUrl: string = '';
  companyId: number = 0;
  picUrl: string = '';
  description: string = '';
  tags: string = '';
  company: string = '';
  artist: ArtistItem | undefined = undefined;
  songs: string[] = [];
  alias: string[] = [];
  status: number = 0;
  copyrightId: number = 0;
  artists: ArtistItem[] = [];
  subType: string = '';
  transName: string | undefined = undefined;
  onSale: boolean = false;
  mark: number = 0;

  static fromJson(json: ESObject): AlbumItem {
    const item = new AlbumItem();
    item.id = json.id;
    item.name = json.name;
    item.type = json.type;
    item.size = json.size;
    item.picId = json.picId;
    item.blurPicUrl = json.blurPicUrl;
    item.companyId = json.companyId;
    item.picUrl = json.picUrl;
    item.description = json.description;
    item.tags = json.tags;
    item.company = json.company;
    item.artist = json.artist;
    item.songs = json.songs;
    item.alias = json.alias;
    item.status = json.status;
    item.copyrightId = json.copyrightId;
    item.artists = json.artists;
    item.subType = json.subType;
    item.transName = json.transName;
    item.onSale = json.onSale;
    item.mark = json.mark;
    return item;
  }

  get title(): string {
    return this.name;
  }

  get coverImgUrl(): string {
    return this.picUrl;
  }
}