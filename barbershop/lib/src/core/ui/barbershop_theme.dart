import 'package:barbershop/src/core/ui/constants.dart';
import 'package:flutter/material.dart';

sealed class BarbershopTheme {
  static const _defaultInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(8),
    ),
    borderSide: BorderSide(
      color: ColorsConstants.grey,
    ),
  );
  static ThemeData themeData = ThemeData(
    appBarTheme: const AppBarTheme(
        centerTitle: true,
        iconTheme: IconThemeData(color: ColorsConstants.brown),
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 18,
          color: Colors.black,
          fontFamily: FontConstants.fontFamily,
        )),
    useMaterial3: true,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(
        color: ColorsConstants.grey,
      ),
      border: _defaultInputBorder,
      errorBorder: _defaultInputBorder.copyWith(
        borderSide: const BorderSide(
          color: ColorsConstants.red,
        ),
      ),
      enabledBorder: _defaultInputBorder,
      focusedBorder: _defaultInputBorder,
      disabledBorder: _defaultInputBorder,
      focusedErrorBorder: _defaultInputBorder.copyWith(
        borderSide: const BorderSide(
          color: ColorsConstants.red,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsConstants.brown,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ColorsConstants.brown,
        side: const BorderSide(
          color: ColorsConstants.brown,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    fontFamily: FontConstants.fontFamily,
  );
}
