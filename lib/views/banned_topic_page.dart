import 'package:flutter/material.dart';
import 'package:mosfet/config/navigator.dart';
import 'package:mosfet/models/banned_topic.dart';
import 'package:mosfet/views/home_page.dart';


class BannedTopicPage extends StatefulWidget {
	const BannedTopicPage({super.key});

	@override
	State<BannedTopicPage> createState() => _BannedTopicPageState();
}

class _BannedTopicPageState extends State<BannedTopicPage> {

	List<BannedTopic> topicList = [];

	@override
	void initState() {
		setState(() {
			topicList = [
				BannedTopic(name: "Automation", isBanned: false),
				BannedTopic(name: "Electronics", isBanned: false),
				BannedTopic(name: "Flying Machines", isBanned: true),
				BannedTopic(name: "Manufacturing", isBanned: false),
				BannedTopic(name: "Open Source", isBanned: false),
			];
		});
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		return WillPopScope(
			onWillPop: () async {changeView(context, const HomePage()); return false;},
			child: Scaffold(
				appBar: AppBar(
					title: const Text("Topics"),
					leading: IconButton(
						icon: const Icon(Icons.arrow_back),
						onPressed: () => changeView(context, const HomePage()),
					),
				),
				body: GridView.count(
					padding: const EdgeInsets.all(12),
					crossAxisCount:
						MediaQuery.of(context).size.height > MediaQuery.of(context).size.width ? 3 : 5,
					children: [
						for(int index = 0; index < topicList.length; index++) Card(
							child: InkWell(
								borderRadius: BorderRadius.circular(10),
								child: Stack(
									alignment: Alignment.center,
									children: [
										Center(
											child: Text(
												topicList[index].name,
												style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
											),
										),
										if(topicList[index].isBanned) Icon(
											Icons.lock,
											size: 100,
											color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.08),
										)
									],
								),
								onTap: (){
									setState(() {
										topicList[index].isBanned = !topicList[index].isBanned;
									});
								},
							),
						)
					],
				),
			),
		);
	}
}
