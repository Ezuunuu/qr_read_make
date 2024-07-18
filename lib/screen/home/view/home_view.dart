import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_make_read/advertise/advertise.dart';
import 'package:qr_make_read/screen/screen.dart';
import 'package:qr_make_read/widget/widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {

  late PageController _pageController;
  late TabController _tabController;

  void _onItemTapped(int index) {
    context.read<HomeCubit>().changeIndex(index: index);
    _pageController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.linearToEaseOut);
    _tabController.animateTo(index, duration: const Duration(milliseconds: 500), curve: Curves.linearToEaseOut);
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: PageView(
            controller: _pageController,
            onPageChanged: _onItemTapped,
            children: const [
              ReadView(),
              WriteView()
            ],
          ),
          bottomNavigationBar: Container(
            color: Theme.of(context).colorScheme.background,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                TabBar(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 5),
                  controller: _tabController,
                  onTap: _onItemTapped,
                  indicator: const CustomTopIndicator(width: 2.5, color: Colors.greenAccent),
                  unselectedLabelColor: const Color(0x5269F0AE),
                  labelColor: Colors.greenAccent,
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  tabs: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 5,
                        child: const Tab(icon: Icon(Icons.qr_code_scanner), text: 'Scan')
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 5,
                        child: const Tab(icon: Icon(Icons.qr_code), text: 'Create')
                    ),
                  ],
                ),
                AdBannerWidget(
                    bannerAd: AdManager.instance.bottomBannerAd,
                    sidePadding: 10.0
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
