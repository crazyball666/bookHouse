import 'package:bookApp/models/CarouselItem.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

/// Banner图组件
class BannerView extends StatefulWidget {
  final List<CarouselItem> carouselData;

  BannerView({this.carouselData = const []});

  @override
  State<StatefulWidget> createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {
  Widget _bannerItemBuilder(BuildContext context, int index) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.w),
      ),
      clipBehavior: Clip.hardEdge,
      child: CachedNetworkImage(
        imageUrl: widget.carouselData[index].image,
        fit: BoxFit.fill,
        errorWidget: (context, url, error) {
          return CachedNetworkImage(
            imageUrl:
            "https://static.crazyball.xyz/uploads/2020-07-19/1595154126_53ykv0ieyfy.jpeg",
            fit: BoxFit.fill,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 400.w,
        margin: EdgeInsets.only(top: 20.w),
        child: Swiper(
          key: UniqueKey(),
          itemCount: widget.carouselData.length,
          itemBuilder: _bannerItemBuilder,
          pagination: SwiperPagination(),
          scale: 0.8,
          viewportFraction: 0.8,
          // autoplay: true,
        ),
      ),
    );
  }
}
