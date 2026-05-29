part of 'wallet_bloc.dart';

// ─── Events ──────────────────────────────────────────────────────────────────

abstract class WalletEvent extends Equatable {
  const WalletEvent();
  @override
  List<Object?> get props => [];
}

class WalletInitialized extends WalletEvent {
  const WalletInitialized();
}

class WalletAddMoneyTapped extends WalletEvent {
  const WalletAddMoneyTapped();
}

class WalletClaimGiftCardTapped extends WalletEvent {
  const WalletClaimGiftCardTapped();
}

class WalletAnimationCompleted extends WalletEvent {
  const WalletAnimationCompleted();
}

// ─── States ──────────────────────────────────────────────────────────────────

abstract class WalletState extends Equatable {
  const WalletState();
  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {
  const WalletInitial();
}

class WalletAnimating extends WalletState {
  final List<WalletFeature> features;
  const WalletAnimating({required this.features});
  @override
  List<Object?> get props => [features];
}

class WalletLoaded extends WalletState {
  final List<WalletFeature> features;
  const WalletLoaded({required this.features});
  @override
  List<Object?> get props => [features];
}

class WalletNavigatingToAddMoney extends WalletState {
  const WalletNavigatingToAddMoney();
}

class WalletNavigatingToGiftCard extends WalletState {
  const WalletNavigatingToGiftCard();
}
