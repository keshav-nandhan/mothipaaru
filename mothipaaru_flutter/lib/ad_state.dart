
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState{
  Future<InitializationStatus> initialization;
  AdState(this.initialization);

  String get interstitialadunit=>'ca-app-pub-3940256099942544/1033173712';

  // AdListener get adListener=>_adListener;
  // AdListener _adListener=AdListener(onAdLoaded:(ad)=>print('Ad Loaded'));
}
