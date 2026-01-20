/**
 * Author: Finn Guo
 * Date: 2026/1/18
 */
import { NoteItem } from '../../models/note/NoteItem';
import { Logger } from '../../utils/Logger';
import { JSON } from '@kit.ArkTS';

@Builder
function noteDetailPageBuilder(name: string, param: Object) {
  NoteDetailPage({ item: param as NoteItem })
}

@Preview
@ComponentV2
export struct NoteDetailPage {
  @Consumer() pathStack: NavPathStack = new NavPathStack();
  @Param item: NoteItem | undefined = undefined;

  aboutToAppear(): void {
    // const params = this.pathStack.getParamByName('NoteDetail') as Array<NoteItem>;
    // if (params && params.length > 0) {
    //   this.item = params[params.length - 1];
    // }
    Logger.info({ domain: 'NoteDetail' }, `note item:${JSON.stringify(this.item)}}`);
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Top }) {
        // 优雅的背景淡入
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor(Color.White)
          .transition(TransitionEffect.OPACITY.animation({ duration: 3500, curve: Curve.Linear }))

        // 优雅的图片飞跃
        if (this.item && this.item.previewURL) {
          Image(this.item.previewURL)
            .geometryTransition(this.item.id.toString(), { follow: true })
            .width('100%')
            .aspectRatio(this.item.webformatWidth / this.item.webformatHeight)
            .objectFit(ImageFit.Cover)
            // 为了让你观察“优雅”的路径，暂时将弹簧曲线改为时长控制
            .animation({
              duration: 3500,
              curve: Curve.EaseInOut // 先加速后减速，方便观察
            })
        }
      }
    }
    .hideTitleBar(true)
    .backgroundColor(Color.Transparent)
    .transition(TransitionEffect.IDENTITY)
  }

  // pageTransition() {
  //   PageTransitionEnter({ type: RouteType.Push, duration: 400 })
  //     .opacity(0) // 页面整体淡入，配合图片飞跃
  //   PageTransitionExit({ type: RouteType.Pop, duration: 400 })
  //     .opacity(0) // 返回时整体淡出
  // }
}