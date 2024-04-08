import 'package:flutter/material.dart';
import 'package:strideflex_application_1/model/notification.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({Key? key, required this.notiflist}) : super(key: key);

  final NotificationModel notiflist;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 80,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue.shade500,
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(
                      Icons.notification_important,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 250,
                    child: Text(
                      "${notiflist.judul}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: 250,
                    child: Text(
                      "${notiflist.deskripsi}",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text("${notiflist.tanggal}")
                ],
              ),
            )
          ],
        ));
  }
}
