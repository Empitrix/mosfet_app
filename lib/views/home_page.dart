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

	Future<void> _updateNews({required List<News> all, required List<String> topics}) async {
		setState(() { isLoaded = false; });
		List<News> dbList = [];
		SNK snk = SNK(context);


		for(News paper in all){
			if(!topics.any((t) => vStr(t) == vStr(paper.topic))){
				dbList.add(paper);
			}
		}
		dbList = initializeAnimations(dbList, this);

		setState(() {
			news = dbList;
			if(dbList.isNotEmpty){
				isLoaded = true;
			}
		});


		NewsManifest manifest = await NewsClient.news();

		if(manifest.statusCode != 0){
			if(manifest.statusCode == -1){
				snk.failed(message: "Internet Connection!");
			}
			else if(manifest.statusCode == -2){
				snk.failed(message: "Try Again!");
			}
			else if(manifest.statusCode == -3){
				snk.failed(message: "Connection Failed!");
			}
		} else {

			List<News> updated = [];
			if(dbList.isNotEmpty){
				for(int i = 0; i < manifest.news!.length; i++){
					if(dbList.any((n) => n.isEqual(manifest.news![i]))){

						for(int j = 0; j < dbList.length; j++){
							if(dbList[j].isEqual(manifest.news![i])){
								// Check for banned topics
								if(!topics.any((t) => vStr(t) == vStr(manifest.news![i].topic))){
									updated.add(dbList[j]);
								}
							}
						}

					} else {
						updated.add(manifest.news![i]);
					}
				}

			} else {
				/* Add the new message */
				updated = manifest.news!;
			}


			// Added loaded items to database
			database.addAllNews(updated);
			// Set Animations
			updated = initializeAnimations(updated, this);
			setState(() { news = updated; isLoaded = true; });
		}
	}


	Future<void> initialize() async {
		await initializeLoading();
		database.init();
		Loaded loaded = loadAllContents();
		if(mounted) Provider.of<ProviderManager>(context, listen: false).changeTheme(loaded.themeMode);
		setState(() {
			dMode = loaded.themeMode == ThemeMode.dark;
			// news = loaded.news;
		});
		await _updateNews(all: loaded.news, topics: loaded.bannedTopics);
		// setState(() { isLoaded = true; });
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
							"assets/svg/icon.svg",
							height: 45,
							width: 45,
							// ignore: deprecated_member_use
							color: Theme.of(context).colorScheme.inverseSurface,
						),
					),
					centerTitle: true,
					leading: IconButton(
						icon: const Icon(Icons.menu),
						onPressed: (){
							if(scaffoldKey.currentState != null){ scaffoldKey.currentState!.openDrawer(); }
						},
					),
				),
				body: isLoaded ? SelectionArea(
					child: ListView.builder(
						padding: const EdgeInsets.only(top: 5),
						itemCount: news.length,
						itemBuilder: (BuildContext context, int index) => NewsItem(
							news: news[index], setState: setState, index: index, all: news, key: news[index].key),
					),
				): const ShimmerView(),
			),
		);
	}
}
