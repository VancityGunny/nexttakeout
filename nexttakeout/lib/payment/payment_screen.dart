import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexttakeout/menu/menu_repository.dart';
import 'package:nexttakeout/order/order_model.dart';
import 'package:nexttakeout/payment/index.dart';
import 'package:nexttakeout/common/transaction_service.dart';
import 'package:nexttakeout/place_order/index.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:uuid/uuid.dart';
import 'package:nexttakeout/common/global_object.dart' as globals;

class PaymentScreen extends StatefulWidget {
  const PaymentScreen(
    this._businessId, {
    Key key,
    @required PaymentBloc paymentBloc,
  })  : _paymentBloc = paymentBloc,
        super(key: key);

  final PaymentBloc _paymentBloc;
  final String _businessId;

  @override
  PaymentScreenState createState() {
    return PaymentScreenState();
  }
}

class PaymentScreenState extends State<PaymentScreen> {
  PaymentScreenState();

  Future<void> _initSquarePayment() async {
    await InAppPayments.setSquareApplicationId(
        'sandbox-sq0idb-n3QCxvsUsVQnLHBXJ0yc_Q');
  }

  /** 
  * An event listener to start card entry flow
  */
  Future<void> _onStartCardEntryFlow(OrderModel newOrder) async {
    await InAppPayments.startCardEntryFlow(
        onCardNonceRequestSuccess: (CardDetails result) {
          _onCardEntryCardNonceRequestSuccess(result, newOrder);
        },
        onCardEntryCancel: _onCancelCardEntryFlow);
  }

  /**
  * Callback when card entry is cancelled and UI is closed
  */
  void _onCancelCardEntryFlow() {
    // Handle the cancel callback
  }

  /**
  * Callback when successfully get the card nonce details for processig
  * card entry is still open and waiting for processing card nonce details
  */
  void _onCardEntryCardNonceRequestSuccess(
      CardDetails result, OrderModel newOrder) async {
    try {
      // take payment with the card nonce details
      // you can take a charge
      var paymentResponse = await chargeCard(newOrder, result);

      // payment finished successfully
      // you must call this method to close card entry
      InAppPayments.completeCardEntry(onCardEntryComplete: () {
        _onCardEntryComplete(paymentResponse, newOrder);
      });
    } on Exception catch (ex) {
      // payment failed to complete due to error
      // notify card entry to show processing error
      InAppPayments.showCardNonceProcessingError(ex.toString());
    }
  }

  /**
  * Callback when the card entry is closed after call 'completeCardEntry'
  */
  void _onCardEntryComplete(dynamic paymentResponse, OrderModel newOrder) {
    // Update UI to notify user that the payment flow is finished successfully
    var paymentResp = paymentResponse['payment'];
    //update the order to marked as paid
    MenuRepository menuRepo = new MenuRepository();
    newOrder.paymentId = paymentResp['id'].toString();
    newOrder.receiptNumber = paymentResp['receipt_number'].toString();
    menuRepo.updateOrder(newOrder);
    Navigator.of(context).pop();
    // goto order selection page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return PlaceOrderPage();
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    _initSquarePayment();
    _load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentBloc, PaymentState>(
        bloc: widget._paymentBloc,
        builder: (
          BuildContext context,
          PaymentState currentState,
        ) {
          if (currentState is UnPaymentState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorPaymentState) {
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
          if (currentState is InPaymentState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: 150.0,
                        child: Column(
                          children: <Widget>[
                            Image.asset('graphics/plates.png'),
                            OutlineButton(
                              onPressed: () async {
                                //create new order and send it
                                MenuRepository menuRepo = new MenuRepository();
                                OrderModel newOrder =
                                    await menuRepo.placeNewOrder(
                                        widget._businessId, '8PACKS', 80.0, 8);
                                _onStartCardEntryFlow(newOrder);
                              },
                              child: Text('Buy 8 packs'),
                            ),
                            Text('Include 8 meals at 80\$')
                          ],
                        ),
                      ),
                      Container(
                          width: 150.0,
                          child: Column(
                            children: <Widget>[
                              Image.asset('graphics/plates.png'),
                              OutlineButton(
                                onPressed: () async {
                                  //create new order and send it
                                  MenuRepository menuRepo =
                                      new MenuRepository();
                                  OrderModel newOrder =
                                      await menuRepo.placeNewOrder(
                                          widget._businessId,
                                          '16PACKS',
                                          150.0,
                                          16);
                                  _onStartCardEntryFlow(newOrder);
                                },
                                child: Text('Buy 16 packs'),
                              ),
                              Text('Include 16 meals at 150\$')
                            ],
                          ))
                    ],
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
    widget._paymentBloc.add(LoadPaymentEvent(isError));
  }
}
