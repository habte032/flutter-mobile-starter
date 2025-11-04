import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boilerplate/config/theme/app_colors.dart';
import 'package:flutter_boilerplate/core/utils/constants/asset_constants/icons_constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_boilerplate/core/utils/constants/ui_constants.dart';
import 'package:toastification/toastification.dart';

Future<void> outlog(Object data, {String? title = ""}) async {
  // if (kDebugMode) {
  // log("$title $data");
  // print("$title $data");
  // }
}

void toast(
  BuildContext context,
  String title,
  String message, {
  ToastificationType type = ToastificationType.info,
  Color? color,
}) {
  toastification.showCustom(
    context: context,
    autoCloseDuration: const Duration(seconds: 3),
    builder: (context, item) {
      return GestureDetector(
        onHorizontalDragEnd: (e) {
          toastification.dismiss(item);
        },
        child: Container(
          alignment: item.alignment,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: color ?? AppColors.grey,
          ),
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Builder(
                builder: (context) {
                  final theme = Theme.of(context);
                  Color iconColor;
                  if (type == ToastificationType.error) {
                    iconColor = theme.colorScheme.error;
                  } else if (type == ToastificationType.warning) {
                    iconColor = theme.colorScheme.secondary;
                  } else {
                    iconColor = theme.colorScheme.tertiary;
                  }
                  return SvgPicture.asset(
                    type == ToastificationType.success
                        ? IconsConstants.checkMarkIcon
                        : IconsConstants.notificationIcon,
                    height: 24,
                    color: iconColor,
                  );
                },
              ),
              kHorizontalGap10,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title.isNotEmpty)
                      Builder(
                        builder: (context) {
                          final theme = Theme.of(context);
                          Color titleColor;
                          if (type == ToastificationType.error) {
                            titleColor = theme.colorScheme.error;
                          } else if (type == ToastificationType.warning) {
                            titleColor = theme.colorScheme.secondary;
                          } else {
                            titleColor = theme.colorScheme.tertiary;
                          }
                          return Text(
                            title,
                            style: theme.textTheme.labelMedium!.copyWith(
                              color: titleColor,
                            ),
                          );
                        },
                      ),
                    Text(message, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
  // toastification.show(
  //     context: router.routerDelegate.navigatorKey.currentContext!,
  //     title: Text(title),
  //     description: Text(message),
  //     backgroundColor: color,
  //     foregroundColor: color,
  //     primaryColor: type == ToastificationType.error
  //         ? Colors.redAccent
  //         : type == ToastificationType.warning
  //             ? Colors.orangeAccent
  //             : Colors.greenAccent,
  //     icon: SvgPicture.asset(
  //       IconsConstants.mobileIcon,
  //     ),
  //     autoCloseDuration: Duration(seconds: 3),
  //     style: ToastificationStyle.fillColored,
  //     type: type,
  //     closeButtonShowType: CloseButtonShowType.none,
  //     showProgressBar: false);
}

StreamTransformer<Uint8List, List<int>> unit8Transformer =
    StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        sink.add(List<int>.from(data));
      },
    );
