/**
 * Author: Finn Guo
 * Date: 2025/12/22
 */
import { Logger } from '../../utils/Logger'

@Preview
@ComponentV2
export struct AudiobookPlayerPage {
  aboutToAppear(): void {
    Logger.info({ domain: 'AudiobookPlayerPage' }, 'about to appear')
  }

  build() {
    Column() {
      Text('AudiobookPlayerPage')
        .fontSize(20)
        .fontColor(Color.Red)
    }
    .width('100%')
    .height('100%')
  }
}