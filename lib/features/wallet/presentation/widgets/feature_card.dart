import 'package:flutter/material.dart';
import 'package:brijesh_patel/core/theme.dart';
import 'package:brijesh_patel/core/assets.dart';
import 'package:brijesh_patel/features/wallet/domain/entities/wallet_feature.dart';

class FeatureCard extends StatelessWidget {
  final WalletFeature feature;
  final double slideOffset;
  final double opacity;
  final Color? backgroundColor;

  const FeatureCard({
    super.key,
    required this.feature,
    this.slideOffset = 0,
    this.opacity = 1.0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, slideOffset),
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.surfaceCardBorder,
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _FeatureIconBox(icon: feature.icon),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(feature.title, style: AppTextStyles.txtTitle),
                    const SizedBox(height: 4),
                    Text(feature.subtitle,
                        style: AppTextStyles.txtSubtitle),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureIconBox extends StatelessWidget {
  final WalletFeatureIcon icon;

  const _FeatureIconBox({required this.icon});

  String _getAssetPath() {
    switch (icon) {
      case WalletFeatureIcon.singleTap:
        return AppAssets.handTapIcon;
      case WalletFeatureIcon.zeroFailures:
        return AppAssets.phoneWifiIcon;
      case WalletFeatureIcon.realTimeRefunds:
        return AppAssets.phoneRefundIcon;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF262626), width: 1),
      ),
      padding: const EdgeInsets.all(12),
      child: AppAssets.image(
        _getAssetPath(),
      ),
    );
  }
}
