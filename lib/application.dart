import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_make_read/config/config.dart';
import 'package:qr_make_read/database/database.dart';
import 'package:qr_make_read/screen/screen.dart';

class Application extends StatelessWidget {
  const Application(
      {
        super.key,
        required this.databaseRepository
      }
  );

  final DatabaseRepository databaseRepository;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit(databaseRepository: databaseRepository)),
        BlocProvider(create: (_) => ReadCubit(databaseRepository: databaseRepository)),
        BlocProvider(create: (_) => WriteCubit(databaseRepository: databaseRepository)),
      ],
      child: const _GestureWrapper(
          child: _ApplicationDetail()
      ),
    );
  }
}

class _GestureWrapper extends StatelessWidget {
  const _GestureWrapper(
      {
        required this.child
      }
  );

  final Widget child;

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return GestureDetector(
      onTap: () {
        try {
          FocusScope.of(context).unfocus();
          FocusManager.instance.primaryFocus!.unfocus();
          // FocusScope.of(context).requestFocus(FocusNode());
          // SystemChannels.textInput.invokeMethod('TextInput.hide');
        } catch (e) {
          logger.e("Gesture Wrapper Error");
        }
      },
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }
}

class _ApplicationDetail extends StatelessWidget {
  const _ApplicationDetail();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
            builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                child: child!
            ),
            debugShowCheckedModeBanner: false,
            theme: initThemeData(brightness: Brightness.light),
            darkTheme: initThemeData(brightness: Brightness.dark),
            themeMode: ThemeMode.system,
            home: child,
            // onGenerateRoute: (_) => MaterialPageRoute(builder: (context) => const SplashView()),
        );
      },
      child: const SafeArea(
        child: HomeView(),
      )
    );
  }
}
