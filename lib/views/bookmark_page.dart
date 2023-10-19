import 'package:flutter/material.dart';
import 'package:mosfet/components/news_item.dart';
import 'package:mosfet/config/navigator.dart';
import 'package:mosfet/database/database.dart';
import 'package:mosfet/models/news.dart';
import 'package:mosfet/utils/init.dart';
import 'package:mosfet/views/home_page.dart';


class BookmarkPage extends StatefulWidget {
	const BookmarkPage({super.key});

	@override
	State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> with TickerProviderStateMixin{

	List<News> bookedItems = [];
	Database database = Database();

	Future<void> loadBookmarks() async {
		List<News> dbList = [];
		dbList = database.allBookmarks();

		setState(() {
			bookedItems = initializeAnimations(dbList, [], this);
		});
	}
	
	@override
	void initState() {
		loadBookmarks();
		super.initState();
	}


	@override
	Widget build(BuildContext context) {
		return WillPopScope(
			onWillPop: () async {changeView(context, const HomePage()); return false;},
			child: Scaffold(
				appBar: AppBar(
					automaticallyImplyLeading: false,
					title: const Text("Bookmark"),
					leading: IconButton(
						icon: const Icon(Icons.arrow_back),
						onPressed: () => changeView(context, const HomePage()),
					),
				),
				body: bookedItems.isNotEmpty ? ListView.builder(
					itemBuilder: (BuildContext context, int index) => NewsItem(
						news: bookedItems[index], setState: setState, index: index, all: bookedItems),
				) : const Center(child: Text("No Item!")),
			)
		);
	}
}
