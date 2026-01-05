// import 'package:flutter/material.dart';
// import 'package:get/get_state_manager/src/simple/get_state.dart';
// import 'package:six_cash/features/home/controllers/menu_controller.dart';
// import 'package:six_cash/util/color_resources.dart';
// import 'package:six_cash/util/dimensions.dart';

// class BottomItemWidget extends StatelessWidget {

//   final dynamic icon; // Change le type ici pour accepter à la fois IconData et String
//   final String name;
//   final int? selectIndex;
//   final VoidCallback? onTop;
//   const BottomItemWidget({Key? key, required this.icon, required this.name, this.selectIndex, this.onTop ,}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(onTap: onTop, child: GetBuilder<MenuItemController>(
//         builder: (menuItemController) {
//           return Column(mainAxisSize: MainAxisSize.min, children: [
//             SizedBox(
//               height: 20,
//               width: Dimensions.fontSizeExtraLarge,
//               child: Image.asset(
//                 icon, fit: BoxFit.contain,
//                 color: menuItemController.currentTabIndex == selectIndex
//                     ? Theme.of(context).textTheme.titleLarge?.color : ColorResources.nevDefaultColor,
//               ),
//             ),
//             const SizedBox(height: 6.0),

//             Text(name, style: TextStyle(
//               color: menuItemController.currentTabIndex == selectIndex
//                   ? Theme.of(context).textTheme.titleLarge?.color : ColorResources.nevDefaultColor,
//               fontSize: Dimensions.fontSizeSmall, fontWeight: FontWeight.w400,
//             ))

//           ]);
//         }
//     ));
//   }
// }




import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:six_cash/features/home/controllers/menu_controller.dart';
import 'package:six_cash/util/color_resources.dart';
import 'package:six_cash/util/dimensions.dart';

class BottomItemWidget extends StatelessWidget {
  final dynamic icon; // Peut être String ou IconData
  final String name;
  final int? selectIndex;
  final VoidCallback? onTop;
  final double? iconSize;

  const BottomItemWidget({
    Key? key,
    required this.icon,
    required this.name,
    this.selectIndex,
    this.onTop,
    this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTop,
      child: GetBuilder<MenuItemController>(
        builder: (menuItemController) {
          bool isSelected = menuItemController.currentTabIndex == selectIndex;
          Color? iconColor = isSelected
              ? Theme.of(context).textTheme.titleLarge?.color
              : ColorResources.nevDefaultColor;
          Widget iconWidget;

          if (icon is IconData) {
            iconWidget = Icon(icon, color: iconColor ,size: iconSize,);
          } else if (icon is String) {
            iconWidget = Image.asset(
              icon,
              fit: BoxFit.contain,
              color: iconColor,
            );
          } else {
            throw ArgumentError("icon must be either IconData or String");
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
                width: Dimensions.fontSizeExtraLarge,
                child: iconWidget,
              ),
              const SizedBox(height: 6.0),
              Text(
                name,
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).textTheme.titleLarge?.color
                      : ColorResources.nevDefaultColor,
                  fontSize: Dimensions.fontSizeSmall,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
