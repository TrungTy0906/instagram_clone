import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/utils/image_cached.dart';
import 'package:video_player/video_player.dart';

class ReelItem extends StatefulWidget {
  final snapshot;
  const ReelItem(this.snapshot, {super.key});

  @override
  State<ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem> {
  late VideoPlayerController controller;
  bool play = true;
  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.snapshot['reelsVideo']))
      ..initialize().then((value) {
        setState(() {
          controller.setLooping(true);
          controller.setVolume(1);
          controller.play();
        });
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              play = !play;
            });
            if (play) {
              controller.play();
            } else {
              controller.pause();
            }
          },
          child: Container(
            width: double.infinity,
            height: 812.h,
            child: VideoPlayer(controller),
          ),
        ),
        if (!play)
          Center(
            child: CircleAvatar(
              backgroundColor: Colors.white30,
              radius: 35.r,
              child: Icon(
                Icons.play_arrow,
                size: 35.w,
                color: Colors.white,
              ),
            ),
          ),
        Positioned(
          top: 430.h,
          right: 15.w,
          child: Column(
            children: [
              Icon(
                Icons.favorite_border,
                color: Colors.white,
                size: 28.w,
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                '0',
                style: TextStyle(fontSize: 12.sp, color: Colors.white),
              ),
              SizedBox(
                height: 15.h,
              ),
              Icon(
                Icons.comment,
                color: Colors.white,
                size: 28.w,
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                '0',
                style: TextStyle(fontSize: 12.sp, color: Colors.white),
              ),
              SizedBox(
                height: 15.h,
              ),
              Icon(
                Icons.send,
                color: Colors.white,
                size: 28.w,
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                '0',
                style: TextStyle(fontSize: 12.sp, color: Colors.white),
              )
            ],
          ),
        ),
        Positioned(
          bottom: 40.h,
          left: 10.w,
          right: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: SizedBox(
                      height: 35.h,
                      width: 40.w,
                      child: ImageCached(widget.snapshot['profileImage']),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    widget.snapshot['userName'],
                    style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 60.w,
                    height: 25.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Text(
                      'Follow',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                widget.snapshot['caption'],
                style: TextStyle(fontSize: 13.sp, color: Colors.white),
              )
            ],
          ),
        )
      ],
    );
  }
}
