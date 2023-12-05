class Validators {
  static bool isValidEmail(String email) {
    final RegExp regex =
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$");
    return regex.hasMatch(email);
  }

  static bool isValidPhoneNumber(String phoneNo) {
    final RegExp regex = RegExp(r"^(01[016789])([0-9]{4})([0-9]{4})$"); // 휴대전화

/*

01[016789]: 01로 시작하고, 그 뒤에 0, 1, 6, 7, 8, 9 중 하나가 오는 숫자 조합을 나타냅니다. 이는 대한민국의 모바일 전화번호의 시작 부분을 나타냅니다.

([0-9]{3,4}): 그 다음에는 3자리 또는 4자리의 숫자가 옵니다. 이는 전화번호의 중간 부분을 나타냅니다.

([0-9]{4}): 마지막으로 4자리의 숫자가 옵니다. 이는 전화번호의 마지막 부분을 나타냅니다.

*/
    //
    // final RegExp regex2 =
    //     RegExp(r"^(0[2-9]{1,2})-?([0-9]{3,4})-?([0-9]{4})$"); // 일반 전화

    // return regex.hasMatch(phoneNo) || regex2.hasMatch(phoneNo);
    return regex.hasMatch(phoneNo);
  }
}
