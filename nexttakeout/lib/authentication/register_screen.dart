import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexttakeout/authentication/index.dart';
import 'package:nexttakeout/business/business_model.dart';

class RegisterScreen extends StatefulWidget {
  @override
  RegisterScreenState createState() {
    return RegisterScreenState();
  }
}

class RegisterScreenState extends State<RegisterScreen> {
  RegisterScreenState();
  BusinessModel newBusiness = new BusinessModel();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register New Store')),
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              key: _formKey,
              autovalidate: true,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.restaurant),
                      hintText: 'Enter your restaurant name',
                      labelText: 'Business Name',
                    ),
                    inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                    validator: (val) =>
                        val.isEmpty ? 'Business Name is required' : null,
                    onSaved: (val) => newBusiness.businessName = val,
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.pin_drop),
                      hintText: 'To verify your restaurant',
                      labelText: 'Yelp BusinessID',
                    ),
                    keyboardType: TextInputType.datetime,
                    onSaved: (val) => newBusiness.yelpId = val,
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.phone),
                      hintText: 'Enter a phone number',
                      labelText: 'Phone',
                    ),
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
              ))),
    );
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      //showMessage('Form is not valid!  Please review and correct.');

    } else {
      form.save(); //This invokes each onSaved event
      // create new business
      BlocProvider.of<AuthBloc>(context)
          .add(RegisterNewBusinessAuthEvent(newBusiness));
    }
  }
}
