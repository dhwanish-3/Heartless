import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/chat_controller.dart';
import 'package:heartless/backend/services/misc/connect_users.dart';
import 'package:heartless/main.dart';
import 'package:heartless/pages/analytics/analytics_page.dart';
import 'package:heartless/pages/auth/forgot_password.dart';
import 'package:heartless/pages/chat/chat_page.dart';
import 'package:heartless/pages/log/daywise_log.dart';
import 'package:heartless/pages/log/health_documents_page.dart';
import 'package:heartless/pages/patient_management/patient_management_profile_page.dart';
import 'package:heartless/pages/profile/edit_profile_page.dart';
import 'package:heartless/pages/profile/extended_timeline_page.dart';
import 'package:heartless/pages/profile/qr_result_page.dart';
import 'package:heartless/pages/schedule/schedule_page.dart';
import 'package:heartless/services/enums/schedule_toggle_type.dart';
import 'package:heartless/services/enums/user_type.dart';
import 'package:heartless/services/utils/qr_scanner.dart';
import 'package:heartless/services/utils/toast_message.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/models/chat.dart';
import 'package:heartless/shared/provider/widget_provider.dart';
import 'package:provider/provider.dart';

class SearchService {
  static String _getOtherUserTypes(UserType userType) {
    if (userType == UserType.doctor) {
      return 'Patient or Nurse';
    } else if (userType == UserType.nurse) {
      return 'Doctor or Patient';
    } else {
      return 'Doctor or Nurse';
    }
  }

  static List<ChatRoom> _getChatRooms(AppUser user, List<AppUser> chatUsers) {
    List<ChatRoom> chatRooms = [];
    chatUsers.forEach((chatUser) async {
      ChatRoom? chatRoom =
          await ChatController().createChatRoom(user, chatUser);
      if (chatRoom != null) {
        chatRooms.add(chatRoom);
      }
    });
    return chatRooms;
  }

  static Future<List<SearchOption>> _getSearchOptionsFromChatUsers(
      AppUser user, List<AppUser> chatUsers) async {
    List<SearchOption> searchOptions = [];
    List<ChatRoom> chatRooms = _getChatRooms(user, chatUsers);

    chatUsers.forEach((chatUser) {
      searchOptions.add(SearchOption(
        name: 'Chat with ' + chatUser.name,
        keywords: ['chat', chatUser.name],
        onTap: () {
          navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
            builder: (context) => ChatPage(
              chatRoom: chatRooms[chatUsers.indexOf(chatUser)],
              chatUser: chatUser,
            ),
          ));
        },
      ));
      if (user.userType == UserType.doctor || user.userType == UserType.nurse) {
        searchOptions.add(SearchOption(
          name: 'View ' + chatUser.name,
          keywords: ['view', 'profile', 'patient', chatUser.name],
          onTap: () {
            navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
              builder: (context) => DoctorNurseSidePatientProfile(
                patient: chatUser,
              ),
            ));
          },
        ));
      }
    });

    // generate a stream of search options
    return searchOptions;
  }

  static Future<List<SearchOption>> generateStaticSearchList(
      AppUser user) async {
    // get the list of chat users
    List<AppUser> chatUsers =
        await ChatController.getChatUsers(user.userType, user.uid);

    List<SearchOption> searchOptions =
        await _getSearchOptionsFromChatUsers(user, chatUsers);

    searchOptions.addAll([
      SearchOption(
        name: 'Scan to add a ' + _getOtherUserTypes(user.userType),
        keywords: ['scan', 'add', _getOtherUserTypes(user.userType)],
        onTap: () {
          QRScanner.scanQRCode().then((value) async {
            AppUser? resultUser = await ConnectUsers.getUserDetails(value);
            ToastMessage Toast = ToastMessage();
            if (resultUser == null) {
              Toast.showError("Qr Code does not belong to a valid user");
            } else if (resultUser.uid == user.uid) {
              Toast.showError("Can't add yourself");
            } else if (resultUser.userType == user.userType) {
              Toast.showError(
                  "Can't add user who is a ${user.userType.capitalisedName}");
            } else {
              await navigatorKey.currentState!.push(
                MaterialPageRoute(
                  builder: (context) => QRResultPage(appUser: resultUser),
                ),
              );
            }
          });
          navigatorKey.currentState!.pop();
        },
      ),
      if (user.userType == UserType.patient)
        SearchOption(
          name: 'Upload Health Documents',
          keywords: ['upload', 'health', 'documents', 'files'],
          onTap: () {
            navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
              builder: (context) => HealthDocumentsPage(
                patientId: user.uid,
              ),
            ));
          },
        ),
      if (user.userType == UserType.patient)
        SearchOption(
          name: 'View Docuemnts',
          keywords: ['files', 'documents', 'pdfs'],
          onTap: () {
            navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
              builder: (context) => HealthDocumentsPage(
                patientId: user.uid,
              ),
            ));
          },
        ),
      if (user.userType == UserType.patient)
        SearchOption(
          name: 'View Today\'s Schedule',
          keywords: ['activity', 'activities', 'schedule'],
          onTap: () {
            navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
              builder: (context) => SchedulePage(
                patient: user,
              ),
            ));
          },
        ),
      if (user.userType == UserType.patient)
        SearchOption(
          name: 'View Today\'s Medication',
          keywords: ['today', 'medication'],
          onTap: () {
            // setting toggle selection to medicine
            WidgetNotifier widgetNotifier =
                navigatorKey.currentContext!.read<WidgetNotifier>();
            widgetNotifier.changeToggleSelection(ScheduleToggleType.medicine);
            navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
              builder: (context) => SchedulePage(
                patient: user,
              ),
            ));
          },
        ),
      if (user.userType == UserType.patient)
        SearchOption(
          name: 'View Today\'s Exercise',
          keywords: ['today', 'exercise'],
          onTap: () {
            // setting toggle selection to exercise
            WidgetNotifier widgetNotifier =
                navigatorKey.currentContext!.read<WidgetNotifier>();
            widgetNotifier.changeToggleSelection(ScheduleToggleType.drill);
            navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
              builder: (context) => SchedulePage(
                patient: user,
              ),
            ));
          },
        ),
      if (user.userType == UserType.patient)
        SearchOption(
          name: 'View Today\'s Diet',
          keywords: ['today', 'diet'],
          onTap: () {
            // setting toggle selection to diet
            WidgetNotifier widgetNotifier =
                navigatorKey.currentContext!.read<WidgetNotifier>();
            widgetNotifier.changeToggleSelection(ScheduleToggleType.diet);
            navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
              builder: (context) => SchedulePage(
                patient: user,
              ),
            ));
          },
        ),
      if (user.userType == UserType.patient)
        SearchOption(
          name: 'View Today\'s Readings',
          keywords: ['today', 'readings'],
          onTap: () {
            navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
              builder: (context) => DayWiseLogPage(
                patient: user,
              ),
            ));
          },
        ),
      if (user.userType == UserType.patient)
        SearchOption(
          name: 'Add a new Reading',
          keywords: ['add', 'new', 'reading'],
          onTap: () {
            navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
              builder: (context) => DayWiseLogPage(
                patient: user,
              ),
            ));
          },
        ),
      if (user.userType == UserType.patient)
        SearchOption(
          name: 'Add a Diary Entry',
          keywords: ['add', 'diary', 'entry'],
          onTap: () {
            navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
              builder: (context) => DayWiseLogPage(
                patient: user,
              ),
            ));
          },
        ),
      if (user.userType == UserType.patient)
        SearchOption(
          name: 'View Diary',
          keywords: ['diary', 'entries'],
          onTap: () {
            navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
              builder: (context) => DayWiseLogPage(
                patient: user,
              ),
            ));
          },
        ),
      if (user.userType == UserType.patient)
        SearchOption(
          name: 'View Timeline',
          keywords: ['timeline', 'entries'],
          onTap: () {
            navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
              builder: (context) => ExtendedTimelinePage(
                patient: user,
              ),
            ));
          },
        ),
      if (user.userType == UserType.patient)
        SearchOption(
          name: 'View Analytics of Medical Readings',
          keywords: ['analytics', 'medical', 'readings'],
          onTap: () {
            // setting toggle selection to readings
            WidgetNotifier widgetNotifier =
                navigatorKey.currentContext!.read<WidgetNotifier>();
            widgetNotifier.setEmailPhoneToggle(false);
            navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
              builder: (context) => AnalyticsPage(
                patientId: user.uid,
              ),
            ));
          },
        ),
      if (user.userType == UserType.patient)
        SearchOption(
          name: 'View Analytics of Activities',
          keywords: ['analytics', 'activities'],
          onTap: () {
            // setting toggle selection to activities
            WidgetNotifier widgetNotifier =
                navigatorKey.currentContext!.read<WidgetNotifier>();
            widgetNotifier.setEmailPhoneToggle(true);
            navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
              builder: (context) => AnalyticsPage(
                patientId: user.uid,
              ),
            ));
          },
        ),
      SearchOption(
        name: 'Change Profile Picture',
        keywords: ['change', 'profile', 'picture'],
        onTap: () {
          navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
            builder: (context) => EditProfilePage(
              user: user,
            ),
          ));
        },
      ),
      SearchOption(
        name: 'Change Password',
        keywords: ['change', 'password'],
        onTap: () {
          navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
            builder: (context) => ForgotPasswordPage(),
          ));
        },
      ),
    ]);

    // generate a stream of search options
    return searchOptions;
  }

  static List<SearchOption> globalSearchOptions = [];
  static void initGlobalSearchOptions(AppUser user) async {
    globalSearchOptions = await generateStaticSearchList(user);
  }
}

class SearchOption {
  final String name;
  List<String> keywords = [];
  final void Function()? onTap;
  int priority = 0;

  SearchOption(
      {required this.name, required this.onTap, required this.keywords});
}
