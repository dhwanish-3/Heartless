enum Status { completed, upcoming, incomplete }

class Medicine {
  String name = '';
  String time = '';
  int intakePerDay = 3;
  String description = '';
  Status status = Status.upcoming;

  Medicine();
}

class Excercise {
  String name = '';
  String time = '';
  int intakePerDay = 3;
  String description = '';
  Status status = Status.upcoming;

  Excercise();
}

class Diet {
  String name = '';
  String time = '';
  int intakePerDay = 3;
  String description = '';
  Status status = Status.upcoming;

  Diet();
}
