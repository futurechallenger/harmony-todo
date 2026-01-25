import axios, {
  AxiosRequestConfig,
  AxiosResponse,
  AxiosInstance,
  InternalAxiosRequestConfig,
  AxiosError
} from '@ohos/axios';
import { promptAction } from '@kit.ArkUI'; // 用于显示提示信息

class Request {
  instance: AxiosInstance;

  constructor(config: AxiosRequestConfig) {
    this.instance = axios.create(config);

    // 请求拦截器
    this.instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
      // 在发送请求前做些处理，例如添加token
      // const token = ...; // 从本地存储获取token的逻辑
      // if (token) {
      //   config.headers.Authorization = `Bearer ${token}`;
      // }
      return config;
    }, (error: AxiosError) => {
      console.error('request error', error)
      return Promise.reject(error);
    });

    // 响应拦截器
    this.instance.interceptors.response.use((response: AxiosResponse) => {
      // 对响应数据做些处理，例如根据自定义业务代码判断成功与否
      const msg: string = response.data?.msg
      return response.data?.data; // 直接返回有用的数据部分

      // TODO: deal with server code later
      // 业务逻辑错误，可以统一提示
      // promptAction.showToast({ message: msg });
      // return Promise.reject(new Error(msg));
    }, (error: AxiosError) => {
      // 对网络错误或HTTP状态码错误进行统一处理
      // promptAction.showToast({ message: '网络请求失败' });
      console.error('response error', error)
      return Promise.reject(error);
    });
  }

  // 封装请求方法
  request<T>(config: AxiosRequestConfig): Promise<T> {
    return this.instance.request(config);
  }

  get<T>(config: AxiosRequestConfig = {}): Promise<T> {
    config.method = 'GET'
    return this.request(config);
  }

  post<T>(config: AxiosRequestConfig = {}): Promise<T> {
    config.method = 'POST'
    return this.request(config);
  }
}

// 导出配置好的实例
export const request = new Request({
  baseURL: 'http://192.168.31.109:17788',
  timeout: 10000 // 10秒超时
});