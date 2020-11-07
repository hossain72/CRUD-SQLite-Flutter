import 'package:flutter/material.dart';
import 'package:flutter_sqlite_demo/models/contact.dart';
import 'package:flutter_sqlite_demo/utils/_databaseHelper.dart';

const darkBlueColor = Color(0xff485679);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Contact _contact = Contact();
  List<Contact> _contactList = [];
  DatabaseHelper _databaseHelper;
  final _nameController = TextEditingController();
  final _mobileNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _databaseHelper = DatabaseHelper.instance;
    });
    _refreshContactList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("SQLite CURD"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[_form(), _list()],
        ),
      ),
    );
  }

  _form() => Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(hintText: "Name"),
                  onSaved: (val) => setState(() => _contact.name = val),
                  validator: (val) =>
                      (val.length == 0 ? "This field is required" : null),
                ),
                TextFormField(
                  controller: _mobileNumberController,
                  decoration: InputDecoration(hintText: "Mobile Number"),
                  onSaved: (val) => setState(() => _contact.mobileNumber = val),
                  validator: (val) =>
                      (val.length != 11 ? "11 characters required" : null),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: RaisedButton(
                    onPressed: () {
                      _onSubmit();
                    },
                    child: Text("Submit"),
                    color: Colors.grey[300],
                    textColor: Colors.green,
                  ),
                )
              ],
            )),
      );

  _onSubmit() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (_contact.id == null)
        await _databaseHelper.insertContact(_contact);
      else
        await _databaseHelper.updateContact(_contact);
      _refreshContactList();
      _resetForm();
    }
  }

  _resetForm() {
    setState(() {
      _formKey.currentState.reset();
      _nameController.clear();
      _mobileNumberController.clear();
      _contact.id = null;
    });
  }

  _refreshContactList() async {
    List<Contact> x = await _databaseHelper.getAllContact();
    setState(() {
      _contactList = x;
    });
  }

  _list() => Expanded(
          child: Card(
        margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: _contactList.length,
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.account_circle,
                      color: darkBlueColor,
                      size: 40.0,
                    ),
                    title: Text(
                      "${_contactList[index].name.toUpperCase()}",
                      style: TextStyle(
                          color: darkBlueColor, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("${_contactList[index].mobileNumber}"),
                    trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await _databaseHelper
                              .deleteContact(_contactList[index].id);
                          _resetForm();
                          _refreshContactList();
                        }),
                    onTap: () {
                      setState(() {
                        _contact = _contactList[index];
                        _nameController.text = _contact.name;
                        _mobileNumberController.text = _contact.mobileNumber;
                      });
                    },
                  ),
                  Divider(
                    height: 5.0,
                  )
                ],
              );
            }),
      ));
}
