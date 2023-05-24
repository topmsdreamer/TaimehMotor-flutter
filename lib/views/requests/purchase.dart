import 'package:arionmotor/views/requests/request_object_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Purchases extends StatefulWidget {
  const Purchases({super.key});

  @override
  State<Purchases> createState() => _Purchases();
}

class _Purchases extends State<Purchases> {

  bool loading = true;
  CollectionReference  requests = FirebaseFirestore.instance.collection('requests');
  List<RequestObject> requestList = [];
  List<Widget> requestWidgetList = [];
  List<RequestObject> tempList = [];

  getRequestList() async {
    if (loading) {
      tempList = [];
      await requests
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if (doc['type'] == 'purchase') {
            tempList.add(
                RequestObject(
                  id: doc.id,
                  request_date: doc["request_date"] ?? '2023-03-01',
                  type: doc["type"] ?? '',
                  user_id: doc["user_id"] ?? '',
                )
            );
          }
        });
      });
      setState(() {
        requestList = tempList;
        loading = false;
      });
    }
  }

  void initState(){
    getRequestList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          const SizedBox(
            height: 6,
          ),
          loading? Container():
          Expanded(
            child:ListView(
              children:requestWidgetList,
            ),
          )
        ]);
  }
}
