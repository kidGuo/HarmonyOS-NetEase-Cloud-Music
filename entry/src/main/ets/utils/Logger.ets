/**
 * Author: Finn Guo
 * Date: 2025/12/20
 */
import { hilog } from '@kit.PerformanceAnalysisKit';

interface LogInfo {
  domain?: string;
  tag?: string;
}

export class Logger {
  static debug(info: LogInfo, message: string, ...args: ESObject[]) {
    const domainStr =
      (info.domain && typeof info.domain === 'string' && info.domain.length > 0) ? `[${info.domain}]` : ''
    const tag = info.tag || 'Debug'
    hilog.debug(0x0001, `[${tag}]`, `${domainStr} ${message}`, args);
  }

  static info(info: LogInfo, message: string, ...args: ESObject[]) {
    const domainStr =
      (info.domain && typeof info.domain === 'string' && info.domain.length > 0) ? `[${info.domain}]` : ''
    const tag = info.tag || 'Info'
    hilog.debug(0x0001, `[${tag}]`, `${domainStr} ${message}`, args);
  }

  static error(info: LogInfo, message: string, ...args: ESObject[]) {
    const domainStr =
      (info.domain && typeof info.domain === 'string' && info.domain.length > 0) ? `[${info.domain}]` : ''
    const tag = info.tag || 'Error'
    hilog.debug(0x0001, `[${tag}]`, `${domainStr} ${message}`, args);
  }
}