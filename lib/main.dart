import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_notification_demo/services/localNotification-service.dart';

import 'screens/green-page.dart';
import 'screens/red-page.dart';

//receive message qje app is in background solution for on message
Future<void> backgroundHandler(RemoteMessage message) async {
  print("background");
  print(message.data.toString());
  print(message.notification?.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //LocalNotificationService.initialize();
  await Firebase.initializeApp();

  //
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
        routes: {"/red": (_) => RedPage(), "/green": (_) => GreenPage()});
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    LocalNotificationService.initialize(context);

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print('initial state cuando la aplicacion se vuelve a abrir');
      if (message != null) {
        final routeFromMessage = message.data["route"];
        print(routeFromMessage);
        Navigator.of(context).pushNamed(routeFromMessage);
      }
    });
    print('aqui se deberia recibir el mensaje');

    ///foreground work
    FirebaseMessaging.onMessage.listen((message) {
      print('quiere decir que la app se ecuentra en ejecucion');
      //print(message.notification?.body);
      //print(message.notification?.title);
      print(message.notification!.body);
      print(message.notification!.title);

      LocalNotificationService.display(message);
    });

    ///When the app is in background but opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('quiere decir que la app en segundo plano se abrio');
      final routeFromMessage = message.data["route"];
      print(routeFromMessage);

      Navigator.of(context).pushNamed(routeFromMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("You will receive a message soon",
                  style: TextStyle(fontSize: 30))
            ],
          ),
        ));
  }
}
