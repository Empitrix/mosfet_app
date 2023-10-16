import 'package:html/dom.dart';


Map<String, dynamic> parseNode(Node node) {
	if (node is Element) {
		Map<String, dynamic> elementData = {
			'tag': node.localName,
			'attributes': {},
			'children': [],
		};

		node.attributes.forEach((attrName, attrValue) {
			elementData['attributes'][attrName] = attrValue;
		});

		for (var childNode in node.nodes) {
			elementData['children'].add(parseNode(childNode));
		}

		return elementData;
	} else if (node is Text) {
		return {'text': node.text};
	}

	return {};
}