import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/data/firebase_services/firestor.dart';
import 'package:instagram/data/firebase_services/storage.dart';

class AddPostTextScreen extends StatefulWidget {
  File _file;
  AddPostTextScreen(this._file, {super.key});

  @override
  State<AddPostTextScreen> createState() => _AddPostTextScreenState();
}

class _AddPostTextScreenState extends State<AddPostTextScreen> {
  final caption = TextEditingController();
  final location = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'New post',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  String post_url = await StorageMethod()
                      .uploadImageToStorage('post', widget._file);
                  await FirebaseFirestor().CreatePost(
                      postImage: post_url,
                      caption: caption.text,
                      location: location.text);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Share',
                  style: TextStyle(color: Colors.blue, fontSize: 15.sp),
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      child: Row(
                        children: [
                          Container(
                            width: 65.w,
                            height: 65.h,
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              image: DecorationImage(
                                  image: FileImage(widget._file),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          SizedBox(
                            width: 240.w,
                            height: 60.h,
                            child: TextField(
                              controller: caption,
                              decoration: const InputDecoration(
                                hintText: 'Write a caption...',
                                border: InputBorder.none,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: SizedBox(
                        width: 240.w,
                        height: 60.h,
                        child: TextField(
                          controller: location,
                          decoration: const InputDecoration(
                            hintText: 'Add location',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    )
                  ],
                )),
    );
  }
}
