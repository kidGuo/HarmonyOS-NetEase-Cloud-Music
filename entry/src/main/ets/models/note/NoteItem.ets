/**
 * Author: Finn Guo
 * Date: 2026/1/4
 */

export class NoteItem {
  id: number = 0;
  pageURL: string = '';
  tags: string = '';
  previewURL: string = '';
  previewWidth: number = 0;
  previewHeight: number = 0;
  webformatURL: string = '';
  webformatWidth: number = 0;
  webformatHeight: number = 0;
  largeImageURL: string = '';
  imageWidth: number = 0;
  imageHeight: number = 0;
  imageSize: number = 0;
  views: number = 0;
  collections: number = 0;
  likes: number = 0;
  comments: number = 0;
  userImageURL: string = '';
  user_id: number = 0;

  static fromJson(json: ESObject): NoteItem {
    const item = new NoteItem();
    item.id = json.id;
    item.pageURL = json.pageURL;
    item.tags = json.tags;
    item.previewURL = json.previewURL;
    item.previewWidth = json.previewWidth;
    item.previewHeight = json.previewHeight;
    item.webformatURL = json.webformatURL;
    item.webformatWidth = json.webformatWidth;
    item.webformatHeight = json.webformatHeight;
    item.largeImageURL = json.largeImageURL;
    item.imageWidth = json.imageWidth;
    item.imageHeight = json.imageHeight;
    item.imageSize = json.imageSize;
    item.views = json.views;
    item.collections = json.collections;
    item.likes = json.likes;
    item.comments = json.comments;
    item.userImageURL = json.userImageURL;
    item.user_id = json.user_id;
    return item;
  }
}