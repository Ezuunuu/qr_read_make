import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_make_read/config/config.dart';
import 'package:qr_make_read/screen/screen.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d("Splash");
    timer = Timer(const Duration(seconds: 2), () async {
      await context.read<HomeCubit>().init();
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PrettyQrView.data(
              data: 'Qr Pixel'
            ),
            const Text('QR Pixel', style: TextStyle(),)
          ],
        )
      ),
    );
  }
}
