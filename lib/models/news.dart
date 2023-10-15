import 'package:mosfet/backend/backend.dart';

class News {
	final String title;

	News({
		required this.title
	});

	toJson(){
		return {
			"title": title,
		};
	}

	static toNews(Map input){
		return News(
			title: input["title"]
		);
	}


	bool isEqual(News input){
		if(
			vStr(input.title) == vStr(title)
		){
			return true;
		}
		return false;
	}

}
