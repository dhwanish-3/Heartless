import 'package:heartless/services/enums/activity_status.dart';
import 'package:heartless/services/enums/activity_type.dart';
import 'package:heartless/services/enums/user_type.dart';
import 'package:heartless/shared/models/activity.dart';
import 'package:heartless/shared/models/app_user.dart';

class StaticData {
  static final AppUser user = AppUser.getInstance(UserType.patient)
    ..name = 'John Doe'
    ..email = 'johndoe2000@gmail.com'
    ..password = 'password'
    ..imageUrl =
        'https://img.freepik.com/free-photo/outdoor-shot-young-caucasian-man-with-beard-relaxing-open-air-surrounded-by-beautiful-mountain-setting-rainforest_273609-1855.jpg?size=626&ext=jpg&ga=GA1.1.553209589.1714435200&semt=ais';

  static final List<Activity> activityList = [
    Activity()
      ..name = 'Peas with Porridge'
      ..description = 'Eat peas with porridge'
      ..time = DateTime(2021, 10, 10, 6, 30)
      ..type = ActivityType.diet
      ..status = ActivityStatus.completed,
    Activity()
      ..name = 'Apixaban'
      ..description = 'take 2.5 milligrams of the drug'
      ..time = DateTime(2021, 10, 10, 12, 30)
      ..type = ActivityType.medicine
      ..status = ActivityStatus.upcoming,
    Activity()
      ..name = 'Evening Walk'
      ..description = 'Walk for 30 minutes'
      ..time = DateTime(2021, 10, 10, 17, 0)
      ..type = ActivityType.exercise
      ..status = ActivityStatus.upcoming,
  ];

  static final List<AppUser> supervisorList = [
    AppUser()
      ..name = 'Dr. Thomas Reus'
      ..imageUrl =
          'https://www.stockvault.net/data/2015/09/01/177580/preview16.jpg',
  ];
}
