import 'package:flutter/material.dart';
import 'package:nexttakeout/menu_search/index.dart';
import 'package:nexttakeout/pickup_order/index.dart';
import 'package:nexttakeout/place_order/index.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;

  PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          PickupOrderScreen(
            pickupOrderBloc: new PickupOrderBloc(),
          ),
          MenuSearchScreen(
            menuSearchBloc: new MenuSearchBloc(),
          ),
          PlaceOrderScreen(
            placeOrderBloc: new PlaceOrderBloc(),
          )
        ],
        onPageChanged: (int index) {
          setState(() {
            _currentTab = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        selectedItemColor: Theme.of(context).accentColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Color.fromRGBO(248, 249, 249, 1),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.restaurant_menu,
            ),
            title: Text('Menu'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shop,
            ),
            title: Text('Order'),
          )
        ],
        onTap: (int index) {
          setState(() {
            _currentTab = index;
          });
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        },
      ),
    );
  }
}
