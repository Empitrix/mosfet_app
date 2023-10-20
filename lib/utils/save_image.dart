import 'dart:io';
import 'package:mosfet/models/news.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;


String _getValidFileName(String name){
	name = name.replaceAll("/", "")
		.replaceAll("\\", "")
		.replaceAll(":", "")
		.replaceAll("*", "")
		.replaceAll("?", "")
		.replaceAll('"', "")
		.replaceAll('>', "")
		.replaceAll('<', "")
		.replaceAll('|', "");
	return "$name.gif";
}


Future<String> _getDownloadPath() async {
	String path = "";
	if(!Platform.isAndroid){
		path = (await getDownloadsDirectory())!.absolute.path;
	} else {
		path = Directory("storage/emulated/0/Download").absolute.path;
	}
	return path;
}



Future<bool> downloadImageToDownload(News input) async {
	String path = await _getDownloadPath();
	File downloadFile = File(p.join(path, _getValidFileName(input.title)));
	http.Response? response;
	try{
		response = await http.get(Uri.parse(input.img));
	} catch(e){
		return false;
	}

	if(response.statusCode == 200){
		downloadFile.writeAsBytesSync(response.bodyBytes);
	}
	return true;
}