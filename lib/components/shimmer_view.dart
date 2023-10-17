import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class ShimmerItem extends StatelessWidget {
	const ShimmerItem({super.key});

	@override
	Widget build(BuildContext context) {
		return Container(
			margin: const EdgeInsets.all(12),
			width: double.infinity,
			height: 55,
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Container(
						width: double.infinity,
						height: 30,
						decoration: BoxDecoration(
							color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.8),
							borderRadius: BorderRadius.circular(5)
						),
					),
					const SizedBox(height: 5),
					Container(
						decoration: BoxDecoration(
							color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.8),
							borderRadius: BorderRadius.circular(5)
						),
						width: MediaQuery.of(context).size.width * 30 / 100,
						height: 20,
					),
				],
			),
		);
	}
}



class ShimmerView extends StatelessWidget {
	const ShimmerView({super.key});

	@override
	Widget build(BuildContext context) {
		return ListView.builder(
			physics: const NeverScrollableScrollPhysics(),
			itemBuilder: (BuildContext context, int index) => Shimmer.fromColors(
				baseColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.8),
				highlightColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.2),
				child: const ShimmerItem(),
			)
		);
	}
}
