import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:heartless/pages/patient_management/patient_management_profile_page.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:provider/provider.dart';

class UsersListPage extends StatelessWidget {
  final AppUser appUser;
  final Future<List<AppUser>>? usersFuture;
  final List<AppUser> users;
  final bool isPatientList;
  const UsersListPage({
    super.key,
    this.users = const [],
    this.usersFuture,
    required this.appUser,
    this.isPatientList = true,
  });

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: isPatientList
            ? const Text('Your Patients ')
            : const Text('Doctors and Nurses'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: usersFuture == null
              ? _buildUsersList(
                  users,
                  context,
                  isPatientList,
                )
              : FutureBuilder<List<AppUser>>(
                  future: usersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).shadowColor,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.data!.isEmpty) {
                      return Center(
                        child: Text('No users found'),
                      );
                    } else {
                      return _buildUsersList(
                        snapshot.data!,
                        context,
                        isPatientList,
                      );
                    }
                  },
                ),
        ),
      ),
    );
  }

  Column _buildUsersList(
      List<AppUser> snapshot, BuildContext context, bool isPatientList) {
    return Column(
      children: snapshot.map((user) {
        return Container(
          height: 56,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          margin: const EdgeInsets.only(
            bottom: 10,
            right: 20,
            left: 20,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).secondaryHeaderColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).highlightColor,
                offset: const Offset(0, 0.5),
                blurRadius: 1,
                spreadRadius: 0,
              ),
            ],
          ),
          child: InkWell(
            onLongPress: () {
              if (!isPatientList) {
                return;
              }
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Delete User'),
                      content:
                          Text('Are you sure you want to remove this user?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            //todo delete user
                          },
                          child: Text('Delete'),
                        ),
                      ],
                    );
                  });
            },
            onTap: () {
              if (!isPatientList) {
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorNurseSidePatientProfile(
                    patient: user,
                  ),
                ),
              );
            },
            child: Row(
              children: [
                CachedNetworkImage(
                  imageUrl: user.imageUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                    user.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).shadowColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
