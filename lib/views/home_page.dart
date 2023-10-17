import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _HomePageState extends State<HomePage> {

	GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
	bool isLoaded = false;
	Database database = Database();
	List<News> news = [];


	void _updateNews({required List<News> all, required List<String> topics}){
		List<News> dummyList = [];
		for(News paper in all){
			if(!topics.any((t) => vStr(t) == vStr(paper.topic))){
				dummyList.add(paper);
			}
		}
		setState(() { news = dummyList; });
	}


	Future<void> initialize() async {
		setState(() { isLoaded = false; });

		await initializeLoading();
		database.init();
		Loaded loaded = loadAllContents();
		if(mounted) Provider.of<ProviderManager>(context, listen: false).changeTheme(loaded.themeMode);
		setState(() {
			dMode = loaded.themeMode == ThemeMode.dark;
			news = loaded.news;
		});
		_updateNews(all: loaded.news, topics: loaded.bannedTopics);

		NewsManifest manifest = await NewsClient.news();

		if(manifest.statusCode != 0){
			if(manifest.statusCode == -1){ /*Internet connection*/ }
			else if(manifest.statusCode == -2){ /*Something Happened*/ }
		} else {

			setState(() {
				news = manifest.news!;
			});

		}

		setState(() { isLoaded = true; });
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
				body: isLoaded ? ListView.builder(
					itemCount: news.length,
					itemBuilder: (BuildContext context, int index) => NewsItem(
						news: news[index], update: setState),
				): const ShimmerView(),
			),
		);
	}
}
