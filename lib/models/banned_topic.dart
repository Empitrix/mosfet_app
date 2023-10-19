import 'package:mosfet/backend/backend.dart';

class BannedTopic{
	final String name;
	late bool isBanned;

	BannedTopic({required this.name, this.isBanned = false});

	static toTopic(Map input){
		return BannedTopic(
			name: input["name"],
			isBanned: input["isBanned"],
		);
	}

	Map toJson(){
		return {
			"name": name,
			"isBanned": isBanned
		};
	}

	bool isEqual(BannedTopic input){
		if(vStr(name) == vStr(input.name)){
			return true;
		}
		return false;
	}
}