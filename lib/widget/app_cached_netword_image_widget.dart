import 'package:chatapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

class AppCachedNetwordImageWidget extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Color progressIndicatorColor;
  final Widget? errorWidget;

  const AppCachedNetwordImageWidget({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.progressIndicatorColor = Colors.blue,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: fit,
        width: width,
        height: height,
        progressIndicatorBuilder: (context, url, downloadProgress) => Center(
              child: SpinKitRing(
                color: AppColors.primaryLight,
                size: 20.0,
                lineWidth: 4,
              ),
            ),
        errorWidget: (context, url, error) =>
            errorWidget ??
            SvgPicture.asset(
              "assets/images/no_profile.png",
              color: AppColors.primaryLight,
            ));
  }
}
