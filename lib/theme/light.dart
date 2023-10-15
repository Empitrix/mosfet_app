import 'package:flutter/material.dart';

ThemeData lightThemeMode(){
	return ThemeData(
		colorScheme: ColorScheme.fromSeed(
			seedColor: Colors.black,
			brightness: Brightness.light
		)
	);
}