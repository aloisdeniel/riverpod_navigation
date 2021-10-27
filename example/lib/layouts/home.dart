import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_navigation/riverpod_navigation.dart';

class HomeLayout extends ConsumerStatefulWidget {
  const HomeLayout({
    Key? key,
    required this.activeTab,
    required this.tabs,
  }) : super(key: key);

  final int activeTab;
  final List<Navigator> tabs;

  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends ConsumerState<HomeLayout> {
  late final pageController = PageController(initialPage: widget.activeTab);

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HomeLayout oldWidget) {
    if (pageController.position.hasViewportDimension &&
        widget.activeTab != pageController.page) {
      pageController.animateToPage(
        widget.activeTab,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () => ref.navigation.navigate(Uri.parse('/about')),
          )
        ],
      ),
      body: PageView(
        controller: pageController,
        children: [
          ...widget.tabs,
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: ref.navigation.activeTabForRoute(Key('Home')) ?? 0,
        onTap: (index) {
          ref.navigation.setActiveTabForRoute(Key('Home'), index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_3x3),
            label: 'Articles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
