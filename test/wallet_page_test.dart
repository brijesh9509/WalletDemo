import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:brijesh_patel/features/wallet/domain/entities/wallet_feature.dart';
import 'package:brijesh_patel/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:brijesh_patel/features/wallet/presentation/pages/wallet_page.dart';
import 'package:brijesh_patel/core/theme.dart';

class MockWalletBloc extends MockBloc<WalletEvent, WalletState>
    implements WalletBloc {}

void main() {
  group('WalletPage Widget Tests', () {
    late MockWalletBloc mockBloc;

    const testFeatures = [
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
        subtitle: 'No need to wait for refunds. Brijesh Patel Money refunds are instant!',
        icon: WalletFeatureIcon.realTimeRefunds,
      ),
    ];

    setUp(() {
      mockBloc = MockWalletBloc();
    });

    Widget buildSubject({WalletState? state}) {
      when(() => mockBloc.state)
          .thenReturn(state ?? const WalletLoaded(features: testFeatures));
      when(() => mockBloc.stream).thenAnswer(
        (_) => Stream.value(state ?? const WalletLoaded(features: testFeatures)),
      );
      return MaterialApp(
        theme: AppTheme.dark,
        home: BlocProvider<WalletBloc>.value(
          value: mockBloc,
          child: const WalletPage(),
        ),
      );
    }

    testWidgets('renders wallet page without error', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(WalletPage), findsOneWidget);
    });

    testWidgets('shows MONEY title when loaded', (tester) async {
      await tester.pumpWidget(
          buildSubject(state: const WalletLoaded(features: testFeatures)));
      await tester.pumpAndSettle();
      expect(find.text('MONEY'), findsOneWidget);
    });

    testWidgets('shows brand name when loaded', (tester) async {
      await tester.pumpWidget(
          buildSubject(state: const WalletLoaded(features: testFeatures)));
      await tester.pumpAndSettle();
      expect(find.text('Brijesh Patel'), findsOneWidget);
    });

    testWidgets('shows Add Money button when loaded', (tester) async {
      await tester.pumpWidget(
          buildSubject(state: const WalletLoaded(features: testFeatures)));
      await tester.pumpAndSettle();
      expect(find.text('Add Money'), findsOneWidget);
    });

    testWidgets('shows Claim Gift Card row when loaded', (tester) async {
      await tester.pumpWidget(
          buildSubject(state: const WalletLoaded(features: testFeatures)));
      await tester.pumpAndSettle();
      expect(find.text('Claim Gift Card'), findsOneWidget);
    });

    testWidgets('shows all 3 feature cards when loaded', (tester) async {
      await tester.pumpWidget(
          buildSubject(state: const WalletLoaded(features: testFeatures)));
      await tester.pumpAndSettle();
      expect(find.text('Single tap payments'), findsOneWidget);
      expect(find.text('Zero failures'), findsOneWidget);
      expect(find.text('Real-time refunds'), findsOneWidget);
    });

    testWidgets('tapping Add Money dispatches correct event', (tester) async {
      await tester.pumpWidget(
          buildSubject(state: const WalletLoaded(features: testFeatures)));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add Money'));
      await tester.pump();
      verify(() => mockBloc.add(const WalletAddMoneyTapped())).called(1);
    });

    testWidgets('tapping Claim Gift Card dispatches correct event',
        (tester) async {
      await tester.pumpWidget(
          buildSubject(state: const WalletLoaded(features: testFeatures)));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Claim Gift Card'));
      await tester.pump();
      verify(() => mockBloc.add(const WalletClaimGiftCardTapped())).called(1);
    });

    testWidgets('settings icon visible in WalletLoaded state', (tester) async {
      await tester.pumpWidget(
          buildSubject(state: const WalletLoaded(features: testFeatures)));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    });
  });
}
