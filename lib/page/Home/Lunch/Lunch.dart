import 'package:intl/intl.dart';

class Lunch {
  /// 하루의 점심 정보를 담고있는 객체

  String YMD;
  List<String> dish;
  List<String> origin;
  String calorie;
  List<String> nutrient;

  Lunch({
    required this.YMD,
    required this.dish,
    required this.origin,
    required this.calorie,
    required this.nutrient,
  });

  List<String> get menu {
    if (dish.isEmpty) {
      return ["급식정보가 없습니다."];
    }

    return List.generate(
        dish.length, (index) => LunchText.cleanText(dish[index]));
  }

  String get date {
    if (YMD == "") {
      return "";
    }
    DateTime dateTime = DateTime.parse(YMD);

    // 이름 구하기
    String st = DateFormat('MM월 dd일').format(dateTime);
    String weekday = DateFormat('E', 'ko').format(dateTime);
    String title = "$st $weekday요일";

    return title;
  }


  factory Lunch.noData(String date) {
    return Lunch(
      YMD: date,
      dish: [],
      origin: [],
      nutrient: [],
      calorie: "",
    );
  }

  factory Lunch.blank() {
    return Lunch(
      YMD: "",
      dish: List.generate(6, (index) => ""),
      origin: [],
      nutrient: [],
      calorie: "",
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "date": date,
      "menu": menu,
      "origin": origin,
      "calorie": calorie,
      "nutrient": nutrient,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class LunchText {
  static cleanText(String text) {
    String cleanedData = text.replaceAll("북고", "");

    for (int k = 20; k > 0; k--) {
      cleanedData = cleanedData.replaceAll("$k.", "");
    }

    cleanedData = cleanedData.replaceAll("-", "");
    cleanedData = cleanedData.replaceAll("_", "");
    cleanedData = cleanedData.replaceAll("()", "");

    cleanedData = cleanedData.replaceAll(" ", "");

    // if (UserProfile.currentUser.schoolName == "도당고등학교") {
    //   cleanedData = cleanedData.replaceAll("1", "");
    // }
    cleanedData = cleanedData.replaceAll("1 ", "");

    return cleanedData;
  }
}

