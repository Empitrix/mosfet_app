import 'package:mosfet/animations/expand.dart';
import 'package:mosfet/backend/backend.dart';
import 'package:flutter/material.dart';
import 'package:mosfet/database/database.dart';

class News {
	final String title;
	final String topic;
	final String source;
	final String img;
	final String date;
	final List<String> texts;
	final List<String> links;
	late bool isSeen;

	// Animation
	late GeneratedAnimation? animation;
	// late Animation<double>? animation;
	// late AnimationController? controller;

	News({
		required this.title,
		required this.topic,
		required this.source,
		required this.img,
		required this.date,
		required this.texts,
		required this.links,
		required this.isSeen,
		this.animation,
	});

	toJson(){
		return {
			"title": title,
			"topic": topic,
			"source": source,
			"img": img,
			"date": date,
			"texts": texts,
			"links": links,
			"isSeen": isSeen
		};
	}

	static toNews(Map input){
		return News(
			title: input["title"],
			topic: input["topic"],
			source: input["source"],
			img: input["img"],
			date: input["date"],
			texts: List<String>.from(input["texts"]),
			links: List<String>.from(input["links"]),
			isSeen: input["isSeen"]
		);
	}


	bool isEqual(News input){
		if(
			vStr(input.title) == vStr(title) &&
			vStr(input.topic) == vStr(topic) &&
			vStr(input.source) == vStr(source) &&
			vStr(input.date) == vStr(date) &&
			vStr(input.img) == vStr(img)
		){
			return true;
		}
		return false;
	}


	void setToSeen(){
		Database db = Database();
		News newNews = this;
		newNews.isSeen = true;
		db.editNews(this, newNews);
	}

}
