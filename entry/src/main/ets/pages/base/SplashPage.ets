/**
 * Author: Finn Guo
 * Date: 2025/12/20
 */

@Builder
export function splashPageBuilder() {
  SplashPage()
}

@Preview
@ComponentV2
export struct SplashPage {
  @Local countDown: number = 5;
  @Consumer() pathStack: NavPathStack = new NavPathStack();
  private timerId?: number;

  build() {
    NavDestination() {
      Stack() {
        Image($r('app.media.launch_image'))
          .objectFit(ImageFit.Cover)
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
          .width('100%')
          .height('100%')
        Text(`跳过 ${this.countDown}`)
          .textAlign(TextAlign.Center)
          .fontSize(14)
          .fontColor(Color.White)
          .position({ top: 0, right: 0 })
          .margin(16)
          .padding({
            top: 8,
            left: 12,
            bottom: 8,
            right: 12
          })
          .backgroundColor('#FF858585')
          .border({
            radius: '30%'
          })
          .onAppear(() => {
            if (!this.timerId) {
              this.timerId = setInterval(() => {
                if (this.countDown < 1) {
                  clearInterval(this.timerId);
                  this.pathStack.replacePathByName('Main', false);
                } else {
                  this.countDown--;
                }
              }, 1000);
            }
          })
          .onClick(() => {
            clearInterval(this.timerId);
            this.pathStack.replacePathByName('Main', false);
          })
      }
    }
    .backgroundColor(Color.Black)
    .width('100%')
    .height('100%')
  }
}