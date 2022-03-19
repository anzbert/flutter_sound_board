// rotate a List
import 'package:flutter/foundation.dart';

List<T> rotateList<T>(List<T> list, int rotateBy) {
  if (list.isEmpty || rotateBy == 0) return list;
  int i = -rotateBy % list.length;
  return list.sublist(i)..addAll(list.sublist(0, i));
}

// create a range of Iterable<int>
Iterable<int> range(int start, int end) {
  return Iterable.generate(end - start, (i) => start + i++);
}

// print only in debug mode:
logd(String text) {
  if (kDebugMode) print(text);
}

logdAll(List<String> textList) {
  if (kDebugMode) {
    for (var text in textList) {
      print(text);
    }
  }
}