/**
 * Author: Finn Guo
 * Date: 2025/12/20
 */
import { TabBarItem } from '../../models/main/TabBarItem';
import MainViewModel from '../../viewModels/main/MainViewModel';
import { PlayerBar } from '../../views/player/PlayerBar';
import { CategoryPage } from '../category/CategoryPage';
import { HomePage } from '../home/HomePage';
import { MinePage } from '../mine/MinePage';
import { NotePage } from '../note/NotePage';
import { DrawerPage } from './DrawerPage';
import { emitter } from '@kit.BasicServicesKit';
import { EVENT_ID_TAB_SEGMENT_INDEX_DATA } from '../../utils/EventData';
import { MusicPlaybackState } from '../../models/player/MusicPlaybackState';
import { AppStorageV2 } from '@kit.ArkUI';

@Builder
function mainPageBuilder() {
  MainPage()
}

@Preview
@ComponentV2
export struct MainPage {
  @Local currentIdx: number = 0;
  @Local segmentIdx: number = 1;
  mainViewModel: MainViewModel = new MainViewModel();
  playbackState: MusicPlaybackState =
    AppStorageV2.connect(MusicPlaybackState, 'MusicPlaybackState', () => new MusicPlaybackState())!

  aboutToAppear(): void {
    emitter.on({ eventId: EVENT_ID_TAB_SEGMENT_INDEX_DATA }, (eventData) => {
      if (eventData.data) {
        this.segmentIdx = eventData.data.segmentIdx;
      }
    })
  }

  @Computed
  get shouldShowPlayerBar(): boolean {
    if (!this.playbackState.isPlayed) {
      return false;
    }
    const isAtHomeFirstSegment = this.currentIdx === 0 && this.segmentIdx === 0;
    return !isAtHomeFirstSegment;
  }

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
    .backgroundColor(Color.Transparent)
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Bottom }) {
        Tabs() {
          ForEach(this.mainViewModel.tabItems, (tabBarItem: TabBarItem, idx: number) => {
            TabContent() {
              if (tabBarItem.id === '2025001') {
                HomePage()
              } else if (tabBarItem.id === '2025002') {
                CategoryPage();
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

        // 播放条
        if (this.shouldShowPlayerBar) {
          PlayerBar()
            .margin({ bottom: 56 })
        }

        // 侧栏
        DrawerPage()
      }
    }
    .hideTitleBar(true)
  }
}