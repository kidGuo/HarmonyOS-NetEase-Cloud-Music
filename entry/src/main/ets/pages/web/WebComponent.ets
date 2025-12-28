/**
 * Author: Finn Guo
 * Date: 2025/12/27
 */
import { webview } from '@kit.ArkWeb';

export interface WebParams {
  url: string;
}

@ComponentV2
export struct WebComponent {
  @Param url: string = '';
  @Param webController: WebviewController = new webview.WebviewController;
  @Event onTitleUpdate?: (title: string) => void = (title: string) => {
  };

  build() {
    Web({
      src: this.url,
      controller: this.webController
    })
      .onTitleReceive((event) => {
        this.onTitleUpdate?.(event.title);
      })
  }
}