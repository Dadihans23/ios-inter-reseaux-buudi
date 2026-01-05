// import 'package:flutter/material.dart';
// import 'package:six_cash/features/transaction_money/screens/confirm_transaction.dart';


// class CustomCard extends StatelessWidget {
//   final String imagePath;
//   final String text;

//   const CustomCard({
//     Key? key,
//     required this.imagePath,
//     required this.text,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 10),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           height: 45,
//                           child: Image.asset(imagePath),
//                         ),
//                         SizedBox(width: 10),
//                         Container(
//                           child: Text(
//                             text,
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.w500,
//                               fontSize: 15,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Container(
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             PageRouteBuilder(
//                               pageBuilder: (context, animation, secondaryAnimation) =>
//                                   ConfirmTransaction(imagePath: imagePath),
//                             ),
//                           );
//                         },
//                         child: Icon(Icons.near_me),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
