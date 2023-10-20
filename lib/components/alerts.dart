import 'package:flutter/material.dart';

SnackBar __show(BuildContext context, IconData icon, String message){
	return SnackBar(
		duration: const Duration(seconds: 1),
		backgroundColor: Theme.of(context).colorScheme.inversePrimary,
		content: Row(
			children: [
				Icon(icon, color: Theme.of(context).colorScheme.inverseSurface),
				const SizedBox(width: 12),
				Text(message, style: TextStyle(
					color: Theme.of(context).colorScheme.inverseSurface
				))
			],
		),
	);
}


class SNK {
	final BuildContext context;
	SNK(this.context);

	void success({required String message, IconData icon = Icons.check}){
		ScaffoldMessenger.of(context).showSnackBar(__show(context, icon, message));
	}
	void failed({required String message, IconData icon = Icons.close}){
		ScaffoldMessenger.of(context).showSnackBar(__show(context, icon, message));
	}
}
