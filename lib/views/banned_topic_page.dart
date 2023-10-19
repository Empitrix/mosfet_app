import 'package:flutter/material.dart';
import 'package:mosfet/backend/backend.dart';
import 'package:mosfet/client/client.dart';
import 'package:mosfet/components/alerts.dart';
import 'package:mosfet/config/navigator.dart';
import 'package:mosfet/database/database.dart';
import 'package:mosfet/models/banned_topic.dart';
import 'package:mosfet/views/home_page.dart';


class BannedTopicPage extends StatefulWidget {
	const BannedTopicPage({super.key});

	@override
	State<BannedTopicPage> createState() => _BannedTopicPageState();
}

class _BannedTopicPageState extends State<BannedTopicPage> {

	List<BannedTopic> topicList = [];
	Database database = Database();

	Future<void> loadTopics() async {
		setState(() {
			topicList = database.allTopics();
		});

		TopicManifest? manifest = await MosfetClient.topics();
		if(manifest.statusCode != 0){
			if(mounted) SNK(context).failed(message: manifest.msg);
			return;
		}


		List<BannedTopic> updated = [];

		for(BannedTopic fTopic in manifest.topics!){
			if(topicList.any((n) => n.isEqual(fTopic))){

				updated.add(topicList.firstWhere((e) => vStr(e.name) == vStr(fTopic.name)));

			} else {
				updated.add(fTopic);
			}


		}

		setState(() { topicList = updated; });

		database.clearTopics();
		for(BannedTopic t in updated){
			database.addToTopics(t);
		}

	}

	@override
	void initState() {
		loadTopics();
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
												style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
										database.toggleTopic(topicList[index]);
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
