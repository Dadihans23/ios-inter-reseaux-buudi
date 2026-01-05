import 'dart:async';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:six_cash/features/language/controllers/localization_controller.dart';
import 'package:six_cash/features/setting/controllers/theme_controller.dart';
import 'package:six_cash/firebase/firebase_api.dart';
import 'package:six_cash/helper/notification_helper.dart';
import 'package:six_cash/helper/route_helper.dart';
import 'package:six_cash/theme/dark_theme.dart';
import 'package:six_cash/theme/light_theme.dart';
import 'package:six_cash/util/app_constants.dart';
import 'package:six_cash/util/messages.dart';

import 'helper/get_di.dart' as di;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
late List<CameraDescription> cameras;

void checkNotificationPermissions() async {
  PermissionStatus status = await Permission.notification.status;
  if (status.isDenied) {
    // Demander l'autorisation
    await Permission.notification.request();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  try {
    await firebaseAPI().initNotifications();
  } catch (e) {
    if (kDebugMode) print(e);
  }

  checkNotificationPermissions();

  if (GetPlatform.isAndroid) {
    await FirebaseMessaging.instance.requestPermission();
  }

  ///firebase crashlytics
  cameras = await availableCameras();

  Map<String, Map<String, String>> languages = await di.init();

  int? orderID;

  // Compteur d'utilisations
  int usageCount = await incrementUsageCount();
  print(' vous etes a votre :$usageCount essaie ');

  // Vérifier si la période d'essai est terminée
  if (usageCount > 100000) {
    print('Période d\'essai terminée');
    Get.off(() =>
        TrialPeriodEndedView()); // Utilisation de GetX pour naviguer vers TrialPeriodEndedView
    return; // Arrêter l'exécution de la fonction main
  }

  // NotificationBody? body;
  try {
    final RemoteMessage? remoteMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMessage != null) {
      //body = NotificationHelper.convertNotification(remoteMessage.data);
    }
    await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  } catch (e) {
    if (kDebugMode) {
      print("");
    }
  }
  initializeDateFormatting('fr_FR', null).then((_) {
    // Démarre ton application ici
    runApp(MyApp(languages: languages, orderID: orderID));
  });

  print(' vous etes a votre :$usageCount essaie ');
}

Future<int> incrementUsageCount() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int currentUsageCount = prefs.getInt('usageCount') ?? 0;
  currentUsageCount++;
  await prefs.setInt('usageCount', currentUsageCount);
  return currentUsageCount;
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>>? languages;
  final int? orderID;
  const MyApp({Key? key, required this.languages, required this.orderID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetBuilder<LocalizationController>(
          builder: (localizeController) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1)),
              child: GetMaterialApp(
                navigatorObservers: [FlutterSmartDialog.observer],
                builder: FlutterSmartDialog.init(),
                title: AppConstants.appName,
                debugShowCheckedModeBanner: false,
                navigatorKey: Get.key,
                theme: themeController.darkTheme ? dark : light,
                locale: localizeController.locale,
                translations: Messages(languages: languages),
                fallbackLocale: Locale(AppConstants.languages[0].languageCode!,
                    AppConstants.languages[0].countryCode),
                initialRoute: RouteHelper.getSplashRoute(),  
                getPages: RouteHelper.routes,
                defaultTransition: Transition.topLevel,
                transitionDuration: const Duration(milliseconds: 500),
              ),
            );
          },
        );
      },
    );
  }
}

class TrialPeriodEndedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Période d\'essai terminée',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}










// import 'dart:async';

// import 'package:camera/camera.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
// import 'package:get/get.dart';
// import 'package:six_cash/features/language/controllers/localization_controller.dart';
// import 'package:six_cash/features/setting/controllers/theme_controller.dart';
// import 'package:six_cash/firebase/firebase_api.dart';
// import 'package:six_cash/helper/notification_helper.dart';
// import 'package:six_cash/helper/route_helper.dart';
// import 'package:six_cash/theme/dark_theme.dart';
// import 'package:six_cash/theme/light_theme.dart';
// import 'package:six_cash/util/app_constants.dart';
// import 'package:six_cash/util/messages.dart';
// import 'package:permission_handler/permission_handler.dart';

// import 'helper/get_di.dart' as di;

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//  late List<CameraDescription> cameras;

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp();
//   await firebaseAPI().initNotifications();
  

//   void checkNotificationPermissions() async {
//   PermissionStatus status = await Permission.notification.status;
//   if (status.isDenied) {
//     // Demander l'autorisation
//     await Permission.notification.request();
//   }
// }


//   if(GetPlatform.isAndroid){
//    await FirebaseMessaging.instance.requestPermission();

//   }

//   ///firebase crashlytics
//   cameras = await availableCameras();

//   Map<String, Map<String, String>> languages = await di.init();

//   int? orderID;
//  // NotificationBody? body;
//   try {
//     final RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
//     if (remoteMessage != null) {
//       //body = NotificationHelper.convertNotification(remoteMessage.data);
//     }
//     await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
//     FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
//   }catch(e) {
//     if (kDebugMode) {
//       print("");
//     }
//   }

//   runApp(MyApp(languages: languages, orderID: orderID));

// }

// class MyApp extends StatelessWidget {
//   final Map<String, Map<String, String>>? languages;
//   final int? orderID;
//   const MyApp({Key? key, required this.languages, required this.orderID}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<ThemeController>(builder: (themeController) {
//       return GetBuilder<LocalizationController>(builder: (localizeController) {
//         return MediaQuery(
//           data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
//           child: GetMaterialApp(
//             navigatorObservers: [FlutterSmartDialog.observer],
//             builder: FlutterSmartDialog.init(),
//             title: AppConstants.appName,
//             debugShowCheckedModeBanner: false,
//             navigatorKey: Get.key,
//             theme: themeController.darkTheme ? dark : light,
//             locale: localizeController.locale,
//             translations: Messages(languages: languages),
//             fallbackLocale: Locale(AppConstants.languages[0].languageCode!, AppConstants.languages[0].countryCode),
//             initialRoute: RouteHelper.getSplashRoute(),
//             getPages: RouteHelper.routes,
//             defaultTransition: Transition.topLevel,
//             transitionDuration: const Duration(milliseconds: 500),
//           ),
//         );
//       },
//       );
//     },
//     );
//   }
// }



