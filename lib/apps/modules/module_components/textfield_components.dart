import 'package:afs_test/utils/constants.dart';
import 'package:afs_test/utils/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class TextInputWidget extends StatelessWidget {
  const TextInputWidget(
      {Key? key,
      this.enable,
      this.text,
      this.icon,
      this.errorText,
      this.height,
      this.prefixWidget,
      this.onSaved,
      this.onChanged,
      this.onEditingComplete,
      this.inputType,
      this.maxLines = 1,
      this.controller,
      this.inputFormatters,
      this.validator,
      this.autocorrect = false,
      this.enableSuggestions = true,
      this.contentPadding,
      this.fillColor,
      this.onTapField,
      this.hintText,
      this.obscure,
      this.border,
      this.textCapitalization = TextCapitalization.words,
      this.textAlign = TextAlign.left,
      this.autoValidateMode = AutovalidateMode.disabled,
      this.read = false,
      this.allowPaste = true,
      this.shadeOnRead = false,
      this.showCursor = true,
      this.autofocus = false,
      this.activeLabel = false,
      this.autoFillHints,
      this.inputAction,
      this.focusNode,
      this.textStyle,
      this.cursorColor,
      this.hintStyle,
      this.initialValue})
      : super(key: key);

  final String? text, initialValue;
  final bool? enable;
  final Widget? icon, prefixWidget;
  final bool? obscure;
  final bool read,
      shadeOnRead,
      autocorrect,
      enableSuggestions,
      showCursor,
      allowPaste,
      autofocus,
      activeLabel;
  final double? height;
  final int? maxLines;
  final String? hintText, errorText;
  final EdgeInsetsGeometry? contentPadding;
  final VoidCallback? onTapField;
  final Function(String?)? onSaved, onChanged;
  final TextAlign textAlign;
  final TextStyle? textStyle, hintStyle;
  final TextCapitalization textCapitalization;
  final VoidCallback? onEditingComplete;
  final TextInputType? inputType;
  final AutovalidateMode autoValidateMode;
  final TextEditingController? controller;
  final Color? fillColor, cursorColor;
  final FocusNode? focusNode;
  final InputBorder? border;
  final List<TextInputFormatter>? inputFormatters;
  final List<String>? autoFillHints;
  final TextInputAction? inputAction;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return SizedBox(
      // height: height ?? 48,
      child: TextFormField(
        enabled: enable,
        keyboardType: inputType,
        enableSuggestions: enableSuggestions,
        enableInteractiveSelection: allowPaste,
        readOnly: read,
        scrollPadding:
            EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        style: GoogleFonts.poppins(),
        obscureText: obscure == null ? false : obscure!,
        onSaved: onSaved,
        initialValue: initialValue,
        validator: validator,
        autofocus: autofocus,
        controller: controller,
        textAlign: textAlign,
        focusNode: focusNode,
        autocorrect: autocorrect,
        maxLines: maxLines,
        autofillHints: autoFillHints,
        textInputAction: inputAction,
        onTap: onTapField,
        showCursor: read ? false : showCursor,
        cursorHeight: 20,
        cursorColor: cursorColor ?? kPrimaryColor,
        textCapitalization: textCapitalization,
        autovalidateMode: autoValidateMode,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          contentPadding:
              contentPadding ?? const EdgeInsets.fromLTRB(15, 10, 5, 10),
          isDense: true,
          filled: true,
          floatingLabelBehavior: activeLabel
              ? FloatingLabelBehavior.always
              : FloatingLabelBehavior.auto,
          label: text != null ? Text(text!) : null,
          labelStyle: textTheme.titleMedium,
          prefixIcon: prefixWidget,
          hintText: hintText,
          hintStyle:
              hintStyle ?? textTheme.titleMedium?.copyWith(color: kGreyLight),
          suffixIcon: icon,
          errorText: errorText,
          errorStyle: textTheme.titleMedium?.copyWith(color: kTextRed),
          fillColor:
              read && shadeOnRead ? kGreyLight : fillColor ?? kTransparent,
          border: border ??
              OutlineInputBorder(
                borderSide: const BorderSide(color: kGreyLight),
                borderRadius: kBoxRadius(10),
              ),
          enabledBorder: border ??
              OutlineInputBorder(
                borderSide: const BorderSide(color: kGreyLight),
                borderRadius: kBoxRadius(10),
              ),
          focusedBorder: border ??
              OutlineInputBorder(
                borderSide: BorderSide(
                    color: read == true ? kGreyLight : kPrimaryColor),
                borderRadius: kBoxRadius(10),
              ),
          errorBorder: OutlineInputBorder(
            borderRadius: kBoxRadius(10),
            borderSide: const BorderSide(color: kTextRed),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: kBoxRadius(10),
            borderSide: const BorderSide(color: kTextRed),
          ),
        ),
      ),
    );
  }
}

class PhoneNumberInput extends StatelessWidget {
  final String code;
  final bool? enabled;
  final String? text, hintText, initialValue;
  final double? height;
  final bool requiredField,
      read,
      applyFilter,
      showCursor,
      autofocus,
      activeLabel,
      allowPaste,
      enableSuggestions;
  final Color? fillColor;
  final TextEditingController? controller;
  final Function(CountryCode)? onCodeChanged;
  final VoidCallback? onEditingComplete;
  final TextStyle? textStyle, hintStyle;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved, onChanged;
  final TextInputAction? inputAction;
  final List<String>? autoFillHints;
  final InputBorder? border;
  final Widget? icon;
  final EdgeInsetsGeometry? contentPadding;

  const PhoneNumberInput(
      {Key? key,
      this.text,
      this.enabled,
      required this.code,
      required this.onCodeChanged,
      this.height,
      this.requiredField = false,
      this.applyFilter = true,
      this.read = false,
      this.showCursor = true,
      this.autofocus = false,
      this.allowPaste = true,
      this.enableSuggestions = true,
      this.activeLabel = false,
      this.textStyle,
      this.validator,
      this.onSaved,
      this.controller,
      this.fillColor,
      this.onChanged,
      this.onEditingComplete,
      this.inputAction,
      this.autoFillHints,
      this.focusNode,
      this.hintText,
      this.icon,
      this.border,
      this.contentPadding,
      this.hintStyle,
      this.initialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: height ?? 48,
      child: TextFormField(
        enabled: enabled,
        readOnly: read,
        controller: controller,
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11),
        ],
        style: GoogleFonts.poppins(),
        onSaved: onSaved,
        initialValue: initialValue,
        validator: validator,
        enableSuggestions: enableSuggestions,
        focusNode: focusNode,
        textInputAction: inputAction,
        autofillHints: autoFillHints,
        showCursor: read ? false : showCursor,
        autofocus: autofocus,
        enableInteractiveSelection: allowPaste,
        onChanged: onChanged,
        autovalidateMode: AutovalidateMode.disabled,
        decoration: InputDecoration(
          suffixIcon: icon,
          isDense: true,
          filled: true,
          contentPadding:
              contentPadding ?? const EdgeInsets.fromLTRB(15, 10, 5, 10),
          label: text != null ? Text(text!) : null,
          labelStyle: GoogleFonts.poppins(),
          fillColor: read ? kGreyLight : fillColor ?? kTransparent,
          hintText: hintText ?? text,
          hintStyle: GoogleFonts.poppins(),
          errorStyle: GoogleFonts.poppins(color: kTextRed),
          floatingLabelBehavior: activeLabel
              ? FloatingLabelBehavior.always
              : FloatingLabelBehavior.auto,
          border: border ??
              OutlineInputBorder(
                borderSide: const BorderSide(color: kGreyLight),
                borderRadius: kBoxRadius(10),
              ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kGreyLight),
            borderRadius: kBoxRadius(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: read == true ? kGreyLight : kPrimaryColor),
            borderRadius: kBoxRadius(10),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: kBoxRadius(10),
            borderSide: const BorderSide(color: kTextRed),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: kBoxRadius(10),
            borderSide: const BorderSide(color: kTextRed),
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.only(left: 10),
            child: CountryCodePicker(
              enabled: !read,
              padding: EdgeInsets.zero,
              onChanged: onCodeChanged,
              textStyle: GoogleFonts.poppins(),
              builder: (code) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 30,
                      width: 40,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            code!.flagUri!,
                            package: 'country_code_picker',
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    xBox(10),
                    Text(
                      code.dialCode!,
                      style: GoogleFonts.poppins(),
                    )
                  ],
                );
              },
              showFlagMain: true,
              dialogTextStyle: GoogleFonts.poppins(),
              initialSelection: "+233",
              countryFilter: applyFilter ? countrySelectFilter : null,
              showCountryOnly: false,
              showDropDownButton: false,
              showOnlyCountryWhenClosed: false,
              showFlagDialog: true,
              showFlag: true,
              alignLeft: true,
            ),
          ),
        ),
      ),
    );
  }
}
