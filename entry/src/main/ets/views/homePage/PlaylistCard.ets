/**
 * Author: Finn Guo
 * Date: 2025/12/21
 */
import { RowEntity } from '../commonViews/ScrollRow';

@Preview
@ComponentV2
export struct PlaylistCard {
  @Param @Require item: RowEntity;

  build() {
    Column() {
      Stack({ alignContent: Alignment.Top }) {
        Image(this.item.coverImgUrl)
          .objectFit(ImageFit.Cover)
          .width('100%')
          .height('100%')

        Row() {
          Image($r('app.media.ic_listen_music'))
            .objectFit(ImageFit.Contain)
            .width(14)
            .margin({ right: 4 })
            .aspectRatio(1.0)
          Text('10.6万')
            .fontColor(Color.White)
            .fontSize(10)
            .maxLines(1)
            .fontSize(FontWeight.Bold)
        }
        .position({ x: 8, y: 10 })

        Image($r('app.media.ic_play'))
          .objectFit(ImageFit.Cover)
          .width(20)
          .height(20)
          .position({ x: '80%', y: '60%' })

        Row() {
          Text(this.item.title)
            .fontSize(14)
            .fontColor(Color.Black)
            .textAlign(TextAlign.Start)
            .maxLines(2)
            .margin({
              left: 8,
              right: 8
            })
        }
        .backgroundColor(Color.White)
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .height('25%')
        .position({ x: 0, y: '75%' })
      }
      .borderRadius(4)
      .width('100%')
      .height('100%')
      .backgroundColor((Math.random() * 100 > 50 ? Color.Red : Color.Green))
    }
  }
}