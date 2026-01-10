/**
 * Author: Finn Guo
 * Date: 2025/12/21
 */

export interface BaseResponse<T> {
  code: number;
  message: string;
  data: T;
}

export interface AppResultsResponse<T> {
  code: number;
  result: T[];
}

export interface AppResultResponse<T> {
  code: number;
  result: T;
}

export interface AppListResponse<T> {
  code: number;
  list: T[];
}

export interface AppAlbumResponse<T> {
  code: number;
  albums: T[];
}