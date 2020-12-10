import 'package:flutter/material.dart';
import 'package:flutter_drupal/signin_page.dart';
import 'api.dart';

class Dashboard extends StatefulWidget {
  @override
  _Dashboard createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
  String name = '';
  String token = '';
  final api = new Api();

  _Dashboard() {
    api.getFromLocalMemory('name').then((val) => setState(() {
          name = val;
        }));
  }

  @override
  Widget build(BuildContext context) {
    // getFromLocalMemory('name').then((value) => name = value);

    // getFromLocalMemory('token').then((value) => token = value);

    final avatar = Padding(
      padding: EdgeInsets.all(20),
      child: Hero(
          tag: 'logo',
          child: SizedBox(
            height: 160,
            child: Image.asset('assets/drupal_flutter.png'),
          )),
    );
    final description = Padding(
      padding: EdgeInsets.all(10),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
            text: 'Hello ' + name + '!  You are now logged in to Drupal.',
            style: TextStyle(color: Colors.black, fontSize: 20)),
      ),
    );

    final buttonLogout = FlatButton(
        child: Text(
          'Logout',
          style: TextStyle(color: Colors.black87, fontSize: 16),
        ),
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SignInPage()));
        });

    return SafeArea(
        child: Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: <Widget>[avatar, description, buttonLogout],
        ),
      ),
    ));
  }
}
