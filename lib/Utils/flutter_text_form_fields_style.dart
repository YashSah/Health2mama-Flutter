import 'package:flutter/material.dart';

import 'flutter_colour_theams.dart';

import 'package:flutter/material.dart';

import 'constant.dart';
import 'flutter_colour_theams.dart';
import 'flutter_font_style.dart';

class TextFormFieldStyle {

  static InputDecoration defaultemailInputDecoration(String displayType) {
    return InputDecoration(
      enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.editTextBorderColorenabled,
          )),
      disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.editTextBorderColorenabled,
          )),
      focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.editTextBorderColorfocused,
          )),
      errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.errorColor,
          )),
      focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.errorColor,
          )),
      hintText: Constants.loginEmailFieldHintText,
      hintStyle: (displayType == 'desktop' || displayType == 'tablet')
          ? FTextStyle.loginFieldHintTextStyleTablet
          : FTextStyle.loginFieldHintTextStyle,
      errorStyle: (displayType == 'desktop' || displayType == 'tablet')
          ? FTextStyle.formFieldErrorTxtStyleTablet
          : FTextStyle.formFieldErrorTxtStyle,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    );
  }

  static InputDecoration otherworkTextField(String displayType) {
    return InputDecoration(
      enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.editTextBorderColorenabled,
          )),
      disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.editTextBorderColorenabled,
          )),
      focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.editTextBorderColorfocused,
          )),
      errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.errorColor,
          )),
      focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.errorColor,
          )),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    );
  }

  static InputDecoration defaultpasswordInputDecoration(String displayType) {
    return InputDecoration(
      enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.editTextBorderColorenabled,
          )),
      disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.editTextBorderColorenabled,
          )),
      focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.editTextBorderColorfocused,
          )),
      errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.errorColor,
          )),
      focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.errorColor,
          )),

      hintText: Constants.loginPasswordFieldHintText,
      hintStyle: (displayType == 'desktop' || displayType == 'tablet')
          ? FTextStyle.loginFieldHintTextStyleTablet
          : FTextStyle.loginFieldHintTextStyle,
      errorStyle: (displayType == 'desktop' || displayType == 'tablet')
          ? FTextStyle.formFieldErrorTxtStyleTablet
          : FTextStyle.formFieldErrorTxtStyle,

      // contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    );
  }

  static const InputDecoration defaultotpInputDecoration = InputDecoration(
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        borderSide: BorderSide(
          color: AppColors.editTextBorderColorenabled,
        )),
    disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        borderSide: BorderSide(
          color: AppColors.editTextBorderColorenabled,
        )),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        borderSide: BorderSide(
          color: AppColors.editTextBorderColorfocused,
        )),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        borderSide: BorderSide(
          color: AppColors.errorColor,
        )),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        borderSide: BorderSide(
          color: AppColors.errorColor,
        )),
  );

  static InputDecoration defaultnameInputDecoration(String displayType) {
    return InputDecoration(
      enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.editTextBorderColorenabled,
          )),
      disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.editTextBorderColorenabled,
          )),
      focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.editTextBorderColorfocused,
          )),
      errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.errorColor,
          )),
      focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.errorColor,
          )),
      hintStyle: (displayType == 'desktop' || displayType == 'tablet')
          ? FTextStyle.loginFieldHintTextStyleTablet
          : FTextStyle.loginFieldHintTextStyle,
      errorStyle: (displayType == 'desktop' || displayType == 'tablet')
          ? FTextStyle.formFieldErrorTxtStyleTablet
          : FTextStyle.formFieldErrorTxtStyle,
      hintText: Constants.createAccountnameHintText,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    );
  }

  static InputDecoration hindCode(String displayType) {
    return InputDecoration(
      enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.editTextBorderColorenabled,
          )),
      disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.editTextBorderColorenabled,
          )),
      focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.editTextBorderColorfocused,
          )),
      errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.errorColor,
          )),
      focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.errorColor,
          )),
      hintText: "Enter code",
      hintStyle: (displayType == 'desktop' || displayType == 'tablet')
          ? FTextStyle.loginFieldHintTextStyleTablet
          : FTextStyle.loginFieldHintTextStyle,
      errorStyle: (displayType == 'desktop' || displayType == 'tablet')
          ? FTextStyle.formFieldErrorTxtStyleTablet
          : FTextStyle.formFieldErrorTxtStyle,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    );
  }

  static InputDecoration defaultcountryInputDecoration(String displayType) {
    return InputDecoration(
      enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.editTextBorderColorenabled,
          )),
      disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.editTextBorderColorenabled,
          )),
      focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.editTextBorderColorfocused,
          )),
      errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.errorColor,
          )),
      focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: AppColors.errorColor,
          )),
      hintText: Constants.createAccountcountryHintText,
      hintStyle: (displayType == 'desktop' || displayType == 'tablet')
          ? FTextStyle.loginFieldHintTextStyleTablet
          : FTextStyle.loginFieldHintTextStyle,
      errorStyle: (displayType == 'desktop' || displayType == 'tablet')
          ? FTextStyle.formFieldErrorTxtStyleTablet
          : FTextStyle.formFieldErrorTxtStyle,
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    );
  }

    static InputDecoration defaultphoneInputDecoration(String displayType) {
      return InputDecoration(
        enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            borderSide: BorderSide(
              color: AppColors.editTextBorderColorenabled,
            )),
        disabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            borderSide: BorderSide(
              color: AppColors.editTextBorderColorenabled,
            )),
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            borderSide: BorderSide(
              color: AppColors.editTextBorderColorfocused,
            )),
        errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            borderSide: BorderSide(
              color: AppColors.errorColor,
            )),
        focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            borderSide: BorderSide(
              color: AppColors.errorColor,
            )),
        hintText: Constants.createAccountphoneHintText,
        hintStyle: (displayType == 'desktop' || displayType == 'tablet')
            ? FTextStyle.loginFieldHintTextStyleTablet
            : FTextStyle.loginFieldHintTextStyle,
        errorStyle: (displayType == 'desktop' || displayType == 'tablet')
            ? FTextStyle.formFieldErrorTxtStyleTablet
            : FTextStyle.formFieldErrorTxtStyle,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      );
    }
  }

