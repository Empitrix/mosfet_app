import 'package:flutter/material.dart';
import 'package:mosfet/models/news.dart';


class NewsItem extends StatelessWidget {
	final News news;
	final Function setState;
	const NewsItem({super.key, required this.news, required this.setState});

	@override
	Widget build(BuildContext context) {
		return InkWell(
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
						)
					],
				),
			),

			onTap: (){
				setState((){});
			},
		);

	}
}
