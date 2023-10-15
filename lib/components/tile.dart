import 'package:flutter/material.dart';


class SwitchTile extends StatelessWidget {
	final Text title;
	final Widget icon;
	final bool value;
	final ValueChanged<bool> onChange;
	const SwitchTile({
		super.key,
		required this.title,
		required this.icon,
		required this.value,
		required this.onChange
	});

	@override
	Widget build(BuildContext context) {
		return ListTile(
			title: title,
			leading: icon,
			trailing: IgnorePointer(
				child: Transform.scale(
					scale: 0.8,
					child: Switch(
						value: value,
						onChanged: (bool? value){},
					),
				),
			),
			onTap: () => onChange(!value),
		);
	}
}
