/**
 * Author: Finn Guo
 * Date: 2026/1/18
 */
import { NoteItem } from '../../models/note/NoteItem';
import { Logger } from '../../utils/Logger';
import { JSON } from '@kit.ArkTS';
import { NavBar } from '../../views/commonViews/NavBar';

@Builder
function noteDetailPageBuilder(name: string, param: Object) {
  NoteDetailPage({ item: param as NoteItem })
}

@Preview
@ComponentV2
export struct NoteDetailPage {
  @Consumer() pathStack: NavPathStack = new NavPathStack();
  @Param item: NoteItem | null = null;
  @Event onBack: () => void = () => {
  };

  aboutToAppear(): void {
    Logger.info({ domain: 'NoteDetail' }, `note item:${JSON.stringify(this.item)}}`);
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      // 优雅的背景淡入
      Column() {
        NavBar({
          title: '笔记详情',
          onBack: () => this.onBack()
        })
          .padding({
            bottom: 12,
            left: 16,
            right: 16
          })

        // 优雅的图片飞跃
        if (this.item && this.item.previewURL) {
          Image(this.item.previewURL)
            .geometryTransition(this.item.id.toString(), { follow: true })
            .width('100%')
            .aspectRatio(1)
            .objectFit(ImageFit.Contain)
        }
      }
      .width('100%')
      .height('100%')
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .transition(TransitionEffect.OPACITY)
    .backgroundColor(Color.White)
    .width('100%')
    .height('100%')
  }
}