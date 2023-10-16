import 'package:mosfet/backend/backend.dart';

class News {
	final String title;
	final String topic;

	News({
		required this.title,
		required this.topic
	});

	toJson(){
		return {
			"title": title,
			"topic": topic
		};
	}

	static toNews(Map input){
		return News(
			title: input["title"],
			topic: input["topic"]
		);
	}


	bool isEqual(News input){
		if(
			vStr(input.title) == vStr(title) &&
			vStr(input.topic) == vStr(topic)
		){
			return true;
		}
		return false;
	}

}
