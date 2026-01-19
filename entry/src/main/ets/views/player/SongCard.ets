/**
 * Author: Finn Guo
 * Date: 2026/1/17
 */

@ComponentV2
export struct SongCard {
  @Param coverImage: ResourceStr = '';

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Image($r('app.media.ic_cd'))
        .objectFit(ImageFit.Cover)
        .width('75%')
        .aspectRatio(1)
      Image(this.coverImage)
        .objectFit(ImageFit.Cover)
        .width('60%')
        .aspectRatio(1)
    }
  }
}