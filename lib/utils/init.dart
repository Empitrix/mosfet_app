import 'package:flutter/cupertino.dart';
import 'package:mosfet/animations/expand.dart';
import 'package:mosfet/models/news.dart';

List<News> initializeAnimations(List<News> input, TickerProvider ticket){
	List<News> actualNews = [];
	for(News current in input){
		current.animation ??= generateLinearAnimation(
			ticket: ticket, initialValue: 0, durations: [250]);
		// Add Key
		current.key = GlobalKey();
		actualNews.add(current);
	}
	// print(actualNews[0].key);
	return actualNews;
}