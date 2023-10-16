import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mosfet/database/database.dart';
import 'package:mosfet/models/news.dart';
import 'package:path/path.dart' as p;
import 'package:mosfet/config/public.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';



class Loaded {
	final List<News> news;
	final ThemeMode themeMode;
	final List<String> bannedTopics;

	Loaded({
		required this.news,
		required this.themeMode,
		required this.bannedTopics,
	});
}



Future<void> initializeLoading() async {
	/* Initialize Loading for permission and create db */
	if(Platform.isWindows){
		localDbPath = p.join((await getApplicationSupportDirectory()).absolute.path, "db.json");
		return;
	}

	if(await Permission.manageExternalStorage.request().isGranted){
		localDbPath = p.join(Directory('/storage/emulated/0/Android/data/com.mosfet.tech.news/files')
			.absolute.path, "db.json");
	} else {
		openAppSettings();
	}
}


Loaded loadAllContents() {
	/* Load requirements contents from database */
	Database db = Database();
	return Loaded(
		news: db.allNews(),
		themeMode: db.loadTheme(),
		bannedTopics: db.allTopics()
	);
}