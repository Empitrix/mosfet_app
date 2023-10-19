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
}