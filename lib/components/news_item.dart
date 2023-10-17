import 'package:flutter/material.dart';
import 'package:mosfet/animations/expand.dart';
import 'package:mosfet/models/news.dart';


void _openFooter({required List<News> all, required int index}){
	for(News n in all){
		n.animation!.controller.reverse();
	}
	if(all[index].animation!.controller.value == 0){
		all[index].animation!.controller.forward();
	} else {
		all[index].animation!.controller.reverse();
	}
}


class NewsItem extends StatelessWidget {
	final News news;
	final Function setState;
	final int index;
	final List<News> all;
	const NewsItem({
		super.key, required this.news, required this.setState, required this.index, required this.all});

	@override
	Widget build(BuildContext context) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				InkWell(
					child: Container(
						margin: const EdgeInsets.only(top: 12, bottom: 12, right: 12, left: 12),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Row(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Column(
											children: [
												const SizedBox(height: 10),
												if(!news.isSeen) const Icon(Icons.circle, size: 10)
												else const SizedBox(width: 10),
											],
										),
										const SizedBox(width: 10),
										Expanded(
											child: Text(news.title, style: const TextStyle(
												fontFamily: "TitilliumWebSemiBold", fontSize: 22)),
										)
									],
								),
								Row(
									children: [
										const SizedBox(width: 20),
										Expanded(
											child: Text(
												"${news.date.toUpperCase()} | ${news.topic.toUpperCase()}",
												style: TextStyle(
													color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.8)
												),
											)
										)
									],
								),


							],
						),
					),

					onTap: (){
						_openFooter(all: all, index: index);
						if(!news.isSeen){
							news.setToSeen();
							setState((){ news.isSeen = true; });
						}


					},
				),
				expandAnimation(
					animation: news.animation!.animation,
					mode: ExpandMode.height,
					body: Container(
						margin: const EdgeInsets.all(12),
						child: Column(
							children: [
								for(int i = 0; i < 10; i++) Text("No.${i + 1}")
							],
						),
					)
				)
			],
		);

	}
}
