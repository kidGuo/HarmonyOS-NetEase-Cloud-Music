/**
 * Author: Finn Guo
 * Date: 2025/12/21
 */
import { AlbumItem } from './AlbumItem';
import { ArtistItem } from './ArtistItem';

export interface SongItem {
  id: number;
  name: string;
  position: number;
  alias: string[];
  status: number;
  fee: number;
  copyrightId: number;
  disc: string;
  no: number;
  artists: ArtistItem[];
  album: AlbumItem;
  duration: number;
  popularity: number;
  score: number;
  starredNum: number;
  playedNum: number;
  dayPlays: number;
  hearTime: number;
}