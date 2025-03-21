import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/data/firebase_services/firestor.dart';
import 'package:instagram/main.dart';
import 'package:instagram/utils/image_cached.dart';

class Comment extends StatefulWidget {
  String type;
  String uid;
  Comment(this.type, this.uid, {super.key});

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  final comment = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25.r),
        topRight: Radius.circular(25.r),
      ),
      child: Container(
        color: Colors.white,
        height: 300.h,
        child: Stack(
          children: [
            Positioned(
              top: 8.h,
              left: 124.w,
              child: Container(
                width: 100.w,
                height: 3.h,
                color: Colors.black,
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection(widget.type)
                    .doc(widget.uid)
                    .collection('comments')
                    .snapshots(),
                builder: (context, snapshot) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }
                        return comment_item(snapshot.data!.docs[index].data());
                      },
                      itemCount: snapshot.data == null
                          ? 0
                          : snapshot.data!.docs.length,
                    ),
                  );
                }),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 60.h,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 45.h,
                        width: 260.w,
                        child: TextField(
                          controller: comment,
                          decoration: InputDecoration(
                            hintText: 'Add a comment',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            if (comment.text.isNotEmpty) {
                              FirebaseFirestor().Comments(
                                comment: comment.text,
                                type: widget.type,
                                uidd: widget.uid,
                              );
                            }
                            setState(() {
                              comment.clear();
                            });
                          },
                          child: Icon(Icons.send))
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget comment_item(final snapshot) {
    return ListTile(
      leading: SizedBox(
        width: 35.w,
        height: 35.h,
        child: ClipOval(
          child: ImageCached(
            snapshot['profileImage'],
          ),
        ),
      ),
      title: Text(
        snapshot['userName'],
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        snapshot['comment'],
        style: TextStyle(
          fontSize: 13.sp,
          color: Colors.black,
        ),
      ),
    );
  }
}
