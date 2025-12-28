/**
 * Author: Finn Guo
 * Date: 2025/12/20
 */
import { SearchCardItem } from '../../models/search/SearchCardItem';
import { SearchViewModel } from '../../viewModels/search/SearchViewModel';
import { WaterFlowComponent } from '../../views/commonViews/WaterFlow/WaterFlowComponent';
import { WaterFlowDataSource } from '../../views/commonViews/WaterFlow/WaterFlowDataSource';
import { WaterFlowItem } from '../../views/commonViews/WaterFlow/WaterFlowItem';
import { SearchCard } from '../../views/search/SearchCard';
import { SearchHeaderView } from '../../views/search/SearchHeaderView';

@ComponentV2
export struct SearchPage {
  viewModel: SearchViewModel = new SearchViewModel();
  @Local waterFlowSections: WaterFlowSections = new WaterFlowSections();
  dataSource: WaterFlowDataSource<SearchCardItem> = new WaterFlowDataSource();

  aboutToAppear(): void {
    this.viewModel.getSearchTopCates().then(() => {
      const headerCard = new SearchCardItem();
      headerCard.id = -1;
      headerCard.type = 'header';
      this.dataSource.addFirstItem(headerCard);
      this.waterFlowSections.splice(0, 0, this.createSectionsOption());
    })
  }

  createSectionsOption(): SectionOptions[] {
    const headerSection: SectionOptions = {
      itemsCount: 1,
      crossCount: 1,
      columnsGap: 10,
      onGetItemMainSizeByIndex: (index: number) => 60
    }

    return [headerSection];
  }

  build() {
    WaterFlowComponent({
      waterFlowSections: this.waterFlowSections,
      dataSource: this.dataSource,
      headerBuilder: this.headerBuilder,
      itemBuilder: this.searchCardBuilder
    })
      .width('100%')
      .height('100%')
  }

  @Builder
  headerBuilder(index: number) {
    SearchHeaderView({ items: this.viewModel.topCates })
      .width('100%')
      .height(60)
      .backgroundColor(Color.Red)
  }

  @Builder
  searchCardBuilder(item: WaterFlowItem, index: number) {
    SearchCard()
  }
}