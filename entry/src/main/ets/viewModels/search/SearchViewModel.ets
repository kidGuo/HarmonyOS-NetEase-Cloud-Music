/**
 * Author: Finn Guo
 * Date: 2025/12/28
 */
import { SearchCardItem } from '../../models/search/SearchCardItem';
import { SearchTopCate } from '../../models/search/SearchTopCate';
import { SearchService } from '../../services/search/SearchService';
import { Logger } from '../../utils/Logger';
import { UIUtils } from '@kit.ArkUI';
import { WaterFlowDataSource } from '../../views/commonViews/WaterFlow/WaterFlowDataSource';
import { WaterFlowItem } from '../../views/commonViews/WaterFlow/WaterFlowItem';

@ObservedV2
export class SearchViewModel {
  @Trace topCates: SearchTopCate[] = [];
  @Trace albums: SearchCardItem[] = [];
  //
  @Trace isRefreshing: boolean = false;
  // 数据源
  private dataSource: WaterFlowDataSource<WaterFlowItem> = new WaterFlowDataSource();
  //
  private waterFlowSections: WaterFlowSections = UIUtils.makeObserved(new WaterFlowSections());

  /**
   * 获取数据源
   */
  getDataSource(): WaterFlowDataSource<WaterFlowItem> {
    return this.dataSource;
  }

  /**
   * 获取 sections 配置
   */
  getSections(): WaterFlowSections {
    return this.waterFlowSections;
  }

  async loadData() {
    if (this.isRefreshing) {
      Logger.info({ domain: 'SearchVM' }, 'Already loading, skip');
      return;
    }

    await Promise.allSettled([
      this.getSearchTopCates(),
      this.getSearchCategoryList()
    ]);
    this.syncDataSource();
  }

  async refresh() {
    if (this.isRefreshing) {
      Logger.info({ domain: 'SearchVM' }, 'Already loading, skip in refresh');
      return;
    }

    this.isRefreshing = true;
    await Promise.allSettled([
      this.getSearchTopCates(),
      this.getSearchCategoryList()
    ]);

    this.isRefreshing = false;
  }

  syncDataSource() {
    this.dataSource.deleteAllItems();

    if (this.topCates.length > 0) {
      const headerCard = new SearchCardItem();
      headerCard.id = -1;
      headerCard.topCates = this.topCates
      this.dataSource.addLastItem(headerCard);
    }

    if (this.albums.length > 0) {
      const idx = this.dataSource.totalCount();
      this.dataSource.addItems(this.albums, idx);
    }

    Logger.info({ domain: 'SearchVM' },
      `datasource len:${this.dataSource.totalCount()}, albums cnt:${this.albums.length}`);
    const newOptions = this.createSectionsOption();
    this.waterFlowSections.splice(0, this.waterFlowSections.length(), newOptions);
  }

  createSectionsOption(): SectionOptions[] {
    const headerSection: SectionOptions = {
      itemsCount: 1,
      crossCount: 1,
      columnsGap: 10,
      onGetItemMainSizeByIndex: (index: number) => 80
    }

    const cardSection: SectionOptions = {
      itemsCount: this.albums.length,
      crossCount: 2,
      columnsGap: 10,
      rowsGap: 8,
      margin: {
        left: 12,
        right: 12,
        top: 0,
        bottom: 12
      },
      onGetItemMainSizeByIndex: (index: number) => 115
    }

    return [headerSection, cardSection];
  }

  async getSearchTopCates() {
    const items = await SearchService.getTopCategories();
    Logger.info({ domain: 'SearchVM' }, `top cates:${JSON.stringify(items)}`);
    this.topCates = items;
  }

  /*
id=19723756，云音乐飙升榜
id=3779629，云音乐新歌榜
id=3778678，云音乐热歌榜
id=2250011882，抖音排行榜
* */
  async getSearchCategoryList(id: string = '2250011882') {
    const albums = await SearchService.getPlaylistDetail(id);
    Logger.info({ domain: 'SearchVM' }, `album cates cnt:${albums.length}, content:${JSON.stringify(albums)}`);
    this.albums = albums;
  }
}