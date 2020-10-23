import 'package:app2020/movies.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';

import 'Books.dart';
class bookForm extends StatelessWidget {

  final databaseReference = FirebaseDatabase.instance.reference();
  final String title;
  bookForm(this.title);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _bookname;
  String _author;
  String _rating;
  String _genre;
  String _user = "1";

  final _nameController = TextEditingController();
  final _authorController = TextEditingController();
  final _genreController = TextEditingController();
  final _ratingController = TextEditingController();

  void _makeApiCall(context) async {
    Dio dio = new Dio();
    Response apiResponse = await dio.post('http://192.168.0.188:3030/upload_book', data:{"name":_nameController.text,"author":_authorController.text,"genre": _genreController.text,"rating": _ratingController .text,"userid":_user}); //Where id is just a parameter in GET api call
    print(apiResponse.data.toString());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: new AppBar(
          title: new Text('Books'),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: (){
                Widget okButton = FlatButton(
                  child: Text("OK"),
                  onPressed: () { Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new Example())); },
                );
                AlertDialog alert = AlertDialog(
                  title: Text("My title"),
                  content: Text("This is my message."),
                  actions: [
                    okButton,
                  ],
                );
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
              }
          ),
        ),
        body: new SingleChildScrollView(
          child: new Container(
            margin: new EdgeInsets.all(15.0),
            child: new Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: FormUI(context),
            ),
          ),
        ),

    );
  }


// Here is our Form UI
  Widget FormUI(context) {
    return new Column(
      children: <Widget>[

        new TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'book Name'),
          keyboardType: TextInputType.text,
          validator: (value)=>value.isEmpty?'Book name can\'t be empty':null,
          onSaved: (value)=> _bookname=value,
        ),
        new TextFormField(
          controller: _authorController,
          decoration: const InputDecoration(labelText: 'Author'),
          keyboardType: TextInputType.text,
          validator: (value)=>value.isEmpty?'Author can\'t be empty':null,
          onSaved: (value)=> _author=value,
        ),
        new TextFormField(
          controller: _ratingController,
          decoration: const InputDecoration(labelText: 'Review Rating out of 5'),
          keyboardType: TextInputType.number,
          validator: (value)=>value.isEmpty?'Rating can\'t be empty':null,
          onSaved: (value)=> _rating=value,
        ),
        new TextFormField(
          controller: _genreController,
          decoration: const InputDecoration(labelText: 'Genre'),
          keyboardType: TextInputType.text,
          validator: (value)=>value.isEmpty?'Genre can\'t be empty':null,
          onSaved: (value)=> _genre=value,
        ),
        new SizedBox(
          height: 10.0,
        ),
        new RaisedButton(
          shape: StadiumBorder(),
          onPressed:(){
            _validateInputs();
            _makeApiCall(context);

            },
          child: Text("Update"),
          color: Colors.blueGrey,
        )
      ],
    );
  }

  void _validateInputs() {
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
     /* AlertDialog(
        title: Text("Successfully Uploaded !"),
        actions: [
          FlatButton(
            child: Text("Ok"),
            onPressed: (){
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Example()));
            },
          )
        ],
      );
*/
    }else{
      print("Form is invalid");
    }
  }

}