import { Logger } from '../utils/Logger';

@Entry
@ComponentV2
struct Index {
  @Provider() pathStack: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    Logger.info({ domain: 'Index' }, 'about to appear', 'Index')
  }

  build() {
    Navigation(this.pathStack) {

    }
    .onAppear(() => {
      Logger.info({ domain: 'Index' }, 'on appear', 'Index');
      this.pathStack.replacePathByName('Splash', false);
    })
    .hideNavBar(true)
  }
}