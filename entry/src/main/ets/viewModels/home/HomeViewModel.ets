/**
 * Author: Finn Guo
 * Date: 2025/12/21
 */
import { AlbumItem } from '../../models/home/AlbumItem';
import { BannerItem } from '../../models/home/BannerItem';
import { CateItem } from '../../models/home/CateItem';
import { MVItem } from '../../models/home/MVItem';
import { PersonalItem } from '../../models/home/PersonalItem';
import { RecommendItem } from '../../models/home/RecommendItem';
import { SegmentItem } from '../../models/home/SegmentItem';
import { TopListItem } from '../../models/home/TopListItem';
import { HomeService } from '../../services/home/HomeService';
import { HomeSegmentDataSource } from './HomeSegmentDataSource';

@ObservedV2
export class HomeViewModel {
  segmentItems: SegmentItem[] =
    [{ id: "20025001", name: "心动" }, { id: "20025002", name: "推荐" }, { id: "20025003", name: "音乐" },
      { id: "20025004", name: "播客" }, { id: "20025005", name: "听书" }, { id: "20025006", name: "AI写歌" },
      { id: "20025007", name: "年报" }, { id: "20025008", name: "午夜飞行" }];
  pagesDataSource: HomeSegmentDataSource = new HomeSegmentDataSource(this.segmentItems);
  // 热门榜单
  @Trace topList: TopListItem[] = [];
  // 推荐数据
  @Trace recommendItems: RecommendItem[] = [];
  // 场景歌单
  @Trace scenePlaylist: RecommendItem[] = [];
  //
  @Trace privateContentItems: PersonalItem[] = [];
  //
  @Trace personalMVs: MVItem[][] = [];
  //
  @Trace newAlbums: AlbumItem[][] = [];
  //
  @Trace banners: BannerItem[] = [];
  //
  @Trace cateItems: CateItem[][] = [];

  async getTopList() {
    const data = await HomeService.getTopList();
    this.topList = data;
  }

  async getRecommendPlaylist() {
    const data = await HomeService.getRecommendPlaylist();
    this.recommendItems = data;
  }

  async getNewSongs() {
    const data = await HomeService.getNewSongs();
    this.scenePlaylist = data;
  }

  async getPrivateContent() {
    const data = await HomeService.getPrivateContent();
    this.privateContentItems = data;
  }

  async getPersonalMV() {
    const data = await HomeService.getPersonalMV();
    // 填充多个数据，为了视觉效果
    if (data.length < 9 && data.length > 0) {
      const needCount = 9 - data.length;
      const baseId = Date.now();

      for (let i = 0; i < needCount; i++) {
        const sourceIndex = i % data.length;
        const sourceItem = data[sourceIndex];

        // 创建新实例
        const placeholder = new MVItem();
        placeholder.id = baseId + i;
        placeholder.type = sourceItem.type;
        placeholder.name = sourceItem.name;
        placeholder.copywriter = sourceItem.copywriter;
        placeholder.picUrl = sourceItem.picUrl;
        placeholder.playCount = sourceItem.playCount;
        placeholder.artists = [...sourceItem.artists];
        placeholder.artistName = sourceItem.artistName;
        placeholder.artistId = sourceItem.artistId;
        placeholder.alg = sourceItem.alg;

        data.push(placeholder);
      }
    }

    this.personalMVs = [];
    const groupSize = 3;
    for (let idx = 0; idx < data.length; idx += groupSize) {
      this.personalMVs.push(data.slice(idx, idx + groupSize));
    }
  }

  // 获取新碟
  async getNewAlbums() {
    const data = await HomeService.getNewAlbums();

    this.newAlbums = [];
    const groupSize = 3;
    for (let idx = 0; idx < data.length; idx += groupSize) {
      this.newAlbums.push(data.slice(idx, idx + groupSize));
    }
  }

  async getMusicBanners() {
    const data = await HomeService.getBanners();
    this.banners = data;
  }

  async getCateList() {
    const data = await HomeService.getCateList();
    this.cateItems = data;
  }
}