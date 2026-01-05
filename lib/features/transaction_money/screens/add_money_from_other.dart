import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:six_cash/features/add_money/controllers/add_money_controller.dart';
import 'package:six_cash/features/setting/controllers/profile_screen_controller.dart';
import 'package:six_cash/features/splash/controllers/splash_controller.dart';
import 'package:six_cash/features/transaction_money/controllers/contact_controller.dart';
import 'package:six_cash/features/transaction_money/controllers/transaction_controller.dart';
import 'package:six_cash/features/transaction_money/domain/models/purpose_model.dart';
import 'package:six_cash/common/models/contact_model.dart';
import 'package:six_cash/features/transaction_money/domain/models/withdraw_model.dart';
import 'package:six_cash/helper/email_checker_helper.dart';
import 'package:six_cash/helper/price_converter_helper.dart';
import 'package:six_cash/helper/transaction_type.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';
import 'package:six_cash/util/styles.dart';
import 'package:six_cash/common/widgets/custom_app_bar_widget.dart';
import 'package:six_cash/common/widgets/custom_loader_widget.dart';
import 'package:six_cash/helper/custom_snackbar_helper.dart';
import 'package:six_cash/features/add_money/widgets/digital_payment_widget.dart';
import 'package:six_cash/features/transaction_money/screens/transaction_confirmation_screen.dart';
import 'package:six_cash/features/transaction_money/screens/confirm_transaction.dart';

import 'package:six_cash/features/transaction_money/widgets/input_box_widget.dart';
import 'package:six_cash/features/transaction_money/widgets/purpose_widget.dart';
import '../widgets/field_item_widget.dart';
import '../widgets/for_person_widget.dart';
import '../widgets/next_button_widget.dart';




class addMoneyFromOther extends StatefulWidget {
  const addMoneyFromOther({Key? key}) : super(key: key);

  @override
  State<addMoneyFromOther> createState() => _addMoneyFromOtherState();
}

class _addMoneyFromOtherState extends State<addMoneyFromOther> {
  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();
    final SplashController splashController = Get.find<SplashController>();
    return  Scaffold(
      appBar: CustomAppbarWidget(title:"DEPOT"),
      body: SingleChildScrollView(
  physics: BouncingScrollPhysics(),
  child: Column(
    children: [
      Container(
        color: Colors.grey.shade200,
        padding: EdgeInsets.symmetric(horizontal: 20 , vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Compte à credité" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold),),
            Row(
              children: [
                Container(
                  height: 85,
                  child: Image.asset(Images.logo),
                  decoration: BoxDecoration(
                    color:Colors.black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                SizedBox(width: 10,) ,
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Le compte buudi" ,style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500)),
                      Text( profileController.userInfo!.phone!,style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500)),
                      Text( "solde : ${PriceConverterHelper.balanceWithSymbol(balance: profileController.userInfo!.balance.toString())}",
                      style: TextStyle(color: Colors.green , fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
      Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text("Compte à débiter" ,style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 18),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20 , horizontal: 25),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("COTE D'IVOIRE ",style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 15),),
                    GestureDetector(
                      onTap:(){
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => ConfirmTransaction(imagePath:  Images.orangelogo, percentage : 0.03  , indicatif: 225, ),
                          ),
                        );
                      },
                      child:Container(
                        child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 45,
                                          child: Image.asset(Images.orangelogo),
                                        ),
                                        SizedBox(width:10),
                                        Container(
                                          child: Text("ORANGE" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 15) ),
                                        )
                                      ],
                                    ),

                                    Container(
                                      child: Row(
                                        children: [
                                          Container( child: Text("3%" , style: TextStyle(fontWeight: FontWeight.w500),),),
                                          SizedBox(width: 7,),
                                          Container(
                                              child: Icon(Icons.near_me),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ),
                          ),
                          
                        ],
                      ),
                      ),
                    ),

                    GestureDetector(
                        onTap: () {
                              Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => ConfirmTransaction(imagePath:  Images.mtnlogo ,  percentage : 0.03 , indicatif: 225,  ),
                            ),
                          );
                        },
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 45,
                                            child: Image.asset(Images.mtnlogo),
                                          ),
                                          SizedBox(width:10),
                                          Container(
                                            child: Text("MTN" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 15) ),
                                          )
                                        ],
                                      ),
                                     Container(
                                      child: Row(
                                        children: [
                                          Container( child: Text(" 3%" , style: TextStyle(fontWeight: FontWeight.w500),),),
                                          SizedBox(width: 7,),
                                          Container(
                                              child: Icon(Icons.near_me),
                                          )
                                        ],
                                      ),
                                    )
                                    ],
                                  ),
                                )
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                    ),
                     GestureDetector(
                        onTap: () {
                              Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => ConfirmTransaction(imagePath:  Images.moovlogo ,  percentage : 0.03 , indicatif: 225, ),
                            ),
                          );
                        },
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 45,
                                            child: Image.asset(Images.moovlogo),
                                          ),
                                          SizedBox(width:10),
                                          Container(
                                            child: Text("MOOV" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 15) ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        child: Row(
                                        children: [
                                          Container( child: Text("3%" , style: TextStyle(fontWeight: FontWeight.w500),),),
                                          SizedBox(width: 7,),
                                          Container(
                                              child: Icon(Icons.near_me),
                                          )
                                        ],
                                      ),
                                    )
                                    ],
                                  ),
                                )
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                    ), 
                    GestureDetector(
                        onTap: () {
                              Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => ConfirmTransaction(imagePath:  Images.wavelogo ,  percentage : 0.025  , indicatif: 225,),
                            ),
                          );
                        },
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 45,
                                            child: Image.asset(Images.wavelogo),
                                          ),
                                          SizedBox(width:10),
                                          Container(
                                            child: Text("WAVE" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 15) ),
                                          )
                                        ],
                                      ),
                                      Container(
                                      child: Row(
                                        children: [
                                          Container( child: Text("2.5%" , style: TextStyle(fontWeight: FontWeight.w500),),),
                                          SizedBox(width: 7,),
                                          Container(
                                              child: Icon(Icons.near_me),
                                          )
                                        ],
                                      ),
                                    )
                                    ],
                                  ),
                                )
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                    ),
              
                  ],
                ),
              ),
            ),

             // ************************** SENEGAL *********************************
             // ************************** SENEGAL *********************************


            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20 , horizontal: 25),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("SENEGAL",style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 15),),
                    GestureDetector(
                      onTap:(){
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => ConfirmTransaction(imagePath:  Images.orangelogo, percentage : 0.02 , indicatif: 221, ),
                          ),
                        );
                      },
                      child:Container(
                        child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 45,
                                          child: Image.asset(Images.orangelogo),
                                        ),
                                        SizedBox(width:10),
                                        Container(
                                          child: Text("ORANGE" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 15) ),
                                        )
                                      ],
                                    ),
                                   Container(
                                      child: Row(
                                        children: [
                                          Container( child: Text("2%" , style: TextStyle(fontWeight: FontWeight.w500),),),
                                          SizedBox(width: 7,),
                                          Container(
                                              child: Icon(Icons.near_me),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ),
                          ),
                          
                        ],
                      ),
                      ),
                    ),

                    GestureDetector(
                        onTap: () {
                              Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => ConfirmTransaction(imagePath:  Images.freemoney ,  percentage : 0.03 , indicatif: 221,  ),
                            ),
                          );
                        },
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 45,
                                            child: Image.asset(Images.freemoney),
                                          ),
                                          SizedBox(width:10),
                                          Container(
                                            child: Text("FREE-MONEY" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 15) ),
                                          )
                                        ],
                                      ),
                                      Container(
                                      child: Row(
                                        children: [
                                          Container( child: Text("2%" , style: TextStyle(fontWeight: FontWeight.w500),),),
                                          SizedBox(width: 7,),
                                          Container(
                                              child: Icon(Icons.near_me),
                                          )
                                        ],
                                      ),
                                    )
                                    ],
                                  ),
                                )
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                    ),
                     GestureDetector(
                        onTap: () {
                              Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => ConfirmTransaction(imagePath:  Images.emoney ,  percentage : 0.02 , indicatif: 221,),
                            ),
                          );
                        },
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 45,
                                            child: Image.asset(Images.emoney),
                                          ),
                                          SizedBox(width:10),
                                          Container(
                                            child: Text("E-MONEY" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 15) ),
                                          )
                                        ],
                                      ),
                                      Container(
                                      child: Row(
                                        children: [
                                          Container( child: Text("2%" , style: TextStyle(fontWeight: FontWeight.w500),),),
                                          SizedBox(width: 7,),
                                          Container(
                                              child: Icon(Icons.near_me),
                                          )
                                        ],
                                      ),
                                    )
                                    ],
                                  ),
                                )
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                    ), 
                    GestureDetector(
                        onTap: () {
                              Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => ConfirmTransaction(imagePath:  Images.wizall ,  percentage : 0.02 , indicatif: 221,),
                            ),
                          );
                        },
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 45,
                                            child: Image.asset(Images.wizall),
                                          ),
                                          SizedBox(width:10),
                                          Container(
                                            child: Text("WIZALL" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 15) ),
                                          )
                                        ],
                                      ),
                                      Container(
                                      child: Row(
                                        children: [
                                          Container( child: Text("2%" , style: TextStyle(fontWeight: FontWeight.w500),),),
                                          SizedBox(width: 7,),
                                          Container(
                                              child: Icon(Icons.near_me),
                                          )
                                        ],
                                      ),
                                    )
                                    ],
                                  ),
                                )
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                              Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => ConfirmTransaction(imagePath:  Images.wizall ,  percentage : 0.02 , indicatif: 221,),
                            ),
                          );
                        },
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 45,
                                            child: Image.asset(Images.wavelogo),
                                          ),
                                          SizedBox(width:10),
                                          Container(
                                            child: Text("WAVE" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 15) ),
                                          )
                                        ],
                                      ),
                                      Container(
                                      child: Row(
                                        children: [
                                          Container( child: Text("2.5%" , style: TextStyle(fontWeight: FontWeight.w500),),),
                                          SizedBox(width: 7,),
                                          Container(
                                              child: Icon(Icons.near_me),
                                          )
                                        ],
                                      ),
                                    )
                                    ],
                                  ),
                                )
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                    ),
              
              
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20 , horizontal: 25),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("MALI",style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 15),),
                    GestureDetector(
                      onTap:(){
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => ConfirmTransaction(imagePath:  Images.moovlogo, percentage : 0.03 , indicatif: 223, ),
                          ),
                        );
                      },
                      child:Container(
                        child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 45,
                                          child: Image.asset(Images.moovlogo),
                                        ),
                                        SizedBox(width:10),
                                        Container(
                                          child: Text("MOOV" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 15) ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Container( child: Text("3%" , style: TextStyle(fontWeight: FontWeight.w500),),),
                                          SizedBox(width: 7,),
                                          Container(
                                              child: Icon(Icons.near_me),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ),
                          ),
                          
                        ],
                      ),
                      ),
                    ),
                    GestureDetector(
                      onTap:(){
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => ConfirmTransaction(imagePath:  Images.orangelogo, percentage : 0.02 , indicatif: 223, ),
                          ),
                        );
                      },
                      child:Container(
                        child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 45,
                                          child: Image.asset(Images.orangelogo),
                                        ),
                                        SizedBox(width:10),
                                        Container(
                                          child: Text("ORANGE" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 15) ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Container( child: Text("2%" , style: TextStyle(fontWeight: FontWeight.w500),),),
                                          SizedBox(width: 7,),
                                          Container(
                                              child: Icon(Icons.near_me),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ),
                          ),
                          
                        ],
                      ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
             Padding(
              padding: const EdgeInsets.symmetric(vertical: 20 , horizontal: 25),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("BURKINA FASO",style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 15),),
                    GestureDetector(
                      onTap:(){
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => ConfirmTransaction(imagePath:  Images.orangelogo, percentage : 0.025 , indicatif: 226,),
                          ),
                        );
                      },
                      child:Container(
                        child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 45,
                                          child: Image.asset(Images.orangelogo),
                                        ),
                                        SizedBox(width:10),
                                        Container(
                                          child: Text("ORANGE" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 15) ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Container( child: Text("3%" , style: TextStyle(fontWeight: FontWeight.w500),),),
                                          SizedBox(width: 7,),
                                          Container(
                                              child: Icon(Icons.near_me),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ),
                          ),
                          
                        ],
                      ),
                      ),
                    ),
                        GestureDetector(
                      onTap:(){
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => ConfirmTransaction(imagePath:  Images.moovlogo, percentage : 0.025 , indicatif: 226, ),
                          ),
                        );
                      },
                      child:Container(
                        child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 45,
                                          child: Image.asset(Images.moovlogo),
                                        ),
                                        SizedBox(width:10),
                                        Container(
                                          child: Text("MOOV" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 15) ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Container( child: Text("3%" , style: TextStyle(fontWeight: FontWeight.w500),),),
                                          SizedBox(width: 7,),
                                          Container(
                                              child: Icon(Icons.near_me),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ),
                          ),
                          
                        ],
                      ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
             Padding(
              padding: const EdgeInsets.symmetric(vertical: 20 , horizontal: 25),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("BENIN",style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 15),),
                    GestureDetector(
                      onTap:(){
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => ConfirmTransaction(imagePath:  Images.moovlogo, percentage : 0.02   , indicatif: 229,),
                          ),
                        );
                      },
                      child:Container(
                        child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 45,
                                          child: Image.asset(Images.moovlogo),
                                        ),
                                        SizedBox(width:10),
                                        Container(
                                          child: Text("MOOV" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 15) ),
                                        )
                                      ],
                                    ),
                                   Container(
                                      child: Row(
                                        children: [
                                          Container( child: Text("2%" , style: TextStyle(fontWeight: FontWeight.w500),),),
                                          SizedBox(width: 7,),
                                          Container(
                                              child: Icon(Icons.near_me),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ),
                          ),
                          
                        ],
                      ),
                      ),
                    ),
                         GestureDetector(
                      onTap:(){
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => ConfirmTransaction(imagePath:  Images.mtnlogo, percentage : 0.02 , indicatif: 229, ),
                          ),
                        );
                      },
                      child:Container(
                        child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 45,
                                          child: Image.asset(Images.mtnlogo),
                                        ),
                                        SizedBox(width:10),
                                        Container(
                                          child: Text("MTN" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 15) ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Container( child: Text("2%" , style: TextStyle(fontWeight: FontWeight.w500),),),
                                          SizedBox(width: 7,),
                                          Container(
                                              child: Icon(Icons.near_me),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ),
                          ),
                          
                        ],
                      ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20 , horizontal: 25),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("TOGO",style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 15),),
                    GestureDetector(
                      onTap:(){
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => ConfirmTransaction(imagePath:  Images.moovlogo, percentage : 0.025 , indicatif: 228, ),
                          ),
                        );
                      },
                      child:Container(
                        child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 45,
                                          child: Image.asset(Images.moovlogo),
                                        ),
                                        SizedBox(width:10),
                                        Container(
                                          child: Text("MOOV" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 15) ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Container( child: Text("3%" , style: TextStyle(fontWeight: FontWeight.w500),),),
                                          SizedBox(width: 7,),
                                          Container(
                                              child: Icon(Icons.near_me),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ),
                          ),
                          
                        ],
                      ),
                      ),
                    ),
                    GestureDetector(
                      onTap:(){
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => ConfirmTransaction(imagePath:  Images.tmoney, percentage : 0.025 , indicatif: 228,  ),
                          ),
                        );
                      },
                      child:Container(
                        child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 45,
                                          child: Image.asset(Images.tmoney),
                                        ),
                                        SizedBox(width:10),
                                        Container(
                                          child: Text("T-MONEY" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 15) ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Container( child: Text("3%" , style: TextStyle(fontWeight: FontWeight.w500),),),
                                          SizedBox(width: 7,),
                                          Container(
                                              child: Icon(Icons.near_me),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ),
                          ),
                          
                        ],
                      ),
                      ),
                    ),

                  ],
                ),
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
      )
    ],
  ),
)

    );
  }
}

































// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:six_cash/features/add_money/controllers/add_money_controller.dart';
// import 'package:six_cash/features/setting/controllers/profile_screen_controller.dart';
// import 'package:six_cash/features/splash/controllers/splash_controller.dart';
// import 'package:six_cash/features/transaction_money/controllers/contact_controller.dart';
// import 'package:six_cash/features/transaction_money/controllers/transaction_controller.dart';
// import 'package:six_cash/features/transaction_money/domain/models/purpose_model.dart';
// import 'package:six_cash/common/models/contact_model.dart';
// import 'package:six_cash/features/transaction_money/domain/models/withdraw_model.dart';
// import 'package:six_cash/helper/email_checker_helper.dart';
// import 'package:six_cash/helper/price_converter_helper.dart';
// import 'package:six_cash/helper/transaction_type.dart';
// import 'package:six_cash/util/dimensions.dart';
// import 'package:six_cash/util/images.dart';
// import 'package:six_cash/util/styles.dart';
// import 'package:six_cash/common/widgets/custom_app_bar_widget.dart';
// import 'package:six_cash/common/widgets/custom_loader_widget.dart';
// import 'package:six_cash/helper/custom_snackbar_helper.dart';
// import 'package:six_cash/features/add_money/widgets/digital_payment_widget.dart';
// import 'package:six_cash/features/transaction_money/screens/transaction_confirmation_screen.dart';
// import 'package:six_cash/features/transaction_money/screens/confirm_transaction.dart';

// import 'package:six_cash/features/transaction_money/widgets/input_box_widget.dart';
// import 'package:six_cash/features/transaction_money/widgets/purpose_widget.dart';
// import '../widgets/field_item_widget.dart';
// import '../widgets/for_person_widget.dart';
// import '../widgets/next_button_widget.dart';

// class AddMoneyFromOther extends StatefulWidget {
//   final String? transactionType;
//   final ContactModel? contactModel;
//   final String? countryCode;
//    const AddMoneyFromOther({Key? key, this.transactionType ,this.contactModel, this.countryCode}) : super(key: key);
//   @override
//   State<AddMoneyFromOther> createState() => _TransactionBalanceInputScreenState();
// }

// class _TransactionBalanceInputScreenState extends State<AddMoneyFromOther> {
//   // final TextEditingController _inputAmountController = TextEditingController();
//   String? _selectedMethodId;
//   List<MethodField>? _fieldList;
//   List<MethodField>? _gridFieldList;
//   Map<String?, TextEditingController> _textControllers =  {};
//   Map<String?, TextEditingController> _gridTextController =  {};
//   final FocusNode _inputAmountFocusNode = FocusNode();

//   void setFocus() {
//     _inputAmountFocusNode.requestFocus();
//     Get.back();
//   }

//   @override
//   void initState() {
//     super.initState();
//     // if(widget.transactionType == TransactionType.withdrawRequest) {
//     //   Get.find<TransactionMoneyController>().getWithdrawMethods();
//     // }
//     Get.find<AddMoneyController>().setPaymentMethod(null, isUpdate: false);
//   }
 
//   @override
//   Widget build(BuildContext context) {
//     final ProfileController profileController = Get.find<ProfileController>();
//     final SplashController splashController = Get.find<SplashController>();
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//           appBar: CustomAppbarWidget(title: widget.transactionType!.tr),

//           body: GetBuilder<TransactionMoneyController>(
//               builder: (transactionMoneyController) {
//                 if(widget.transactionType == TransactionType.withdrawRequest &&
//                     transactionMoneyController.withdrawModel == null) {
//                   return CustomLoaderWidget(color: Theme.of(context).primaryColor);
//                 }
//                 return SingleChildScrollView(
//                   physics: BouncingScrollPhysics(),
//                   child: Column(
//                       children: [
//                         Container(
//                           color: Colors.grey.shade200,
//                           padding: EdgeInsets.symmetric(horizontal: 20 , vertical: 20),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("Carte à créditer" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold),),
//                               Row(
//                                 children: [
//                                   Container(
//                                     height: 85,
//                                     child: Image.asset(Images.logo),
//                                     decoration: BoxDecoration(
//                                           color:Colors.black,
//                                           borderRadius: BorderRadius.circular(30),
//                                         ),
//                                    ),
//                                    SizedBox(width: 10,) ,
//                                    Container(
//                                     child: Column(
//                                      crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text("La carte buudi" ,style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500)),
//                                         Text( profileController.userInfo!.phone!,style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500)),
//                                         Text( "solde : ${PriceConverterHelper.balanceWithSymbol(balance: profileController.userInfo!.balance.toString())}",
//                                         style: TextStyle(color: Colors.green , fontWeight: FontWeight.bold)),
//                                       ],
//                                     ),
//                                    )
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                         Container(
//                           child: Column(
//                             children: [
//                               Container(
//                                 padding: EdgeInsets.symmetric(vertical: 15),
//                                 child: Text("Compte à débiter" ,style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 18),),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: 20 , horizontal: 25),
//                                 child: Container(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text("Côte d'Ivoire",style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 15),),
//                                       Container(
//                                         child: Column(
//                                           children: [
//                                            Padding(
//                                             padding: EdgeInsets.symmetric(vertical: 10),
//                                             child: Container(
//                                                     decoration: BoxDecoration(
//                                                       color: Colors.grey.shade300,
//                                                       borderRadius: BorderRadius.circular(5)
//                                                     ),
//                                                     child: Padding(
//                                                       padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 10),
//                                                       child: Row(
//                                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                         children: [
//                                                           Row(
//                                                             children: [
//                                                               Container(
//                                                                 height: 45,
//                                                                 child: Image.asset(Images.orangelogo),
//                                                               ),
//                                                               SizedBox(width:10),
//                                                               Container(
//                                                                 child: Text("ORANGE" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 15) ),
//                                                               )
//                                                             ],
//                                                           ),
//                                                           Container(
//                                                             child: GestureDetector(
//                                                               onTap: () {
//                                                                   // double amount = double.parse(_inputAmountController.text);
//                                                                   // _confirmationRoute(amount);
//                                                               },
//                                                               child: Icon(Icons.near_me),
//                                                             ),
//                                                           )
//                                                         ],
//                                                       ),
//                                                     )
//                                             ),
//                                            ),
                                            
//                                           ],
//                                         ),
//                                       ),
//                                       Container(
//                                         child: Column(
//                                           children: [
//                                            Padding(
//                                             padding: EdgeInsets.symmetric(vertical: 10),
//                                             child: Container(
//                                                     decoration: BoxDecoration(
//                                                       color: Colors.grey.shade300,
//                                                       borderRadius: BorderRadius.circular(5)
//                                                     ),
//                                                     child: Padding(
//                                                       padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 10),
//                                                       child: Row(
//                                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                         children: [
//                                                           Row(
//                                                             children: [
//                                                               Container(
//                                                                 height: 45,
//                                                                 child: Image.asset(Images.moovlogo),
//                                                               ),
//                                                               SizedBox(width:10),
//                                                               Container(
//                                                                 child: Text("MOOV" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 15) ),
//                                                               )
//                                                             ],
//                                                           ),
//                                                           Container(
//                                                             child: GestureDetector(
//                                                               onTap: () {
//                                                                   // double amount = double.parse(_inputAmountController.text);
//                                                                   // _confirmationRoute(amount);
//                                                               },
//                                                               child: Icon(Icons.near_me),
//                                                             ),
//                                                           )
//                                                         ],
//                                                       ),
//                                                     )
//                                             ),
//                                            ),
                                            
//                                           ],
//                                         ),
//                                       ),
//                                       Container(
//                                         child: Column(
//                                           children: [
//                                            Padding(
//                                             padding: EdgeInsets.symmetric(vertical: 10),
//                                             child: Container(
//                                                     decoration: BoxDecoration(
//                                                       color: Colors.grey.shade300,
//                                                       borderRadius: BorderRadius.circular(5)
//                                                     ),
//                                                     child: Padding(
//                                                       padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 10),
//                                                       child: Row(
//                                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                         children: [
//                                                           Row(
//                                                             children: [
//                                                               Container(
//                                                                 height: 45,
//                                                                 child: Image.asset(Images.mtnlogo),
//                                                               ),
//                                                               SizedBox(width:10),
//                                                               Container(
//                                                                 child: Text("MTN" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 15) ),
//                                                               )
//                                                             ],
//                                                           ),
//                                                           Container(
//                                                             child: GestureDetector(
//                                                               onTap: () {
//                                                                   // double amount = double.parse(_inputAmountController.text);
//                                                                   // _confirmationRoute(amount);
//                                                               },
//                                                               child: Icon(Icons.near_me),
//                                                             ),
//                                                           )
//                                                         ],
//                                                       ),
//                                                     )
//                                             ),
//                                            ),
                                            
//                                           ],
//                                         ),
//                                       ),
//                                       Container(
//                                         child: Column(
//                                           children: [
//                                            Padding(
//                                             padding: EdgeInsets.symmetric(vertical: 10),
//                                             child: Container(
//                                                     decoration: BoxDecoration(
//                                                       color: Colors.grey.shade300,
//                                                       borderRadius: BorderRadius.circular(5)
//                                                     ),
//                                                     child: Padding(
//                                                       padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 10),
//                                                       child: Row(
//                                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                         children: [
//                                                           Row(
//                                                             children: [
//                                                               Container(
//                                                                 height: 45,
//                                                                 child: Image.asset(Images.wavelogo),
//                                                               ),
//                                                               SizedBox(width:10),
//                                                               Container(
//                                                                 child: Text("WAVE" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500 , fontSize: 15) ),
//                                                               )
//                                                             ],
//                                                           ),
//                                                           Container(
//                                                             child: GestureDetector(
//                                                               onTap: () {
//                                                                   // double amount = double.parse(_inputAmountController.text);
//                                                                   // _confirmationRoute(amount);
//                                                                   Navigator.push(
//                                                                   context,
//                                                                   PageRouteBuilder(
//                                                                     pageBuilder: (context, animation, secondaryAnimation) => confirmTransaction(),
//                                                                   ),
//                                                                 );
//                                                               },
//                                                               child: Icon(Icons.near_me),
//                                                             ),
//                                                           )
//                                                         ],
//                                                       ),
//                                                     )
//                                             ),
//                                            ),
                                            
//                                           ],
//                                         ),
//                                       )
                                
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(40),
//                               topRight: Radius.circular(40),
//                             ),
//                           ),
//                         )
//                       ],
//                   ),
//                 );
//                   }
//           )

//       ),
//     );
//   }

// void _confirmationRoute() {
//   final transactionMoneyController = Get.find<TransactionMoneyController>();
//   // double? amount = double.tryParse(_inputAmountController.text);

//   if (amount == null) {
//     showCustomSnackBarHelper("Veuillez entrer un montant valide.");
//     return;
//   }

//   if(widget.transactionType == TransactionType.addMoney){
//     Get.find<AddMoneyController>().addMoney(amount);
//   } else if(widget.transactionType == TransactionType.withdrawRequest) {
//     String? message;
//     WithdrawalMethod? withdrawMethod = transactionMoneyController.withdrawModel?.withdrawalMethods.
//     firstWhereOrNull((method) => _selectedMethodId == method.id.toString());

//     List<MethodField> list = [];
//     String? validationKey;

//     if(withdrawMethod != null) {
//       for (var method in withdrawMethod.methodFields) {
//         if(method.inputType == 'email') {
//           validationKey  = method.inputName;
//         }
//         if(method.inputType == 'date') {
//           validationKey  = method.inputName;
//         }
//       }
//     } else {
//       message = 'please_select_a_method'.tr;
//     }

//     _textControllers.forEach((key, textController) {
//       list.add(MethodField(
//         inputName: key, inputType: null,
//         inputValue: textController.text,
//         placeHolder: null,
//       ));

//       if((validationKey == key) && EmailCheckerHelper.isNotValid(textController.text)) {
//         message = 'please_provide_valid_email'.tr;
//       } else if((validationKey == key) && textController.text.contains('-')) {
//         message = 'please_provide_valid_date'.tr;
//       }

//       if(textController.text.isEmpty && message == null) {
//         message = 'please fill ${key!.replaceAll('_', ' ')} field';
//       }
//     });

//     _gridTextController.forEach((key, textController) {
//       list.add(MethodField(
//         inputName: key, inputType: null,
//         inputValue: textController.text,
//         placeHolder: null,
//       ));

//       if((validationKey == key) && textController.text.contains('-')) {
//         message = 'please_provide_valid_date'.tr;
//       }
//     });

//     if(message != null) {
//       showCustomSnackBarHelper(message);
//       message = null;

//     } else {
//       Get.to(() => TransactionConfirmationScreen(
//         inputBalance: amount,
//         transactionType: TransactionType.withdrawRequest,
//         contactModel: null,
//         withdrawMethod: WithdrawalMethod(
//           methodFields: list,
//           methodName: withdrawMethod!.methodName,
//           id: withdrawMethod.id,
//         ),
//         callBack: setFocus,
//       ));
//     }

//   } else {
//     Get.to(()=> TransactionConfirmationScreen(
//       inputBalance: amount,
//       transactionType: widget.transactionType,
//       purpose:  widget.transactionType == TransactionType.sendMoney ?
//       transactionMoneyController.purposeList != null && transactionMoneyController.purposeList!.isNotEmpty
//           ? transactionMoneyController.purposeList![transactionMoneyController.selectedItem].title
//           : PurposeModel().title
//           : TransactionType.requestMoney.tr,

//       contactModel: widget.contactModel,
//       callBack: setFocus,
//     ));
//   }
// }


//   }

