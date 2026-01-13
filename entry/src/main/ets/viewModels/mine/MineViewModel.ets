/**
 * Author: Finn Guo
 * Date: 2026/1/10
 */
import { SegmentItem } from '../../models/home/SegmentItem';
import { MenuItem } from '../../models/mine/MenuItem';
import { MineFavItem } from '../../models/mine/MineFavItem';
import { MineService } from '../../services/mine/MineService';
import { SegmentedStyle } from '../../views/commonViews/SegmentView/SegmentedStyle';
import { SegmentController } from '../../views/commonViews/SegmentView/SegmentedView';

@ObservedV2
export class MineViewModel {
  @Trace scrollY: number = 0;
  @Trace currentIndex: number = 0;
  @Trace favItems: MineFavItem[] = [];
  @Trace navBgAlpha: number = 0;
  //
  headerHeight: number = 400;
  menus: MenuItem[] = [{ id: '2000801', title: '最近', icon: '' }, { id: '2000802', title: '本地', icon: '' },
    { id: '2000803', title: '网盘', icon: '' }, { id: '2000804', title: '装扮', icon: '' },
    { id: '2000805', title: '更多', icon: '' }];
  cates: SegmentItem[] =
    [{ id: '2000811', name: '音乐' }, { id: '2000812', name: '播客' }, { id: '2000813', name: '笔记' }];
  swiperWidth: number = 0;
  // 控制器
  private scroller: Scroller = new Scroller();
  private segmentController: SegmentController = new SegmentController();
  // 样式
  private segmentedStyle: SegmentedStyle = new SegmentedStyle();
  navBarThreshold: number = 100;

  constructor() {
    this.commonInitialization();
  }

  private commonInitialization() {
    this.segmentedStyle
      .setSpaceGap(30)
      .setIndicatorColor(Color.Red)
      .setIndicatorHorizontalInset(20);
  }

  getScroller(): Scroller {
    return this.scroller;
  }

  getSegmentController(): SegmentController {
    return this.segmentController;
  }

  getSegmentedStyle(): SegmentedStyle {
    return this.segmentedStyle;
  }

  //
  async loadData() {
    await Promise.allSettled([
      this.getMyFavoriteSongs()
    ])
  }

  async getMyFavoriteSongs() {
    const items = await MineService.getMySongs();
    this.favItems = items;
  }
}