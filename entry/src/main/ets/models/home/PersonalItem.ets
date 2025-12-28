/**
 * Author: Finn Guo
 * Date: 2025/12/21
 */
import { RowEntity } from '../../views/commonViews/ScrollRow';

export class PersonalItem implements RowEntity {
  id: number = 0;
  url: string = '';
  picUrl: string = '';
  sPicUrl: string = '';
  type: number = 0;
  copywriter: string = '';
  name: string = '';

  static fromJson(json: ESObject): PersonalItem {
    const item = new PersonalItem();
    item.id = json.id;
    item.url = json.url;
    item.picUrl = json.picUrl;
    item.sPicUrl = json.sPicUrl;
    item.type = json.type;
    item.copywriter = json.copywriter;
    item.name = json.name;
    return item;
  }

  get title(): string {
    return this.name;
  }

  get coverImgUrl(): string {
    return this.sPicUrl;
  }

  get description(): string {
    return this.copywriter;
  }
}