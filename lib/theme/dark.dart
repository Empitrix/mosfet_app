import 'package:flutter/material.dart';

ThemeData darkThemeMode(){
	return ThemeData(
		colorScheme: ColorScheme.fromSeed(
			seedColor: Colors.white,
			brightness: Brightness.dark
		)
	);
}