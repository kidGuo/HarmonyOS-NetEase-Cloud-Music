/**
 * Author: Finn Guo
 * Date: 2025/12/21
 */
import { Logger } from '../../utils/Logger'

@Preview
@ComponentV2
export struct AIWriterPage {
  aboutToAppear(): void {
    Logger.info({ domain: 'AIWriterPage' }, 'about to appear')
  }

  build() {
    Column() {
      Text('AIWriterPage')
        .fontSize(20)
        .fontColor(Color.Red)
    }
    .width('100%')
    .height('100%')
  }
}