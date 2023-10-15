import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mosfet/views/drawer_page.dart';

class HomePage extends StatefulWidget {
	const HomePage({super.key});

	@override
	State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

	GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

	@override
	Widget build(BuildContext context) {
		return WillPopScope(
			onWillPop: () async { SystemNavigator.pop(animated: true); return false; },
			child: Scaffold(
				key: scaffoldKey,
				drawer: DrawerPage(scaffoldKey: scaffoldKey),
				appBar: AppBar(
					automaticallyImplyLeading: false,
					title: const Text("News"),
					leading: IconButton(
						icon: const Icon(Icons.menu),
						onPressed: (){
							if(scaffoldKey.currentState != null){ scaffoldKey.currentState!.openDrawer(); }
						},
					),
				),
				body: const Center(child: Text("Mosfet!")),
			),
		);
	}
}
