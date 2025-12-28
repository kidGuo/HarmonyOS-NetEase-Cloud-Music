/**
 * Author: Finn Guo
 * Date: 2025/12/21
 */
import { webview } from '@kit.ArkWeb';
import { Logger } from '../../utils/Logger';
import { WebComponent, WebParams } from './WebComponent';
import json from '@ohos.util.json';

@Builder
function webPageBuilder() {
  WebPage()
}

@Preview
@ComponentV2
export struct WebPage {
  @Local targetUrl: string = '';
  @Local title: string = '';
  @Consumer() pathStack: NavPathStack = new NavPathStack();
  private controller: WebviewController = new webview.WebviewController();

  build() {
    NavDestination() {
      Column() {
        WebComponent({
          url: this.targetUrl,
          webController: this.controller,
          onTitleUpdate: (title: string) => {
            this.title = title;
          }
        })
          .width('100%')
          .height('100%')
      }
      .width('100%')
      .height('100%')
    }
    .title(this.title)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .onReady((context: NavDestinationContext) => {
      const params = context.pathInfo.param as WebParams
      if (params && params.url) {
        this.targetUrl = params.url;
      }
      const config = context.getConfigInRouteMap();
      Logger.info({ domain: "Webview" },
        `params:${JSON.stringify(params)}, url:${this.targetUrl}, router_config:${json.stringify(config)}`)
    })
  }
}