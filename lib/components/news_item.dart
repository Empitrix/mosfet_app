import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mosfet/animations/expand.dart';
import 'package:mosfet/backend/backend.dart';
import 'package:mosfet/backend/clipboard.dart';
import 'package:mosfet/components/alerts.dart';
import 'package:mosfet/components/sheets.dart';
import 'package:mosfet/models/news.dart';


void _openFooter({
	required List<News> all, required int index}) async {
	for(News n in all){
		n.animation!.controller.reverse();
	}
	if(all[index].animation!.controller.value == 0){
		await all[index].animation!.controller.forward();
		Scrollable.ensureVisible(
			all[index].key!.currentContext!,
			duration: const Duration(milliseconds: 250),
			alignment: 0
		);
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
				Listener(
					onPointerDown: (pointer){
						if(Platform.isWindows || Platform.isLinux){
							if(pointer.buttons == 2){
								showMoreBottomSheet(context: context, news: news);
							}
						}
					},
					child: InkWell(
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
													fontFamily: "TitilliumWebSemiBold", fontSize: 20)),
											)
										],
									),
									Row(
										children: [
											const SizedBox(width: 20),
											Expanded(
												child: Text(
													"${vStr(news.date) == vStr(getFormattedCurrentDate()) ?
													"TODAY" : news.date.toUpperCase()} | ${news.topic.toUpperCase()}",
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
						onLongPress: () => showMoreBottomSheet(context: context, news: news),
					),
				),
				expandAnimation(
					animation: news.animation!.animation,
					mode: ExpandMode.height,
					body: Container(
						constraints: const BoxConstraints(maxWidth: 700),
						margin: const EdgeInsets.all(12),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.center,
							children: [
								SizedBox(
									height: 250,
									// width: 700,
									child: CachedNetworkImage(
										imageUrl: news.img,
										placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
										errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
									),
								),
								Row(
									mainAxisAlignment: MainAxisAlignment.spaceBetween,
									children: [
										Expanded(
											child: Text(news.source, style: const TextStyle(fontWeight: FontWeight.bold)),
										),
									],
								),
								const SizedBox(height: 12),
								SizedBox(
									width: double.infinity,
									child: SelectionArea(
										child: Column(
											crossAxisAlignment: CrossAxisAlignment.start,
											children: [
												for(String text in news.texts) Column(
													crossAxisAlignment: CrossAxisAlignment.start,
													mainAxisAlignment: MainAxisAlignment.start,
													children: [Text(text), const SizedBox(height: 5)]
												),
												const SizedBox(height: 20),
												for(String link in news.links) Container(
													margin: EdgeInsets.zero,
													padding: EdgeInsets.zero,
													height: 22,
													child: TextButton(
														style: ButtonStyle(
															padding: const MaterialStatePropertyAll(
																EdgeInsets.only(right: 5, left: 5, top: 2, bottom: 2)),
															shape: MaterialStatePropertyAll(
																RoundedRectangleBorder(
																	borderRadius: BorderRadius.circular(5)
																)
															)
														),
														onPressed: () async => await openCustomURL(link.trim()),
														onLongPress: () async {
															SNK(context).success(message: "Copied!");
															await CCB.copy(link.trim());
														},
														child: RichText(text: TextSpan(text: link, style: TextStyle(
															color: Theme.of(context).colorScheme.primary,
															overflow: TextOverflow.ellipsis
														))),
													)
												),


											],
										),
									)
								)


							],
						),
					)
				)
			],
		);

	}
}
