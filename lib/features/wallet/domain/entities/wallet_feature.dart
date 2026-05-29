import 'package:equatable/equatable.dart';

class WalletFeature extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final WalletFeatureIcon icon;

  const WalletFeature({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  List<Object> get props => [id, title, subtitle, icon];
}

enum WalletFeatureIcon { singleTap, zeroFailures, realTimeRefunds }
