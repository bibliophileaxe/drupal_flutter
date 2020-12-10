import 'package:flutter/material.dart';
import 'signed_in.dart';
import 'api.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  Future<LoginResponse> _futureJwt;

  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final api = new Api();

  @override
  Widget build(BuildContext context) {
    final logo = Padding(
      padding: EdgeInsets.all(20),
      child: Hero(
          tag: 'hero',
          child: SizedBox(
            height: 160,
            child: Image.asset('assets/drupal_flutter.png'),
          )),
    );

    final inputEmail = Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: _userController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: 'Email',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0))),
      ),
    );

    final inputPassword = Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: _passController,
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Password',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0))),
      ),
    );

    final buttonLogin = Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: ButtonTheme(
        height: 56,
        child: RaisedButton(
          child: Text('Signin',
              style: TextStyle(color: Colors.white, fontSize: 20)),
          color: Colors.black87,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          onPressed: () {
            setState(() {
              _futureJwt = api.createLoginState(
                  _userController.text, _passController.text);
            });
          },
        ),
      ),
    );

    return SafeArea(
        child: Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      return AnimatedContainer(
          duration: Duration(milliseconds: 500),
          color: Colors.lightBlue[900],
          padding: constraints.maxWidth < 500
              ? EdgeInsets.zero
              : const EdgeInsets.all(30.0),
          child: Center(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 25.0),
              constraints: BoxConstraints(
                maxWidth: 500,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: (_futureJwt == null)
                  ? SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          logo,
                          inputEmail,
                          inputPassword,
                          buttonLogin
                        ],
                      ),
                    )
                  //If the Conditiion (_futureJwt == null) is false then
                  : FutureBuilder<LoginResponse>(
                      //refer the object to the future
                      future: _futureJwt,
                      //
                      builder: (context, snapshot) {
                        //if the data is getting
                        if (snapshot.hasData) {
                          var token = snapshot.data.token;
                          print(token);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Dashboard()));
                          });
                        }
                        //if the data results an error
                        else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }

                        return CircularProgressIndicator();
                      },
                    ),
            ),
          ));
    })));
  }
}
