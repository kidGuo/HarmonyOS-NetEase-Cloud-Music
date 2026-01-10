/**
 * Author: Finn Guo
 * Date: 2026/1/10
 */
import { MineFavItem } from '../../models/mine/MineFavItem';

@ComponentV2
export struct MineMusicCard {
  @Param item: MineFavItem | null = null;
  @Param index: number = -1;

  build() {
    Row() {
      Image(this.item?.picUrl || '')
        .size({ width: 60, height: 60 })
        .borderRadius(8)
        .margin({ right: 10 })

      Column() {
        Text((this.index === 0 ? '我喜欢的音乐' : this.item?.name))
          .fontColor(Color.Black)
          .fontSize(16)
        Text('177首·3350次播放')
          .fontColor('#4D000000')
          .fontSize(14)
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Image($r('app.media.more'))
        .size({ width: 24, height: 24 })
    }
  }
}