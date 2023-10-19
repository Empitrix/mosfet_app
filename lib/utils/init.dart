import 'package:flutter/cupertino.dart';
import 'package:mosfet/animations/expand.dart';
import 'package:mosfet/backend/backend.dart';
import 'package:mosfet/models/banned_topic.dart';
import 'package:mosfet/models/news.dart';

List<News> initializeAnimations(List<News> input, List<BannedTopic> topics, TickerProvider ticket){
	List<News> actualNews = [];
	for(News current in input){
		current.animation ??= generateLinearAnimation(
			ticket: ticket, initialValue: 0, durations: [250]);
		// Add Key
		// current.key = GlobalKey();
		current.key = GlobalKey();
		actualNews.add(current);

		for(int t = 0; t < topics.length; t++){
			if(!topics[t].isBanned){ continue; }
			bool haveTopic = vStr(current.topic) != vStr(topics[t].name);
			if(!haveTopic){
				actualNews.removeLast();
			}

		}

	}
	// print(actualNews[0].key);
	return actualNews;
}