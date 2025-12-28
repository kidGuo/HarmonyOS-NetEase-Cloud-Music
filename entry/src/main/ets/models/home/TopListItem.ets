/**
 * Author: Finn Guo
 * Date: 2025/12/21
 */
import { RowEntity } from '../../views/commonViews/ScrollRow';

export class TopListItem implements RowEntity {
  id: number = 0;
  name: string = '';
  description: string = '';
  coverImgUrl: string = '';

  static fromJson(json: ESObject): TopListItem {
    const item = new TopListItem();
    item.id = json.id;
    item.name = json.name;
    item.description = json.description;
    item.coverImgUrl = json.coverImgUrl;
    return item;
  }

  get title(): string {
    return this.name;
  }
}