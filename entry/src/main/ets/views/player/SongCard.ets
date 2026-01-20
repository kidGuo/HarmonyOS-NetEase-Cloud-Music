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
        .width('52%')
        .aspectRatio(1)
        .borderRadius('50%')
        .clip(true)
    }
  }
}