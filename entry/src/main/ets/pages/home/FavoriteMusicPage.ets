/**
 * Author: Finn Guo
 * Date: 2026/1/17
 */
import { AlbumItem } from '../../models/home/AlbumItem';
import { ArtistItem } from '../../models/home/ArtistItem';
import { RecommendItem } from '../../models/home/RecommendItem';
import { SongItem } from '../../models/home/SongItem';
import { Logger } from '../../utils/Logger';
import { FavViewModel } from '../../viewModels/home/FavViewModel';
import { HomeViewModel } from '../../viewModels/home/HomeViewModel';
import { playerController } from '../../viewModels/player/MusicPlayerController';
import { PlayerActionView } from '../../views/player/PlayerActionView';
import { SongCard } from '../../views/player/SongCard';

@Preview
@ComponentV2
export struct FavoriteMusicPage {
  @Consumer() viewModel: HomeViewModel = new HomeViewModel();
  favViewModel: FavViewModel = new FavViewModel();

  @Computed
  get currentSong(): SongItem {
    return this.viewModel.scenePlaylist?.[this.favViewModel.currentIndex]?.song ?? { name: '未知歌曲' } as SongItem;
  }

  @Computed
  get currentAlbum(): AlbumItem {
    return this.viewModel.scenePlaylist?.[this.favViewModel.currentIndex]?.song?.album ??
      { name: '未知专辑' } as AlbumItem;
  }

  @Computed
  get currentArtist(): ArtistItem {
    return this.viewModel.scenePlaylist?.[this.favViewModel.currentIndex]?.song?.artists[0] ??
      { name: '云音乐' } as ArtistItem;
  }

  @Computed
  get isStylusActive(): boolean {
    return this.favViewModel.isPlaying &&
      !this.favViewModel.isDragging &&
      !this.favViewModel.isScrolling;
  }

  build() {
    Stack() {
      Image(this.currentAlbum.blurPicUrl)
        .objectFit(ImageFit.Cover)
        .blur(700)
        .width('100%')
        .height('100%')
        .overlay(this.backgroundMask())

      Column() {
        Stack({ alignContent: Alignment.Top }) {
          Stack({ alignContent: Alignment.Center }) {
            // 唱片背景
            Image($r('app.media.cm2_efc_knob_trough_night_ip6_Normal'))
              .objectFit(ImageFit.Cover)
              .width('80%')
              .aspectRatio(1)

            Swiper(this.favViewModel.swiperController) {
              ForEach(this.viewModel.scenePlaylist, (item: RecommendItem, index: number) => {
                Stack({ alignContent: Alignment.Center }) {
                  SongCard({
                    coverImage: item.song?.album.picUrl
                  })
                }
                .reuseId('songCard')
                .width('100%')
                .aspectRatio(1)
                .rotate({
                  angle: this.favViewModel.currentAngle,
                  centerY: '50%',
                  centerX: '50%'
                })
              }, (item: RecommendItem) => item.id.toString())
            }
            .indicator(false)
            .autoPlay(false)
            .loop(true)
            .width('100%')
            .aspectRatio(1)
            .onChange((index: number) => {
              Logger.info({ domain: 'FavMusic' }, `on change index:${index}`);
              this.favViewModel.isDragging = false;
              this.favViewModel.isScrolling = false;
              if (this.favViewModel.isPlaying) {
                this.favViewModel.updateSongIndex(index);
              }
            })
            .onAnimationStart((index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) => {
              Logger.info({ domain: 'FavMusic' }, `on animation start:${index}, targetIdx:${targetIndex}`);
              this.favViewModel.isDragging = false;
            })
            .onAnimationEnd((index: number, extraInfo: SwiperAnimationEvent) => {
              Logger.info({ domain: 'FavMusic' }, `on animation end:${index}`);
              this.favViewModel.isDragging = false;
              this.favViewModel.isScrolling = false;
              this.favViewModel.manageDiscAnimation(this.getUIContext(), this.favViewModel.isPlaying)
            })
            .onContentDidScroll((selectedIndex: number, index: number, position: number, mainAxisLength: number) => {
              Logger.info({ domain: 'FavMusic' },
                `on content did scroll:${selectedIndex}, index:${index}, pos:${position}`);
            })
            .onGestureSwipe((index: number, extraInfo: SwiperAnimationEvent) => {
              Logger.info({ domain: 'FavMusic' }, `on gesture swipe:${index}`);
              this.favViewModel.isDragging = true;
              this.favViewModel.isScrolling = true;
              // this.favViewModel.manageDiscAnimation(this.getUIContext(), false)
            })
          }
          .width('100%')
          .aspectRatio(1)
          .position({ y: '18%' })

          // 唱针
          Image($r('app.media.cm6_play_needle_play_Normal'))
            .width(300)
            .aspectRatio(1)
            .objectFit(ImageFit.Cover)
            .position({ x: '8%', y: '-35%' })
            .rotate({
              angle: this.isStylusActive ? 0 : -30,
              centerX: '50%',
              centerY: '50%'
            })
            .animation({
              duration: 500
            })
        }
        .width('100%')
        .aspectRatio(1)

        this.songInfosBuilder()
        //
        this.actionToolBuilder()
      }
      .width('100%')
      .height('100%')
    }
    .onVisibleAreaChange([0.0, 1.0], (isExpanding: boolean, currentRatio: number) => {
      // 这里仅仅是为了保持数据一致
      const songItems: SongItem[] = this.viewModel.scenePlaylist.flatMap(item => item.song ? [item.song] : []);
      if (isExpanding && currentRatio >= 1.0 && songItems.length !== playerController.playbackState.playlist.length) {
        playerController.addSongsToEnd(songItems, false);
      }
    })
    .width('100%')
    .height('100%')
  }

  @Builder
  backgroundMask() {
    Column()
      .width('100%')
      .height('100%')
      .backgroundColor('rgba(0,0,0,0.3)')
  }

  @Builder
  songInfosBuilder() {
    Row() {
      Column() {
        Text(this.currentSong.name)
          .fontColor(Color.White)
          .fontSize(16)
          .maxLines(2)
        Row() {
          Text(this.currentArtist.name)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
            .fontSize(12)
            .maxLines(1)
            .margin({ right: 8 })
          Text('关注')
            .fontColor(Color.White)
            .fontSize(10)
            .padding({
              left: 6,
              top: 4,
              bottom: 4,
              right: 6
            })
            .borderRadius('20%')
            .backgroundColor('rgba(0,0,0,0.5)')
        }
      }
      .height('100%')
      .justifyContent(FlexAlign.SpaceAround)
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Row() {
        Stack({ alignContent: Alignment.TopEnd }) {
          Image($r('app.media.cm5_sati_favorite_selected_Normal'))
            .size({ width: 32, height: 32 })
          Text(`${Math.ceil(Math.random() * 1000 + this.favViewModel.currentIndex)}` + 'w+')
            .fontSize(10)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
            .offset({ x: 20, y: 0 })
        }

        Blank()
          .width(25)

        Stack({ alignContent: Alignment.TopEnd }) {
          Image($r('app.media.cm6_play_icn_cmt_num_Normal'))
            .size({ width: 32, height: 32 })
          Text(`${Math.ceil(Math.random() * 10) + this.favViewModel.currentIndex}` + 'w+')
            .fontSize(10)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
            .offset({ x: 10, y: 0 })
        }

        Blank()
          .width(25)

        Image($r('app.media.cm6_play_icn_more_Normal'))
          .size({ width: 32, height: 32 })
          .padding({ right: 10 })
      }
    }
    .padding({ left: 20, right: 4 })
    .margin({ top: 40 })
    .width('100%')
    .height(48)
  }

  @Builder
  actionToolBuilder() {
    PlayerActionView({
      songItem: this.currentSong,
      actionCallback: (type, value) => {
        this.favViewModel.handleUserActionType(this.getUIContext(), type, value);
      }
    })
      .width('100%')
  }
}