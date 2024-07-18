import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


class AdBannerWidget extends StatelessWidget {
  final AdManagerBannerAd? bannerAd;
  final double sidePadding;

  const AdBannerWidget({
    super.key,
    required this.bannerAd,
    this.sidePadding = 0
  });

  @override
  Widget build(BuildContext context) {
    if(bannerAd != null) {
      return SizedBox(
          width: MediaQuery.of(context).size.width - sidePadding * 2,
          height: bannerAd!.sizes.first.height.toDouble(),
          child: AdWidget(ad: bannerAd!)
      );
    } else {
      return const SizedBox(width: 0, height: 0);
    }
  }
}