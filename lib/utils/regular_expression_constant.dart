class RegularExpressionConstant {
  RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  RegExp khmerNameRegExp =
      RegExp(r'^[ក-អ ា-ោះ្់៊ឧឫឳឱឳឩឪ៌​ឥឯឭឮឬ ៉ៈំាំ័៍ ៌ៅ៏ ៌ៗ៍័៏៎ឦាំឰ]+$');
  RegExp englishNameRegexp = RegExp(r'^[a-zA-Z\s]+$');

  RegExp phoneRegexp = RegExp(r'^\d{3} \d{3} \d{3,4}$');
  RegExp emailRegexp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  RegExp khmerOnlyRegexp = RegExp(r'^[\u1780-\u17FF\s]+$');
  RegExp englishOnlyRegexp = RegExp(r'^[a-zA-Z1-9\s]+$');

  RegExp englishWithSymbolWithNumber =
      RegExp(r'^[a-zA-Z0-9!@#$%^&*()_|+{}\[\]:;<>,.?~\\-]+$');
  RegExp url = RegExp(r'^(https?|ftp):\/\/[^\s\/$.?#].[^\s]*$');

  RegExp passwordRegexp = RegExp(r'^.{6,50}$');
  RegExp dateAndTimeRegExp = RegExp(r'^\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}$');
  RegExp searchPlateRegExp = RegExp(
      r"^[1-6](?![\d-])([a-zA-Z]{0,2}(?![\dA-Z])-?\d{0,4})$",
      caseSensitive: false);

  RegExp plateRegex = RegExp(r"([0-9]{1})([A-Z]{0,2})([-]{1})([0-9]{4})");

  RegExp plateRegexWeb =
      RegExp(r"^[1-6](?![\\d-])([a-zA-Z]{0,2}(?![\\dA-Z])-?\\d{0,4})$");
}
