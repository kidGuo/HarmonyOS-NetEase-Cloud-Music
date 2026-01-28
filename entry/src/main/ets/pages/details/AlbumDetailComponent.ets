/**
 * Author: Finn Guo
 * Date: 2026/1/25
 */
import { EmptyComponent } from '../../views/commonViews/EmptyComponent';

@Preview
@ComponentV2
export struct AlbumDetailComponent {
  @Event onBack: () => void = () => {
  };

  build() {
    Column() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(40)
          .borderRadius('50%')
      }
      .justifyContent(FlexAlign.Start)
      .margin({ left: 16, top: 12 })
      .height(44)
      .onClick(() => {
        this.onBack();
      })

      EmptyComponent()
        .width('100%')
        .layoutWeight(1)
    }
    .alignItems(HorizontalAlign.Start)
  }
}