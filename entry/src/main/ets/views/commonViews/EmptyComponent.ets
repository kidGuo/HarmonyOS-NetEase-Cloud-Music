/**
 * Author: Finn Guo
 * Date: 2026/1/10
 */

@ComponentV2
export struct EmptyComponent {
  build() {
    Column() {
      Image($r('app.media.empty'))
        .objectFit(ImageFit.Contain)
    }
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Color.White)
  }
}