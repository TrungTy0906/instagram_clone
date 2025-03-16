import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/data/firebase_services/firestor.dart';
import 'package:instagram/main.dart';
import 'package:instagram/utils/image_cached.dart';
import 'package:instagram/widgets/comment.dart';
import 'package:instagram/widgets/like.dart';

class PostWidget extends StatefulWidget {
  final snapshot;
  PostWidget(this.snapshot, {super.key});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool isAnimating = false;
  String user = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = _auth.currentUser!.uid;
  }

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 375.w,
          height: 54.h,
          color: Colors.white,
          child: Center(
            child: ListTile(
              leading: ClipOval(
                child: SizedBox(
                  width: 35.w,
                  height: 35.h,
                  child: ImageCached(widget.snapshot['profileImage']),
                ),
              ),
              title: Text(
                widget.snapshot['userName'],
                style: TextStyle(
                  fontSize: 13.sp,
                ),
              ),
              subtitle: Text(
                widget.snapshot['location'],
                style: TextStyle(fontSize: 11.sp),
              ),
              trailing: Icon(Icons.more_horiz),
            ),
          ),
        ),
        GestureDetector(
          onDoubleTap: () {
            FirebaseFirestor().like(
                like: widget.snapshot['like'],
                type: 'posts',
                uid: user,
                postId: widget.snapshot['postId']);
            setState(() {
              isAnimating = true;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 375.w,
                height: 375.h,
                child: ImageCached(widget.snapshot['postImage']),
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: isAnimating ? 1 : 0,
                child: LikeAnimation(
                  child: Icon(
                    Icons.favorite,
                    size: 100.w,
                    color: Colors.red,
                  ),
                  isAnimating: isAnimating,
                  duration: Duration(milliseconds: 400),
                  iconlike: false,
                  End: () {
                    setState(() {
                      isAnimating = false;
                    });
                  },
                ),
              )
            ],
          ),
        ),
        Container(
          width: 375.w,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 14.h,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 14.w,
                  ),
                  LikeAnimation(
                      child: IconButton(
                          onPressed: () {
                            FirebaseFirestor().like(
                                like: widget.snapshot['like'],
                                type: 'posts',
                                uid: user,
                                postId: widget.snapshot['postId']);
                          },
                          icon: Icon(
                            widget.snapshot['like'].contains(user)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: widget.snapshot['like'].contains(user)
                                ? Colors.red
                                : Colors.black,
                            size: 30,
                          )),
                      isAnimating: widget.snapshot['like'].contains(user)),
                  SizedBox(
                    width: 17.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      showBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: DraggableScrollableSheet(
                              maxChildSize: 0.6,
                              initialChildSize: 0.5,
                              minChildSize: 0.2,
                              builder: (context, ScrollController) {
                                return Comment(
                                    widget.snapshot['postId'], 'posts');
                              },
                            ),
                          );
                        },
                      );
                    },
                    child: Image.asset(
                      'assets/images/comment.webp',
                      height: 28.h,
                    ),
                  ),
                  SizedBox(
                    width: 17.w,
                  ),
                  Image.asset(
                    'assets/images/send.jpg',
                    height: 28.h,
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 15.w),
                    child: Image.asset(
                      'assets/images/save.png',
                      height: 28,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 22.w,
            top: 5.h,
            bottom: 5.h,
          ),
          child: Row(
            children: [
              Text(
                widget.snapshot['like'].length.toString(),
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Row(
            children: [
              Text(
                widget.snapshot['userName'] + '  ',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
              ),
              Text(
                widget.snapshot['caption'],
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15, top: 20, bottom: 5),
          child: Text(
            formatDate(
                widget.snapshot['time'].toDate(), [yyyy, '-', mm, '-', dd]),
            style: TextStyle(fontSize: 11.sp, color: Colors.grey),
          ),
        )
      ],
    );
  }
}
