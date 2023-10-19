import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mosfet/backend/backend.dart';
import 'package:mosfet/client/client.dart';
import 'package:mosfet/components/alerts.dart';
import 'package:mosfet/components/news_item.dart';
import 'package:mosfet/components/shimmer_view.dart';
import 'package:mosfet/config/provider_manager.dart';
import 'package:mosfet/config/public.dart';
import 'package:mosfet/database/database.dart';
import 'package:mosfet/models/banned_topic.dart';
import 'package:mosfet/models/news.dart';
import 'package:mosfet/utils/init.dart';
import 'package:mosfet/utils/loading.dart';
import 'package:mosfet/views/drawer_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
	const HomePage({super.key});

	@override
	State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{

	GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
	bool isLoaded = false;
	Database database = Database();
	List<News> news = [];

	Future<void> _updateNews({required List<News> all, required List<BannedTopic> topics}) async {
		setState(() { isLoaded = false; });
		// List<News> dbList = [];
		SNK snk = SNK(context);

		// for(News paper in all){
		// 	if(!topics.any((t) => vStr(t.name) == vStr(paper.topic))){
		// 		print("yews");
		// 		dbList.add(paper);
		// 	}
		// }

		setState(() {
			news = initializeAnimations(all, this);
			if(topics.isNotEmpty){
				isLoaded = true;
			}
		});


		NewsManifest manifest = await MosfetClient.news();

		if(manifest.statusCode != 0){
			snk.failed(message: manifest.msg);
		} else {
			List<News> updated = [];
			if(all.isNotEmpty){
				for(int i = 0; i < manifest.news!.length; i++){
					if(all.any((n) => n.isEqual(manifest.news![i]))){
						for(int j = 0; j < all.length; j++){
							if(all[j].isEqual(manifest.news![i])){
								// Check for banned topics
								// if(!topics.any((t) => vStr(t.name) == vStr(manifest.news![i].topic))){
								//
								// }
								updated.add(all[j]);
							}
						}
					} else { updated.add(manifest.news![i]); }  // Add the new message
				}
			} else {
				print("Called !");
				updated = manifest.news!;
			}  // First time news

			print("N len: ${updated.length}");

			database.addAllNews(updated);  // Added loaded items to database

			setState(() { news = initializeAnimations(updated, this); isLoaded = true; });
		}
	}


	Future<void> initialize() async {
		await initializeLoading();
		database.init();
		Loaded loaded = loadAllContents();
		if(mounted) Provider.of<ProviderManager>(context, listen: false).changeTheme(loaded.themeMode);
		setState(() { dMode = loaded.themeMode == ThemeMode.dark; });
		print("B Len: ${loaded.bannedTopics.length}");
		await _updateNews(all: loaded.news, topics: loaded.bannedTopics);
		debugPrint("[ NEWS ARE LOADED ]");
	}


	@override
	void initState() {
		initialize();
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		return WillPopScope(
			onWillPop: () async { SystemNavigator.pop(animated: true); return false; },
			child: Scaffold(
				key: scaffoldKey,
				drawer: DrawerPage(scaffoldKey: scaffoldKey),

				appBar: AppBar(
					automaticallyImplyLeading: false,
					// title: const Text("MOSFET"),
					title: Container(
						margin: const EdgeInsets.only(top: 5, bottom: 5),
						child: SvgPicture.asset(
							"assets/svg/icon.svg", height: 45, width: 45,
							// ignore: deprecated_member_use
							color: Theme.of(context).colorScheme.inverseSurface),
					),
					centerTitle: true,
					leading: IconButton(
						icon: const Icon(Icons.menu),
						onPressed: (){
							if(scaffoldKey.currentState != null){ scaffoldKey.currentState!.openDrawer(); }
						},
					),
				),
				body: isLoaded ? ListView.builder(
					padding: const EdgeInsets.only(top: 5),
					itemCount: news.length,
					itemBuilder: (BuildContext context, int index) => NewsItem(
						news: news[index], setState: setState, index: index, all: news, key: news[index].key),
				): const ShimmerView(),
			),
		);
	}
}
