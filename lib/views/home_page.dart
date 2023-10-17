import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mosfet/animations/expand.dart';
import 'package:mosfet/backend/backend.dart';
import 'package:mosfet/client/client.dart';
import 'package:mosfet/components/news_item.dart';
import 'package:mosfet/components/shimmer_view.dart';
import 'package:mosfet/config/provider_manager.dart';
import 'package:mosfet/config/public.dart';
import 'package:mosfet/database/database.dart';
import 'package:mosfet/models/news.dart';
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


	List<News> _initializeAnimations(List<News> input){
		List<News> actualNews = [];
		for(News current in input){
			current.animation = generateLinearAnimation(
				ticket: this, initialValue: 0, durations: [250]);
			actualNews.add(current);
		}
		return actualNews;
	}

	Future<void> _updateNews({required List<News> all, required List<String> topics}) async {
		setState(() { isLoaded = false; });
		List<News> dummyList = [];

		for(News paper in all){
			if(!topics.any((t) => vStr(t) == vStr(paper.topic))){
				dummyList.add(paper);
			}
		}
		dummyList = _initializeAnimations(dummyList);

		setState(() {
			news = dummyList;
			isLoaded = true;
		});


		NewsManifest manifest = await NewsClient.news();

		if(manifest.statusCode != 0){
			if(manifest.statusCode == -1){ /*Internet connection*/ }
			else if(manifest.statusCode == -2){ /*Something Happened*/ }
		} else {

			List<News> updated = [];
			for(int i = 0; i < dummyList.length; i++){
				for(int j = 0; j < manifest.news!.length; j++){
					if(dummyList[i].isEqual(manifest.news![j])){
						// Check for banned topics
						if(!topics.any((t) => vStr(t) == vStr(manifest.news![j].topic))){
							// manifest.news![j] = dummyList[i];
							updated.add(dummyList[i]);
						}
					}
				}
			}
			// Added loaded items to database
			database.addAllNews(updated);
			// Set Animations
			updated = _initializeAnimations(updated);

			setState(() { news = updated; });
		}
	}


	Future<void> initialize() async {
		await initializeLoading();
		database.init();
		Loaded loaded = loadAllContents();
		if(mounted) Provider.of<ProviderManager>(context, listen: false).changeTheme(loaded.themeMode);
		setState(() {
			dMode = loaded.themeMode == ThemeMode.dark;
			news = loaded.news;
		});
		await _updateNews(all: loaded.news, topics: loaded.bannedTopics);
		// setState(() { isLoaded = true; });
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
					title: const Text("News"),
					leading: IconButton(
						icon: const Icon(Icons.menu),
						onPressed: (){
							if(scaffoldKey.currentState != null){ scaffoldKey.currentState!.openDrawer(); }
						},
					),
				),
				body: isLoaded ? SelectionArea(
					child: ListView.builder(
						itemCount: news.length,
						itemBuilder: (BuildContext context, int index) => NewsItem(
							news: news[index], setState: setState, index: index, all: news),
					),
				): const ShimmerView(),
			),
		);
	}
}
