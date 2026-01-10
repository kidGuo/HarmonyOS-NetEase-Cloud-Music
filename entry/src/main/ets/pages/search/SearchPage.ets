/**
 * Author: Finn Guo
 * Date: 2025/12/20
 */
import { SearchCardItem } from '../../models/search/SearchCardItem';
import { SearchViewModel } from '../../viewModels/search/SearchViewModel';
import { WaterFlowItem } from '../../views/commonViews/WaterFlow/WaterFlowItem';
import { SearchCard } from '../../views/search/SearchCard';
import { WaterFlowComponent } from '../../views/commonViews/WaterFlow/WaterFlowComponent';
import { SearchHeaderView } from '../../views/search/SearchHeaderView';
import { Logger } from '../../utils/Logger';
import { HomeNavBar } from '../../views/homePage/HomeNavBar';

@ComponentV2
export struct SearchPage {
  @Provider() viewModel: SearchViewModel = new SearchViewModel();

  aboutToAppear(): void {
    this.viewModel.loadData();
  }

  @Builder
  titleViewBuilder() {
    Row() {
      Row() {
        Image($r('app.media.search_icon'))
          .size({ width: 16, height: 16 })
          .objectFit(ImageFit.Contain)
          .margin({ right: 8 })
        Text('抖音热歌精选')
          .fontColor('#6E7075')
          .fontSize(14)
      }
      .margin({ left: 16 })

      Image($r('app.media.scan'))
        .size({ width: 16, height: 16 })
        .objectFit(ImageFit.Contain)
        .margin({ right: 16 })
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .borderRadius('50%')
    .backgroundColor('#E9EAED')
    .margin({ left: 10, top: 8 })
    .height('70%')
    .width('70%')
  }

  @Builder
  navBarRightActionsBuilder() {
    Row() {
      Image($r('app.media.voice_icon'))
        .width(24)
        .aspectRatio(1)
        .objectFit(ImageFit.Contain)
    }
    .margin({ right: 2 })
    .height('100%')
  }

  build() {
    Column() {
      HomeNavBar({
        titleView: () => {
          this.titleViewBuilder()
        },
        rightView: this.navBarRightActionsBuilder
      })
        .width('100%')
        .height(48)

      WaterFlowComponent({
        isRefreshing: this.viewModel.isRefreshing,
        waterFlowSections: this.viewModel.getSections(),
        dataSource: this.viewModel.getDataSource(),
        headerBuilder: this.headerBuilder,
        itemBuilder: this.searchCardBuilder,
        getItemReuseId: (item: WaterFlowItem, index: number) => {
          if ((item as SearchCardItem).topCates?.length > 0) {
            return "Header";
          }
          return "Card";
        },
        onRefresh: () => {
          Logger.info({ domain: 'WaterFlowComponent' }, `on refresh called:${this.viewModel.isRefreshing}`);
          this.viewModel.refresh();
        }
      })
        .width('100%')
        .layoutWeight(1)
    }
  }

  @Builder
  headerBuilder(item: WaterFlowItem, index: number) {
    if ((item as SearchCardItem).topCates?.length > 0) {
      SearchHeaderView({ items: (item as SearchCardItem).topCates })
        .width('100%')
        .height(80)
    }
  }

  @Builder
  searchCardBuilder(item: WaterFlowItem, index: number) {
    if (item as SearchCardItem) {
      SearchCard({
        item: item as SearchCardItem
      })
    }
  }
}