/**
 * Author: Finn Guo
 * Date: 2026/1/18
 */

export interface ChatMessage {
  role: string;
  content: string;
}

export interface DeepSeekDelta {
  content?: string;
}

export interface DeepSeekChoice {
  delta: DeepSeekDelta;
}

export interface DeepSeekResponse {
  choices: DeepSeekChoice[];
}

/**
 * 流式请求状态
 */
export enum StreamStatus {
  STARTED = 'started', // 开始请求
  STREAMING = 'streaming', // 正在接收数据
  COMPLETED = 'completed', // 成功完成
  ERROR = 'error' // 发生错误
}

/**
 * 状态回调参数
 */
export interface StreamStatusCallback {
  status: StreamStatus;
  message?: string;
  error?: ESObject;
}