/**
 * Author: Finn Guo
 * Date: 2026/1/18
 */
import { StreamStatus, StreamStatusCallback } from '../../network/DeepSeekResponse';
import { AIWriterService } from '../../services/home/AIWriterService';
import { Logger } from '../../utils/Logger';

@ObservedV2
export class AIWriterViewModel {
  @Trace prompt: string = '';
  @Trace lyricsText: string = '';
  @Trace isLoading: boolean = false;
  @Trace errorMessage: string = '';

  async requestDeepSeekStream(userInput: string) {
    const prompt = this.buildLyricsPrompt(userInput);
    Logger.info({ domain: 'AIWriterVM' }, `user prompt: ${prompt}`);

    await AIWriterService.callDeepSeekStream(prompt,
      (chunk) => {
        this.lyricsText += chunk;
        Logger.info({ domain: 'AIWriterVM' }, `chunk: ${chunk}`);
      }, (statusCallback: StreamStatusCallback) => {
        switch (statusCallback.status) {
          case StreamStatus.STARTED: {
            Logger.info({ domain: 'AIWriterVM' }, 'Stream started');
            this.isLoading = true;
            break;
          }
          case StreamStatus.STREAMING: {
            Logger.info({ domain: 'AIWriterVM' }, 'Receiving data...');
            break;
          }
          case StreamStatus.COMPLETED: {
            Logger.info({ domain: 'AIWriterVM' }, 'Stream completed');
            this.isLoading = false;
            break;
          }
          case StreamStatus.ERROR: {
            Logger.error({ domain: 'AIWriterVM' }, `Error: ${statusCallback.message}`);
            this.isLoading = false;
            this.errorMessage = statusCallback.message || '系统正忙 请稍后再试'
            break;
          }
        }
      });
  }

  private buildLyricsPrompt(userInput: string): string {
    return `你是一位专业的歌词创作人，擅长创作符合网易云音乐风格的歌词。

创作要求：
1. **风格调性**：符合网易云音乐平台特色，情感细腻、文艺唯美，容易引起听众共鸣
2. **语言特点**：用词优美、富有诗意，避免过于直白，善用比喻和意象
3. **结构要求**：包含主歌（Verse）和副歌（Chorus），主歌2-3段，副歌重复2-3次
4. **情感表达**：情感真挚、有故事性，能够触动人心
5. **主题深度**：不流于表面，有一定的思考和深度

用户创作灵感：
${userInput}

请根据以上灵感，创作一首完整的歌词。歌词格式如下：

[主歌1]
...
[副歌]
...
[主歌2]
...
[副歌]
...

注意：
- 每行歌词长度适中，适合演唱
- 押韵自然，不过分追求押韵
- 整体风格统一，符合网易云音乐调性
- 直接输出歌词内容，不要添加额外说明`;
  }

  clearLyrics() {
    this.lyricsText = '';
    this.prompt = '';
    this.errorMessage = '';
  }

  clearError() {
    this.errorMessage = '';
  }
}