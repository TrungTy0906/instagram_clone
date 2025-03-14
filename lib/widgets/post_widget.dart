import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/main.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({super.key});

  @override
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
                  child: Image.asset('assets/images/person.png'),
                ),
              ),
              title: Text(
                'username',
                style: TextStyle(
                  fontSize: 13.sp,
                ),
              ),
              subtitle: Text(
                'location',
                style: TextStyle(fontSize: 11.sp),
              ),
              trailing: Icon(Icons.more_horiz),
            ),
          ),
        ),
        Container(
          width: 375.w,
          height: 375.h,
          child: Image.asset(
            'assets/images/post.jpg',
            fit: BoxFit.cover,
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
                  Icon(
                    Icons.favorite_outline,
                    size: 25.w,
                  ),
                  SizedBox(
                    width: 17.w,
                  ),
                  Image.asset(
                    'assets/images/comment.webp',
                    height: 28.h,
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
                '0',
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
                'username' + ' ',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
              ),
              Text(
                'caption',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15, top: 20, bottom: 5),
          child: Text(
            'dateformat',
            style: TextStyle(fontSize: 11.sp, color: Colors.grey),
          ),
        )
      ],
    );
  }
}
