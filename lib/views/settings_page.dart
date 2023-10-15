import 'package:flutter/material.dart';
import 'package:mosfet/components/tile.dart';
import 'package:mosfet/config/navigator.dart';
import 'package:mosfet/config/provider_manager.dart';
import 'package:mosfet/config/public.dart';
import 'package:mosfet/views/home_page.dart';
import 'package:provider/provider.dart';


class SettingsPage extends StatefulWidget {
	const SettingsPage({super.key});

	@override
	State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

	Future<void> loadValues() async {
		/* Load settings from database */
		setState(() { dMode; });
	}

	@override
	void initState() {
		loadValues();
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		return WillPopScope(
			onWillPop: () async {
				return false;
			},
			child: Scaffold(
				appBar: AppBar(
					automaticallyImplyLeading: false,
					title: const Text("Settings"),
					leading: IconButton(
						icon: const Icon(Icons.arrow_back),
						onPressed: () => changeView(context, const HomePage()),
					),
				),
				body: ListView(
					children: [
						SwitchTile(
							title: const Text("Dark Mode"),
							icon: const Icon(Icons.dark_mode),
							value: dMode,
							onChange: (bool value){
								setState(() {dMode = value;});
								Provider.of<ProviderManager>(context, listen: false).changeTheme(
									dMode ? ThemeMode.dark : ThemeMode.light);
								// Update on database
							}
						),
					],
				),
			),
		);
	}
}
