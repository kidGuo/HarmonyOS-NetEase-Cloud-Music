/**
 * Author: Finn Guo
 * Date: 2025/12/21
 */
import { Logger } from '../../utils/Logger';

@Preview
@ComponentV2
export struct PodcastPage {
  @Param @Once isActive: boolean = false;
  private hasLoaded: boolean = false;

  @Monitor('isActive')
  onActiveChange(monitor: IMonitor) {
    monitor.dirty.forEach((path) => {
      Logger.info({ domain: 'Podcast' },
        `is active:${this.isActive}, before:${monitor.value(path)?.before}, now:${monitor.value(path)?.now}`)
    })
  }

  aboutToAppear(): void {
    Logger.info({ domain: 'PodcastPage' }, 'about to appear')
  }

  build() {
    Column() {
      Text('PodcastPage')
        .fontSize(20)
        .fontColor(Color.Red)
    }
    .width('100%')
    .height('100%')
  }
}