import 'package:flutter/material.dart';

ThemeData lightThemeMode(){
	return ThemeData(
		useMaterial3: true,
		fontFamily: "TitilliumWebRegular",
		colorScheme: ColorScheme.fromSeed(
			seedColor: Colors.black,
			brightness: Brightness.light
		)
	);
}