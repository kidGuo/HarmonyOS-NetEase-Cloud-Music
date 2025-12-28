/**
 * Author: Finn Guo
 * Date: 2025/12/21
 */
import { RowEntity } from '../commonViews/ScrollRow';

@Preview
@ComponentV2
export struct GroupCard {
  @Param items: RowEntity[] = [];
  @Event onCardSelect?: (item: RowEntity, index: number) => void;

  build() {
    Column() {
      ForEach(this.items, (item: RowEntity, index: number) => {
        Row() {
          Image(item.coverImgUrl)
            .objectFit(ImageFit.Cover)
            .height('80%')
            .aspectRatio(1)
            .borderRadius(8)
            .margin({ right: 2 })
            .clip(true)

          Column() {
            Text(item.title)
              .fontColor(Color.Black)
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .maxLines(1)
            Blank()
              .height(12)
            Text(item.description)
              .fontColor(Color.Gray)
              .fontSize(12)
              .maxLines(1)
          }
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Start)
          .height('100%')

          Image($r('app.media.black_play_icon'))
            .width(20)
            .aspectRatio(1)
        }
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.SpaceBetween)
        .layoutWeight(1)
        .width('100%')
        .onClick(() => {
          this.onCardSelect?.(item, index);
        })
      }, (item: RowEntity) => item.id.toString())
    }
    .justifyContent(FlexAlign.SpaceEvenly)
    .alignItems(HorizontalAlign.Start)
  }
}