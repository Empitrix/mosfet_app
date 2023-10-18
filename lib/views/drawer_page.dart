import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
					topLeft: Radius.zero,
					bottomLeft: Radius.zero,
					topRight: Radius.circular(roundness),
					bottomRight: Radius.circular(roundness)
				)
			),
			child: Scaffold(
				body: ListView(
					children: [

						// Container(
						// 	margin: const EdgeInsets.only(top: 20, bottom: 20, right: 12, left: 12),
						// 	child: const Center(
						// 		child: Text(
						// 			"MOSFET",
						// 			style: TextStyle(fontSize: 40, fontFamily: "TitilliumWebSemiBold"),
						// 		),
						// 	),
						// ),

						Container(
							margin: const EdgeInsets.only(top: 20, bottom: 20, right: 12, left: 12),
							child: Center(
								child: Row(
									mainAxisAlignment: MainAxisAlignment.center,
									children: [
										SvgPicture.asset(
											"assets/svg/icon.svg",
											height: 80,
											width: 80,
											// ignore: deprecated_member_use
											color: Theme.of(context).colorScheme.inverseSurface,
										),
										const SizedBox(width: 5),
										Expanded(
											child: Text(
												"Keeping you up to date with technological change.",
												style: TextStyle(
													fontWeight: FontWeight.bold
												),
											),
										)
									],
								)
							),
						),


						ListTile(
							title: const Text("Settings"),
							leading: const Icon(Icons.settings),
							onTap: (){
								closeDrawer();
								changeView(context, const SettingsPage(), isPush: true);
							},
						),

						ListTile(
							title: const Text("Bookmark"),
							leading: const Icon(Icons.bookmark),
							onTap: (){
								closeDrawer();

							},
						),

						ListTile(
							title: const Text("Banned Topics"),
							leading: const Icon(Icons.cancel_presentation),
							onTap: (){
								closeDrawer();

							},
						)


					],
				),
			),
		);
 }
}
