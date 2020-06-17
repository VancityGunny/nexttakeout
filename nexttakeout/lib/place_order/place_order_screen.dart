import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horizontal_calendar_widget/horizontal_calendar.dart';
import 'package:nexttakeout/business/business_model.dart';
import 'package:nexttakeout/business/business_repository.dart';
import 'package:nexttakeout/menu/menu_model.dart';
import 'package:nexttakeout/menu/menu_repository.dart';
import 'package:nexttakeout/order/order_item_model.dart';
import 'package:nexttakeout/order/order_model.dart';
import 'package:nexttakeout/place_order/index.dart';
import 'package:uuid/uuid.dart';
import 'package:nexttakeout/common/global_object.dart' as globals;

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({
    Key key,
    @required PlaceOrderBloc placeOrderBloc,
  })  : _placeOrderBloc = placeOrderBloc,
        super(key: key);

  final PlaceOrderBloc _placeOrderBloc;

  @override
  PlaceOrderScreenState createState() {
    return PlaceOrderScreenState();
  }
}

class PlaceOrderScreenState extends State<PlaceOrderScreen> {
  PlaceOrderScreenState();

  List<OrderItemModel> currentOrderItems = new List<OrderItemModel>();
  List<OrderModel> currentOrders = new List<OrderModel>();
  DateTime currentDate;
  BusinessModel currentBusiness;
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
    widget._placeOrderBloc.initStream();
    // preload packaeg deal available

    return BlocBuilder<PlaceOrderBloc, PlaceOrderState>(
        bloc: widget._placeOrderBloc,
        builder: (
          BuildContext context,
          PlaceOrderState currentState,
        ) {
          if (currentState is UnPlaceOrderState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorPlaceOrderState) {
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
          if (currentState is InPlaceOrderState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  HorizontalCalendar(
                    onDateSelected: (selectedDate) {
                      currentDate = selectedDate;
                      // check the date for outstanding order and show it
                      refreshMealPackages(selectedDate);
                    },
                    firstDate: DateTime.now().add(
                        new Duration(days: 1)), // only allow order 1 day before
                    lastDate: DateTime.now().add(new Duration(
                        days: 29)), // only allow preorder of 4 weeks plan
                    selectedDecoration: BoxDecoration(
                      color: Colors.lightBlue,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: (currentOrders.length == 0 && this.currentDate!=null)
                          ? Container(
                              alignment: Alignment.center,
                              child: Text(
                                  'You do not have meal packages available to order. Please purchase meal packages from restaurant'))
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: currentOrders.length,
                              itemBuilder: (context, index) {
                                // get business for this order

                                var foundBusinessId =
                                    currentOrders[index].businessId;
                                BusinessRepository businessRepo =
                                    new BusinessRepository();
                                var foundBusiness = businessRepo
                                    .getBusinessById(foundBusinessId);
                                return FutureBuilder(
                                  future: foundBusiness,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<BusinessModel> snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    return Container(
                                        child: Card(
                                            child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          colorFilter: ColorFilter.mode(
                                              Colors.black.withOpacity(0.7),
                                              BlendMode.dstATop),
                                          image: (snapshot.data.photoUrl ==
                                                  null)
                                              ? Image.asset(
                                                      'graphics/blankshop.jpg')
                                                  .image
                                              : Image.network(
                                                      snapshot.data.photoUrl)
                                                  .image,
                                          fit: BoxFit.cover,
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Text(snapshot.data.businessName),
                                          Text(
                                              currentOrders[index].productCode),
                                          RaisedButton(
                                            color: Colors.blue,
                                            onPressed: () {
                                              //View menu
                                              orderThis(currentOrders[index]);
                                            },
                                            child: Text('Place an Order'),
                                          ),
                                          Text(currentOrders[index]
                                                  .usedQuantity
                                                  .toString() +
                                              '/' +
                                              currentOrders[index]
                                                  .maxQuantity
                                                  .toString() +
                                              " meals used")
                                        ],
                                      ),
                                    )));
                                  },
                                );
                              })),
                  (this.currentDate == null)
                      ? Text('Please select date')
                      : Text('Today Menu'),
                  Expanded(
                      flex: 3,
                      child: StreamBuilder(
                        stream: widget._placeOrderBloc.allOrderItems.stream,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<OrderItemModel>> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          var currentOrderItems = snapshot.data
                              .where((element) =>
                                  element.pickupDate == this.currentDate)
                              .toList();
                          if (currentOrderItems.length == 0) {
                            return Container(
                              alignment: Alignment.center,
                              child: Text('Nothing here'),
                            );
                          }
                          return ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: currentOrderItems.length,
                              itemBuilder: (context, index) {
                                return Container(
                                    child: Card(
                                        child: Column(
                                  children: <Widget>[
                                    Image.network(currentOrderItems[index]
                                        .menuOrdered
                                        .photoUrl),
                                    Text('Order Date:' +
                                        currentOrderItems[index]
                                            .orderedDate
                                            .toString()),
                                    Text('Pickup Date:' +
                                        currentOrderItems[index]
                                            .pickupDate
                                            .toString()),
                                    Text('Order Item:' +
                                        currentOrderItems[index]
                                            .menuOrdered
                                            .name),
                                    Text('Order Status:' +
                                        currentOrderItems[index].orderStatus),
                                  ],
                                )));
                              });
                        },
                      )),
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void refreshMealPackages(DateTime selectedDate) {
    var allOrderItems = widget._placeOrderBloc.allOrderItems.value;
    if (allOrderItems != null) {
      var foundOrderItems = allOrderItems.where((x) =>
          x.pickupDate.day == selectedDate.day &&
          x.pickupDate.month == selectedDate.month &&
          x.pickupDate.year == selectedDate.year);

      setState(() {
        this.currentOrderItems = foundOrderItems.toList();
      });
    }

    // also eligible restaurant that user can order from
    var allOrders = widget._placeOrderBloc.availableOrders.value;
    if (allOrders != null) {
      var foundBusinessId = allOrders.first.businessId;
      BusinessRepository businessRepo = new BusinessRepository();
      businessRepo.getBusinessById(foundBusinessId).then((value) {
        setState(() {
          this.currentBusiness = value;
        });
      });
      //grab menu from business to order from
      setState(() {
        this.currentOrders = allOrders;
      });
    }
  }

  void _load([bool isError = false]) {
    widget._placeOrderBloc.add(LoadPlaceOrderEvent(isError));
  }

  void orderThis(OrderModel currentOrder) async {
    //load menu

    MenuRepository menuRepo = new MenuRepository();
    BusinessRepository businessRepo = new BusinessRepository();
    var business = await businessRepo.getBusinessById(currentOrder.businessId);
    List<MenuModel> businessMenu = await menuRepo.fetchMenuItems(currentOrder.businessId);
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
                      OutlineButton(
                          onPressed: () {
                            // place this menu item
                            Uuid uuid = new Uuid();
                            var newOrderItemId = uuid.v1();
                            OrderItemModel newMenuOrder = new OrderItemModel(
                                newOrderItemId,
                                currentOrder.orderId,
                                e,
                                DateTime.now(),
                                currentDate,
                                'Pending',
                                globals.currentUserDisplayName,
                                globals.currentUserId);
                            menuRepo.placeNewOrderItem(
                                business.id, newMenuOrder);
                            //update quanity of the order
                            var updatedOrderQuantity = currentOrder;
                            updatedOrderQuantity.usedQuantity += 1;
                            menuRepo.updateOrder(updatedOrderQuantity);
                            Navigator.of(context).pop();
                            refreshMealPackages(this.currentDate);
                            // OrderItemModel newMenuOrder = new OrderItemModel()
                            // menuRepo.placeNewOrderItem(business.id, newOrderItem)
                          },
                          child: Text('Order ' + e.name)),
                    ],
                  ),
                ));
              }).toList());
        });
  }
}
