import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mosfet/components/alerts.dart';
import 'package:mosfet/components/tile.dart';
import 'package:mosfet/config/navigator.dart';
import 'package:mosfet/config/provider_manager.dart';
import 'package:mosfet/config/public.dart';
import 'package:mosfet/database/database.dart';
import 'package:mosfet/views/home_page.dart';
import 'package:provider/provider.dart';


class SettingsPage extends StatefulWidget {
	const SettingsPage({super.key});

	@override
	State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

	Database database = Database();

	Future<void> loadValues() async {
		/* Load settings from database */
		// setState(() { dMode; });
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
								Provider.of<ProviderManager>(context, listen: false).changeTheme(
									value ? ThemeMode.dark : ThemeMode.light);
								// Update on database
								database.updateTheme(value ? ThemeMode.dark : ThemeMode.light);
								Future.microtask((){
									setState(() { dMode = value; });
								});
							}
						),
						ListTile(
							leading: const Icon(Icons.folder),
							title: const Text("Clear Temp Folder"),
							onTap: (){
								showDialog(
									context: context,
									builder: (context) => AlertDialog(
										title: const Text("Clean"),
										content: const Text(
											"Did you want to clean up temp folder?\nAll the images will download again"),
										actions: [
											OutlinedButton(
												onPressed: () => Navigator.pop(context),
												child: const Text("No"),
											),
											FilledButton(
												onPressed: () async {
													DefaultCacheManager manager = DefaultCacheManager();
													await manager.emptyCache(); //clears all data in cache.
													if(mounted){
														SNK(context).success(message: "Cleaned!");
														Navigator.pop(context);
													}
												},
												child: const Text("Yes"),
											)
										],
									)
								);
							},
						)
					],
				),
			),
		);
	}
}
