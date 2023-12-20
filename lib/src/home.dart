// ignore_for_file: unused_field

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic>? _userData;
  AccessToken? _accessToken;
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _checkIfisLoggedIn();
  }

  _checkIfisLoggedIn() async {
    final accessToken = await FacebookAuth.instance.accessToken;

    setState(() {
      _checking = false;
    });

    if (accessToken != null) {
      print(accessToken.toJson());
      final userData = await FacebookAuth.instance.getUserData();
      _accessToken = accessToken;
      setState(() {
        _userData = userData;
      });
    } else {
      _login();
    }
  }

  _login() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      _accessToken = result.accessToken;

      final userData = await FacebookAuth.instance.getUserData();
      _userData = userData;
    } else {
      print('Result>>>>>>>>>>>>>>>>>>>>>>>${result.status}');
      print('message>>>>>>>>>>>>>>>>>>>>>>${result.message}');
    }
    setState(() {
      _checking = false;
    });
  }

  _logout() async {
    await FacebookAuth.instance.logOut();
    _accessToken = null;
    _userData = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("userData>>>>>>>>>>>>>>>>>>>>>>${_userData}");
    return Scaffold(
      appBar: AppBar(title: Text('Facebook Auth Project')),
      body: _checking
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _userData != null
                    ? Text('name: ${_userData!['name']}')
                    : Container(),
                _userData != null
                    ? Text('email: ${_userData!['email']}')
                    : Container(),
                _userData != null
                    ? Container(
                        height: 200,
                        width: 200,
                        child: Image.network(
                            '${_userData!['picture']['data']['url']}'),
                      )
                    : Container(),
                SizedBox(
                  height: 20,
                ),
                CupertinoButton(
                    color: Colors.blue,
                    child: Text(
                      _userData != null ? 'LOGOUT' : 'LOGIN',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _userData != null ? _logout : _login),
              ],
            )),
    );
  }
}

// GET FRIENDS

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   Map<String, dynamic>? _userData;
//   AccessToken? _accessToken;
//   bool _checking = true;

//   @override
//   void initState() {
//     super.initState();
//     _checkIfisLoggedIn();
//   }

//   _checkIfisLoggedIn() async {
//     final accessToken = await FacebookAuth.instance.accessToken;

//     setState(() {
//       _checking = false;
//     });

//     if (accessToken != null) {
//       print(accessToken.toJson());
//       final userData = await FacebookAuth.instance.getUserData();
//       _accessToken = accessToken;
//       setState(() {
//         _userData = userData;
//       });
//     } else {
//       _login();
//     }
//   }

//   _login() async {
//     final LoginResult result = await FacebookAuth.instance.login(
//         permissions: ['email', 'public_profile', 'user_friends'],
//         loginBehavior: LoginBehavior.dialogOnly);

//     if (result.status == LoginStatus.success) {
//       _accessToken = result.accessToken;

//       final userData = await FacebookAuth.instance.getUserData();
//       _userData = userData;
//     } else {
//       print('Result>>>>>>>>>>>>>>>>>>>>>>>${result.status}');
//       print('message>>>>>>>>>>>>>>>>>>>>>>${result.message}');
//     }
//     setState(() {
//       _checking = false;
//     });
//   }

//   _logout() async {
//     await FacebookAuth.instance.logOut();
//     _accessToken = null;
//     _userData = null;
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(actions: [
//         CupertinoButton(
//             color: Colors.blue,
//             child: Text(
//               _userData != null ? 'LOGOUT' : 'LOGIN',
//               style: TextStyle(color: Colors.white),
//             ),
//             onPressed: _userData != null ? _logout : _login),
//       ]),
//       body: _checking
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 const Text('Get Friends'),
//                 Expanded(
//                   child: FutureBuilder<Map<String, dynamic>>(
//                       future: FacebookAuth.i.getUserData(fields: 'friends'),
//                       builder: (context, snapshort) {
//                         return ListView.builder(
//                             itemCount:
//                                 snapshort.data!['friends']['data'].length,
//                             itemBuilder: (BuildContext context, int index) {
//                               return ListTile(
//                                 title: Text(
//                                   snapshort.data!['friends']['data'][index]
//                                       ['name'],
//                                 ),
//                               );
//                             });
//                       }),
//                 ),
//               ],
//             ),
//     );
//   }
// }
