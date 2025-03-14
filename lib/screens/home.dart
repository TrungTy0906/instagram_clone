import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/main.dart';
import 'package:instagram/widgets/post_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: Image.asset('assets/images/camera.jpg'),
        title: SizedBox(
          width: 105.w,
          height: 95.h,
          child: Image.asset('assets/images/instagram.jpg'),
        ),
        actions: [
          const Icon(
            Icons.favorite_border_outlined,
            color: Colors.black,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Image.asset('assets/images/send.jpg'),
          )
        ],
        backgroundColor: const Color(0xffFAFAFA),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return PostWidget();
              },
              childCount: 5,
            ),
          ),
        ],
      ),
    );
  }
}
