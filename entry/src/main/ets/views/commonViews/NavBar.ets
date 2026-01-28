/**
 * Author: Finn Guo
 * Date: 2026/1/25
 */

@ComponentV2
export struct NavBar {
  @Param title: ResourceStr = '';
  @Consumer() pathStack: NavPathStack = new NavPathStack();
  @Event onBack: () => void = () => {
    this.pathStack.pop()
  };

  build() {
    Row({ space: 10 }) {
      Column() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize(24)
          .fontWeight(FontWeight.Normal)
      }
      .width(40)
      .height(40)
      .margin({ right: 8 })
      .borderRadius('100%')
      .justifyContent(FlexAlign.Center)
      .backgroundColor($r('sys.color.comp_background_tertiary'))
      .onClick(() => {
        this.onBack();
      })

      Text(this.title)
        .width('100%')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
    }
    .width('100%')
    .height(56)
    .alignItems(VerticalAlign.Center)
  }
}