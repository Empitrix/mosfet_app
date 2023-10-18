import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mosfet/backend/backend.dart';
import 'package:mosfet/backend/parser.dart';
import 'package:mosfet/models/news.dart';

/*
Status code explain
0 : all fine
-1: Internet connection
-2: Something wrong
-3: Connection failed
*/




class NewsManifest{
	final int statusCode;
	late List<News>? news;

	NewsManifest({required this.statusCode, required this.news});
}

class NewsClient {
	static Future<NewsManifest> news() async {
		List<News> collectedNews = [];
		// Check for internet connection
		if(!await InternetConnectionChecker().hasConnection){
			return NewsManifest(statusCode: -1, news: null);}

		http.Response? response;
		// Get data from internet
		try{
			response = await http.get(Uri.parse("https://mosfet.net"));
		} catch(e){
			return NewsManifest(statusCode: -3, news: null);
		}

		if(response.statusCode != 200){
			return NewsManifest(statusCode: -2, news: null);}


		Map output = htmlToJson(response.body);
		List<Map> mixedChildren = [];

		for(Map tag in output["children"]){
			if(tag["tag"] == null){ continue; }
			if(tag["tag"] == "main"){
				mixedChildren = List<Map<String, dynamic>>.from(tag["children"]);
			}
		}

		for(Map tag in mixedChildren){
			if(tag["tag"] == null) { continue; }
			if(tag["tag"] == "div"){
				mixedChildren = List<Map<String, dynamic>>.from(tag["children"]);
				break;
			}
		}

		List<List> extractedChildren = [];

		for (Map tag in mixedChildren) {
			if (tag["tag"] == null) { continue; }
			if (tag["tag"] == "article") {
				extractedChildren.add(tag["children"]);
			}
		}


		for(List single in extractedChildren){
			Map thisNews = {
				"title": "", "topic": "", "source": "",
				"img": "", "date": "", "texts": [], "links": [], "isSeen": false
			};

			for(Map cursor in single){
				if(cursor["tag"] == null){ continue; }
				// Title
				if(cursor["tag"] == "h2"){ thisNews["title"] = (cursor["children"][0]["text"]); }

				if(cursor["tag"] == "div"){
					String currentAttribute = cursor["attributes"]["class"];
					if(currentAttribute == "post-meta"){
						for(Map item in cursor["children"]){
							if(item["attributes"] == null){ continue; }
							// Date
							if(item["attributes"]["class"] == "date"){
								thisNews["date"] = (item["children"][0]["text"]); }
							// Topic
							if (item["attributes"]["class"] == "cat") {
								thisNews["topic"] = (item["children"][0]["text"]); }
						}
					} else if (currentAttribute == "post-content"){
						for(Map item in cursor["children"]){
							if(item["attributes"] == null){ continue; }

							for(Map content in item["children"]){
								if(content["tag"] == null){ continue; }
								if(content["tag"] == "figure"){
									for(Map f in content["children"]){
										if(f["tag"] == null){ continue; }
										if(f["tag"] == "img"){
											// print(f["attributes"]["data-src"]);  // Image
											// Image
											thisNews["img"] = f["attributes"]["data-src"];
										} else if (f["tag"] == "figcaption"){
											// Source
											thisNews["source"] = f["children"].first["text"];
										}
									}
								} else if (content["tag"] == "p"){
									for(Map element in content["children"]){
										if(element["tag"] == null){
											// take as text
											thisNews["texts"].add(element["text"]);
										} else {
											// take as link
											for(Map l in element["children"]){
												if(l["text"] != null){
													// Link
													thisNews["links"].add(l["text"]);
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}

			// Update today's date
			if(vStr(thisNews["date"]) == "today"){
				thisNews["date"] = getFormattedCurrentDate(); }

			// Collect News
			collectedNews.add(News.toNews(thisNews));
		}

		return NewsManifest(statusCode: 0, news: collectedNews);
	}
}
