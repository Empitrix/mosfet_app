import 'package:flutter/material.dart';


void changeView(BuildContext context, StatefulWidget page, {bool isPush = false}){
	if(isPush){
		Navigator.push(
			context,
			MaterialPageRoute(builder: (context) => page),
		);
	} else {
		Navigator.pop(context);
	}
}
