/**
 * Author: Finn Guo
 * Date: 2026/1/10
 */
import { MineFavItem } from '../../models/mine/MineFavItem';
import { MineMusicCard } from './MineMusicCard';

@ComponentV2
export struct MineMusicComponent {
  @Param items: MineFavItem[] = [];

  build() {
    List() {
      ForEach(this.items, (item: MineFavItem, index: number) => {
        MineMusicCard({
          item: item,
          index: index
        })
          .width('100%')
          .height(80)
      }, (item: MineFavItem, index: number) => item.id.toString())
    }
    .scrollBar(BarState.Off)
    .enabled(false)
    .width('100%')
    .height('100%')
  }
}