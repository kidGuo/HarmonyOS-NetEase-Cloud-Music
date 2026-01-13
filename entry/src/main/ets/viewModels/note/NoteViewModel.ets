/**
 * Author: Finn Guo
 * Date: 2026/1/4
 */
import { SegmentItem } from '../../models/home/SegmentItem';
import { NoteService } from '../../services/note/NoteService';
import { Logger } from '../../utils/Logger';
import { SegmentController } from '../../views/commonViews/SegmentView/SegmentedView';
import { BaseWaterFlowViewModel } from '../baseViewModel/BaseWaterFlowViewModel';

@ObservedV2
export class NoteViewModel extends BaseWaterFlowViewModel {
  cates: SegmentItem[] = [{ id: '20028001', name: '关注' }, { id: '20028002', name: '推荐' }];
  private segmentController: SegmentController = new SegmentController();
  swiperWidth: number = 0;
  @Trace isRefreshing: boolean = false;
  @Trace currentIndex: number = 1;
  @Trace isLoadingMore: boolean = false;

  constructor() {
    super()
  }

  getSegmentController(): SegmentController {
    return this.segmentController;
  }

  // ****** 接口 ******* //
  async loadData() {
    await Promise.allSettled([
      this.getNoteList(0)
    ])

    this.syncDataSource();
  }

  async refreshData() {
    if (this.isRefreshing) {
      return;
    }

    this.isRefreshing = true;
    await this.getNoteList(0);
    this.syncDataSource();
    this.isRefreshing = false;
  }

  async loadMoreData() {
    if (this.isLoadingMore) {
      return;
    }

    this.isLoadingMore = true;
    await this.getNoteList(this.dataSource.totalCount());
    this.syncDataSource();
    this.isLoadingMore = false;
  }

  private syncDataSource() {
    // sections
    const section: SectionOptions = {
      itemsCount: this.dataSource.totalCount(),
      crossCount: 2,
      rowsGap: 4,
      columnsGap: 4,
      margin: { left: 4, right: 4 }
    }

    const sections = [section];
    this.waterFlowSections.splice(0, this.waterFlowSections.length(), sections);
  }

  async getNoteList(offset: number) {
    const items = await NoteService.getNotes();
    Logger.info({ domain: 'NoteVM' }, `notes cnt:${items.length}`);
    if (offset > 0) {
      this.dataSource.addItems(items);
    } else {
      this.dataSource.deleteAllItems();
      this.dataSource.addItems(items);
    }
  }
}