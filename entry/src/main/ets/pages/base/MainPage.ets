/**
 * Author: Finn Guo
 * Date: 2025/12/20
 */
import { TabBarItem } from '../../models/main/TabBarItem';
import MainViewModel from '../../viewModels/main/MainViewModel';
import { HomePage } from '../home/HomePage';
import { MinePage } from '../mine/MinePage';
import { NotePage } from '../note/NotePage';
import { SearchPage } from '../search/SearchPage';

@Builder
function mainPageBuilder() {
  MainPage()
}

@Preview
@ComponentV2
export struct MainPage {
  @Local currentIdx: number = 0;
  mainViewModel: MainViewModel = new MainViewModel();

  @Builder
  tabBarBuilder(tabBarItem: TabBarItem, index: number) {
    Column() {
      Text(tabBarItem.name)
        .textAlign(TextAlign.Center)
        .fontWeight(FontWeight.Bold)
        .fontSize(16)
        .fontColor(this.currentIdx === index ? tabBarItem.selectedColor : tabBarItem.color)
    }
    .height(48)
    .width('100%')
    .margin({ top: 16 })
    .alignItems(HorizontalAlign.Center)
  }

  build() {
    NavDestination() {
      Stack() {
        Tabs() {
          ForEach(this.mainViewModel.tabItems, (tabBarItem: TabBarItem, idx: number) => {
            TabContent() {
              if (tabBarItem.id === '2025001') {
                HomePage();
              } else if (tabBarItem.id === '2025002') {
                SearchPage();
              } else if (tabBarItem.id === '2025003') {
                NotePage();
              } else if (tabBarItem.id === '2025004') {
                MinePage();
              } else {
                Column()
              }
            }
            .tabBar(this.tabBarBuilder(tabBarItem, idx));
          }, (tabBarItem: TabBarItem) => tabBarItem.id);
        }
        .barPosition(BarPosition.End)
        .scrollable(false)
        .barBackgroundColor('#EFEDF0')
        .width('100%')
        .height('100%')
        .barBackgroundEffect({
          radius: 20
        })
        .onChange((index: number) => {
          this.currentIdx = index;
        })
      }
    }
    .hideTitleBar(true)
  }
}