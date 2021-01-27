import 'package:bookApp/components/Toast.dart';
import 'package:bookApp/util/CommonUtil.dart';
import 'package:dio/dio.dart';

/// http请求工具类封装
class Request {
  ///超时时间
  static const int CONNECT_TIMEOUT = 30000;
  static const int RECEIVE_TIMEOUT = 30000;
  Dio dio;

  Request() {
    BaseOptions options = new BaseOptions(
      connectTimeout: CONNECT_TIMEOUT,
      receiveTimeout: RECEIVE_TIMEOUT,
      headers: {},
    );
    dio = Dio(options);
    dio.interceptors.add(BaseInterceptor());
  }
}

class BaseInterceptor extends Interceptor {
  @override
  Future onRequest(RequestOptions options) {
    print("[Request] ${options.method} - ${options.uri}");
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    print(
        "[Response] ${response.statusCode} - ${response.request.uri}\n${response.headers}\n${response.data}");
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    print("[Error]\n${err.error}");
    err.error = RequestException.create(err);
    CBToast.showErrorToast(CommonUtil.rootContext, err.error.toString());
    return super.onError(err);
  }
}

/// 自定义异常
class RequestException implements Exception {
  final String _message;
  final int _code;

  RequestException([
    this._code,
    this._message,
  ]);

  String toString() {
    return "$_code $_message";
  }

  factory RequestException.create(DioError error) {
    switch (error.type) {
      case DioErrorType.CANCEL:
        {
          return RequestException(-1, "请求取消");
        }
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        {
          return RequestException(-1, "连接超时");
        }
        break;
      case DioErrorType.SEND_TIMEOUT:
        {
          return RequestException(-1, "请求超时");
        }
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        {
          return RequestException(-1, "响应超时");
        }
        break;
      case DioErrorType.RESPONSE:
        {
          try {
            int errCode = error.response.statusCode;
            switch (errCode) {
              case 400:
                {
                  return RequestException(errCode, "请求语法错误");
                }
                break;
              case 401:
                {
                  return RequestException(errCode, "没有权限");
                }
                break;
              case 403:
                {
                  return RequestException(errCode, "服务器拒绝执行");
                }
                break;
              case 404:
                {
                  return RequestException(errCode, "无法连接服务器");
                }
                break;
              case 405:
                {
                  return RequestException(errCode, "请求方法被禁止");
                }
                break;
              case 500:
                {
                  return RequestException(errCode, "服务器内部错误");
                }
                break;
              case 502:
                {
                  return RequestException(errCode, "无效的请求");
                }
                break;
              case 503:
                {
                  return RequestException(errCode, "服务器挂了");
                }
                break;
              case 505:
                {
                  return RequestException(errCode, "不支持HTTP协议请求");
                }
                break;
              default:
                {
                  return RequestException(
                      errCode, error.response.statusMessage);
                }
            }
          } on Exception catch (_) {
            return RequestException(-1, "未知错误");
          }
        }
        break;
      default:
        {
          return RequestException(-1, error.message);
        }
    }
  }
}
