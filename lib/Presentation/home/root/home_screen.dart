import 'package:dropili/Presentation/Nfc/nfc_dialoge.dart';
import 'package:dropili/Presentation/home/ProfilePage/bloc/profileScreen_bloc.dart';
import 'package:dropili/Presentation/home/collectionPage/collection_page.dart';
import 'package:dropili/Presentation/home/navigation_bar/navigation_bar_widget.dart';
import 'package:dropili/Presentation/home/qr_page/qr_page.dart';
import 'package:dropili/Presentation/home/ProfilePage/screens/profile_page.dart';
import 'package:dropili/Presentation/home/drawerPage/drawerPage.dart';
import 'package:dropili/Presentation/home/root/bloc/navigation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropili/di/get_it.dart' as getIt;
import 'package:flutter_share/flutter_share.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late NavigationBloc _navigationBloc;
  late ProfileBloc _profileBloc;

  final _pageController = PageController();
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _navigationBloc = getIt.getItInstace<NavigationBloc>();
    _profileBloc = getIt.getItInstace<ProfileBloc>();

    _pages = [
      ProfilePageWidget(),
      Container(),
      QrPage(),
      CollectionPage(),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    _navigationBloc.close();
    _profileBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _navigationBloc),
        BlocProvider.value(value: _profileBloc),
      ],
      child: BlocListener<NavigationBloc, NavigationState>(
        listener: (context, state) async {
          if (state.currentPage == Pages.scanner) {
            context.read<NavigationBloc>().add(NavigationEvent(0));
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              enableDrag: true,
              context: context,
              builder: (context) {
                return NfcScanWidget(
                  dataToTag: 'http://dropili.co/link/' +
                      _profileBloc.state.showProfile!.user.name,
                );
              },
            );
          } else {
            _pageController.animateToPage(state.index,
                duration: Duration(milliseconds: 550), curve: Curves.ease);
          }
        },
        child: BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.black),
                title: Center(
                  child: Image.asset(
                    'assets/dropili_Logo_PNG.png',
                    fit: BoxFit.contain,
                    height: 50,
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.share,
                      color: Colors.black54,
                    ),
                    onPressed: () async {
                      await FlutterShare.share(
                        title: 'Dropili profile',
                        text: context
                                .read<ProfileBloc>()
                                .state
                                .showProfile!
                                .user
                                .name +
                            ' Profile',
                        linkUrl: 'dorpili.co/link/abdenourgnx' +
                            context
                                .read<ProfileBloc>()
                                .state
                                .showProfile!
                                .user
                                .name,
                      );
                      // do something
                    },
                  )
                ],
              ),
              // body: state.currentPage == Pages.profile
              //     ? _pages[0]
              //     : state.currentPage == Pages.qr
              //         ? _pages[1]
              //         : _pages[2],
              body: PageView(
                controller: _pageController,
                children: _pages,
                physics: NeverScrollableScrollPhysics(),
              ),
              drawer: DrawerPage(),
              bottomNavigationBar: NavigatioBarWidget(),
            );
          },
        ),
      ),
    );
  }
}
