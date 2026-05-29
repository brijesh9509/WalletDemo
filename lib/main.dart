import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brijesh_patel/core/theme.dart';
import 'package:brijesh_patel/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:brijesh_patel/features/wallet/presentation/pages/wallet_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brijesh Patel',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: BlocProvider(
        create: (_) => WalletBloc(),
        child: const WalletPage(),
      ),
    );
  }
}
