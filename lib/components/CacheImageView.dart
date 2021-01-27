import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// 缓存图片组件
class CacheImageView extends StatelessWidget {
  final String url;
  final BoxFit fit;

  CacheImageView({
    @required this.url,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      errorWidget: (context, url, err) {
        return CachedNetworkImage(
          imageUrl:
              "https://static.crazyball.xyz/uploads/2020-07-19/1595154126_53ykv0ieyfy.jpeg",
          fit: fit,
        );
      },
    );
  }
}
