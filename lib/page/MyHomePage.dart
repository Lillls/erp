import 'package:erp/page/category_list_page.dart';
import 'package:erp/page/product_add_page.dart';
import 'package:erp/page/product_list_page.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _pageIndex = 0;
  final PageController _controller = PageController();

  @override
  void initState() {
    super.initState();
  }

  final List<NavigationRailDestination> destinations = [
    NavigationRailDestination(
        icon: Container(
          alignment: Alignment.center,
          width: 200,
          child: const Text(
            "商品管理",
            style: TextStyle(color: Colors.white),
          ),
        ),
        label: Container(
          alignment: Alignment.center,
          width: 200,
          child: const Text(""),
        )),
    NavigationRailDestination(
        icon: Container(
          alignment: Alignment.center,
          width: 200,
          child: const Text(
            "品类管理",
            style: TextStyle(color: Colors.white),
          ),
        ),
        label: const Text("")),
    NavigationRailDestination(
        icon: Container(
          alignment: Alignment.center,
          width: 200,
          child: const Text(
            "运费管理",
            style: TextStyle(color: Colors.white),
          ),
        ),
        label: Container(
          alignment: Alignment.center,
          width: 200,
          child: const Text(""),
        )),
  ];

  Widget _buildLeftNavigation(int index) {
    return Container(
      width: 250,
      padding: const EdgeInsets.only(bottom: 20, left: 20),
      child: NavigationRail(
        onDestinationSelected: _onDestinationSelected,
        backgroundColor: const Color(0xFF041527),
        destinations: destinations,
        selectedIndex: index,
        indicatorColor: const Color(0xFF2a5eb7),
      ),
    );
  }

  void _onDestinationSelected(int value) {
    _controller.jumpToPage(value);
    setState(() {
      _pageIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var page = Navigator(
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case 'list':
            builder = (context) => ProductListPage();
            break;
          case 'add':
            builder = (context) => ProductAddPage();
            break;
          default:
            builder = (context) => ProductListPage();
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
    List<Widget> navigatorChild = [
      page,
      CategoryListPage(),
      const Text("运费管理"),
    ];
    return Scaffold(
      body: Row(
        children: [
          _buildLeftNavigation(_pageIndex),
          Expanded(
              child: PageView(
            controller: _controller,
            children: [
              navigatorChild[_pageIndex],
            ],
          ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
