import 'dart:io';

import 'package:afs_test/utils/constants.dart';
import 'package:afs_test/utils/navigators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';



class CBackButton extends StatelessWidget {
  final bool darkButton;
  final VoidCallback? onTap;

  const CBackButton({Key? key, this.darkButton = false, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
      splashColor: kTransparent,
      splashRadius: 20,
      highlightColor: darkButton ? kGreyLight : kGreyLight.withOpacity(0.5),
      style: ButtonStyle(
        splashFactory: NoSplash.splashFactory,
        overlayColor: MaterialStateProperty.all<Color>(
            darkButton ? kGreyLight : kGreyLight.withOpacity(0.3)),
      ),
      color: darkButton ? kPrimaryWhite : kTextGreyDark,
      onPressed: onTap ??
          () {
            if (canPopPage()) {
              Navigator.pop(context);
            }
          },
    );
  }
}

class LargeButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool whiteButton;
  final Color? color, borderColor, textColor;
  final Widget? body;
  final double? height, fontSize, borderRadius;

  const LargeButton({
    Key? key,
    required this.title,
    this.onPressed,
    this.whiteButton = false,
    this.body,
    this.height,
    this.color,
    this.fontSize,
    this.borderRadius,
    this.borderColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    bool isActive = onPressed != null;
    Color buttonColor = whiteButton ? kPrimaryWhite : color ?? kPrimaryColor;
    Color _textColor = whiteButton ? kTextGreyMedium : kPrimaryWhite;

    return SizedBox(
      width: double.infinity,
      height: height ?? 50,
      child: FilledButton(
        style: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          backgroundColor: MaterialStateProperty.all<Color>(
              isActive ? buttonColor : kInactiveColor),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: kBoxRadius(borderRadius ?? 10),
              side: BorderSide(color: borderColor ?? buttonColor),
            ),
          ),
          overlayColor: MaterialStateProperty.all<Color>(
            kGreyLight.withOpacity(0.3),
          ),
        ),
        onPressed: () {
          FocusScope.of(context).unfocus();
          if (onPressed != null) onPressed!();
        },
        child: body ??
            SizedBox(
              height: 45,
              child: Center(
                child: Text(
                  title,
                  style: textTheme.bodySmall?.copyWith(
                    color: textColor ?? _textColor,
                    fontSize: fontSize ?? 16,
                  ),
                ),
              ),
            ),
      ),
    );
  }
}


class LargeLoadingButton extends StatelessWidget {
  final bool whiteButton, outlineButton;
  final String? title;

  const LargeLoadingButton(
      {Key? key,
      this.outlineButton = false,
      this.whiteButton = false,
      this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return LargeButton(
      title: "",
      onPressed: () {},
      color: kPrimaryColor.withOpacity(0.8),
      body: title != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title ?? "",
                  style: textTheme.bodyMedium?.copyWith(
                    color: whiteButton ? kPrimaryColor : kPrimaryWhite,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 15),
                SpinKitThreeBounce(
                  color: whiteButton ? kPrimaryColor : kPrimaryWhite,
                  size: 20,
                ),
              ],
            )
          : SpinKitThreeBounce(
              color: whiteButton ? kPrimaryColor : kPrimaryWhite,
              size: 20,
            ),
    );
  }
}

class CInkWell extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;
  final Color? highlightColor;

  const CInkWell(
      {Key? key,
      required this.onTap,
      required this.child,
      this.highlightColor = kGreyMedium})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: kTransparent,
      highlightColor: highlightColor?.withOpacity(0.2),
      borderRadius: kBoxRadius(50),
      onTap: onTap,
      child: child,
    );
  }
}
