import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/data/firebase_services/firestor.dart';
import 'package:instagram/data/model/user_model.dart';
import 'package:instagram/screens/post_screen.dart';
import 'package:instagram/utils/image_cached.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFirestore _firebaseStorage = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int post_lenght = 0;
  bool yourse = false;
  List following = [];
  bool follow = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: FutureBuilder(
                  future: FirebaseFirestor().getUser(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Head(snapshot.data!);
                  },
                ),
              ),
              StreamBuilder(
                  stream: _firebaseStorage
                      .collection('posts')
                      .where('uid', isEqualTo: _auth.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    post_lenght = snapshot.data!.docs.length;
                    return SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        var snap = snapshot.data!.docs[index];
                        return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      PostScreen(snap.data())));
                            },
                            child: ImageCached(snap['postImage']));
                      }, childCount: post_lenght),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget Head(UserModel user) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 10.h),
                child: ClipOval(
                  child: SizedBox(
                      width: 76.w,
                      height: 70.h,
                      child: ImageCached(user.profile)),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 36.w,
                      ),
                      Text(
                        post_lenght.toString(),
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 56.w,
                      ),
                      Text(
                        user.followers.length.toString(),
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 68.w,
                      ),
                      Text(
                        user.following.length.toString(),
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 30.w,
                      ),
                      Text(
                        'Posts',
                        style: TextStyle(fontSize: 13.sp),
                      ),
                      SizedBox(
                        width: 30.w,
                      ),
                      Text(
                        'Followers',
                        style: TextStyle(fontSize: 13.sp),
                      ),
                      SizedBox(
                        width: 30.w,
                      ),
                      Text(
                        'Following',
                        style: TextStyle(fontSize: 13.sp),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  user.username,
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  user.bio,
                  style:
                      TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  alignment: Alignment.center,
                  height: 30.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: const Text('Edit Your Profile'),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              SizedBox(
                width: double.infinity,
                height: 30.h,
                child: const TabBar(
                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.black,
                    indicatorColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Icon(Icons.grid_on),
                      Icon(Icons.video_collection),
                      Icon(Icons.person),
                    ]),
              ),
              SizedBox(
                height: 5.h,
              )
            ],
          ),
        ],
      ),
    );
  }
}
