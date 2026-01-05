
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:six_cash/features/home/controllers/banner_controller.dart';
import 'package:six_cash/features/home/controllers/home_controller.dart';
import 'package:six_cash/features/notification/controllers/notification_controller.dart';
import 'package:six_cash/features/setting/controllers/profile_screen_controller.dart';
import 'package:six_cash/features/requested_money/controllers/requested_money_controller.dart';
import 'package:six_cash/features/splash/controllers/splash_controller.dart';
import 'package:six_cash/features/transaction_money/controllers/transaction_controller.dart';
import 'package:six_cash/features/history/controllers/transaction_history_controller.dart';
import 'package:six_cash/features/home/controllers/websitelink_controller.dart';
import 'package:six_cash/features/transaction_money/screens/retrait_inter.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/features/home/widgets/home_app_bar_widget.dart';
import 'package:six_cash/features/home/widgets/bottomsheet_content_widget.dart';
import 'package:six_cash/features/home/widgets/persistent_header_widget.dart';
import 'package:six_cash/features/home/widgets/theme_one_widget.dart';
import 'package:six_cash/features/home/widgets/linked_website_widget.dart';
import 'package:six_cash/features/home/widgets/theme_two_widget.dart';
import 'package:six_cash/features/home/widgets/theme_three_widget.dart';

import 'package:six_cash/util/images.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _loadData(BuildContext context, bool reload) async {
    if(reload){
      Get.find<SplashController>().getConfigData();
    }

    Get.find<ProfileController>().getProfileData(reload: reload);
    Get.find<BannerController>().getBannerList(reload);
    Get.find<RequestedMoneyController>().getRequestedMoneyList(reload, isUpdate: reload);
    Get.find<RequestedMoneyController>().getOwnRequestedMoneyList(reload, isUpdate: reload);
    Get.find<TransactionHistoryController>().getTransactionData(1, reload: reload);
    Get.find<WebsiteLinkController>().getWebsiteList(reload, isUpdate: reload);
    Get.find<NotificationController>().getNotificationList(reload);
    Get.find<TransactionMoneyController>().getPurposeList(reload,  isUpdate: reload);
    Get.find<TransactionMoneyController>().getWithdrawMethods(isReload: reload);
    Get.find<RequestedMoneyController>().getWithdrawHistoryList(reload: false);




  }
  @override
  void initState() {

    _loadData(context, false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<HomeController>(
        builder: (controller) {
          return Scaffold(
            appBar: const HomeAppBarWidget(),
            body: ExpandableBottomSheet(
                enableToggle: true,
                background: RefreshIndicator(
                  onRefresh: () async => await _loadData(context, true),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: GetBuilder<SplashController>(builder: (splashController) {
                      int themeIndex = splashController.configModel!.themeIndex ?? 1;
                      return Column(
                        
                        children: [

                           

                        themeIndex == 1 ?  const ThemeOneWidget() :
                        themeIndex == 2 ? const ThemeTwoWidget() :
                        themeIndex == 3 ? const ThemeThreeWidget() :
                        const ThemeOneWidget(),

                        // Container(
                        //   child: Text("Retrait Mobile Money" , style: TextStyle( fontSize: 22 , fontWeight: FontWeight.w600),),
                        //   padding: EdgeInsets.symmetric(vertical: 15),
                        // ),

                        // const SizedBox(height: Dimensions.paddingSizeDefault),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 15 ),
                          child: Column(
                            children: [
                            // Container(
                            //   padding: EdgeInsets.symmetric(horizontal: 15),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       // Container(
                            //       //   child: Row(
                            //       //     children: [
                            //       //       Container(
                            //       //         padding: EdgeInsets.symmetric(vertical: 10),
                            //       //         child: ClipOval(
                            //       //           child: Container(
                            //       //             height: 70,
                            //       //             width: 80,
                            //       //             child: Image.asset(Images.ivoire, fit: BoxFit.cover),
                            //       //           ),
                            //       //         ),
                            //       //       ),
                            //       //         SizedBox(width: 20,),
                            //       //       Container(
                            //       //         child: Text("Cote d'ivoire" , style: TextStyle( fontSize: 18 , fontWeight: FontWeight.w600),),
                            //       //         padding: EdgeInsets.symmetric(vertical: 15),
                            //       //       ),

                            //       //     ],
                            //       //   ),
                            //       // ),
                            //       Container(
                            //         child: Row(
                            //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                            //           children: [
                            //             GestureDetector(
                            //               onTap: () {
                            //                 Navigator.push(
                            //                   context,
                            //                   PageRouteBuilder(
                            //                     pageBuilder: (context, animation, secondaryAnimation) => retraitInter(imagePath: Images.orangelogo, percentage: 0.03 , indicatif: 225,),
                            //                   ),
                            //                 );
                            //               },
                            //               child: Container(
                            //                 height: 40,
                            //                 width: 60,
                            //                 child: Image.asset(Images.orangelogo),
                            //               ),
                            //             ),
                            //             GestureDetector(
                            //               onTap: () {
                            //                 Navigator.push(
                            //                   context,
                            //                   PageRouteBuilder(
                            //                     pageBuilder: (context, animation, secondaryAnimation) => retraitInter(imagePath: Images.wavelogo, percentage: 0.02 ,indicatif: 225),
                            //                   ),
                            //                 );
                            //               },
                            //               child: Container(
                            //                 height: 40,
                            //                 width: 60,
                            //                 child: Image.asset(Images.wavelogo),
                            //               ),
                            //             ),
                            //             GestureDetector(
                            //               onTap: () {
                            //                 Navigator.push(
                            //                   context,
                            //                   PageRouteBuilder(
                            //                     pageBuilder: (context, animation, secondaryAnimation) => retraitInter(imagePath: Images.mtnlogo, percentage: 0.015 ,indicatif: 225),
                            //                   ),
                            //                 );
                            //               },
                            //               child: Container(
                            //                 height: 40,
                            //                 width: 60,
                            //                 child: Image.asset(Images.mtnlogo),
                            //               ),
                            //             ),
                            //             GestureDetector(
                            //               onTap: () {
                            //                 Navigator.push(
                            //                   context,
                            //                   PageRouteBuilder(
                            //                     pageBuilder: (context, animation, secondaryAnimation) => retraitInter(imagePath: Images.moovlogo, percentage: 0.025 ,indicatif: 225),
                            //                   ),
                            //                 );
                            //               },
                            //               child: Container(
                            //                 height: 40,
                            //                 width: 60,
                            //                 child: Image.asset(Images.moovlogo),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //       Divider(
                            //         color: Colors.grey,
                            //         thickness: 0.5,
                            //       )
                            //     ],
                            //   ),
                            // ),
                            // SizedBox(height: 20),
                            // Container(
                            //   padding: EdgeInsets.symmetric(horizontal: 15),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //     Container(
                            //         child: Row(
                            //           children: [
                            //             Container(
                            //               padding: EdgeInsets.symmetric(vertical: 10),
                            //               child: ClipOval(
                            //                 child: Container(
                            //                   height: 70,
                            //                   width: 80,
                            //                   child: Image.asset(Images.senegal, fit: BoxFit.cover),
                            //                 ),
                            //               ),
                            //             ),
                            //               SizedBox(width: 20,),
                            //             Container(
                            //               child: Text("Senegal" , style: TextStyle( fontSize: 18 , fontWeight: FontWeight.w600),),
                            //               padding: EdgeInsets.symmetric(vertical: 15),
                            //             ),

                            //           ],
                            //         ),
                            //       ),
                            //       Container(
                            //         child: Row(
                            //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                            //           children: [
                            //             GestureDetector(
                            //               onTap: () {
                            //                 Navigator.push(
                            //                   context,
                            //                   PageRouteBuilder(
                            //                     pageBuilder: (context, animation, secondaryAnimation) => retraitInter(imagePath: Images.orangelogo, percentage: 0.03 ,indicatif: 221),
                            //                   ),
                            //                 );
                            //               },
                            //               child: Container(
                            //                 height: 40,
                            //                 width: 60,
                            //                 child: Image.asset(Images.orangelogo, fit: BoxFit.cover),
                            //               ),
                            //             ),
                            //             GestureDetector(
                            //               onTap: () {
                            //                 Navigator.push(
                            //                   context,
                            //                   PageRouteBuilder(
                            //                     pageBuilder: (context, animation, secondaryAnimation) => retraitInter(imagePath: Images.freemoney, percentage: 0.02,indicatif: 221),
                            //                   ),
                            //                 );
                            //               },
                            //               child: Container(
                            //                 height: 40,
                            //                 width: 60,
                            //                 child: Image.asset(Images.freemoney, fit: BoxFit.cover),
                            //               ),
                            //             ),
                            //             GestureDetector(
                            //               onTap: () {
                            //                 Navigator.push(
                            //                   context,
                            //                   PageRouteBuilder(
                            //                     pageBuilder: (context, animation, secondaryAnimation) => retraitInter(imagePath: Images.emoney, percentage: 0.015,indicatif: 221),
                            //                   ),
                            //                 );
                            //               },
                            //               child: Container(
                            //                 height: 40,
                            //                 width: 60,
                            //                 child: Image.asset(Images.emoney, fit: BoxFit.cover),
                            //               ),
                            //             ),
                            //             GestureDetector(
                            //               onTap: () {
                            //                 Navigator.push(
                            //                   context,
                            //                   PageRouteBuilder(
                            //                     pageBuilder: (context, animation, secondaryAnimation) => retraitInter(imagePath: Images.wizall, percentage: 0.025,indicatif: 221),
                            //                   ),
                            //                 );
                            //               },
                            //               child: Container(
                            //                 height: 40,
                            //                 width: 60,
                            //                 child: Image.asset(Images.wizall, fit: BoxFit.cover),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //       Divider(
                            //         color: Colors.grey,
                            //         thickness: 0.5,
                            //       )
                            //     ],
                            //   ),
                            // ),
                            // SizedBox(height: 20),

                            // Container(
                            //   padding: EdgeInsets.symmetric(horizontal: 15),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Container(
                            //         child: Row(
                            //           children: [
                            //             Container(
                            //               padding: EdgeInsets.symmetric(vertical: 10),
                            //               child: ClipOval(
                            //                 child: Container(
                            //                   height: 70,
                            //                   width: 80,
                            //                   child: Image.asset(Images.bf, fit: BoxFit.cover),
                            //                 ),
                            //               ),
                            //             ),
                            //               SizedBox(width: 20,),
                            //             Container(
                            //               child: Text("Burkina Faso" , style: TextStyle( fontSize: 18 , fontWeight: FontWeight.w600),),
                            //               padding: EdgeInsets.symmetric(vertical: 15),
                            //             ),

                            //           ],
                            //         ),
                            //       ),
                            //       Container(
                            //         child: Row(
                            //           mainAxisAlignment: MainAxisAlignment.start,
                            //           children: [
                            //             GestureDetector(
                            //               onTap: () {
                            //                 Navigator.push(
                            //                   context,
                            //                   PageRouteBuilder(
                            //                     pageBuilder: (context, animation, secondaryAnimation) => retraitInter(imagePath: Images.orangelogo, percentage: 0.03 ,indicatif: 226),
                            //                   ),
                            //                 );
                            //               },
                            //               child: Container(
                            //                 height: 40,
                            //                 width: 60,
                            //                 child: Image.asset(Images.orangelogo, fit: BoxFit.cover),
                            //               ),
                            //             ),
                            //             SizedBox(width: 20),
                            //             GestureDetector(
                            //               onTap: () {
                            //                 Navigator.push(
                            //                   context,
                            //                   PageRouteBuilder(
                            //                     pageBuilder: (context, animation, secondaryAnimation) => retraitInter(imagePath: Images.moovlogo, percentage: 0.025,indicatif: 226),
                            //                   ),
                            //                 );
                            //               },
                            //               child: Container(
                            //                 height: 40,
                            //                 width: 60,
                            //                 child: Image.asset(Images.moovlogo, fit: BoxFit.cover),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //       Divider(
                            //         color: Colors.grey,
                            //         thickness: 0.5,
                            //       )
                            //     ],
                            //   ),
                            // ),
                            SizedBox(height: 20),
                            // Container(
                            //   padding: EdgeInsets.symmetric(horizontal: 15),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Container(
                            //         child: Row(
                            //           children: [
                            //             Container(
                            //               padding: EdgeInsets.symmetric(vertical: 10),
                            //               child: ClipOval(
                            //                 child: Container(
                            //                   height: 70,
                            //                   width: 80,
                            //                   child: Image.asset(Images.benin, fit: BoxFit.cover),
                            //                 ),
                            //               ),
                            //             ),
                            //               SizedBox(width: 20,),
                            //             Container(
                            //               child: Text("Benin" , style: TextStyle( fontSize: 18 , fontWeight: FontWeight.w600),),
                            //               padding: EdgeInsets.symmetric(vertical: 15),
                            //             ),

                            //           ],
                            //         ),
                            //       ),
                            //       Container(
                            //         child: Row(
                            //           mainAxisAlignment: MainAxisAlignment.start,
                            //           children: [
                            //             GestureDetector(
                            //               onTap: () {
                            //                 Navigator.push(
                            //                   context,
                            //                   PageRouteBuilder(
                            //                     pageBuilder: (context, animation, secondaryAnimation) => retraitInter(imagePath: Images.moovlogo, percentage: 0.025,indicatif: 229),
                            //                   ),
                            //                 );
                            //               },
                            //               child: Container(
                            //                 height: 40,
                            //                 width: 60,
                            //                 child: Image.asset(Images.moovlogo, fit: BoxFit.cover),
                            //               ),
                            //             ),
                            //             SizedBox(width: 20),
                            //             GestureDetector(
                            //               onTap: () {
                            //                 Navigator.push(
                            //                   context,
                            //                   PageRouteBuilder(
                            //                     pageBuilder: (context, animation, secondaryAnimation) => retraitInter(imagePath: Images.mtnlogo, percentage: 0.02,indicatif: 229),
                            //                   ),
                            //                 );
                            //               },
                            //               child: Container(
                            //                 height: 40,
                            //                 width: 60,
                            //                 child: Image.asset(Images.mtnlogo, fit: BoxFit.cover),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //       Divider(
                            //         color: Colors.grey,
                            //         thickness: 0.5,
                            //       )
                            //     ],
                            //   ),
                            // ),
                            // Container(
                            //   padding: EdgeInsets.symmetric(horizontal: 15),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Container(
                            //         child: Row(
                            //           children: [
                            //             Container(
                            //               padding: EdgeInsets.symmetric(vertical: 10),
                            //               child: ClipOval(
                            //                 child: Container(
                            //                   height: 70,
                            //                   width: 80,
                            //                   child: Image.asset(Images.togo, fit: BoxFit.cover),
                            //                 ),
                            //               ),
                            //             ),
                            //               SizedBox(width: 20,),
                            //             Container(
                            //               child: Text("Togo" , style: TextStyle( fontSize: 18 , fontWeight: FontWeight.w600),),
                            //               padding: EdgeInsets.symmetric(vertical: 15),
                            //             ),

                            //           ],
                            //         ),
                            //       ),
                            //       Container(
                            //         child: Row(
                            //           mainAxisAlignment: MainAxisAlignment.start,
                            //           children: [
                            //             GestureDetector(
                            //               onTap: () {
                            //                 Navigator.push(
                            //                   context,
                            //                   PageRouteBuilder(
                            //                     pageBuilder: (context, animation, secondaryAnimation) => retraitInter(imagePath: Images.moovlogo, percentage: 0.025,indicatif: 228),
                            //                   ),
                            //                 );
                            //               },
                            //               child: Container(
                            //                 height: 40,
                            //                 width: 60,
                            //                 child: Image.asset(Images.moovlogo, fit: BoxFit.cover),
                            //               ),
                            //             ),
                            //             SizedBox(width: 20),
                            //             GestureDetector(
                            //               onTap: () {
                            //                 Navigator.push(
                            //                   context,
                            //                   PageRouteBuilder(
                            //                     pageBuilder: (context, animation, secondaryAnimation) => retraitInter(imagePath: Images.tmoney, percentage: 0.02 ,indicatif: 228),
                            //                   ),
                            //                 );
                            //               },
                            //               child: Container(
                            //                 height: 40,
                            //                 width: 60,
                            //                 child: Image.asset(Images.tmoney, fit: BoxFit.cover),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //       Divider(
                            //         color: Colors.grey,
                            //         thickness: 0.5,
                            //       )
                            //     ],
                            //   ),
                            // ),
                            
                            // Container(
                            //   padding: EdgeInsets.symmetric(horizontal: 15),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Container(
                            //         child: Row(
                            //           children: [
                            //             Container(
                            //               padding: EdgeInsets.symmetric(vertical: 10),
                            //               child: ClipOval(
                            //                 child: Container(
                            //                   height: 70,
                            //                   width: 80,
                            //                   child: Image.asset(Images.mali, fit: BoxFit.cover),
                            //                 ),
                            //               ),
                            //             ),
                            //               SizedBox(width: 20,),
                            //             Container(
                            //               child: Text("Mali" , style: TextStyle( fontSize: 18 , fontWeight: FontWeight.w600),),
                            //               padding: EdgeInsets.symmetric(vertical: 15),
                            //             ),

                            //           ],
                            //         ),
                            //       ),
                            //       Container(
                            //         child: Row(
                            //           children: [
                            //             GestureDetector(
                            //               onTap: () {
                            //                 Navigator.push(
                            //                   context,
                            //                   PageRouteBuilder(
                            //                     pageBuilder: (context, animation, secondaryAnimation) => retraitInter(imagePath: Images.moovlogo, percentage: 0.025 ,indicatif: 223),
                            //                   ),
                            //                 );
                            //               },
                            //               child: Container(
                            //                 height: 40,
                            //                 width: 60,
                            //                 child: Image.asset(Images.moovlogo, fit: BoxFit.cover),
                            //               ),
                            //             ),
                            //             SizedBox(width: 20),
                            //             GestureDetector(
                            //               onTap: () {
                            //                 Navigator.push(
                            //                   context,
                            //                   PageRouteBuilder(
                            //                     pageBuilder: (context, animation, secondaryAnimation) => retraitInter(imagePath: Images.orangelogo, percentage: 0.025 ,indicatif: 223),
                            //                   ),
                            //                 );
                            //               },
                            //               child: Container(
                            //                 height: 40,
                            //                 width: 60,
                            //                 child: Image.asset(Images.orangelogo, fit: BoxFit.cover),
                            //               ),
                            //             ),
                            //             SizedBox(width: 20),
                            //           ],
                            //         ),
                            //       ),
                            //       Divider(
                            //         color: Colors.grey,
                            //         thickness: 0.5,
                            //       )
                            //     ],
                            //   ),
                            // ),
                    
                            ],
                          ),
                        ) ,

                        
                        const LinkedWebsiteWidget(),
                        const SizedBox(height: 80),

                      ]);
                    }),
                  ),
                ),
                persistentContentHeight: 70,
                persistentHeader: const PersistentHeaderWidget(),
                expandableContent: const BottomSheetContentWidget()
            ),
          );
        });
  }

}

