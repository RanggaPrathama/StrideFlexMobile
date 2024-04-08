import 'package:flutter/material.dart';
import 'package:strideflex_application_1/Theme.dart';
import 'package:strideflex_application_1/model/notification.dart';
import 'package:strideflex_application_1/screen/notification/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  static String routeName = "/notification";

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(6.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.zero,
                  foregroundColor: Colors.blue,
                  elevation: 0,
                  backgroundColor: Colors.white),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
          title: Text(
            "Notifications",
            style: headingText,
          ),
        ),
        body: SafeArea(
            child: ListView.builder(
          itemCount: notif.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Dismissible(
                key: Key(notif[index].idnotif.toString()),
                background: Container(
                  padding: EdgeInsets.only(right: 20),
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  setState(() {
                    notif.removeAt(index);
                  });
                },
                child: NotificationCard(notiflist: notif[index])),
          ),
        )));
  }
}
