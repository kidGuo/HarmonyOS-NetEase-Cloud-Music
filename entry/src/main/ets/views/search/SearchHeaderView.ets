/**
 * Author: Finn Guo
 * Date: 2025/12/28
 */
import { SearchTopCate } from '../../models/search/SearchTopCate';

@ComponentV2
export struct SearchHeaderView {
  @Param items: SearchTopCate[] = [];

  build() {
    Row() {
      ForEach(this.items, (item: SearchTopCate, idx: number) => {
        Column() {
          Image($r(item.icon))
            .objectFit(ImageFit.Cover)
            .width(30)
            .height(30)

          Blank()
            .height(6)

          Text(item.title)
            .textAlign(TextAlign.Center)
            .fontSize(16)
            .fontColor(Color.Black)
        }
        .alignItems(HorizontalAlign.Center)
        .layoutWeight(1)
      }, (item: SearchTopCate) => item.id.toString());
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceEvenly)
    .padding({
      top: 10,
      left: 26,
      bottom: 20,
      right: 26
    })
  }
}