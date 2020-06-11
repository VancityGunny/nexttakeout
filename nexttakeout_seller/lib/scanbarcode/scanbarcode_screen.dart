import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexttakeout_seller/scanbarcode/index.dart';

class ScanbarcodeScreen extends StatefulWidget {
  const ScanbarcodeScreen({
    Key key,
    @required ScanbarcodeBloc scanbarcodeBloc,
  })  : _scanbarcodeBloc = scanbarcodeBloc,
        super(key: key);

  final ScanbarcodeBloc _scanbarcodeBloc;

  @override
  ScanbarcodeScreenState createState() {
    return ScanbarcodeScreenState();
  }
}

class ScanbarcodeScreenState extends State<ScanbarcodeScreen> {
  ScanbarcodeScreenState();

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
    return BlocBuilder<ScanbarcodeBloc, ScanbarcodeState>(
        bloc: widget._scanbarcodeBloc,
        builder: (
          BuildContext context,
          ScanbarcodeState currentState,
        ) {
          if (currentState is UnScanbarcodeState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorScanbarcodeState) {
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
           if (currentState is InScanbarcodeState) {
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
    widget._scanbarcodeBloc.add(LoadScanbarcodeEvent(isError));
  }
}
