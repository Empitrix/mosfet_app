import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

Map<String, dynamic> _parseNode(dom.Node node) {
	if (node is dom.Element) {
		Map<String, dynamic> elementData = {
			'tag': node.localName,
			'attributes': {},
			'children': [],
		};

		node.attributes.forEach((attrName, attrValue) {
			elementData['attributes'][attrName] = attrValue;
		});

		for (dom.Node childNode in node.nodes) {
			elementData['children'].add(_parseNode(childNode));
		}

		return elementData;
	} else if (node is dom.Text) {
		return {'text': node.text};
	}

	return {};
}

Map htmlToJson(String htmlInput) {
	dom.Document document = parser.parse(htmlInput);
	return _parseNode(document.body!);
}

