/**
 * Author: Finn Guo
 * Date: 2025/12/21
 */
import axios, { AxiosInstance, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios';

class NetworkManager {
  private instance: AxiosInstance;

  constructor() {
    this.instance = axios.create({
      baseURL: 'https://music.163.com/api',
      timeout: 30000
    })

    this.setupInterceptors();
  }

  private setupInterceptors() {
    this.instance.interceptors.request.use(
      (config: InternalAxiosRequestConfig) => {
        return config;
      },
      (error: Error) => Promise.reject(error)
    )
    this.instance.interceptors.response.use(
      (response: AxiosResponse) => {
        return response;
      },
      (error: Error) => Promise.reject(error)
    )
  }

  public get<T>(url: string, params?: ESObject): Promise<T> {
    return this.instance.get<null, T>(url, { params });
  }

  public post<T>(url: string, data?: ESObject): Promise<T> {
    return this.instance.post<null, T>(url, data);
  }
}

export const httpClient = new NetworkManager();