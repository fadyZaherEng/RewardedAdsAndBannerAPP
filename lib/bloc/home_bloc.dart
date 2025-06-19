import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late RewardedAd _rewardedAd;
  late BannerAd _bannerAd;
  bool isRewardedAdReady = false;
  bool isBannerAdReady = false;
  int credits = 0;
  bool isTestDevice = true;

  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  void init() {
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: ['YOUR_DEVICE_ID']),
    );
    _initRewardedAd();
    _initBannerAd();
  }

  void _initRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          isRewardedAdReady = true;
          _rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (RewardedAd ad) =>
                debugPrint('ad onAdShowedFullScreenContent.'),
            onAdDismissedFullScreenContent: (RewardedAd ad) {
              ad.dispose();
              isRewardedAdReady = false;
              debugPrint('ad onAdDismissedFullScreenContent.');
              _initRewardedAd();
              emit(HomeGetRewarded());
            },
            onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
              ad.dispose();
              isRewardedAdReady = false;
              debugPrint('ad onAdFailedToShowFullScreenContent: $error');
              _initRewardedAd();
              emit(HomeGetRewarded());
            },
          );
          emit(HomeGetRewarded());
        },
        onAdFailedToLoad: (LoadAdError error) {
          isRewardedAdReady = false;
          debugPrint('Rewarded ad failed to load: $error');
          emit(HomeGetRewarded());
        },
      ),
    );
  }

  void showRewardedAd() {
    if (isRewardedAdReady) {
      _rewardedAd.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          credits += reward.amount.toInt();
          debugPrint('User earned the reward.');
          emit(HomeGetRewarded());
        },
      );
    }
  }

  void _initBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          isBannerAdReady = true;
          emit(HomeGetBanner());
        },
        onAdFailedToLoad: (ad, error) {
          isBannerAdReady = false;
          debugPrint('Banner ad failed to load: $error');
          emit(HomeGetBanner());
        },
      ),
    );
    _bannerAd.load();
  }

  String get rewardedAdUnitId {
    if (isTestDevice) {
      return 'ca-app-pub-3940256099942544/5224354917';
    } else if (Platform.isAndroid) {
      return "ca-app-pub-6463336204730146/7953971006";
    } else {
      return 'ca-app-pub-6463336204730146/1615761545';
    }
  }

  String get bannerAdUnitId {
    if (isTestDevice) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isAndroid) {
      return "ca-app-pub-6463336204730146/3840300322";
    } else {
      return 'ca-app-pub-6463336204730146/2822716218';
    }
  }

  Widget buildBannerAd() {
    if (isBannerAdReady) {
      return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.green[100],
            height: _bannerAd.size.height.toDouble(),
            width: _bannerAd.size.width.toDouble(),
            child: AdWidget(ad: _bannerAd),
          ));
    } else {
      return Container();
    }
  }

  @override
  Future<void> close() {
    _rewardedAd.dispose();
    _bannerAd.dispose();
    return super.close();
  }
}
