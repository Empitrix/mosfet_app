import 'package:flutter/material.dart';
import 'package:mosfet/config/provider_manager.dart';
import 'package:mosfet/views/home_page.dart';
import 'package:provider/provider.dart';

void main(){
	runApp(const MosfetApplication());
}


class MosfetApplication extends StatelessWidget {
	const MosfetApplication({super.key});

	@override
	Widget build(BuildContext context) {
		return MultiProvider(
			providers: [
				ChangeNotifierProvider(
					create: (_) => ProviderManager(),
					builder: (BuildContext context, Widget? child){
						return MaterialApp(
							title: "Mosfet",
							debugShowCheckedModeBanner: false,
							themeMode: Provider.of<ProviderManager>(context).themeMode,
							theme: Provider.of<ProviderManager>(context).lightTheme,
							darkTheme: Provider.of<ProviderManager>(context).darkTheme,
							home: const HomePage(),
						);
					},
				)
			],
		);
	}
}
