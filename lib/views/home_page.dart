import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
	const HomePage({super.key});

	@override
	State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
	@override
	Widget build(BuildContext context) {
		return WillPopScope(
			onWillPop: () async { SystemNavigator.pop(animated: true); return false; },
			child: const Scaffold(
				body: Center(child: Text("Mosfet!")),
			),
		);
	}
}
