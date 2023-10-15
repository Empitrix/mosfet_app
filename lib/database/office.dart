import 'package:mosfet/config/public.dart';
import 'dart:convert';
import 'dart:io';


class Office {
	void write(Map data){
		File jsonFile = File(localDbPath);
		jsonFile.writeAsStringSync(json.encode(data));
	}

	Map read(){
		File jsonFile = File(localDbPath);
		String file = jsonFile.readAsStringSync();
		if(file != ""){ return jsonDecode(file); }
		else{ return {}; }
	}
}
