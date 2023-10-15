import 'package:flutter/material.dart';

ThemeData darkThemeMode(){
	return ThemeData(
		useMaterial3: true,
		fontFamily: "TitilliumWebRegular",
		colorScheme: ColorScheme.fromSeed(
			seedColor: Colors.white,
			brightness: Brightness.dark
		)
	);
}