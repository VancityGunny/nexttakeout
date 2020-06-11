import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexttakeout/business/index.dart';

class BusinessScreen extends StatefulWidget {
  const BusinessScreen({
    Key key,
    @required BusinessBloc businessBloc,
  })  : _businessBloc = businessBloc,
        super(key: key);

  final BusinessBloc _businessBloc;

  @override
  BusinessScreenState createState() {
    return BusinessScreenState();
  }
}

class BusinessScreenState extends State<BusinessScreen> {
  BusinessScreenState();

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
    return BlocBuilder<BusinessBloc, BusinessState>(
        bloc: widget._businessBloc,
        builder: (
          BuildContext context,
          BusinessState currentState,
        ) {
          if (currentState is UnBusinessState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorBusinessState) {
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
           if (currentState is InBusinessState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(currentState.hello),
                  Text('Flutter files: done'),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: RaisedButton(
                      color: Colors.red,
                      child: Text('throw error'),
                      onPressed: () => _load(true),
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
    widget._businessBloc.add(LoadBusinessEvent(isError));
  }
}
