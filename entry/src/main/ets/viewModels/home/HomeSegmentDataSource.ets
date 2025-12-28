/**
 * Author: Finn Guo
 * Date: 2025/12/21
 */
import { SegmentItem } from '../../models/home/SegmentItem';

export class HomeSegmentDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private items: SegmentItem[] = [];

  constructor(items: SegmentItem[]) {
    this.items = items;
  }

  allItems(): SegmentItem[] {
    return this.items;
  }

  totalCount(): number {
    return this.items.length;
  }

  getData(index: number): SegmentItem {
    return this.items[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const idx = this.listeners.indexOf(listener);
    if (idx >= 0) {
      this.listeners.splice(idx, 1);
    }
  }
}