import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:six_cash/features/auth/controllers/auth_controller.dart';
import 'package:six_cash/features/splash/controllers/splash_controller.dart';
import 'package:six_cash/features/transaction_money/controllers/contact_controller.dart';
import 'package:six_cash/data/api/api_checker.dart';
import 'package:six_cash/features/auth/domain/models/user_short_data_model.dart';
import 'package:six_cash/helper/route_helper.dart';
import 'package:six_cash/util/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/helper/custom_snackbar_helper.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';




class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver {
  late StreamSubscription<List<ConnectivityResult>> subscription;
  double _progress = 0.0;
   late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startProgress();


    bool isFirstTime = true;

     subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) async {
      if(await ApiChecker.isVpnActive()) {
        showCustomSnackBarHelper('you are using vpn', isVpn: true, duration: const Duration(minutes: 10));
      }
      if(isFirstTime) {
        isFirstTime = false;
        await _route();
      }
    });




  }


  @override
  void dispose() {
    super.dispose();
  }

    void _startProgress() {
    const oneSec = const Duration(seconds: 1);
    int counter = 0;

    _timer = Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        _progress = counter / 6;
      });

      if (counter++ >= 5) {
        timer.cancel();
      }
    });
  }

  Future<void> _route() async {
    await  Get.find<ContactController>().getContactList().then((_){


      Get.find<SplashController>().getConfigData().then((value) {
        if(value.isOk) {
          Timer(const Duration(milliseconds: 50), () async {
            Get.find<SplashController>().initSharedData().then((value) {
              UserShortDataModel? userData = Get.find<AuthController>().getUserData();

              if(userData != null && (Get.find<SplashController>().configModel!.companyName != null)){
                Get.offNamed(RouteHelper.getLoginRoute(
                  countryCode: userData.countryCode,phoneNumber: userData.phone,
                ));
              }else{
                Get.offNamed(RouteHelper.getChoseLoginRegRoute());
              }
            });

          });
        }
      });

    });
  }

  @override
 Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(Images.logo, height: 175),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30 , horizontal: 60),
              child: LinearProgressIndicator(
                  backgroundColor: Colors.grey[200],
                  color: Color(0xFFfa6508), // Utilisation du code couleur hexadécimal
                  minHeight: 04,
                  value: _progress,
                ),
            ),
           
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical:20 , horizontal: 20),
            //   child: CircularProgressIndicator(
            //       ba ckgroundColor: Colors.grey[200],
            //       color: Colors.orangeAccent,
            //     ),
            // ),
           
            //  Padding(
            //   padding: const EdgeInsets.symmetric(vertical:20 , horizontal: 20),
            //   child:  CupertinoActivityIndicator(
            //     color: Colors.orangeAccent,
            //   ),   
            //  )         

          ],
        ),
      ),
    );
  }
}
