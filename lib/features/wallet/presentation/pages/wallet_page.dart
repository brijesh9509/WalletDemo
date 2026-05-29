import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brijesh_patel/features/wallet/domain/entities/wallet_feature.dart';
import 'package:brijesh_patel/core/theme.dart';
import 'package:brijesh_patel/core/assets.dart';
import 'package:brijesh_patel/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:brijesh_patel/features/wallet/presentation/widgets/confetti_painter.dart';
import 'package:brijesh_patel/features/wallet/presentation/widgets/feature_card.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with TickerProviderStateMixin {
  // ── Confetti ───────────────────────────────────────────────────────────────
  final List<ConfettiParticle> _particles = [];
  final math.Random _rng = math.Random();
  late final Ticker _confettiTicker;
  bool _confettiActive = false;
  Completer<void>? _confettiCompleter;

  // ── Wallet icon bounce ─────────────────────────────────────────────────────
  late final AnimationController _walletBounceCtrl;
  late final Animation<double> _walletScaleAnim;
  late final Animation<double> _walletRotateAnim;
  late final Animation<Offset> _walletPositionAnim;

  // ── Brand text fade ────────────────────────────────────────────────────────
  late final AnimationController _brandTextCtrl;
  late final Animation<double> _brandNameFade;
  late final Animation<Offset> _brandNameSlide;
  late final Animation<double> _moneyTitleFade;
  late final Animation<double> _moneyTitleScale;
  late final Animation<double> _moneyShiftScaleAnim;

  // ── Feature cards slide up ────────────────────────────────────────────────
  late final AnimationController _cardsCtrl;
  late final List<Animation<double>> _cardOffsets;
  late final List<Animation<double>> _cardOpacities;

  // ── CTA + gift card ────────────────────────────────────────────────────────
  late final AnimationController _ctaCtrl;
  late final Animation<double> _ctaOpacity;
  late final Animation<Offset> _ctaSlide;
  late final Animation<double> _giftCardOpacity;
  late final Animation<Offset> _giftCardSlide;
  late final Animation<Color?> _cardBgColor;
  late final Animation<Color?> _dotsBgColor;

  // ── Bottom slogan ──────────────────────────────────────────────────────────
  late final AnimationController _sloganCtrl;
  late final Animation<double> _sloganOpacity;

  // ── Dotted texture ─────────────────────────────────────────────────────────
  late final AnimationController _dotsCtrl;
  late final Animation<double> _dotsOpacity;

  // ── Background transition ──────────────────────────────────────────────────
  late final AnimationController _bgCtrl;

  // ── Content shift (center to top) ──────────────────────────────────────────
  late final AnimationController _contentShiftCtrl;
  late final Animation<double> _contentShiftAnim;

  // ── Wallet "settle" wiggle ────────────────────────────────────────────────
  late final AnimationController _wiggleCtrl;
  late final Animation<double> _wiggleRotation;

  Size _screenSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _screenSize = MediaQuery.of(context).size;
      context.read<WalletBloc>().add(const WalletInitialized());
      _startSequence();
    });
  }

  void _initAnimations() {
    // Dots fade-in
    _dotsCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _dotsOpacity = CurvedAnimation(parent: _dotsCtrl, curve: Curves.easeIn);

    // Wallet bounce in
    _walletBounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _walletScaleAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.15)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.15, end: 0.92)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.92, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 25,
      ),
    ]).animate(_walletBounceCtrl);

    _walletRotateAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: -0.3, end: 0.18)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.18, end: -0.08)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -0.08, end: 0.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 30,
      ),
    ]).animate(_walletBounceCtrl);

    _walletPositionAnim = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0, -0.15), end: const Offset(0, 0))
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0, 0), end: const Offset(0, 0.02))
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0, 0.02), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
    ]).animate(_walletBounceCtrl);

    // Wiggle after bounce
    _wiggleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _wiggleRotation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.06), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.06, end: -0.06), weight: 50),
      TweenSequenceItem(tween: Tween(begin: -0.06, end: 0.0), weight: 25),
    ]).animate(CurvedAnimation(parent: _wiggleCtrl, curve: Curves.easeInOut));

    // Brand text
    _brandTextCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _brandNameFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _brandTextCtrl,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _brandNameSlide = Tween(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _brandTextCtrl,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );
    _moneyTitleFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _brandTextCtrl,
        curve: const Interval(0.35, 1.0, curve: Curves.easeOut),
      ),
    );
    _moneyTitleScale = Tween(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _brandTextCtrl,
        curve: const Interval(0.35, 1.0, curve: Curves.easeOutBack),
      ),
    );

    // Feature cards
    _cardsCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _cardOffsets = List.generate(3, (i) {
      final start = 0.1 + i * 0.15;
      final end = (start + 0.45).clamp(0.0, 1.0);
      return Tween(begin: 80.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _cardsCtrl,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });
    _cardOpacities = List.generate(3, (i) {
      final start = 0.1 + i * 0.15;
      final end = (start + 0.35).clamp(0.0, 1.0);
      return Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _cardsCtrl,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    // CTA & gift card
    _ctaCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _ctaOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctaCtrl,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _ctaSlide = Tween(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _ctaCtrl,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );
    _giftCardOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctaCtrl,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );
    _giftCardSlide = Tween(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _ctaCtrl,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _cardBgColor = ColorTween(
      begin: AppColors.surfaceCard,
      end: const Color(0xFF36353a),
    ).animate(CurvedAnimation(
      parent: _ctaCtrl,
      curve: Curves.easeInOut,
    ));

    _dotsBgColor = ColorTween(
      begin: Colors.transparent,
      end: const Color(0xFF141306)
          .withValues(alpha: 0.8), // Distinct dark olive-gold tint
    ).animate(CurvedAnimation(
      parent: _ctaCtrl,
      curve: Curves.easeInOut,
    ));

    // Bottom slogan
    _sloganCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _sloganOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sloganCtrl, curve: Curves.easeOut),
    );

    // Content shift
    _contentShiftCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _contentShiftAnim = CurvedAnimation(
      parent: _contentShiftCtrl,
      curve: Curves.easeInOutCubic,
    );
    _moneyShiftScaleAnim =
        Tween<double>(begin: 1.0, end: 0.8).animate(_contentShiftAnim);

    // Background transition
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Confetti ticker
    _confettiTicker = createTicker((_) {
      if (!_confettiActive) return;
      setState(() {
        for (final p in _particles) {
          p.update(0.55, _screenSize);
        }
        _particles.removeWhere((p) => !p.isActive);
        if (_particles.isEmpty && _confettiActive) {
          _confettiActive = false;
          _confettiTicker.stop();
          _confettiCompleter?.complete();
        }
      });
    });
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _dotsCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    // 1. Wallet icon bounce & wiggle in center
    await _walletBounceCtrl.forward();
    _wiggleCtrl.forward();

    // 2. Confetti animation
    _triggerConfetti();

    await Future.delayed(const Duration(milliseconds: 300));
    // 3. Wallet icon with below text animated show in center
    await _brandTextCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 600));
    // 4. Move wallet icon and text from center to top
    await _contentShiftCtrl.forward();

    // 5. Change background & show feature cards
    _bgCtrl.forward();
    await _cardsCtrl.forward();

    // 6. Display CTA and slogan
    await _ctaCtrl.forward();
    _sloganCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      context.read<WalletBloc>().add(const WalletAnimationCompleted());
    }
  }

  void _triggerConfetti() {
    _confettiCompleter = Completer<void>();
    if (_screenSize == Size.zero) {
      _screenSize = const Size(390, 844);
    }

    final mq = MediaQuery.of(context);
    const double headerHeight = 66.0;
    const double contentHeight = 200.0;
    final double availableHeight =
        mq.size.height - mq.padding.top - headerHeight - mq.padding.bottom;
    final double initialPadding = (availableHeight - contentHeight) / 2;
    final double iconCenterY =
        mq.padding.top + headerHeight + initialPadding + 60;
    final double iconCenterX = _screenSize.width / 2;

    _particles.clear();
    for (int i = 0; i < 80; i++) {
      _particles.add(ConfettiParticle.random(
        _rng,
        _screenSize,
        startPosition: Offset(iconCenterX, iconCenterY),
      ));
    }
    _confettiActive = true;
    _confettiTicker.start();
  }

  @override
  void dispose() {
    _confettiTicker.dispose();
    _walletBounceCtrl.dispose();
    _wiggleCtrl.dispose();
    _brandTextCtrl.dispose();
    _cardsCtrl.dispose();
    _ctaCtrl.dispose();
    _sloganCtrl.dispose();
    _dotsCtrl.dispose();
    _bgCtrl.dispose();
    _contentShiftCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Stack(
          children: [
            // ── Base Linear Gradient ───────────────────────────────────────
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF2E2A0E), // Subtle dark gold base at the top
                      AppColors.backgroundDark,
                    ],
                    stops: [0.0, 0.45],
                  ),
                ),
              ),
            ),

            // ── Dotted texture (Asset Image) ──────────────────────────────
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 350,
              child: AnimatedBuilder(
                animation: Listenable.merge([_dotsOpacity, _dotsBgColor]),
                builder: (_, __) => ShaderMask(
                  shaderCallback: (rect) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black, Colors.transparent],
                      stops: [0.6, 1.0],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Container(
                    color: _dotsBgColor.value,
                    child: Opacity(
                      opacity: _dotsOpacity.value,
                      child: AppAssets.image(
                        AppAssets.dottedTexture,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Two-part background transition (Dark Overlay) ───────────────
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _ctaOpacity,
                builder: (_, __) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        const Color(0xFF0D0D0D)
                            .withValues(alpha: 0.8 * _ctaOpacity.value),
                        const Color(0xFF0D0D0D)
                            .withValues(alpha: 0.98 * _ctaOpacity.value),
                      ],
                      stops: const [0.1, 0.45, 0.8],
                    ),
                  ),
                ),
              ),
            ),


            // ── Main scrollable content ────────────────────────────────────
            SafeArea(
              child: Column(
                children: [
                  // Header row
                  _buildHeader(),

                  // Scrollable body
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          _buildMovingContent(),
                          const SizedBox(height: 28),
                          // Feature cards
                          _buildFeatureCards(),
                          const SizedBox(height: 28),
                          // CTA button
                          _buildCtaButton(),
                          const SizedBox(height: 16),
                          // Gift card row
                          _buildGiftCardRow(),
                          const SizedBox(height: 40),
                          // Bottom slogan
                          _buildBottomSlogan(),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Confetti overlay ───────────────────────────────────────────
            if (_confettiActive || _particles.isNotEmpty)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: ConfettiPainter(particles: _particles),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.of(context).maybePop(),
          ),
          AnimatedBuilder(
            animation: _ctaOpacity,
            builder: (_, __) => Opacity(
              opacity: _ctaOpacity.value,
              child: _CircleIconButton(
                icon: Icons.settings_outlined,
                onTap: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovingContent() {
    return AnimatedBuilder(
      animation: _contentShiftAnim,
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        const double headerHeight = 66.0;
        const double contentHeight = 200.0; // Icon(120) + Gap(16) + Text(~64)
        final double availableHeight =
            mq.size.height - mq.padding.top - headerHeight - mq.padding.bottom;

        // Initially center both icon and text together
        final double initialPadding = (availableHeight - contentHeight) / 2;
        const double targetPadding = 24.0;

        final double currentPadding = Tween<double>(
          begin: initialPadding > 0 ? initialPadding : targetPadding,
          end: targetPadding,
        ).evaluate(_contentShiftAnim);

        // Adjust gap to pull text closer as they scale down (20% smaller)
        final double currentGap = Tween<double>(
          begin: 16.0,
          end: -10.0,
        ).evaluate(_contentShiftAnim);

        return Column(
          children: [
            SizedBox(height: currentPadding),
            _buildWalletIcon(),
            SizedBox(height: math.max(0.0, currentGap)),
            Transform.translate(
              offset: Offset(0, math.min(0.0, currentGap)),
              child: _buildBrandText(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWalletIcon() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _walletBounceCtrl,
        _wiggleCtrl,
        _contentShiftAnim,
      ]),
      builder: (_, __) {
        final rotation = _walletBounceCtrl.isCompleted
            ? _wiggleRotation.value
            : _walletRotateAnim.value;
        return SlideTransition(
          position: _walletPositionAnim,
          child: Transform.scale(
            scale: _walletScaleAnim.value * _moneyShiftScaleAnim.value,
            child: Transform.rotate(
              angle: rotation,
              child: AppAssets.image(
                AppAssets.walletIcon,
                width: 120,
                height: 120,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBrandText() {
    return AnimatedBuilder(
      animation: Listenable.merge([_brandTextCtrl, _contentShiftAnim]),
      builder: (_, __) {
        final double textGap = Tween<double>(
          begin: 4.0,
          end: 0.0,
        ).evaluate(_contentShiftAnim);

        return Transform.scale(
          scale: _moneyShiftScaleAnim.value,
          child: Column(
            children: [
              FadeTransition(
                opacity: _brandNameFade,
                child: SlideTransition(
                  position: _brandNameSlide,
                  child: const Text('blinkit', style: AppTextStyles.brandName),
                ),
              ),
              SizedBox(height: textGap),
              FadeTransition(
                opacity: _moneyTitleFade,
                child: Transform.scale(
                  scale: _moneyTitleScale.value,
                  child: const Text('MONEY', style: AppTextStyles.moneyTitle),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeatureCards() {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (_, state) {
        List<WalletFeature> features = [];
        if (state is WalletAnimating) features = state.features;
        if (state is WalletLoaded) features = state.features;

        if (features.isNotEmpty) {
          return AnimatedBuilder(
            animation: Listenable.merge([_cardsCtrl, _ctaCtrl]),
            builder: (_, __) {
              return Column(
                children: List.generate(
                  features.length,
                  (i) => FeatureCard(
                    feature: features[i],
                    slideOffset: _cardOffsets[i].value,
                    opacity: _cardOpacities[i].value,
                    backgroundColor: _cardBgColor.value,
                  ),
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCtaButton() {
    return AnimatedBuilder(
      animation: _ctaCtrl,
      builder: (_, __) => FadeTransition(
        opacity: _ctaOpacity,
        child: SlideTransition(
          position: _ctaSlide,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _GreenCtaButton(
              label: 'Add Money',
              onTap: () {
                context.read<WalletBloc>().add(const WalletAddMoneyTapped());
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGiftCardRow() {
    return AnimatedBuilder(
      animation: _ctaCtrl,
      builder: (_, __) => FadeTransition(
        opacity: _giftCardOpacity,
        child: SlideTransition(
          position: _giftCardSlide,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () {
                context
                    .read<WalletBloc>()
                    .add(const WalletClaimGiftCardTapped());
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: AppColors.surfaceCardBorder, width: 1),
                ),
                child: Row(
                  children: [
                    // Gift icon
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF644514),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: AppAssets.image(
                        AppAssets.giftCardIcon,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Claim Gift Card',
                              style: AppTextStyles.txtTitle),
                          SizedBox(height: 2),
                          Text(
                            'Enter gift card details to claim your gift card',
                            style: AppTextStyles.txtSubtitle,
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textMuted,
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSlogan() {
    return AnimatedBuilder(
      animation: _sloganCtrl,
      builder: (_, __) => FadeTransition(
        opacity: _sloganOpacity,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Enjoy seamless\none tap payments',
            style: AppTextStyles.bottomSlogan,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

// ── Reusable widgets ──────────────────────────────────────────────────────────

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2818),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF3A3820), width: 1),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}

class _GreenCtaButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _GreenCtaButton({required this.label, required this.onTap});

  @override
  State<_GreenCtaButton> createState() => _GreenCtaButtonState();
}

class _GreenCtaButtonState extends State<_GreenCtaButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _pressCtrl.forward(),
      onTapUp: (_) {
        _pressCtrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _pressCtrl.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (_, child) => Transform.scale(
          scale: _scaleAnim.value,
          child: child,
        ),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF4CAF50),
                Color(0xFF388E3C),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(widget.label, style: AppTextStyles.ctaButton),
        ),
      ),
    );
  }
}
