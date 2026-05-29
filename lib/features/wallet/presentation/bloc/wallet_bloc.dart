import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brijesh_patel/features/wallet/domain/entities/wallet_feature.dart';

part 'wallet_event_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(const WalletInitial()) {
    on<WalletInitialized>(_onInitialized);
    on<WalletAnimationCompleted>(_onAnimationCompleted);
    on<WalletAddMoneyTapped>(_onAddMoneyTapped);
    on<WalletClaimGiftCardTapped>(_onClaimGiftCardTapped);
  }

  static const List<WalletFeature> _features = [
    WalletFeature(
      id: 'single_tap',
      title: 'Single tap payments',
      subtitle: 'Enjoy seamless payments without the wait for OTPs',
      icon: WalletFeatureIcon.singleTap,
    ),
    WalletFeature(
      id: 'zero_failures',
      title: 'Zero failures',
      subtitle: 'Zero payment failures ensure you never miss an order',
      icon: WalletFeatureIcon.zeroFailures,
    ),
    WalletFeature(
      id: 'real_time_refunds',
      title: 'Real-time refunds',
      subtitle: 'No need to wait for refunds. Blinkit Money refunds are instant!',
      icon: WalletFeatureIcon.realTimeRefunds,
    ),
  ];

  void _onInitialized(WalletInitialized event, Emitter<WalletState> emit) {
    emit(const WalletAnimating(features: _features));
  }

  void _onAnimationCompleted(
    WalletAnimationCompleted event,
    Emitter<WalletState> emit,
  ) {
    emit(const WalletLoaded(features: _features));
  }

  void _onAddMoneyTapped(
    WalletAddMoneyTapped event,
    Emitter<WalletState> emit,
  ) {
    emit(const WalletNavigatingToAddMoney());
    emit(const WalletLoaded(features: _features));
  }

  void _onClaimGiftCardTapped(
    WalletClaimGiftCardTapped event,
    Emitter<WalletState> emit,
  ) {
    emit(const WalletNavigatingToGiftCard());
    emit(const WalletLoaded(features: _features));
  }
}
