import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:kariyer_hedefim/Screens/GirisEkranı.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // English
        const Locale('tr', 'TR'), // Turkish
      ],
      title: "LOGİN",
      debugShowCheckedModeBanner: false,
      home: GirisEkrani(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class TrCupertinoLocalizations extends CupertinoLocalizations {
  TrCupertinoLocalizations();

  @override
  String get alertDialogLabel => 'Uyarı';

  @override
  String get anteMeridiemAbbreviation => 'ÖÖ';

  // Add more localized strings as necessary...

  static const LocalizationsDelegate<CupertinoLocalizations> delegate =
      _TrCupertinoLocalizationsDelegate();

  @override
  // TODO: implement copyButtonLabel
  String get copyButtonLabel => throw UnimplementedError();

  @override
  // TODO: implement cutButtonLabel
  String get cutButtonLabel => throw UnimplementedError();

  @override
  // TODO: implement datePickerDateOrder
  DatePickerDateOrder get datePickerDateOrder => throw UnimplementedError();

  @override
  // TODO: implement datePickerDateTimeOrder
  DatePickerDateTimeOrder get datePickerDateTimeOrder =>
      throw UnimplementedError();

  @override
  String datePickerDayOfMonth(int dayIndex) {
    // TODO: implement datePickerDayOfMonth
    throw UnimplementedError();
  }

  @override
  String datePickerHour(int hour) {
    // TODO: implement datePickerHour
    throw UnimplementedError();
  }

  @override
  String? datePickerHourSemanticsLabel(int hour) {
    // TODO: implement datePickerHourSemanticsLabel
    throw UnimplementedError();
  }

  @override
  String datePickerMediumDate(DateTime date) {
    // TODO: implement datePickerMediumDate
    throw UnimplementedError();
  }

  @override
  String datePickerMinute(int minute) {
    // TODO: implement datePickerMinute
    throw UnimplementedError();
  }

  @override
  String? datePickerMinuteSemanticsLabel(int minute) {
    // TODO: implement datePickerMinuteSemanticsLabel
    throw UnimplementedError();
  }

  @override
  String datePickerMonth(int monthIndex) {
    // TODO: implement datePickerMonth
    throw UnimplementedError();
  }

  @override
  String datePickerYear(int yearIndex) {
    // TODO: implement datePickerYear
    throw UnimplementedError();
  }

  @override
  // TODO: implement modalBarrierDismissLabel
  String get modalBarrierDismissLabel => throw UnimplementedError();

  @override
  // TODO: implement pasteButtonLabel
  String get pasteButtonLabel => throw UnimplementedError();

  @override
  // TODO: implement postMeridiemAbbreviation
  String get postMeridiemAbbreviation => throw UnimplementedError();

  @override
  // TODO: implement searchTextFieldPlaceholderLabel
  String get searchTextFieldPlaceholderLabel => throw UnimplementedError();

  @override
  // TODO: implement selectAllButtonLabel
  String get selectAllButtonLabel => throw UnimplementedError();

  @override
  String tabSemanticsLabel({required int tabIndex, required int tabCount}) {
    // TODO: implement tabSemanticsLabel
    throw UnimplementedError();
  }

  @override
  String timerPickerHour(int hour) {
    // TODO: implement timerPickerHour
    throw UnimplementedError();
  }

  @override
  String? timerPickerHourLabel(int hour) {
    // TODO: implement timerPickerHourLabel
    throw UnimplementedError();
  }

  @override
  // TODO: implement timerPickerHourLabels
  List<String> get timerPickerHourLabels => throw UnimplementedError();

  @override
  String timerPickerMinute(int minute) {
    // TODO: implement timerPickerMinute
    throw UnimplementedError();
  }

  @override
  String? timerPickerMinuteLabel(int minute) {
    // TODO: implement timerPickerMinuteLabel
    throw UnimplementedError();
  }

  @override
  // TODO: implement timerPickerMinuteLabels
  List<String> get timerPickerMinuteLabels => throw UnimplementedError();

  @override
  String timerPickerSecond(int second) {
    // TODO: implement timerPickerSecond
    throw UnimplementedError();
  }

  @override
  String? timerPickerSecondLabel(int second) {
    // TODO: implement timerPickerSecondLabel
    throw UnimplementedError();
  }

  @override
  // TODO: implement timerPickerSecondLabels
  List<String> get timerPickerSecondLabels => throw UnimplementedError();

  @override
  // TODO: implement todayLabel
  String get todayLabel => throw UnimplementedError();
}

class _TrCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _TrCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'tr';

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture<TrCupertinoLocalizations>(TrCupertinoLocalizations());

  @override
  bool shouldReload(_TrCupertinoLocalizationsDelegate old) => false;
}
