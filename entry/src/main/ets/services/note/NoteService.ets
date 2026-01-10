/**
 * Author: Finn Guo
 * Date: 2026/1/4
 */
import { NoteItem } from '../../models/note/NoteItem';
import { IS_DEBUG } from '../../utils/EnvConfig';
import { JSON } from '@kit.ArkTS';
import { NOTES_JSON_STRING } from '../../../../mock/MockDataCenter';

export class NoteService {
  static async getNotes(): Promise<NoteItem[]> {
    if (IS_DEBUG) {
      return new Promise((resolve) => {
        setTimeout(() => {
          const notes = JSON.parse(NOTES_JSON_STRING) as NoteItem[];
          const items = notes.map((item) => NoteItem.fromJson(item));
          resolve(items)
        }, 300)
      });
    }

    return [];
  }
}