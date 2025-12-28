/**
 * Author: Finn Guo
 * Date: 2025/12/21
 */
import { RecommendItem } from '../../models/home/RecommendItem';

@Preview
@ComponentV2
export struct RecommendView {
  @Param recommendItems: RecommendItem[] = [];
  @Event onRecommendSelect?: (index: number, item: RecommendItem) => void = () => {
  };
  // 本地数据
  private labelNames: string[] = ['每日推荐', '漫游', '歌单推荐', '私人雷达', '心动模式', '每日博客'];

  build() {
    Column() {
      List({ space: 10 }) {
        ForEach(this.recommendItems, (item: RecommendItem, index: number) => {
          ListItem() {
            Stack({ alignContent: Alignment.Top }) {
              Image(item.picUrl)
                .objectFit(ImageFit.Cover)
                .width('100%')
                .height('100%')

              Text(this.labelNames[index % this.labelNames.length])
                .fontColor(Color.White)
                .fontSize(16)
                .fontWeight(FontWeight.Bolder)
                .position({ x: 12, y: 12 })

              Row() {
                if (index === 0) {
                  Text('免费听')
                    .fontSize(12)
                    .fontColor(Color.White)
                    .padding({
                      top: 2,
                      left: 4,
                      bottom: 2,
                      right: 4
                    })
                    .borderRadius(2)
                    .backgroundColor('#80000000')
                }
                Blank()
                if ([0, 2, 5].includes(index)) {
                  Image($r('app.media.ic_play'))
                    .objectFit(ImageFit.Cover)
                    .width(20)
                    .height(20)
                }
              }
              .width('100%')
              .padding({ left: 12, right: 12 })
              .position({ x: 0, y: '55%' })

              Column() {
                Text(item.name)
                  .fontSize(14)
                  .fontColor(Color.White)
                  .fontWeight(FontWeight.Medium)
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .textAlign(TextAlign.Center)
                  .padding({ left: 10, right: 10 })
              }
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
              .backgroundBlurStyle(BlurStyle.Thin)
              .width('100%')
              .height('26%')
              .position({ x: 0, y: '74%' })
            }
            .clip(true)
            .borderRadius(4)
          }
          .width(160)
          .onClick(() => {
            this.onRecommendSelect?.(index, item);
          })
        }, (item: RecommendItem) => item.id.toString())
      }
      .scrollBar(BarState.Off)
      .listDirection(Axis.Horizontal)
      .padding({ left: 16, right: 16 })
      .clip(false)
      .width('100%')
      .height('100%')
    }
  }
}