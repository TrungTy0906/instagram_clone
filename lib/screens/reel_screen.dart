import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/widgets/reel_item.dart';

class ReelScreen extends StatefulWidget {
  const ReelScreen({super.key});

  @override
  State<ReelScreen> createState() => _ReelScreenState();
}

class _ReelScreenState extends State<ReelScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: StreamBuilder(
              stream: _firestore
                  .collection('reels')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                return PageView.builder(
                  scrollDirection: Axis.vertical,
                  controller:
                      PageController(initialPage: 0, viewportFraction: 1),
                  itemBuilder: (context, index) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    return ReelItem(snapshot.data!.docs[index].data());
                  },
                  itemCount:
                      snapshot.data == null ? 0 : snapshot.data!.docs.length,
                );
              })),
    );
  }
}
