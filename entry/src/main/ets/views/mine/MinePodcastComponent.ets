/**
 * Author: Finn Guo
 * Date: 2026/1/10
 */
import { EmptyComponent } from '../commonViews/EmptyComponent'

@ComponentV2
export struct MinePodcastComponent {
  build() {
    Column() {
      EmptyComponent()
        .width('100%')
        .height('100%')
    }
    .justifyContent(FlexAlign.Center)
  }
}