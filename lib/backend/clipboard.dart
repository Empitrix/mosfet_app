import 'package:flutter/services.dart';

class CCB {
	static Future<void> copy(String text)async{
		await Clipboard.setData(ClipboardData(text: text.toString()));
	}
	static Future<String> paste()async{
		final clipboardData = await Clipboard
			.getData(Clipboard.kTextPlain);
		String? clipboardText = clipboardData?.text;
		if(clipboardText.runtimeType != Null){
			return clipboardText!.replaceAll("\n", " ");
		}else{
			return "";
		}
	}
}
