import 'package:flutter/material.dart';
import 'package:flutter_file_upload_firebase/upload.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  State<StatefulWidget> createState() => LoginPageState();
}

enum FormType{
  Login,
  Register
}

class LoginPageState extends State<LoginPage> {
  String _Email;
  String _password;
  final formkey = new GlobalKey<FormState>();
  final key = new GlobalKey<ScaffoldState>();
  FormType _FormType = FormType.Login;

  bool ValidateAndSave() {
    final Form = formkey.currentState;
    if (Form.validate()) {
      Form.save();
      return true;
    }
    return false;
  }

  void ValidateAndSubmit() async {
    if (ValidateAndSave()) {
//      FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _Email, password: _password);
      try {
        if(_FormType == FormType.Login) {
          FirebaseUser user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: _Email, password: _password))
              .user;
          print('Signed in: ${user.uid}');
        }else{
          FirebaseUser user = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: _Email, password: _password))
              .user;
          print('Registered user: ${user.uid}');
        }
      } catch (e) {
        if (e.code == 'the network error code');
      }
    }
  }

  void MoveToRegister(){
    formkey.currentState.reset();
    setState(() {
      _FormType = FormType.Register;
    });
  }

  void MoveToLogin(){
    formkey.currentState.reset();
    setState(() {
      _FormType = FormType.Login;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: key,
      appBar: new AppBar(
        backgroundColor: Colors.red[800],
        centerTitle: true,
        title: Text('Login'),
      ),
      body: Center(
        child: Form(
            key: formkey,
            child: Column(
              children: buildInputs()+buildSubmitButtons(),
            )),
      ),
    );
  }

  List<Widget> buildInputs(){
    return[
      Padding(
        padding: EdgeInsets.all(16.0),
        child: TextFormField(
          decoration: InputDecoration(
              hintText: "username",
              hintStyle:
              TextStyle(color: Colors.grey, fontSize: 15.0)),
          validator: (value) =>
          value.isEmpty ? 'Username can\'t empty' : null,
          onSaved: (value) => _Email = value,
        ),
      ),
      Padding(
        padding: EdgeInsets.all(16.0),
        child: TextFormField(
          decoration: InputDecoration(
              hintText: "password",
              hintStyle:
              TextStyle(color: Colors.grey, fontSize: 15.0)),
          validator: (value) =>
          value.isEmpty ? 'Password can\'t empty' : null,
          onSaved: (value) => _password = value,
          obscureText: true,
        ),
      ),
    ];
  }

  List<Widget> buildSubmitButtons(){
    if(_FormType == FormType.Login) {
      return [
        Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: ValidateAndSubmit,
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                color: Colors.red[800],
                highlightColor: Colors.red[800],
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(5.0))),
              ),
            ],
          ),
        ),
        FlatButton(
          child: Text(
            'Create an account',
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.blue,
            ),
          ),
          onPressed: MoveToRegister,
        ),
      ];
    }else{
      return [
        Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: ValidateAndSubmit,
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                color: Colors.red[800],
                highlightColor: Colors.red[800],
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(5.0))),
              ),
            ],
          ),
        ),
        FlatButton(
          child: Text(
            'Have an account? Login',
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.blue,
            ),
          ),
          onPressed: MoveToLogin,
        ),
      ];
    }
  }
}
