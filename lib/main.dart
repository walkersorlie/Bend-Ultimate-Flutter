import 'package:bend_ultimate_flutter/controllers/bindings/initial_bindings.dart';
import 'package:bend_ultimate_flutter/routers/router.dart';
import 'package:bend_ultimate_flutter/themes/base_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
            ? Center(child: Text(snapshot.error.toString()))
            : snapshot.connectionState == ConnectionState.done
                ? GetMaterialApp(
                    theme: BaseTheme.baseTheme,
                    initialRoute: '/',
                    initialBinding: InitialBindings(),
                    onGenerateRoute: (settings) => MyRouter.onGenerateRoute(settings),
                  )
                : Center(child: CircularProgressIndicator());
      },
    );
  }
}
