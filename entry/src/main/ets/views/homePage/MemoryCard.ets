/**
 * Author: Finn Guo
 * Date: 2025/12/21
 */
import { TopListItem } from '../../models/home/TopListItem';
import { Logger } from '../../utils/Logger';
import { RowEntity } from '../commonViews/ScrollRow';

@Preview
@ComponentV2
export struct MemoryCard {
  @Param @Require item: RowEntity;

  aboutToAppear(): void {
    Logger.info({ domain: 'Home', tag: 'MemoryCard' },
      `Memory card, title:${this.item.title}, name:${(this.item as TopListItem).name}, desc:${this.item.description}`)
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.TopStart }) {
        Image(this.item.coverImgUrl)
          .width('100%')
          .height('100%')

        Text(this.item.title)
          .fontSize(16)
          .fontColor(Color.White)
          .position({ x: 12, y: 12 })

        Column() {
          Text(this.item.description)
            .fontSize(14)
            .fontColor(Color.White)
            .maxLines(2)
            .textAlign(TextAlign.Start)
        }
        .width('100%')
        .height('25%')
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .backgroundBlurStyle(BlurStyle.Thin)
        .position({ x: 0, y: '75%' })
      }
      .width('100%')
      .height('100%')
    }
  }
}