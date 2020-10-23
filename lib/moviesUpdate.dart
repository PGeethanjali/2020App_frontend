import 'package:app2020/movies.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class movieForm extends StatelessWidget {

  final String title;
  movieForm(this.title);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _bookname;
  String _author;
  String _rating;
  String _genre;
  String _user = "1";
  final _nameController = TextEditingController();
  final _directorController = TextEditingController();
  final _genreController = TextEditingController();
  final _ratingController = TextEditingController();

  void _makeApiCall(context) async {
    Dio dio = new Dio();
    Response apiResponse = await dio.post('http://192.168.0.188:3030/upload_movie', data:{"name":_nameController.text,"director":_directorController.text,"genre": _genreController.text,"rating": _ratingController .text,"userid":_user}); //Where id is just a parameter in GET api call
    print(apiResponse.data.toString());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: new AppBar(
          title: new Text('Movies'),
          leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => new Example1()));
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
          decoration: const InputDecoration(labelText: 'Movie Name'),
          keyboardType: TextInputType.text,
          validator: (value)=>value.isEmpty?'Movie name can\'t be empty':null,
          onSaved: (value)=> _bookname=value,
        ),
        new TextFormField(
          controller: _directorController,
          decoration: const InputDecoration(labelText: 'Director'),
          keyboardType: TextInputType.text,
          validator: (value)=>value.isEmpty?'Director can\'t be empty':null,
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
          onPressed: (){

            _validateInputs();
            _makeApiCall(context);

            },
          child: Text("Update"),
          color: Colors.blueGrey,
        ),
        new RaisedButton(

            onPressed:(){
            return Example1();
          },
          child: Text("Test"),
          color: Colors.blueGrey,
              /*Alert(
                context: context,
                title: "Successfully Uploaded",
                buttons: [
                  DialogButton(
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: (){
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) => new Example1()));
                    },
                    width: 120,
                  )
                ],
              ).show();
*/

        )
      ],
    );
  }



  void _validateInputs() {
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();

    }else{
      print("Form is invalid");
    }
  }

}