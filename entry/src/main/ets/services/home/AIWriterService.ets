/**
 * Author: Finn Guo
 * Date: 2026/1/18
 */
import { http } from '@kit.NetworkKit';
import { JSON } from '@kit.ArkTS';
import { Logger } from '../../utils/Logger';
import { DEEP_SEEK_API_KEY } from '../../utils/EnvConfig';
import { ChatMessage, DeepSeekResponse, StreamStatus, StreamStatusCallback } from '../../network/DeepSeekResponse';

export class AIWriterService {
  private static readonly API_URL = 'https://api.deepseek.com/v1/chat/completions';

  static async callDeepSeekStream(
    prompt: string,
    onChunk?: (content: string) => void,
    onStatusChange?: (callback: StreamStatusCallback) => void
  ): Promise<void> {
    if (prompt.trim().length === 0 ||
      DEEP_SEEK_API_KEY.length === 0) {
      if (onStatusChange) {
        onStatusChange({
          status: StreamStatus.ERROR,
          message: (DEEP_SEEK_API_KEY.length === 0 ? '请填写DeepSeek API KEY' : '非法Prompt')
        })
      }
      return;
    }

    const httpRequest: http.HttpRequest = http.createHttp();

    // 拼装数据
    const messageList: ChatMessage[] = [
      { role: 'user', content: prompt }
    ];

    // 检测
    httpRequest.on('headersReceive', (headers) => {
      Logger.info({ domain: 'AIWriterService' }, `HTTP Status: ${JSON.stringify(headers)}`);
    });

    try {
      Logger.info({ domain: 'AIWriterService' },
        `start request: ${JSON.stringify(messageList)}`);

      // 回调
      if (onStatusChange) {
        onStatusChange({
          status: StreamStatus.STARTED,
          message: 'Request started'
        });
      }

      // 在回调中处理完整数据
      httpRequest.request(AIWriterService.API_URL, {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${DEEP_SEEK_API_KEY}`,
          'Accept': 'text/event-stream'
        },
        extraData: JSON.stringify({
          model: 'deepseek-chat',
          messages: messageList,
          stream: true
        }),
        usingProtocol: http.HttpProtocol.HTTP1_1,
        readTimeout: 60000,
        connectTimeout: 60000
      }, (err, data) => {
        if (err) {
          Logger.error({ domain: 'AIWriterService' }, `Request error: ${JSON.stringify(err)}`);

          // 错误回调
          if (onStatusChange) {
            onStatusChange({
              status: StreamStatus.ERROR,
              message: 'Request failed',
              error: err as ESObject
            });
          }

          httpRequest.destroy();
          return;
        }

        try {
          // 开始流式处理
          if (onStatusChange) {
            onStatusChange({
              status: StreamStatus.STREAMING,
              message: 'Streaming data'
            });
          }

          // 从 result 字段获取完整的 SSE 数据
          const result = data.result as string;
          Logger.info({ domain: 'AIWriterService' }, `Processing complete result, length: ${result.length}`);

          // 解析 SSE 格式数据
          const lines = result.split('\n');
          for (let line of lines) {
            const trimmed = line.trim();
            if (!trimmed.startsWith('data: ')) {
              continue;
            }

            const dataStr = trimmed.slice(6);
            if (dataStr === '[DONE]') {
              Logger.info({ domain: 'AIWriterService' }, 'Stream Finished [DONE]');
              break;
            }

            try {
              const json = JSON.parse(dataStr) as DeepSeekResponse;
              if (json.choices && json.choices.length > 0) {
                const content = json.choices[0].delta.content;
                if (content) {
                  Logger.info({ domain: 'AIWriterService' }, `Content chunk: ${content}`);
                  if (onChunk) {
                    onChunk(content);
                  }
                }
              }
            } catch (e) {
              Logger.error({ domain: 'AIWriterService' }, `JSON parse error: ${dataStr.substring(0, 50)}`);
            }
          }

          Logger.info({ domain: 'AIWriterService' }, 'All chunks processed');

          // 完成
          if (onStatusChange) {
            onStatusChange({
              status: StreamStatus.COMPLETED,
              message: 'Stream completed successfully'
            });
          }

        } catch (e) {
          Logger.error({ domain: 'AIWriterService' }, `Process result error: ${JSON.stringify(e)}`);

          // 处理错误
          if (onStatusChange) {
            onStatusChange({
              status: StreamStatus.ERROR,
              message: 'Failed to process stream data',
              error: e as ESObject
            });
          }
        } finally {
          httpRequest.destroy();
        }
      });

      Logger.info({ domain: 'AIWriterService' }, 'Request sent, waiting for stream segments...');

    } catch (err) {
      Logger.error({ domain: 'AIWriterService' }, `call deepseek error: ${JSON.stringify(err)}`);

      // 异常
      if (onStatusChange) {
        onStatusChange({
          status: StreamStatus.ERROR,
          message: 'Exception occurred',
          error: err as ESObject
        });
      }

      httpRequest.destroy();
    }
  }
}
