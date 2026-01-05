import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/features/setting/controllers/profile_screen_controller.dart';
import 'package:six_cash/features/splash/controllers/splash_controller.dart';
import 'package:six_cash/features/transaction_money/screens/add_money_from_other.dart';
import 'package:six_cash/helper/price_converter_helper.dart';
import 'package:six_cash/helper/transaction_type.dart';
import 'package:six_cash/util/color_resources.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';
import 'package:six_cash/util/styles.dart';
import 'package:six_cash/common/widgets/custom_ink_well_widget.dart';
import 'package:six_cash/features/home/widgets/banner_widget.dart';
import 'package:six_cash/features/home/widgets/option_card_widget.dart';
import 'package:six_cash/features/home/widgets/option_car_banking.dart';

import 'package:six_cash/features/requested_money/screens/requested_money_list_screen.dart';
import 'package:six_cash/features/transaction_money/screens/transaction_balance_input_screen.dart';
import 'package:six_cash/features/transaction_money/screens/transaction_money_screen.dart';
import 'package:six_cash/features/transaction_money/screens/credit_card.dart';
import '../../../helper/route_helper.dart';



class ThemeOneWidget extends StatelessWidget {
  const ThemeOneWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      builder: (splashController) {
        return Stack(children: [
          Container(
            height: 180.0,
            color: const Color(0xFFFA6508),
          ),

          Positioned(child: Column(
            children: [
              Container(
                width: double.infinity, height: 80.0,
                margin: const  EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeLarge,
                  vertical: Dimensions.paddingSizeLarge,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSizeLarge),
                  color: Theme.of(context).cardColor,
                ),


                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),

                      child: GetBuilder<ProfileController>(
                          builder: (profileController) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'your_balance'.tr, style: rubikLight.copyWith(
                                  color: ColorResources.getBalanceTextColor(),
                                  fontSize: Dimensions.fontSizeLarge,
                                ),),
                                const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                                

                                profileController.userInfo !=  null ?
                                Text(
                                  PriceConverterHelper.balanceWithSymbol(balance: profileController.userInfo!.balance.toString()),
                                  style: rubikMedium.copyWith(
                                    color: Theme.of(context).textTheme.titleLarge!.color,
                                    fontSize: Dimensions.fontSizeExtraLarge,
                                  ),
                                ) :
                                Text(
                                  PriceConverterHelper.convertPrice(0.00),
                                  style: rubikMedium.copyWith(
                                    color: Theme.of(context).textTheme.titleLarge!.color,
                                    fontSize: Dimensions.fontSizeExtraLarge,
                                  ),
                                ),
                                
                              ],
                            );
                          }
                      ),
                    ),
                    const Spacer(),

                    
                    if(splashController.configModel!.systemFeature!.addMoneyStatus!) Container(
                      height: 80.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSizeLarge),
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                      child: CustomInkWellWidget(
                        onTap: () => Get.to(const addMoneyFromOther()),
                        radius: Dimensions.radiusSizeLarge,
                        child: Padding(padding: const EdgeInsets.symmetric(horizontal:15),
                          child: Column(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height:34, child: Image.asset(Images.walletLogo)),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                              Text(
                                'Ajouter', style: rubikRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: Theme.of(context).textTheme.bodyLarge!.color,
                              ),)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical:05 , horizontal: 05),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteHelper.homeInter);
                  }, 
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Transfert inter réseaux" ,
                          style: TextStyle( color: Colors.white , fontSize: 22 ,  )),
                          ),
                        ),
                      ),
              ),
                  
              /// Cards...
              SizedBox(
                height: 120.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.fontSizeExtraSmall),
                  child: Row(
                    children: [
                      if(splashController.configModel!.systemFeature!.sendMoneyStatus!) Expanded(child: OptionCardWidget(
                        image: Images.sendMoneyLogo, text: "Envoyer",
                        color: Theme.of(context).secondaryHeaderColor,
                        onTap: ()=> Get.to(()=> const TransactionMoneyScreen(
                          fromEdit: false,
                          transactionType: TransactionType.sendMoney,
                        )),
                      )),

                      if(splashController.configModel!.systemFeature!.cashOutStatus!)Expanded(child: OptionCardWidget(
                        image: Images.cashOutLogo, text: "Retirer",
                        color: ColorResources.getCashOutCardColor(),
                        onTap: ()=> Get.to(()=> const TransactionMoneyScreen(
                          fromEdit: false,
                          transactionType: TransactionType.cashOut,
                        )),
                      )),
                      
                      if(splashController.configModel!.systemFeature!.sendMoneyRequestStatus!)Expanded(child: OptionCardWidget(
                        image: Images.requestMoneyLogo, text: "Demander",

                        color: ColorResources.getRequestMoneyCardColor(),
                        onTap: ()=> Get.to(()=> const TransactionMoneyScreen(
                          fromEdit: false,
                          transactionType: TransactionType.requestMoney,
                        )),
                      )),

                      if(splashController.configModel!.systemFeature!.sendMoneyRequestStatus!)Expanded(child: OptionCardWidget(
                        image: Images.requestListImage2,
                        text: 'requests'.tr,
                        color: ColorResources.getReferFriendCardColor(),
                        onTap: () => Get.to(()=> const RequestedMoneyListScreen(requestType: RequestType.request)),
                      ),
                      ),
                    ],
                  ),
                ),
              ),



              const BannerWidget(),

            ],
          )),
        ]);
      }
    );
  }

}
