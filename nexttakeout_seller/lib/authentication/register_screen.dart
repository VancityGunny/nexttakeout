import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexttakeout_seller/authentication/index.dart';
import 'package:nexttakeout_seller/business/business_model.dart';
import 'package:nexttakeout_seller/yelp/yelp_web_service.dart';

import 'package:nexttakeout_seller/common/global_object.dart' as globals;

class RegisterScreen extends StatefulWidget {
  @override
  RegisterScreenState createState() {
    return RegisterScreenState();
  }
}

class RegisterScreenState extends State<RegisterScreen> {
  RegisterScreenState();
  BusinessModel newBusiness = new BusinessModel();
  // Textbox controller
  final myYelpIdController = TextEditingController();
  final myBusinessNameController = TextEditingController();
  final myBusinessAddressController = TextEditingController();
  final myBusinessPhoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
        top: false,
        bottom: false,
        child: new Form(
            key: _formKey,
            autovalidate: true,
            child: new ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: <Widget>[
                Text(
                  'Register new business',
                  style: TextStyle(fontSize: 25.0),
                  textAlign: TextAlign.center,
                ),
                new TextFormField(
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.restaurant),
                    hintText: 'Enter your restaurant name',
                    labelText: 'Business Name',
                  ),
                  controller: myBusinessNameController,
                  inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                  validator: (val) =>
                      val.isEmpty ? 'Business Name is required' : null,
                  onSaved: (val) => newBusiness.businessName = val,
                ),
                Wrap(
                  children: <Widget>[
                    new TextFormField(
                      controller: myYelpIdController,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.pin_drop),
                        hintText: 'To verify your restaurant',
                        labelText: 'Yelp BusinessID',
                      ),
                      keyboardType: TextInputType.datetime,
                      onSaved: (val) => newBusiness.yelpId = val,
                    ),
                    OutlineButton(
                      onPressed: () {
                        // populate fields with data from yelp
                        YelpWebService yelpService = new YelpWebService();
                        yelpService
                            .getBusienssInfo(myYelpIdController.text)
                            .then((value) {
                          var foundBusiness = (value != null)
                              ? BusinessModel.fromJson(value)
                              : null;
                          newBusiness.address = foundBusiness.address;
                          myBusinessAddressController.text =
                              foundBusiness.address.fold(
                                  '',
                                  (previousValue, element) =>
                                      previousValue + ' ' + element);
                          newBusiness.businessName = foundBusiness.businessName;
                          myBusinessNameController.text =
                              foundBusiness.businessName;
                          newBusiness.phone = foundBusiness.phone;
                          myBusinessPhoneController.text = foundBusiness.phone;
                        });
                      },
                      child: Text('Fetch Data From Yelp'),
                    )
                  ],
                ),
                new TextFormField(
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.flag),
                    hintText: 'Enter an address',
                    labelText: 'Address',
                  ),
                  controller: myBusinessAddressController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  onSaved: (val) => newBusiness.phone = val,
                ),
                new TextFormField(
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.phone),
                    hintText: 'Enter a phone number',
                    labelText: 'Phone',
                  ),
                  controller: myBusinessPhoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  onSaved: (val) => newBusiness.phone = val,
                ),
                new Container(
                    padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                    child: new RaisedButton(
                      child: const Text('Submit'),
                      onPressed: _submitForm,
                    )),
              ],
            )));
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      //showMessage('Form is not valid!  Please review and correct.');

    } else {
      form.save(); //This invokes each onSaved event
      newBusiness.ownerUserId = globals.currentUserId;
      // create new business
      BlocProvider.of<AuthBloc>(context)
          .add(RegisterNewBusinessAuthEvent(newBusiness));
    }
  }
}
