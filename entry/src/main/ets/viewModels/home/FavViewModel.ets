/**
 * Author: Finn Guo
 * Date: 2026/1/18
 */
import { playerController } from '../player/MusicPlayerController';
import { AnimatorResult } from '@kit.ArkUI';

@ObservedV2
export class FavViewModel {
  @Trace isPlaying: boolean = false;
  @Trace isDragging: boolean = false;
  @Trace isScrolling: boolean = false;
  @Trace currentIndex: number = 0;
  @Trace currentAngle: number = 0;
  timerId?: number;
  animator?: AnimatorResult;
  swiperController: SwiperController = new SwiperController();

  updateSongIndex(index: number) {
    if (this.currentIndex === index) {
      return;
    }
    this.currentIndex = index;
    this.isPlaying = true;
    playerController.loadSong(this.currentIndex);
  }

  handleUserActionType(context: UIContext, type: 'play' | 'pause' | 'prev' | 'next' | 'seek', value?: number) {
    switch (type) {
      case 'play': {
        playerController.loadSong(this.currentIndex);
        this.isPlaying = true
        this.manageDiscAnimation(context, true)
        break;
      }
      case 'pause': {
        playerController.togglePlay();
        this.isPlaying = true
        this.manageDiscAnimation(context, false)
        break;
      }
      case 'prev': {
        playerController.playPrevious();
        const cnt = playerController.playbackState.playlist.length;
        this.currentIndex = (this.currentIndex - 1 + cnt) % cnt;
        this.swiperController.showPrevious();
        break;
      }
      case 'next': {
        playerController.playNext(true);
        let cnt = playerController.playbackState.playlist.length;
        this.currentIndex = (this.currentIndex - 1 + cnt) % cnt;
        this.swiperController.showNext();
        break;
      }
      case 'seek': {
        playerController.seek(value ?? 0)
        break;
      }
    }
  }

  manageDiscAnimation(context: UIContext, isPlay: boolean) {
    if (!this.animator) {
      this.initDiscAnimator(context);
    }

    const animator = this.animator;
    if (!animator) {
      return;
    }

    if (isPlay) {
      animator.play();
    } else {
      animator.pause();
    }
  }

  private initDiscAnimator(context: UIContext) {
    this.animator = context.createAnimator({
      duration: 10000,
      easing: 'linear',
      delay: 0,
      fill: 'forwards',
      direction: 'normal',
      iterations: -1,
      begin: 0,
      end: 360
    })
    this.animator.onFrame = (progress) => {
      this.currentAngle = progress;
    };
  }
}