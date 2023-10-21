import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mosfet/backend/backend.dart';
import 'package:mosfet/components/alerts.dart';
import 'package:mosfet/database/database.dart';
import 'package:mosfet/models/banned_topic.dart';
import 'package:mosfet/models/news.dart';
import 'package:mosfet/utils/save_image.dart';


Database database = Database();

void _showBottomSheetModel({required BuildContext context, required Function builder}){
	showModalBottomSheet(
		context: context,
		showDragHandle: true,
		shape: const RoundedRectangleBorder(
			borderRadius: BorderRadius.only(
				topRight: Radius.circular(12),
				topLeft: Radius.circular(12),
			)
		),
		builder: (BuildContext context) => builder(context)
	);
}


void showMoreBottomSheet({required BuildContext context, required News news, Function? onLoad}){
	bool isInBookmark = database.allBookmarks().any((e) => e.isEqual(news));
	bool isInBannedTopics = database.allTopics().any((t) => vStr(t.name) == vStr(news.topic));
	ValueNotifier<bool> isDownloading = ValueNotifier<bool>(false);

	_showBottomSheetModel(
		context: context,
		builder: (BuildContext context){
			SNK snk = SNK(context);
			return SizedBox(
				width: MediaQuery.of(context).size.width,
				child: SingleChildScrollView(
					child: Column(
						children: [
							Container(
								margin: const EdgeInsets.all(12),
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(
											news.title,
											style: Theme.of(context).textTheme.bodyLarge!.copyWith(
												fontWeight: FontWeight.bold
											)
										),
										const SizedBox(height: 5),
										Text(
											"${vStr(news.date) == vStr(getFormattedCurrentDate()) ?
											"TODAY" : news.date.toUpperCase()} | ${news.topic.toUpperCase()}",
											style: TextStyle(
												color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.8)
											),
										)
									],
								),
							),
							const SizedBox(height: 20),
							ListTile(
								leading: Icon(isInBookmark ? Icons.bookmark_remove : Icons.bookmark_add),
								title: Text(isInBookmark ? "Remove from bookmark" : "Add to Bookmark"),
								onTap: (){
									if(isInBookmark){
										database.deleteFromBookmarks(news);
										snk.success(message: "Removed !", icon: Icons.bookmark_remove);
									} else {
										database.addToBookmarks(news);
										snk.success(message: "Added !", icon: Icons.bookmark_add);
									}
									Navigator.pop(context);
									if(onLoad != null){ onLoad(); }
								},
							),

							if(isInBannedTopics) ListTile(
								leading: const Icon(Icons.topic),
								title: const Text("Banned this topic"),
								onTap: (){
									database.addToTopics(BannedTopic(name: news.topic));
									if(onLoad != null){ onLoad(); }
								},
							),

							ListTile(
								leading: ValueListenableBuilder(
									valueListenable: isDownloading,
									builder: (_, bool snap, __){
										return snap ?
										const SizedBox(
											height: 25,
											width: 25,
											child: CircularProgressIndicator(strokeWidth: 3),
										) :
										const Icon(Icons.image);
									},
								),
								title: const Text("Save to Downloads"),
								onTap: () async {
									isDownloading.value = true;
									bool status = await downloadImageToDownload(news);
									if(status){
										snk.success(message: "Saved!");
									} else {
										snk.success(message: "Failed to save!");
									}
									// ignore: use_build_context_synchronously
									Navigator.pop(context);

								},
							),


							const SizedBox(height: 20),
						],
					),
				),
			);
		}
	);
}

void showAboutSheet({required BuildContext context}){
	_showBottomSheetModel(
		context: context,
		builder: (BuildContext context){
			return Container(
				margin: const EdgeInsets.only(right: 12, left: 12, bottom: 10),
				width: MediaQuery.of(context).size.width,
				child: SingleChildScrollView(
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Text("MOSFET",
								style: Theme.of(context).textTheme.displaySmall!
									.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
							const SizedBox(height: 12),
							Text("Simple Tech News Update", style: Theme.of(context).textTheme.bodyLarge),
							Text(
								"Keeping you up to date with technological change.",
								style: Theme.of(context).textTheme.bodyLarge),
							const SizedBox(height: 20),
							/* Links */
							Row(
								children: [
									IconButton(
										icon: const FaIcon(FontAwesomeIcons.youtube),
										onPressed: () => openCustomURL("https://www.youtube.com/@MOSFETnet"),
									),
									IconButton(
										icon: const Icon(Icons.language),
										onPressed: () => openCustomURL("https://mosfet.net/"),
									),
									const SizedBox(height: 25, child: VerticalDivider()),
									IconButton(
										tooltip: "N-O-D-E",
										icon: const Icon(Icons.web),
										onPressed: () => openCustomURL("https://n-o-d-e.net/"),
									),
									const SizedBox(height: 25, child: VerticalDivider()),
									IconButton(
										icon: const FaIcon(FontAwesomeIcons.github),
										onPressed: () => openCustomURL("https://github.com/empitrix/mosfet_app"),
									),
								],
							),
							const SizedBox(height: 15),
						],
					),
				),
			);
		}
	);
}
