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
          Image('')
            .overlay('no:' + idx.toString())
            .objectFit(ImageFit.Cover)
            .width(25)
            .height(25)

          Blank()
            .height(12)

          Text(item.title)
            .textAlign(TextAlign.Center)
            .fontSize(16)
            .fontColor(Color.Black)
            .width('100%')
        }
        .alignItems(HorizontalAlign.Center)
      }, (item: SearchTopCate) => item.id.toString());
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      top: 20,
      left: 30,
      bottom: 20,
      right: 30
    })
  }
}