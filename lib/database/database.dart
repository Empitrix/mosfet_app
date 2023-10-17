import 'package:flutter/material.dart';
import 'package:mosfet/backend/backend.dart';
import 'package:mosfet/config/public.dart';
import 'package:mosfet/database/office.dart';
import 'package:mosfet/models/news.dart';
import 'dart:io';

Office office = Office();


class Database {
	void init(){
		File file = File(localDbPath);
		Map init = {
			"darkMode": false,
			"news": [],
			"bookmarks": [],
			"bannedTopics": []
		};
		if(!file.existsSync()){
			file.createSync(recursive: true);
			office.write(init);
		}
	}


	/* Theme */
	ThemeMode loadTheme(){
		return office.read()["darkMode"] ? ThemeMode.dark : ThemeMode.light;
	}
	void updateTheme(ThemeMode mode) {
		Map data = office.read();
		data["darkMode"] = (mode == ThemeMode.dark);
		office.write(data);
	}


	/* News */
	List<News> allNews(){
		List<News> news = [];
		for(Map item in office.read()["news"]){
			news.add(News.toNews(item)); }
		return news;
	}

	void addAllNews(List<News> input){
		Map data = office.read();
		List<Map> news = [];
		data["news"] = [];
		for(News item in input){
			news.add(item.toJson());
		}
		data["news"] = news;
		office.write(data);
	}

	void editNews(News old, News newItem){
		Map data = office.read();
		for(int i = 0; i < data["news"].length; i++){
			if(old.isEqual(News.toNews(data["news"][i]))){
				data["news"][i] = newItem.toJson();
			}
		}
		office.write(data);
	}


	/* Bookmarks */
	List<News> allBookmarks(){
		List<News> bookmarks = [];
		for(Map item in office.read()["bookmarks"]){
			bookmarks.add(News.toNews(item)); }
		return bookmarks;
	}

	void addToBookmarks(News input){
		Map data = office.read();
		data["bookmarks"].insert(0, input.toJson());
		office.write(data);
	}

	void deleteFromBookmarks(News input){
		Map data = office.read();
		data["bookmarks"].removeWhere((n) => input.isEqual(News.toNews(n)));
		office.write(data);
	}


	/* Banned Topics */
	List<String> allTopics(){
		List<String> topics = [];
		for(String topic in office.read()["bannedTopics"]){
			topics.add(topic); }
		return topics;
	}

	void addToTopics(String input){
		Map data = office.read();
		data["bannedTopics"].add(input);
		office.write(data);
	}

	void deleteFromTopics(String input){
		Map data = office.read();
		data["bannedTopics"].removeWhere((t) => vStr(t) == vStr(t));
		office.write(data);
	}


}