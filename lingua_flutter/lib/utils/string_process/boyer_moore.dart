import 'dart:math';

int boyerMoore(String text, String pattern) {
  int n = text.length;
  int m = pattern.length;
  Map<String, int> badChar = {};

  // 나쁜 문자 테이블 생성
  for (int i = 0; i < m; i++) {
    badChar[pattern[i]] = i;
  }

  int s = 0; // s는 텍스트에 대한 패턴의 시프트
  while (s <= (n - m)) {
    int j = m - 1;

    // 패턴의 오른쪽부터 왼쪽까지 문자를 비교
    while (j >= 0 && pattern[j] == text[s + j]) {
      j--;
    }

    // 패턴이 일치하는 경우
    if (j < 0) {
      return s; // 일치하는 위치 반환
      //s += (s + m < n) ? m - badChar[text[s + m]] : 1; // 다음 가능한 시프트
    } else {
      s += max(1, j - (badChar[text[s + j]] ?? -1));
    }
  }

  return -1; // 패턴이 없는 경우
}
