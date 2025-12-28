/**
 * Author: Finn Guo
 * Date: 2025/12/21
 */
import { RecommendItem } from '../../models/home/RecommendItem';
import { HomeViewModel } from '../../viewModels/home/HomeViewModel';
import { RowEntity, ScrollGroupRow, ScrollRow } from '../../views/commonViews/ScrollRow';
import { GroupCard } from '../../views/homePage/GroupCard';
import { MemoryCard } from '../../views/homePage/MemoryCard';
import { PlaylistCard } from '../../views/homePage/PlaylistCard';
import { RecommendView } from '../../views/homePage/RecommendView';

@Preview
@ComponentV2
export struct DiscoveryPage {
  @Consumer() viewModel: HomeViewModel = new HomeViewModel();

  aboutToAppear(): void {
    this.viewModel.getTopList();
    this.viewModel.getRecommendPlaylist();
    this.viewModel.getNewSongs();
    this.viewModel.getPrivateContent();
    this.viewModel.getPersonalMV();
  }

  build() {
    Scroll() {
      Column() {
        // 推荐
        this.recommendBuilder()

        // 场景歌单
        this.sectionBuilderWrapper('场景歌单', '专属你的「治愈」精选')

        // 回忆歌单
        this.sectionBuilderWrapper('回忆歌单', '回忆歌单')

        // 专属歌单
        this.sectionBuilderWrapper('专属歌单', '你的专属推荐歌单')

        // 热门节目推荐
        this.sectionBuilderWrapper('热门节目推荐', '根据你听过的热门节目推荐 >')

        // 留白
        Blank()
          .height(20)
      }
      .justifyContent(FlexAlign.Start)
    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Off)
    .align(Alignment.Top)
    .edgeEffect(EdgeEffect.Spring)
  }

  @Builder
  recommendBuilder() {
    RecommendView({
      recommendItems: this.viewModel.recommendItems,
      onRecommendSelect: (index: number, item: RecommendItem) => {

      }
    })
      .width('100%')
      .height(210)
      .margin({ top: 8 })
  }

  // 功能模块
  @Builder
  sectionBuilderWrapper(section: '场景歌单' | '回忆歌单' | '专属歌单' | '热门节目推荐', title: string) {
    Column() {
      Text(title)
        .fontColor(Color.Black)
        .fontSize(16)
        .fontWeight(FontWeight.Bolder)
        .margin({ left: 12, bottom: 16 })
      if (section === '场景歌单') {
        this.sceneSectionBuilder()
      } else if (section === '回忆歌单') {
        this.memorySectionBuilder()
      } else if (section === '专属歌单') {
        this.personalSectionBuilder()
      } else if (section === '热门节目推荐') {
        this.hotSectionBuilder()
      }
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .margin({ top: 30 })
  }

  // ******************** 场景歌单模块 ********************
  @Builder
  sceneSectionBuilder() {
    ScrollRow({
      items: this.viewModel.scenePlaylist,
      itemExtent: 160,
      itemSpace: 10,
      cardBuilder: this.scenePlaylistCard,
      onCardSelect: (item: RowEntity, index: number) => {

      }
    })
      .width('100%')
      .height(200)
  }

  // 场景歌单卡片
  @Builder
  scenePlaylistCard(item: RowEntity, index: number) {
    PlaylistCard({
      item: item
    })
      .width('100%')
      .height(200)
      .borderRadius(4)
      .clip(true)
  }

  // ******************** 回忆歌单模块 ********************
  @Builder
  memorySectionBuilder() {
    ScrollRow({
      items: this.viewModel.topList,
      itemExtent: 160,
      itemSpace: 10,
      cardBuilder: this.memoryPlaylistCard,
      onCardSelect: (item: RowEntity, index: number) => {

      }
    })
      .width('100%')
      .height(220)
  }

  // 回忆歌单卡片
  @Builder
  memoryPlaylistCard(item: RowEntity, index: number) {
    MemoryCard({
      item: item
    })
      .width('100%')
      .height(220)
      .borderRadius(4)
      .clip(true)
  }

  // ******************** 专属歌单模块 ********************
  @Builder
  personalSectionBuilder() {
    ScrollRow({
      items: this.viewModel.privateContentItems,
      itemExtent: 160,
      itemSpace: 10,
      cardBuilder: this.personalPlaylistCard,
      onCardSelect: (item: RowEntity, index: number) => {

      }
    })
      .width('100%')
      .height(200)
  }

  @Builder
  personalPlaylistCard(item: RowEntity, index: number) {
    PlaylistCard({
      item: item
    })
      .width('100%')
      .height(200)
      .borderRadius(4)
      .clip(true)
  }

  // ******************** 热门节目模块 ********************
  @Builder
  hotSectionBuilder() {
    ScrollGroupRow({
      itemsGroup: this.viewModel.personalMVs,
      itemExtent: '96%',
      itemSpace: 10,
      cardBuilder: this.hotPlaylistCard
    })
      .width('100%')
      .height(210)
  }

  @Builder
  hotPlaylistCard(items: RowEntity[], index: number) {
    GroupCard({
      items: items,
      onCardSelect: (item: RowEntity, index: number) => {

      }
    })
      .width('100%')
      .height('100%')
  }
}