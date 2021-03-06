import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexttakeout_seller/menu/index.dart';
import 'package:image/image.dart' as IM;

import 'package:nexttakeout_seller/common/global_object.dart' as globals;
import 'package:uuid/uuid.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({
    Key key,
    @required MenuBloc menuBloc,
  })  : _menuBloc = menuBloc,
        super(key: key);

  final MenuBloc _menuBloc;

  @override
  MenuScreenState createState() {
    return MenuScreenState();
  }
}

class MenuScreenState extends State<MenuScreen> {
  MenuScreenState();

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
    return BlocBuilder<MenuBloc, MenuState>(
        bloc: widget._menuBloc,
        builder: (
          BuildContext context,
          MenuState currentState,
        ) {
          if (currentState is UnMenuState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorMenuState) {
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
          if (currentState is InMenuState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: currentState.menuItems.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Container(
                            alignment: Alignment.bottomRight,
                              height: 180.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.7),
                                      BlendMode.dstATop),
                                  image: Image.network(currentState
                                          .menuItems[index].photoUrl)
                                      .image,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                ),
                              ),
                              child: Column(children: <Widget>[
                                Text(
                                  currentState.menuItems[index].name,
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                            // bottomLeft
                                            offset: Offset(1.5, -1.5),
                                            color: Colors.black)
                                      ]),
                                ),
                                Text(
                                  'Stock:' +
                                      currentState.menuItems[index].dailyStock
                                          .toString(),
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                            // bottomLeft
                                            offset: Offset(1.5, -1.5),
                                            color: Colors.black)
                                      ]),
                                )
                              ])),
                        );
                      },
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      // update menu item
                      openNewMenuItem().then((value) {
                        if (value != null) {
                          MenuModel newMenuItem = value;
                          var updatedMenuItems = currentState.menuItems;
                          updatedMenuItems.add(newMenuItem);
                          widget._menuBloc
                              .add(UpdateMenuItemsEvent(updatedMenuItems));
                        }
                      });
                    },
                    child: Text(
                      'Add Menu Item',
                      style: TextStyle(fontSize: 22.0),
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
    widget._menuBloc.add(LoadMenuEvent(isError));
  }

  Future<MenuModel> openNewMenuItem() async {
    var newItem = await showDialog(
        context: context,
        builder: (_) {
          return MenuAddDialog(key: widget.key, menuBloc: widget._menuBloc);
        });
    return newItem;
  }
}

class MenuAddDialog extends StatefulWidget {
  const MenuAddDialog({
    Key key,
    @required MenuBloc menuBloc,
  })  : _menuBloc = menuBloc,
        super(key: key);

  final MenuBloc _menuBloc;

  @override
  MenuAddDialogState createState() {
    return MenuAddDialogState();
  }
}

class MenuAddDialogState extends State<MenuAddDialog> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  MenuModel newMenuItem;
  File _image;
  @override
  Widget build(BuildContext context) {
    newMenuItem = new MenuModel(null, null, null, null, null);
    // TODO: implement build
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      children: <Widget>[
        Form(
            key: _formKey,
            child: Container(
              width: 200.0,
              height: 500.0,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.restaurant),
                      hintText: 'Enter your menu name',
                      labelText: 'Menu Name',
                    ),
                    inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                    validator: (val) =>
                        val.isEmpty ? 'Menu name is required' : null,
                    onSaved: (String value) {
                      newMenuItem.name = value;
                    },
                  ),
                  Container(
                    child: OutlineButton(
                      child: Text('Add Image'),
                      onPressed: getImage,
                    ),
                  ),
                  Center(
                    child: _image == null
                        ? Text('No image selected.')
                        : Image.file(_image),
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.shopping_basket),
                      hintText: 'Enter a daily stock',
                      labelText: 'Daily Stock',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    validator: (val) =>
                        val.isEmpty ? 'Daily stock is required' : null,
                    onSaved: (String value) {
                      newMenuItem.dailyStock = int.tryParse(value);
                    },
                  ),
                  new Container(
                      padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                      child: new RaisedButton(
                        child: const Text('Submit'),
                        onPressed: _submitForm,
                      )),
                ],
              ),
            ))
      ],
    );
  }

  Future getImage() async {
    var picker = ImagePicker();
    var pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // then save the new item model
      //save image first then update the path
      if (_image != null) {
        IM.Image originalImage = IM.decodeImage(_image.readAsBytesSync());
        IM.Image thumbnail = IM.copyResize(originalImage, width: 200);

        var localPath = await globals.localPath;
        var thumbImageFile = new File('$localPath/temp.png')
          ..writeAsBytesSync(IM.encodePng(thumbnail));
        var uuid = new Uuid();
        var imageId = uuid.v1();
        String thumbPath = 'images/menu/' + imageId + '.png';
        var uploadTask =
            globals.storage.ref().child(thumbPath).putFile(thumbImageFile);
        var thumbUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
        newMenuItem.photoUrl = thumbUrl;
      }

      Navigator.of(context).pop(this.newMenuItem);
    }
  }
}
