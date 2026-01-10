/**
 * Author: Finn Guo
 * Date: 2025/12/28
 */
import { SearchCardItem } from '../../models/search/SearchCardItem';

@Preview
@ComponentV2
export struct SearchCard {
  @Param item: SearchCardItem = new SearchCardItem();

  build() {
    Stack({ alignContent: Alignment.Start }) {
      Image(this.item.album.picUrl)
        .objectFit(ImageFit.Cover)
        .aspectRatio(1)
        .width('100%')
        .backgroundColor(Color.White)

      Row() {
        Column() {
          Text(this.item.album.name)
            .maxLines(1)
            .fontSize(16)
            .fontColor(Color.White)
            .textAlign(TextAlign.Start)
            .margin({ bottom: 6 })
          Text(this.item.album.company)
            .maxLines(1)
            .fontSize(12)
            .fontColor(Color.White)
            .textAlign(TextAlign.Start)
            .margin({ bottom: 8 })
        }
        .margin({ left: 8 })
        .alignItems(HorizontalAlign.Start)
      }
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Bottom)
      .width('60%')
      .height('100%')
    }
    .borderRadius(8)
    .clip(true)
  }
}