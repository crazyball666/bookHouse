import 'package:bookApp/models/Book.dart';
import 'package:bookApp/models/BorrowCarBook.dart';
import 'package:bookApp/models/BorrowOverviewInfo.dart';
import 'package:bookApp/models/CarouselItem.dart';
import 'package:bookApp/models/Category.dart';
import 'package:bookApp/models/Comment.dart';
import 'package:bookApp/models/ListResult.dart';
import 'package:bookApp/models/User.dart';
import 'package:bookApp/provider/UserProvider.dart';
import 'package:bookApp/util/CommonUtil.dart';
import 'package:bookApp/util/NetworkUtil.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

/// 推荐类型
enum RecommendType {
  RecommendTypeNew,
  RecommendTypeBorrow,
  RecommendTypePopular,
}

enum BorrowListType {
  BorrowListTypeNow, // 当前借阅
  BorrowListTypeHistory, // 历史借阅
  BorrowListTypeViolation // 违规借阅
}

enum BookListType {
  defaultType,
  collectCount,
  score,
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
    String column = "",
    String order = "",
  }) async {
    Response response = await dio.get(
      "${CommonUtil.baseHost}/city_book/api/book/list",
      queryParameters: {
        "offset": (page - 1) * 10,
        "limit": 10,
        "content": searchText,
        "second_category_id": categoryId,
        "column": column,
        "order": order,
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
    int uid = Provider.of<UserProvider>(CommonUtil.rootContext, listen: false)
        .user
        ?.id;
    Response response = await dio.get(
      "${CommonUtil.baseHost}/city_book/api/book/${bookId.toString()}",
      queryParameters: {"user_id": uid ?? ""},
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

  /// 借阅预览
  Future<BorrowOverviewInfo> getBorrowOverviewInfo(int uid) async {
    Response response = await dio.get(
        "${CommonUtil.baseHost}/city_book/api/borrow_record/count",
        queryParameters: {
          "user_id": uid,
        });
    return BorrowOverviewInfo.initWithMap(response.data);
  }

  /// 借阅列表
  Future<List<Map>> getBookBorrowList({
    int uid,
    BorrowListType type,
  }) async {
    String typeStr = "now";
    if (type == BorrowListType.BorrowListTypeHistory) {
      typeStr = "history";
    } else if (type == BorrowListType.BorrowListTypeViolation) {
      typeStr = "violation";
    }
    Response response = await dio.get(
      "${CommonUtil.baseHost}/city_book/api/borrow_record/list",
      queryParameters: {
        "user_id": uid,
        "offset": 0,
        "limit": -1,
        "type": typeStr,
      },
    );
    Map result = response.data;
    List booksData = result["data"];
    return booksData.map<Map>((e) => e).toList();
  }

  /// 加入借阅车
  Future addBorrowCar({
    int bookId,
  }) async {
    int uid = Provider.of<UserProvider>(CommonUtil.rootContext, listen: false)
        .user
        ?.id;
    Response response = await dio.post(
      "${CommonUtil.baseHost}/city_book/api/borrow_record",
      data: {
        "user_id": uid,
        "book_id": bookId,
      },
    );
    if (response.data["stateCode"] != 200) {
      throw Exception("收藏失败");
    }
  }

  /// 借阅车列表
  Future<List<BorrowCarBook>> getBorrowCarBookList() async {
    int uid = Provider.of<UserProvider>(CommonUtil.rootContext, listen: false)
        .user
        ?.id;
    Response response = await dio.get(
      "${CommonUtil.baseHost}/city_book/api/borrow_car/list",
      queryParameters: {
        "user_id": uid,
      },
    );
    List data = response.data;
    return data.map((e) => BorrowCarBook.initWithMap(e)).toList();
  }

  /// 取消借阅车
  Future cancelBorrowCar(
    int borrowCarItemId,
  ) async {
    int uid = Provider.of<UserProvider>(CommonUtil.rootContext, listen: false)
        .user
        ?.id;
    Response response = await dio.delete(
      "${CommonUtil.baseHost}/city_book/api/borrow_car/$borrowCarItemId",
      queryParameters: {
        "user_id": uid,
      },
    );
    if (response.data["stateCode"] != 200) {
      throw Exception("取消收藏失败");
    }
  }

  /// 收藏列表
  Future<List<Map>> getCollectBookList() async {
    int uid = Provider.of<UserProvider>(CommonUtil.rootContext, listen: false)
        .user
        ?.id;
    Response response = await dio.get(
        "${CommonUtil.baseHost}/city_book/api/collect/list",
        queryParameters: {
          "user_id": uid,
        });
    List data = response.data;
    return data.map<Map>((e) => e).toList();
  }

  /// 添加收藏
  Future addCollect(int bookId) async {
    int uid = Provider.of<UserProvider>(CommonUtil.rootContext, listen: false)
        .user
        ?.id;
    Response response =
        await dio.post("${CommonUtil.baseHost}/city_book/api/collect", data: {
      "user_id": uid,
      "book_id": bookId,
    });
    if (response.data["stateCode"] != 200 &&
        response.data["stateCode"] != 403) {
      throw Exception("收藏失败");
    }
  }

  /// 取消收藏
  Future cancelCollect(int bookId) async {
    int uid = Provider.of<UserProvider>(CommonUtil.rootContext, listen: false)
        .user
        ?.id;
    Response response =
        await dio.delete("${CommonUtil.baseHost}/city_book/api/collect", data: {
      "user_id": uid,
      "book_id": bookId,
    });
    if (response.data["stateCode"] != 200) {
      throw Exception("取消收藏失败");
    }
  }
}
