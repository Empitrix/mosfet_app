import 'package:flutter/material.dart';
import 'package:mosfet/theme/dark.dart';
import 'package:mosfet/theme/light.dart';


class ProviderManager extends ChangeNotifier {
	ThemeMode themeMode = ThemeMode.system;

	ThemeData lightTheme = lightThemeMode();
	ThemeData darkTheme = darkThemeMode();

	void changeTheme(ThemeMode newTheme){
		themeMode = newTheme;
		notifyListeners();
	}


}