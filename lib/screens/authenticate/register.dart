import 'package:flutter/material.dart';
import 'package:local_commodities/services/auth.dart';
import 'package:local_commodities/shared/constants.dart';
import 'package:local_commodities/shared/loading.dart';
import 'package:local_commodities/services/database.dart';

class Register extends StatefulWidget {

  final Function toggleView; 
  Register({ this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

final List<String> userType = ['Customer','Store Owner','Delivery Executive'];
final AuthService _auth = AuthService();
final _formKey = GlobalKey<FormState>();
bool loading = false;

String _currentUserType;
String _currentName;
String _currentPhno;

//text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {

    return loading ? Loading() : Scaffold(
      //resizeToAvoidBottomPadding: false,
        body: Container(
          width : double.infinity,
          height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter,colors:[Colors.orange[900],Colors.orange[800],Colors.orange[400]])
            ),
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),

            child : SingleChildScrollView(
                          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 80,),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Register", style: TextStyle(color: Colors.white, fontSize: 40),),
                      SizedBox(height: 10,),
                      Text("Create an Account", style: TextStyle(color: Colors.white, fontSize: 18),),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                
              Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Name'),
                    validator: (val) => val.isEmpty ? 'Enter your name' : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Phone Number'),
                    validator: (val) => val.isEmpty ? 'Enter your number' : null,
                    onChanged: (val) => setState(() => _currentPhno = val),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Email'),
                    validator: (val) => val.isEmpty ? 'Enter an email' : null,
                    onChanged: (val) {
                      setState(() => email = val);
                    }
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Password'),
                    obscureText: true,
                    validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    }
                  ),
                  SizedBox(height: 20.0),
                  DropdownButtonFormField(
                  value: userType[0],
                  decoration: textInputDecoration,
                  items: userType.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text('$type'),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _currentUserType = val ),
                ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(
                        'Create Account',
                        style: TextStyle(color: Colors.orange[800],fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() => loading = true);
                        dynamic result = await _auth.registerWithEmailAndPassword(email,password);
                        await DatabaseService(uid: result.uid).addUserTypeandName(
                        _currentUserType ?? userType[0],
                        _currentName,
                      );
                        if (result == null) {
                          setState(() {
                             error = 'Invalid email or account already exists';
                             loading = false;
                        });
                      }}
                    }
                  ),

                  //SizedBox(height: 12.0),

                   RaisedButton(
                      color: Colors.white,
                      
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                      child: Text(
                        'Log in',
                        style: TextStyle(color: Colors.orange[800],fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {widget.toggleView();}
                      ),

                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  )
                ],
              ),
              ),
              ],
          ),
            ),
        ),
    );
  }
}
