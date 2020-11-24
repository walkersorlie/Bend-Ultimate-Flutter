import 'package:bend_ultimate_flutter/controllers/bindings/initial_bindings.dart';
import 'package:bend_ultimate_flutter/routers/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        return snapshot.hasError
            ? Center(child: Text(snapshot.error))
            : snapshot.connectionState == ConnectionState.done
                ? GetMaterialApp(
                    initialRoute: '/',
                    initialBinding: InitialBindings(),
                    onGenerateRoute: (settings) => MyRouter.onGenerateRoute(settings),
                  )
                : Center(child: CircularProgressIndicator());
      },
    );
  }
}
