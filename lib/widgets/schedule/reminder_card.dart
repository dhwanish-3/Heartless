import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:heartless/backend/controllers/activity_controller.dart';
import 'package:heartless/services/date/date_service.dart';
import 'package:heartless/services/enums/activity_status.dart';
import 'package:heartless/services/enums/activity_type.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/shared/models/activity.dart';
import 'package:heartless/shared/models/app_user.dart';

//* type :- medicine 0 : food 1 : exercise 2
//* status :- active 0: done 1: missed 2

class ReminderCard extends StatelessWidget {
  final AppUser patient;
  final Activity activity;

  //! to be taken from provider
  final bool isPatient;
  const ReminderCard({
    super.key,
    required this.activity,
    required this.patient,
    this.isPatient = true,
  });

  void _onDisimissed() {
    ActivityController().markAsCompleted(activity, patient.uid);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = 0.9 * screenWidth;
    String buttonUrl = activity.status.icon;
    String trailLabel = (activity.status == ActivityStatus.upcoming)
        ? 'Swipe right to mark as done >>'
        : '';
    String imageUrl = activity.type.imageUrl;
    Color bgColor = activity.type.color;
    // bgColor = Constants.primaryColor.withOpacity(0.1);

    return Slidable(
      startActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          // only show the completed button if the activity is upcoming
          activity.status == ActivityStatus.upcoming
              ? SlidableAction(
                  onPressed: (context) => _onDisimissed(),
                  label: "Completed",
                  icon: Icons.check,
                  backgroundColor: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                )
              : Container(),
        ],
      ),
      child: Builder(
        builder: (context) => GestureDetector(
          onTap: () {
            final slidable = Slidable.of(context)!;
            final isClosed =
                slidable.actionPaneType.value == ActionPaneType.none;
            if (!isClosed) {
              slidable.close();
            } else {
              slidable.openStartActionPane();
            }
          },
          child: Container(
            height: 85,
            width: containerWidth,
            decoration: BoxDecoration(
              // color: Theme.of(context).canvasColor,
              color: bgColor,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).highlightColor,
                  spreadRadius: 0,
                  blurRadius: 0.5,
                  offset: Offset(0, 1),
                ),
              ],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.all(12),
                    // padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.contain,
                    )),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            // padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                            height: 50,
                            //!have to be made responsice
                            width: containerWidth - 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    activity.name,
                                    textAlign: TextAlign.left,
                                    // style: Theme.of(context).textTheme.bodyLarge,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(activity.description,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                      )),
                                ),
                              ],
                            ),
                          ),
                          isPatient
                              ? Container(
                                  width: 33,
                                  height: 33,
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 0, 12, 0),
                                  // padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: Constants.notifColor,
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(17)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 0,
                                        blurRadius: 2,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(buttonUrl))
                              : Container()
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateService.getFormattedTime(activity.time),
                            // style: Theme.of(context).textTheme.headlineSmall,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          isPatient
                              ? Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: Text(
                                    trailLabel,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                    ),
                                  ),
                                )
                              : Container()
                        ],
                      )
                    ],
                  ),
                ),
                !isPatient
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              ActivityController().deleteActivity(activity);
                            },
                            child: Container(
                                height: 33,
                                width: 33,
                                margin: const EdgeInsets.fromLTRB(0, 5, 12, 0),
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    opacity: 0.8,
                                    scale: 2,
                                    image:
                                        AssetImage('assets/Icons/delete.png'),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              //todo edit activity
                            },
                            child: Container(
                                height: 33,
                                width: 33,
                                margin: const EdgeInsets.fromLTRB(0, 0, 10, 5),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(17)),
                                  image: DecorationImage(
                                    scale: 1.3,
                                    opacity: 0.6,
                                    image: AssetImage('assets/Icons/edit.png'),
                                  ),
                                )),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
