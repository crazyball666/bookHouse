import 'package:bookApp/models/Book.dart';
import 'package:bookApp/models/CarouselItem.dart';
import 'package:bookApp/models/Category.dart';
import 'package:bookApp/models/Comment.dart';
import 'package:bookApp/models/ListResult.dart';
import 'package:bookApp/models/User.dart';
import 'package:bookApp/util/CommonUtil.dart';
import 'package:bookApp/util/NetworkUtil.dart';
import 'package:dio/dio.dart';

/// 推荐类型
enum RecommendType {
  RecommendTypeNew,
  RecommendTypeBorrow,
  RecommendTypePopular,
}

/// 请求拦截器
class ApiInterceptor extends Interceptor {
  @override
  Future onRequest(RequestOptions options) {
    return super.onRequest(options);
  }
}

/// 请求单例
class ApiRequest extends Request {
  static ApiRequest _instance = ApiRequest._share();

  factory ApiRequest() => _instance;

  ApiRequest._share() {
    dio.interceptors.add(ApiInterceptor());
  }

  /// 获取Banner数据
  Future<List<CarouselItem>> getCarouselItemList() async {
    Response response =
        await dio.get("${CommonUtil.baseHost}/city_book/api/carousel/list");
    List data = response.data;
    return data.map<CarouselItem>((e) => CarouselItem.initWithMap(e)).toList();
  }

  /// 获取首页分类
  Future<List<BookCategory>> getIndexPageCategoryList() async {
    Response response =
        await dio.get("${CommonUtil.baseHost}/city_book/api/category/list");
    List data = response.data;
    return data.map<BookCategory>((e) => BookCategory.initWithMap(e)).toList();
  }

  /// 获取首页推荐书列表
  Future<List<Book>> getIndexPageRecommendBookList(RecommendType type) async {
    String recommendType = "popular";
    if (type == RecommendType.RecommendTypeBorrow) {
      recommendType = "borrow";
    } else if (type == RecommendType.RecommendTypeNew) {
      recommendType = "new";
    }
    Response response = await dio.get(
        "${CommonUtil.baseHost}/city_book/api/book/recommend",
        queryParameters: {
          "recommend": recommendType,
        });
    List data = response.data;
    return data.map<Book>((e) => Book.initWithMap(e)).toList();
  }

  /// 获取所有分类
  Future<List<BookCategory>> getAllCategory() async {
    Response response =
        await dio.get("${CommonUtil.baseHost}/city_book/api/category/all");
    List data = response.data;
    return data.map<BookCategory>((e) => BookCategory.initWithMap(e)).toList();
  }

  /// 获取书列表
  Future<ListResult<Book>> getBookList({
    int page,
    String searchText,
    int categoryId,
  }) async {
    Response response = await dio.get(
      "${CommonUtil.baseHost}/city_book/api/book/list",
      queryParameters: {
        "offset": (page - 1) * 10,
        "limit": 10,
        "content": searchText,
        "second_category_id": categoryId,
      },
    );
    ListResult<Book> listResult = ListResult<Book>();
    listResult.currentPage = page;
    listResult.total = response.data["total"];
    listResult.totalPage = (listResult.total / 10).ceil();
    List data = response.data["data"];
    listResult.data = data.map<Book>((e) => Book.initWithMap(e)).toList();
    return listResult;
  }

  /// 获取书详情
  Future<Book> getBookDetail(int bookId) async {
    Response response = await dio.get(
      "${CommonUtil.baseHost}/city_book/api/book/${bookId.toString()}",
      queryParameters: {"user_id": 2},
    );
    Map data = response.data;
    return Book.initWithMap(data);
  }

  /// 获取书评论列表
  Future<ListResult<Comment>> getCommentList(int bookId, int page) async {
    Response response = await dio.get(
      "${CommonUtil.baseHost}/city_book/api/comment/list",
      queryParameters: {
        "offset": (page - 1) * 10,
        "limit": 10,
        "book_id": bookId,
      },
    );
    ListResult<Comment> listResult = ListResult<Comment>();
    listResult.currentPage = page;
    listResult.total = response.data["total"];
    listResult.totalPage = (listResult.total / 10).ceil();
    List data = response.data["data"];
    listResult.data = data.map<Comment>((e) => Comment.initWithMap(e)).toList();
    return listResult;
  }

  /// 登录
  Future<User> login(String account, String password) async {
    Response response = await dio.post(
      "${CommonUtil.baseHost}/city_book/api/user/login",
      data: {
        "account": account,
        "password": password,
      },
    );
    Map data = response.data;
    return User.initWithMap(data);
  }

  /// 注册
  Future register(String account, String password) async {
    Response response = await dio.post(
      "${CommonUtil.baseHost}/city_book/api/user/register",
      data: {
        "account": account,
        "password": password,
      },
    );
    Map data = response.data;
    return User.initWithMap(data);
  }
}
