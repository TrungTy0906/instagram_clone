import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram/screens/post_screen.dart';
import 'package:instagram/utils/image_cached.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final search = TextEditingController();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool show = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: CustomScrollView(
        slivers: [
          SearchBox(),
          if (!show)
            StreamBuilder(
              stream: _firebaseFirestore.collection('posts').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final snap = snapshot.data!.docs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PostScreen(
                              snap.data(),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                        ),
                        child: ImageCached(snap['postImage']),
                      ),
                    );
                  }, childCount: snapshot.data!.docs.length),
                  gridDelegate: SliverQuiltedGridDelegate(
                    crossAxisCount: 3,
                    mainAxisSpacing: 3,
                    crossAxisSpacing: 3,
                    pattern: [
                      const QuiltedGridTile(2, 1),
                      const QuiltedGridTile(2, 2),
                      const QuiltedGridTile(1, 1),
                      const QuiltedGridTile(1, 1),
                      const QuiltedGridTile(1, 1),
                    ],
                  ),
                );
              },
            ),
          if (!show)
            StreamBuilder(
              stream: _firebaseFirestore.collection('posts').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                  final snap = snapshot.data!.docs[index];
                  return Column(
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24.r,
                            backgroundImage: NetworkImage(snap['profile']),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          Text(snap['userName']),
                        ],
                      )
                    ],
                  );
                }, childCount: snapshot.data!.docs.length));
              },
            ),
        ],
      )),
    );
  }

  SliverToBoxAdapter SearchBox() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Container(
          width: double.infinity,
          height: 36.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.all(
              Radius.circular(10.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              children: [
                const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                    child: TextField(
                  onChanged: (value) {
                    setState(() {
                      if (value.length > 0) {
                        show = true;
                      } else {
                        show = false;
                      }
                    });
                  },
                  controller: search,
                  decoration: InputDecoration(
                    hintText: 'Search User',
                    hintStyle: TextStyle(color: Colors.black),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
