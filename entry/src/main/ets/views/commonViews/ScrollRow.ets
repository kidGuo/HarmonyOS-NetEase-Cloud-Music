/**
 * Author: Finn Guo
 * Date: 2025/12/21
 */

export interface RowEntity {
  id: string | number;
  title: string;
  coverImgUrl: string;
  description: string;
}

@Preview
@ComponentV2
export struct ScrollRow {
  @Param items: RowEntity[] = [];
  @Param itemExtent: Length = 20;
  @Param itemSpace: string | number | undefined = 0;
  @BuilderParam cardBuilder: (item: RowEntity, index: number) => void = this.defaultCardBuilder;
  @Event onCardSelect?: (item: RowEntity, index: number) => void;

  @Builder
  defaultCardBuilder(item: RowEntity, index: number) {
  }

  build() {
    Column() {
      List({ space: this.itemSpace }) {
        ForEach(this.items, (item: RowEntity, index: number) => {
          ListItem() {
            if (this.cardBuilder) {
              this.cardBuilder(item, index);
            } else {
              this.defaultCardBuilder(item, index);
            }
          }
          .width(this.itemExtent)
          .onClick(() => {
            this.onCardSelect?.(item, index);
          })
        }, (item: RowEntity) => item.id.toString());
      }
      .listDirection(Axis.Horizontal)
      .scrollBar(BarState.Off)
      .padding({ left: 16, right: 16 })
      .clip(false)
      .width('100%')
      .height('100%')
    }
  }
}


@ComponentV2
export struct ScrollGroupRow {
  @Param itemsGroup: RowEntity[][] = [];
  @Param itemExtent: Length = 20;
  @Param itemSpace: string | number | undefined = 0;
  @BuilderParam cardBuilder: (items: RowEntity[], groupIndex: number) => void = this.defaultCardBuilder;

  @Builder
  defaultCardBuilder(items: RowEntity[], groupIndex: number) {
  }

  build() {
    Column() {
      List({ space: this.itemSpace }) {
        ForEach(this.itemsGroup, (items: RowEntity[], index: number) => {
          ListItem() {
            if (this.cardBuilder) {
              this.cardBuilder(items, index);
            } else {
              this.defaultCardBuilder(items, index);
            }
          }
          .width(this.itemExtent)
          .height('100%')
        }, (item: RowEntity[]) => item[0].id.toString());
      }
      .listDirection(Axis.Horizontal)
      .scrollBar(BarState.Off)
      .padding({ left: 16, right: 16 })
      .clip(false)
      .width('100%')
      .height('100%')
    }
  }
}