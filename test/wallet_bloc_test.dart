import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:brijesh_patel/features/wallet/domain/entities/wallet_feature.dart';
import 'package:brijesh_patel/features/wallet/presentation/bloc/wallet_bloc.dart';

void main() {
  group('WalletBloc', () {
    late WalletBloc bloc;

    setUp(() {
      bloc = WalletBloc();
    });

    tearDown(() => bloc.close());

    test('initial state is WalletInitial', () {
      expect(bloc.state, const WalletInitial());
    });

    blocTest<WalletBloc, WalletState>(
      'emits [WalletAnimating] when WalletInitialized is added',
      build: () => WalletBloc(),
      act: (b) => b.add(const WalletInitialized()),
      expect: () => [isA<WalletAnimating>()],
    );

    blocTest<WalletBloc, WalletState>(
      'emits [WalletAnimating, WalletLoaded] sequence',
      build: () => WalletBloc(),
      act: (b) {
        b.add(const WalletInitialized());
        b.add(const WalletAnimationCompleted());
      },
      expect: () => [
        isA<WalletAnimating>(),
        isA<WalletLoaded>(),
      ],
    );

    blocTest<WalletBloc, WalletState>(
      'WalletLoaded contains correct number of features',
      build: () => WalletBloc(),
      act: (b) {
        b.add(const WalletInitialized());
        b.add(const WalletAnimationCompleted());
      },
      verify: (b) {
        final state = b.state;
        expect(state, isA<WalletLoaded>());
        final loaded = state as WalletLoaded;
        expect(loaded.features.length, 3);
      },
    );

    blocTest<WalletBloc, WalletState>(
      'WalletLoaded features have correct icons',
      build: () => WalletBloc(),
      act: (b) {
        b.add(const WalletInitialized());
        b.add(const WalletAnimationCompleted());
      },
      verify: (b) {
        final loaded = b.state as WalletLoaded;
        expect(loaded.features[0].icon, WalletFeatureIcon.singleTap);
        expect(loaded.features[1].icon, WalletFeatureIcon.zeroFailures);
        expect(loaded.features[2].icon, WalletFeatureIcon.realTimeRefunds);
      },
    );

    blocTest<WalletBloc, WalletState>(
      'AddMoneyTapped emits navigating then returns to loaded',
      build: () => WalletBloc(),
      seed: () => const WalletLoaded(features: [
        WalletFeature(
          id: 'test',
          title: 'T',
          subtitle: 'S',
          icon: WalletFeatureIcon.singleTap,
        ),
      ]),
      act: (b) => b.add(const WalletAddMoneyTapped()),
      expect: () => [
        const WalletNavigatingToAddMoney(),
        isA<WalletLoaded>(),
      ],
    );

    blocTest<WalletBloc, WalletState>(
      'ClaimGiftCardTapped emits navigating then returns to loaded',
      build: () => WalletBloc(),
      seed: () => const WalletLoaded(features: []),
      act: (b) => b.add(const WalletClaimGiftCardTapped()),
      expect: () => [
        const WalletNavigatingToGiftCard(),
        isA<WalletLoaded>(),
      ],
    );
  });

  group('WalletFeature entity', () {
    const feature = WalletFeature(
      id: 'test_id',
      title: 'Test Title',
      subtitle: 'Test Subtitle',
      icon: WalletFeatureIcon.singleTap,
    );

    test('props equality works correctly', () {
      const same = WalletFeature(
        id: 'test_id',
        title: 'Test Title',
        subtitle: 'Test Subtitle',
        icon: WalletFeatureIcon.singleTap,
      );
      expect(feature, equals(same));
    });

    test('different id makes entities unequal', () {
      const different = WalletFeature(
        id: 'other_id',
        title: 'Test Title',
        subtitle: 'Test Subtitle',
        icon: WalletFeatureIcon.singleTap,
      );
      expect(feature, isNot(equals(different)));
    });

    test('toString reflects all props', () {
      expect(feature.props, [
        'test_id',
        'Test Title',
        'Test Subtitle',
        WalletFeatureIcon.singleTap,
      ]);
    });
  });
}
