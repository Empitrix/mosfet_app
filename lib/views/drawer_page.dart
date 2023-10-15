import 'package:flutter/material.dart';
import 'package:mosfet/config/navigator.dart';
import 'package:mosfet/views/settings_page.dart';


class DrawerPage extends StatefulWidget {
	final GlobalKey<ScaffoldState> scaffoldKey;
	const DrawerPage({super.key, required this.scaffoldKey});

	@override
	State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {

	double roundness = 5;

	void closeDrawer(){
		if(widget.scaffoldKey.currentState != null){
			widget.scaffoldKey.currentState!.closeDrawer();
		}
	}

	@override
	Widget build(BuildContext context) {
		return Drawer(
			shape: RoundedRectangleBorder(
				borderRadius: BorderRadius.only(
					topRight: Radius.zero,
					bottomRight: Radius.zero,
					topLeft: Radius.circular(roundness),
					bottomLeft: Radius.circular(roundness)
				)
			),
			child: Scaffold(
				body: ListView(
					children: [
						ListTile(
							title: const Text("Settings"),
							leading: const Icon(Icons.settings),
							onTap: (){
								closeDrawer();
								changeView(context, const SettingsPage(), isPush: true);
							},
						)
					],
				),
			),
		);
 }
}
