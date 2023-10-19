import 'package:flutter/material.dart';
import 'package:mosfet/models/news.dart';


void _showBottomSheetModel({required BuildContext context, required Function builder}){
	showModalBottomSheet(
		context: context,
		showDragHandle: true,
		shape: const RoundedRectangleBorder(
			borderRadius: BorderRadius.only(
				topRight: Radius.circular(12),
				topLeft: Radius.circular(12),
			)
		),
		builder: (BuildContext context) => builder(context)
	);
}


void showMoreBottomSheet({required BuildContext context, required News news}){
	_showBottomSheetModel(
		context: context,
		builder: (BuildContext context) => Container(
			padding: const EdgeInsets.all(5),
			width: MediaQuery.of(context).size.width,
			child: SingleChildScrollView(
				child: Column(
					children: [
						Text(news.title),
						const SizedBox(height: 8),
					],
				),
			),
		)
	);
}