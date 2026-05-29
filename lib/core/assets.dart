import 'package:flutter/widgets.dart';

class AppAssets {
  static const String _pngPath = 'assets/images/png';

  static String png(String name) => '$_pngPath/$name.png';

  static String get walletIcon => png('wallet_icon');
  static String get giftCardIcon => png('gift_card_icon');
  static String get handTapIcon => png('hand_tap_icon');
  static String get phoneWifiIcon => png('phone_wifi_icon');
  static String get phoneRefundIcon => png('phone_refund_icon');
  static String get dottedTexture => 'assets/images/appImages/dotted_texture_image.png';

  static Image image(
    String path, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
    Alignment alignment = Alignment.center,
  }) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      color: color,
      alignment: alignment,
    );
  }
}
