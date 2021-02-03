import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService{

  firebaseCloudMessaging_Listeners() async {

    final FirebaseMessaging _firebaseMessaging = await FirebaseMessaging();

    if (Platform.isIOS) iOS_Permission(_firebaseMessaging);


    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );


    _firebaseMessaging.getToken().then((token){

      print("the token is $token");

      return token;

    });


  }

  void iOS_Permission(_firebaseMessaging) {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }



}