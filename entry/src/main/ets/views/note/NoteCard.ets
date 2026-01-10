/**
 * Author: Finn Guo
 * Date: 2026/1/4
 */
import { NoteItem } from '../../models/note/NoteItem';

@ComponentV2
export struct NoteCard {
  @Param item: NoteItem = new NoteItem();

  build() {
    Column() {
      Image(this.item.previewURL)
        .width('100%')
        .aspectRatio(this.item.webformatWidth / this.item.webformatHeight)
        .margin({ bottom: 8 })

      Text(this.item.tags)
        .fontSize(16)
        .fontColor(Color.Black)
        .maxLines(2)
        .padding({ left: 8, right: 8, bottom: 8 })
        .width('100%')

      Row() {
        Row() {
          Image(this.item.userImageURL)
            .alt($r('app.media.music_icon'))
            .size({ width: 12, height: 12 })
            .borderRadius(6)
            .clip(true)
          Text('网易云')
            .maxLines(1)
            .fontSize(12)
            .padding({ left: 8 })
        }

        Row() {
          Image($r('app.media.like'))
            .size({ width: 12, height: 12 })
            .margin({ right: 2 })
          Text(this.item.likes.toString())
            .fontSize(10)
            .fontColor(Color.Gray)
        }
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ left: 8, right: 8, bottom: 8 })
      .width('100%')
    }
    .alignItems(HorizontalAlign.Start)
    .borderRadius(4)
    .clip(true)
  }
}