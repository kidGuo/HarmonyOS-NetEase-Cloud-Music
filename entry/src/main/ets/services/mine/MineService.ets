/**
 * Author: Finn Guo
 * Date: 2026/1/10
 */
import { JSON } from '@kit.ArkTS';
import { MY_SONGS_STRING } from '../../../../mock/MockDataCenter';
import { MineFavItem } from '../../models/mine/MineFavItem';

export class MineService {
  static async getMySongs(): Promise<MineFavItem[]> {
    return new Promise((resolve) => {
      setTimeout(() => {
        const favItems: MineFavItem[] = JSON.parse(MY_SONGS_STRING) as MineFavItem[];
        resolve(favItems)
      }, 300);
    });
  }
}