/**
 * Author: Finn Guo
 * Date: 2025/12/21
 */
import { BannerItem } from '../../models/home/BannerItem';
import { Logger } from '../../utils/Logger';
import { HomeViewModel } from '../../viewModels/home/HomeViewModel';
import json from '@ohos.util.json';
import { CateItem } from '../../models/home/CateItem';
import { RowEntity, ScrollGroupRow, ScrollRow } from '../../views/commonViews/ScrollRow';
import { GroupCard } from '../../views/homePage/GroupCard';
import { MemoryCard } from '../../views/homePage/MemoryCard';
import { WebParams } from '../web/WebComponent';

@Preview
@ComponentV2
export struct MusicsPage {
  @Consumer() viewModel: HomeViewModel = new HomeViewModel();
  @Consumer() pathStack: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    this.viewModel.getMusicBanners();
    this.viewModel.getCateList();
    Logger.info({ domain: 'Music' }, 'about to appear')
  }

  onPageShow(): void {
    Logger.info({ domain: 'Music' }, 'on page show')
  }

  build() {
    Scroll() {
      Column() {
        this.bannersBuilder()
        //
        this.cateListBuilder()
        //
        this.sectionBuilder('歌单', '精选歌单')
        // 新歌新碟
        this.sectionBuilder('新碟', '新歌新碟 >')
      }
      .width('100%')
    }
    .onVisibleAreaChange([0.0, 1.0], (isExpanding: boolean, currentRatio: number) => {
      Logger.info({ domain: 'Music' }, `on visible area change, expanding:${isExpanding}, ratio:${currentRatio}`)
      if (isExpanding && currentRatio >= 1.0) {
        Logger.info({ domain: 'Music' }, '进入 音乐 tab')
      }
      if (!isExpanding && currentRatio <= 0.0) {
        Logger.info({ domain: 'Music' }, '离开 音乐 tab')
      }
    })
  }

  @Builder
  bannersBuilder() {
    Swiper() {
      ForEach(this.viewModel.banners, (item: BannerItem, index: number) => {
        Image(item.pic)
          .objectFit(ImageFit.Cover)
          .width('100%')
          .height('100%')
          .borderRadius(8)
          .onError((error) => {
            Logger.error({ domain: 'Music' }, `banner load error:${json.stringify(error)}`);
          })
          .onClick(() => {
            const params: WebParams = { url: item.url };
            this.pathStack.pushPathByName('Web', params)
          })
      }, (item: BannerItem) => item.bannerId)
    }
    .itemSpace(12)
    .loop(true)
    .indicator(
      new DotIndicator()
        .itemWidth(6)
        .itemHeight(6)
        .selectedItemWidth(6)
        .selectedItemHeight(6)
        .color(Color.Gray)
        .selectedColor(Color.White)
        .left(0)
        .bottom(0)
    )
    .autoPlay(true)
    .clip(false)
    .padding({
      top: 20,
      left: 12,
      bottom: 20,
      right: 12
    })
    .width('100%')
    .aspectRatio(3.0 / 2.0)
  }

  // 分类区
  @Builder
  cateListBuilder() {
    Swiper() {
      ForEach(this.viewModel.cateItems, (items: CateItem[], index: number) => {
        Grid() {
          ForEach(items, (item: CateItem, index: number) => {
            GridItem() {
              Row() {
                Text(item.name)
                  .fontColor(Color.Black)
                  .fontSize(14)
              }
              .justifyContent(FlexAlign.Center)
              .width('100%')
              .padding(8)
              .border({
                width: 1,
                radius: 4,
                color: Color.Black
              })
            }
          }, (item: CateItem) => item.id.toString())
        }
        .columnsTemplate('1fr 1fr 1fr 1fr')
        .layoutDirection(GridDirection.Row)
        .rowsGap(10)
        .columnsGap(10)
        .padding(12)
        .width('100%')
      }, (items: CateItem[]) => items[0].id.toString())
    }
    .width('100%')
    .loop(false)
    .indicator(false)
    .onGestureSwipe((index: number, extraInfo: SwiperAnimationEvent) => {

    })
  }

  @Builder
  sectionBuilder(section: '新碟' | '歌单', title: string) {
    Column() {
      Text(title)
        .fontColor(Color.Black)
        .fontSize(16)
        .fontWeight(FontWeight.Bolder)
        .margin({ left: 12, bottom: 16 })

      if (section === '歌单') {
        this.playlistSectionBuilder()
      } else if (section === '新碟') {
        this.newAlbumsBuilder()
      }
    }
    .alignItems(HorizontalAlign.Start)
    .margin({ top: 20 })
    .width('100%')
  }

  // 新碟区
  @Builder
  newAlbumsBuilder() {
    ScrollGroupRow({
      itemsGroup: this.viewModel.personalMVs,
      itemExtent: '96%',
      itemSpace: 10,
      cardBuilder: this.newAlbumCard
    })
      .width('100%')
      .height(210)
  }

  @Builder
  newAlbumCard(items: RowEntity[], index: number) {
    GroupCard({
      items: items,
      onCardSelect: (item: RowEntity, index: number) => {

      }
    })
      .width('100%')
      .height('100%')
  }

  // 歌单
  @Builder
  playlistSectionBuilder() {
    ScrollRow({
      items: this.viewModel.topList,
      itemExtent: 160,
      itemSpace: 10,
      cardBuilder: this.playlistCard,
      onCardSelect: (item: RowEntity, index: number) => {

      }
    })
      .width('100%')
      .height(220)
  }

  // 歌单卡片
  @Builder
  playlistCard(item: RowEntity, index: number) {
    MemoryCard({
      item: item
    })
      .width('100%')
      .height(220)
      .borderRadius(4)
      .clip(true)
  }
}