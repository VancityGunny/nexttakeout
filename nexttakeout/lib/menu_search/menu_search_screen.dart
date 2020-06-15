import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexttakeout/business/business_model.dart';
import 'package:nexttakeout/menu/menu_model.dart';
import 'package:nexttakeout/menu/menu_repository.dart';
import 'package:nexttakeout/menu_search/index.dart';
import 'package:nexttakeout/payment/index.dart';

class MenuSearchScreen extends StatefulWidget {
  const MenuSearchScreen({
    Key key,
    @required MenuSearchBloc menuSearchBloc,
  })  : _menuSearchBloc = menuSearchBloc,
        super(key: key);

  final MenuSearchBloc _menuSearchBloc;

  @override
  MenuSearchScreenState createState() {
    return MenuSearchScreenState();
  }
}

class MenuSearchScreenState extends State<MenuSearchScreen> {
  MenuSearchScreenState();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuSearchBloc, MenuSearchState>(
        bloc: widget._menuSearchBloc,
        builder: (
          BuildContext context,
          MenuSearchState currentState,
        ) {
          if (currentState is UnMenuSearchState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorMenuSearchState) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(currentState.errorMessage ?? 'Error'),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text('reload'),
                    onPressed: _load,
                  ),
                ),
              ],
            ));
          }
          if (currentState is InMenuSearchState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: currentState.businesses.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 150.0,
                          child: Card(
                              child: Container(
                            alignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: (currentState
                                            .businesses[index].photoUrl ==
                                        null)
                                    ? Image.asset('graphics/blankshop.jpg')
                                        .image
                                    : Image.network(currentState
                                            .businesses[index].photoUrl)
                                        .image,
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.center,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                        currentState
                                            .businesses[index].businessName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                          shadows: <Shadow>[
                                            Shadow(
                                              offset: Offset(2.0, 2.0),
                                              blurRadius: 2.0,
                                              color: Color.fromARGB(
                                                  125, 0, 0, 255),
                                            ),
                                          ],
                                        ))),
                                Expanded(child: Text('')),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    RaisedButton(
                                      onPressed: () {
                                        //View menu
                                        _viewMenu(
                                            currentState.businesses[index]);
                                      },
                                      child: Text('View Menu'),
                                    ),
                                    RaisedButton(
                                      onPressed: () {
                                        //order payment page
                                        _gotoPaymentPage(
                                            currentState.businesses[index].id);
                                      },
                                      child: Text('Buy Meal Package'),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void _load([bool isError = false]) {
    widget._menuSearchBloc.add(LoadMenuSearchEvent(isError));
  }

  void _gotoPaymentPage(String businessId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return PaymentPage(businessId);
      }),
    );
  }

  void _viewMenu(BusinessModel business) async {
    //load menu

    MenuRepository menuRepo = new MenuRepository();
    List<MenuModel> businessMenu = await menuRepo.fetchMenuItems(business.id);
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
              title: Text(business.businessName + "'s Menu"),
              children: businessMenu.map((e) {
                return SimpleDialogOption(
                    child: Card(
                  child: Column(
                    children: <Widget>[
                      Image.network(e.photoUrl),
                      Text(
                        e.name,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ));
              }).toList());
        });
  }
}
