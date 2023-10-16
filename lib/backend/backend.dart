import 'package:intl/intl.dart';

String vStr(String input){
	/* Valid String */
	return input.toLowerCase().trim();
}


String getFormattedCurrentDate(){
	List<String> monthOrder = [
		'January',
		'February',
		'March',
		'April',
		'May',
		'June',
		'July',
		'August',
		'September',
		'October',
		'November',
		'December',
	];
	var now = DateTime.now();
	var formatter = DateFormat('MM-dd-yyyy');
	String formatted = formatter.format(now);
	String m = monthOrder[int.parse(formatted.split("-")[0]) - 1];
	return "$m ${formatted.split("-")[1]} ${formatted.split("-")[2]}";
}


