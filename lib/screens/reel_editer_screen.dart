import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/data/firebase_services/firestor.dart';
import 'package:instagram/data/firebase_services/storage.dart';
import 'package:video_player/video_player.dart';

class ReelEditerScreen extends StatefulWidget {
  File videoFile;
  ReelEditerScreen(this.videoFile, {super.key});

  @override
  State<ReelEditerScreen> createState() => _ReelEditerScreenState();
}

class _ReelEditerScreenState extends State<ReelEditerScreen> {
  late VideoPlayerController controller;
  final TextEditingController caption = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
        controller.setLooping(true);
        controller.setVolume(1.0);
        controller.play();
      });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'New Reels',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SafeArea(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                    color: Colors.black,
                  ))
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.w),
                          child: Container(
                            width: 270.w,
                            height: 420.h,
                            child: controller.value.isInitialized
                                ? AspectRatio(
                                    aspectRatio: controller.value.aspectRatio,
                                    child: VideoPlayer(controller),
                                  )
                                : const CircularProgressIndicator(),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          height: 60.h,
                          width: 280.w,
                          child: TextField(
                            controller: caption,
                            maxLines: 10,
                            decoration: InputDecoration(
                              hintText: 'Write a caption...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 45.h,
                              width: 150.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Text(
                                'Save draft',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                String Reels_URL = await StorageMethod()
                                    .uploadImageToStorage(
                                        'Reels', widget.videoFile);
                                await FirebaseFirestor().CreateReels(
                                    video: Reels_URL, caption: caption.text);
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 45.h,
                                width: 150.w,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Text(
                                  'Share',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )));
  }
}
