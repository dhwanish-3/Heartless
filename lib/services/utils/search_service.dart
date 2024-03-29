import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/chat_controller.dart';
import 'package:heartless/main.dart';
import 'package:heartless/pages/chat/chat_page.dart';
import 'package:heartless/services/enums/user_type.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/models/chat.dart';

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
          navigatorKey.currentState!.push(MaterialPageRoute(
            builder: (context) => ChatPage(
              chatRoom: chatRooms[chatUsers.indexOf(chatUser)],
              chatUser: chatUser,
            ),
          ));
        },
      ));
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
        onTap: () {},
      ),
      SearchOption(
        name: 'Upload Health Documents',
        keywords: ['upload', 'health', 'documents', 'files'],
        onTap: () {},
      ),
      SearchOption(
        name: 'View Docuemnts',
        keywords: ['files', 'documents', 'pdfs'],
        onTap: () {},
      ),
      SearchOption(
        name: 'View Today\'s Schedule',
        keywords: ['activity', 'activities', 'schedule'],
        onTap: () {},
      ),
      SearchOption(
        name: 'View Today\'s Medication',
        keywords: ['today', 'medication'],
        onTap: () {},
      ),
      SearchOption(
        name: 'View Today\'s Exercise',
        keywords: ['today', 'exercise'],
        onTap: () {},
      ),
      SearchOption(
        name: 'View Today\'s Diet',
        keywords: ['today', 'diet'],
        onTap: () {},
      ),
      SearchOption(
        name: 'View Today\'s Readings',
        keywords: ['today', 'readings'],
        onTap: () {},
      ),
      SearchOption(
        name: 'Add a new Reading',
        keywords: ['add', 'new', 'reading'],
        onTap: () {},
      ),
      SearchOption(
        name: 'Add a Diary Entry',
        keywords: ['add', 'diary', 'entry'],
        onTap: () {},
      ),
      SearchOption(
        name: 'View Diary',
        keywords: ['diary', 'entries'],
        onTap: () {},
      ),
      SearchOption(
        name: 'View Timeline',
        keywords: ['timeline', 'entries'],
        onTap: () {},
      ),
      SearchOption(
        name: 'View Analytics of Medical Readings',
        keywords: ['analytics', 'medical', 'readings'],
        onTap: () {},
      ),
      SearchOption(
        name: 'View Analytics of Activities',
        keywords: ['analytics', 'activities'],
        onTap: () {},
      ),
      SearchOption(
        name: 'Change Profile Picture',
        keywords: ['change', 'profile', 'picture'],
        onTap: () {},
      ),
      SearchOption(
        name: 'Change Password',
        keywords: ['change', 'password'],
        onTap: () {},
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
