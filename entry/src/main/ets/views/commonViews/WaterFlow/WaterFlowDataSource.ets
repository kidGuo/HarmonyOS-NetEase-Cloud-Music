/**
 * Author: Finn Guo
 * Date: 2025/12/28
 */
import { Logger } from '../../../utils/Logger';
import json from '@ohos.util.json';
import { WaterFlowItem } from './WaterFlowItem';

export class WaterFlowDataSource<T extends WaterFlowItem> implements IDataSource {
  private items: T[] = [];
  private listeners: DataChangeListener[] = [];

  private notifyDataReloaded() {
    this.listeners.forEach((listener) => {
      listener.onDataReloaded();
    })
  }

  private notifyDataAdd(idx: number) {
    this.listeners.forEach((listener) => {
      listener.onDataAdd(idx);
    })
  }

  private notifyDataDelete(idx: number) {
    this.listeners.forEach((listener) => {
      listener.onDataDelete(idx);
    })
  }

  private notifyDataChange(idx: number) {
    this.listeners.forEach((listener) => {
      listener.onDataChange(idx);
    })
  }

  private notifyDatasetChange(operations: DataOperation[]) {
    this.listeners.forEach((listener) => {
      listener.onDatasetChange(operations)
    })
  }

  totalCount(): number {
    return this.items.length;
  }

  getData(index: number): T {
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

  addFirstItem(item: T) {
    this.items.unshift(item);
    this.notifyDataAdd(0);
  }

  addLastItem(item: T) {
    this.items.push(item);
    this.notifyDataAdd(this.items.length - 1);
  }

  addItem(item: T, index: number) {
    this.items.splice(index, 0, item);
    this.notifyDataAdd(index);
  }

  addItems(items: T[], index?: number) {
    if (!items || items.length === 0) {
      return;
    }

    // 如果 index 未提供、为负数或超出范围，从尾部添加
    if (index === undefined || index < 0 || index >= this.items.length) {
      const startIdx = this.items.length;
      this.items.push(...items);
      this.notifyDataAdd(startIdx);
    } else {
      // 如果传入了有效的 index，在指定位置插入
      this.items.splice(index, 0, ...items);
      this.notifyDataAdd(index);
    }
  }

  deleteFirstItem() {
    this.items.splice(0, 1);
    this.notifyDataDelete(0);
  }

  deleteLastItem() {
    const deleteIndex = this.items.length - 1;
    this.items.pop();
    this.notifyDataDelete(deleteIndex);
  }

  deleteItem(index: number) {
    this.items.splice(index, 1);
    this.notifyDataDelete(index);
  }

  updateItem(item: T, startIdx: number) {
    if (startIdx >= 0 && startIdx < this.items.length && this.items.length > 0) {
      this.items[startIdx] = item;
      this.notifyDataChange(startIdx);
    } else {
      Logger.info({ domain: 'WaterFlowDataSource' },
        `Index ${startIdx} out of bounds. Array length: ${this.items.length}`)
    }
  }

  updateItems(items: T[], startIdx: number) {
    if (!items || items.length === 0) {
      return;
    }

    if (startIdx < 0 || startIdx >= this.items.length || this.items.length === 0) {
      Logger.info({ domain: 'WaterFlowDataSource' },
        `Start index ${startIdx} out of bounds. Array length: ${this.items.length}`)
      return;
    }

    const maxCnt = this.items.length - startIdx;
    const updateCnt = Math.min(items.length, maxCnt);
    if (updateCnt === 0) {
      return;
    }

    try {
      const operations: DataOperation[] = [];
      for (let idx = 0; idx < updateCnt; idx++) {
        const currentIdx = startIdx + idx;
        this.items[currentIdx] = items[idx];
        operations.push({
          type: DataOperationType.CHANGE,
          index: currentIdx
        } as DataOperation)
      }
      if (operations.length > 0) {
        this.notifyDatasetChange(operations);
        return;
      }
    } catch (error) {
      Logger.info({ domain: 'WaterFlowDataSource' },
        `Update dataset error:${json.stringify(error)}`);
    }
  }
}