// import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:six_cash/features/transaction_money/widgets/input_box_widget.dart';
import 'package:six_cash/features/transaction_money/widgets/purpose_widget.dart';
import 'package:six_cash/features/transaction_money/widgets/custum_phone_input.dart';

import '../widgets/field_item_widget.dart';
import '../widgets/for_person_widget.dart';
import '../widgets/next_button_widget.dart';


class retraitInter extends StatefulWidget {
  final String imagePath;
  final double percentage; 
  final int indicatif ;
   retraitInter({Key? key ,required this.imagePath, required this.percentage , required this.indicatif}) : super(key: key) ;

  @override
  State<retraitInter> createState() => _retraitInterState();

}

class _retraitInterState extends State<retraitInter> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
 

  double _fees = 0.0;
  double _totalAmount = 0.0;
   

  void _calculateFees(String value) {
    setState(() {
      if (value.isNotEmpty) {
        double amount = double.tryParse(value) ?? 0.0;
        _fees = amount * widget.percentage;
        _totalAmount = amount - _fees;
      } else {
        _fees = 0.0;
        _totalAmount = 0.0;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false, // mettez cette propriété à false pour éviter les overflow
        appBar: CustomAppbarWidget(title:"RETRAIT"),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20 ,horizontal:20),
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  height: 80,
                                  child: Image.asset(widget.imagePath),
                                ),
                                 Padding(
                                  padding: EdgeInsets.symmetric( horizontal: 30 , vertical: 20),
                                    child: Container(
                                    padding: EdgeInsets.symmetric( horizontal: 10 , vertical: 10),
                                    color: Colors.grey.shade200,
                                    child: Text("Assurez vous que le numéro de l'expéditeur est correct. En cas de transfert erroné , BUUDI ne saurait garantir le retour de vos fonds",
                                    style: TextStyle(fontSize: 13 , fontWeight: FontWeight.w700),
                                    ) ,
                                   ),
                                ),
                                Container(
                                  child: CustomPhoneinput(
                                    hintText: 'Entrez votre numero de telephone',
                                    prefixIcon: Icon(Icons.phone),
                                    controller: _phoneController,
                                    prefixText:'+' + widget.indicatif.toString(),
                                  ),
                                ) , 
                                 Container(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 40),
                                    child: TextField(
                                          onChanged: _calculateFees,
                                          controller: _amountController,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(8),
                                            FilteringTextInputFormatter.digitsOnly
                                          ],
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold),
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                                            enabledBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.orange),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            // filled: true,
                                            // fillColor: Colors.white,
                                            hintText: 'Entrez le montant',
                                            hintStyle: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[400],
                                            ),
                                                suffixText: 'FCFA ',
                                                suffixStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                  ),
                                ),
                              
                              ],
                            ),
                          ),
                        )
                        ),
                ),
              Container(
                child: Column(
                  children: [
                      Divider(
                        color: Colors.grey.shade400,
                        thickness: 1,
                      ),
                      Text("Frais : ${(widget.percentage * 100).toStringAsFixed(0)}%" , style: TextStyle(fontWeight:FontWeight.bold),)
                  ],
                ),
              ) , 
               
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal:12),
                   child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10 , vertical: 20) ,
                     child: Column(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                   Text(
                                    "Frais d'opération",
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${_fees.toStringAsFixed(2)} FCFA",
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ), 
                               Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Montant à recevoir",
                                    style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${_totalAmount.toStringAsFixed(2)} FCFA",
                                    style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                        padding: EdgeInsets.symmetric(horizontal: 70 , vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text("confirmer"),
                        ),
                      ],
                     ),
                    ),
                 ),
              ],
            ),
          ),
        )
      ),
    );
  }
}

// class confirmTransaction extends StatefulWidget {
//   final String? transactionType;
//   final ContactModel? contactModel;
//   final String? countryCode;
//    const confirmTransaction({Key? key, this.transactionType ,this.contactModel, this.countryCode}) : super(key: key);
//   @override
//   State<confirmTransaction> createState() => _TransactionBalanceInputScreenState();
// }

// class _TransactionBalanceInputScreenState extends State<confirmTransaction> {
//   final TextEditingController _inputAmountController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();

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
//     if(widget.transactionType == TransactionType.withdrawRequest) {
//       Get.find<TransactionMoneyController>().getWithdrawMethods();
//     }
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
//                 return (
//                   SingleChildScrollView(
//                   physics: BouncingScrollPhysics(),
//                   child: Container(
//                     child: Column(
//                       children: [
//                         Container(
//                           height: 100,
//                           child: Image.asset(Images.orangelogo),
//                         ),
//                         Container(
//                           child: CustomPhoneinput(
//                              hintText: 'entrez votre numero de telephone',
//                             prefixIcon: Icon(Icons.phone),
//                             controller: _phoneController,
//                           ),
//                         )
//                       ],
//                     ),
//                   )
//                   )
//                 );
//               }
//           ),

//           floatingActionButton: GetBuilder<TransactionMoneyController>(
//               builder: (transactionMoneyController) {
//                 return  FloatingActionButton(

//                   onPressed:() {
//                     double amount;
//                     if(_inputAmountController.text.isEmpty){
//                       showCustomSnackBarHelper('please_input_amount'.tr,isError: true);
//                     }else{
//                       String balance =  _inputAmountController.text;
//                       if(balance.contains('${splashController.configModel!.currencySymbol}')) {
//                         balance = balance.replaceAll('${splashController.configModel!.currencySymbol}', '');
//                       }
//                       if(balance.contains(',')){
//                         balance = balance.replaceAll(',', '');
//                       }
//                       if(balance.contains(' ')){
//                         balance = balance.replaceAll(' ', '');
//                       }
//                       amount = double.parse(balance);
//                       if(amount <= 0) {
//                         showCustomSnackBarHelper('transaction_amount_must_be'.tr,isError: true);
//                       }else {
//                         bool inSufficientBalance = false;
//                         bool isPaymentSelect = Get.find<AddMoneyController>().paymentMethod != null;

//                         final bool isCheck = widget.transactionType != TransactionType.requestMoney
//                             && widget.transactionType != TransactionType.addMoney;

//                         if(isCheck && widget.transactionType == TransactionType.sendMoney) {
//                           inSufficientBalance = PriceConverterHelper.balanceWithCharge(amount, splashController.configModel!.sendMoneyChargeFlat, false) > profileController.userInfo!.balance!;
//                         }else if(isCheck && widget.transactionType == TransactionType.cashOut) {
//                           inSufficientBalance = PriceConverterHelper.balanceWithCharge(amount, splashController.configModel!.cashOutChargePercent, true) > profileController.userInfo!.balance!;
//                         }else if(isCheck && widget.transactionType == TransactionType.withdrawRequest) {
//                           inSufficientBalance = PriceConverterHelper.balanceWithCharge(amount, splashController.configModel!.withdrawChargePercent, true) > profileController.userInfo!.balance!;
//                         }else if(isCheck){
//                           inSufficientBalance = amount > profileController.userInfo!.balance!;
//                         }


//                         if(inSufficientBalance) {
//                           showCustomSnackBarHelper('insufficient_balance'.tr, isError: true);
//                         }else if(widget.transactionType == TransactionType.addMoney && !isPaymentSelect){
//                           showCustomSnackBarHelper('please_select_a_payment'.tr, isError: true);
//                         } else {
//                          _confirmationRoute(amount);
//                         }
//                       }

//                     }
//                   },
//                   backgroundColor: Theme.of(context).secondaryHeaderColor,
//                   child: GetBuilder<AddMoneyController>(builder: (addMoneyController) {
//                     return addMoneyController.isLoading ||
//                         transactionMoneyController.isLoading
//                         ? const CircularProgressIndicator()
//                         : const NextButtonWidget(isSubmittable: true);
//                   }),
//                 );
//               }
//           )

//       ),
//     );
//   }


//   void _confirmationRoute(double amount) {
//     final transactionMoneyController = Get.find<TransactionMoneyController>();
//     if(widget.transactionType == TransactionType.addMoney){
//       Get.find<AddMoneyController>().addMoney(amount);
//     }
//     else if(widget.transactionType == TransactionType.withdrawRequest) {
//       String? message;
//       WithdrawalMethod? withdrawMethod = transactionMoneyController.withdrawModel!.withdrawalMethods.
//       firstWhereOrNull((method) => _selectedMethodId == method.id.toString());


//       List<MethodField> list = [];
//       String? validationKey;

//       if(withdrawMethod != null) {
//         for (var method in withdrawMethod.methodFields) {
//           if(method.inputType == 'email') {
//             validationKey  = method.inputName;
//           }
//           if(method.inputType == 'date') {
//             validationKey  = method.inputName;
//           }

//         }
//       }else{
//         message = 'please_select_a_method'.tr;
//       }


//       _textControllers.forEach((key, textController) {
//         list.add(MethodField(
//           inputName: key, inputType: null,
//           inputValue: textController.text,
//           placeHolder: null,
//         ));

//         if((validationKey == key) && EmailCheckerHelper.isNotValid(textController.text)) {
//           message = 'please_provide_valid_email'.tr;
//         }else if((validationKey == key) && textController.text.contains('-')) {
//           message = 'please_provide_valid_date'.tr;
//         }

//         if(textController.text.isEmpty && message == null) {
//           message = 'please fill ${key!.replaceAll('_', ' ')} field';
//         }
//       });

//       _gridTextController.forEach((key, textController) {
//         list.add(MethodField(
//           inputName: key, inputType: null,
//           inputValue: textController.text,
//           placeHolder: null,
//         ));

//         if((validationKey == key) && textController.text.contains('-')) {
//           message = 'please_provide_valid_date'.tr;
//         }
//       });

//       if(message != null) {
//         showCustomSnackBarHelper(message);
//         message = null;

//       }
//       else{


//         Get.to(() => TransactionConfirmationScreen(
//           inputBalance: amount,
//           transactionType: TransactionType.withdrawRequest,
//           contactModel: null,
//           withdrawMethod: WithdrawalMethod(
//             methodFields: list,
//             methodName: withdrawMethod!.methodName,
//             id: withdrawMethod.id,
//           ),
//           callBack: setFocus,
//         ));
//       }

//     }

//     else{
//       Get.to(()=> TransactionConfirmationScreen(
//         inputBalance: amount,
//         transactionType:widget.transactionType,
//         purpose:  widget.transactionType == TransactionType.sendMoney ?
//         transactionMoneyController.purposeList != null && transactionMoneyController.purposeList!.isNotEmpty
//             ? transactionMoneyController.purposeList![transactionMoneyController.selectedItem].title
//             : PurposeModel().title
//             : TransactionType.requestMoney.tr,

//         contactModel: widget.contactModel,
//         callBack: setFocus,

//       ));
//     }


//   }
// }




// Align(
//                           child: GestureDetector(
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.orangeAccent,
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
//                                 child: Text(
//                                   "confirmer",
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),