import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  // singleton instance
  static AdManager instance = AdManager();

  // 스크린 별로 사용될 AdManagerBannerAd 객체들
  AdManagerBannerAd? bottomBannerAd;

  AdManager({
    this.bottomBannerAd,
  });

  // AdManager 객체 초기화
  factory AdManager.init() => instance = AdManager(
    bottomBannerAd: _loadBannerAd(),
  );
}

// AdManagerBannerAd 객체를 로드하는 함수
AdManagerBannerAd _loadBannerAd() {
  const String androidBannerAdUnitId = 'ca-app-pub-6782725719721526~9727756440';
  const String iosBannerAdUnitId = 'ca-app-pub-6782725719721526~9727756440';

  String adUnitId = androidBannerAdUnitId;
  if(Platform.isIOS) adUnitId = iosBannerAdUnitId;

  return AdManagerBannerAd(
    adUnitId: adUnitId,
    request: const AdManagerAdRequest(),
    sizes: [AdSize.banner],
    listener: AdManagerBannerAdListener(),
  )..load();
}