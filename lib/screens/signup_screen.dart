import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/data/firebase_services/firebase_auth.dart';
import 'package:instagram/utils/dialog.dart';
import 'package:instagram/utils/exception.dart';
import 'package:instagram/utils/imagepicker.dart';

class SignupScreen extends StatefulWidget {
  final VoidCallback show;
  const SignupScreen(this.show, {super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final email = TextEditingController();
  final FocusNode _email = FocusNode();
  final username = TextEditingController();
  final FocusNode _username = FocusNode();
  final bio = TextEditingController();
  final FocusNode _bio = FocusNode();
  final password = TextEditingController();
  final FocusNode _password = FocusNode();
  final passwordComfirm = TextEditingController();
  final FocusNode _passwordComfirm = FocusNode();
  File? _imageFile;

  @override
  void dispose() {
    _email.dispose();
    _username.dispose();
    _bio.dispose();
    _password.dispose();
    _passwordComfirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: 96.w,
              height: 50.h,
            ),
            Center(
              child: Image.asset('assets/images/logo.jpg'),
            ),
            SizedBox(
              height: 50.h,
            ),
            Center(
              child: InkWell(
                onTap: () async {
                  File _imagefile = await Imagepicker().uploadImage('gallery');
                  setState(() {
                    _imageFile = _imagefile;
                  });
                },
                child: CircleAvatar(
                  radius: 36.r,
                  backgroundColor: Colors.grey,
                  child: CircleAvatar(
                    radius: 32.r,
                    backgroundColor: Colors.grey.shade200,
                    child: _imageFile == null
                        ? CircleAvatar(
                            radius: 34.r,
                            backgroundImage:
                                AssetImage('assets/images/person.png'),
                            backgroundColor: Colors.grey.shade200,
                          )
                        : CircleAvatar(
                            radius: 34.r,
                            backgroundImage: Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                            ).image,
                            backgroundColor: Colors.grey.shade200,
                          ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 60.h,
            ),
            textfiled(
              email,
              Icons.email,
              "Email",
              _email,
            ),
            SizedBox(
              height: 10.h,
            ),
            textfiled(username, Icons.person, 'Username', _username),
            SizedBox(
              height: 10.h,
            ),
            textfiled(bio, Icons.abc, 'bio', _bio),
            SizedBox(
              height: 10.h,
            ),
            textfiled(password, Icons.lock, 'Password', _password),
            SizedBox(
              height: 10.h,
            ),
            textfiled(passwordComfirm, Icons.lock, 'Password Comfirm',
                _passwordComfirm),
            SizedBox(
              height: 10.h,
            ),
            // forgot(),
            SizedBox(
              height: 10.h,
            ),
            signUp(),
            SizedBox(height: 10.h),
            have(),
          ],
        ),
      ),
    );
  }

  Widget have() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Are you have account?',
            style: TextStyle(fontSize: 13.sp, color: Colors.grey),
          ),
          GestureDetector(
            onTap: widget.show,
            child: Text(
              'Login',
              style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.blue,
                  fontWeight: FontWeight.w800),
            ),
          )
        ],
      ),
    );
  }

  Widget signUp() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: InkWell(
        onTap: () async {
          try {
            await Authentication().signUp(
                email: email.text,
                password: password.text,
                passwordcomfirm: passwordComfirm.text,
                username: username.text,
                bio: bio.text,
                profile: File(""));
          } on Exceptions catch (e) {
            dialogBuilder(context, e.massage);
          }
        },
        child: Container(
          alignment: Alignment.center,
          height: 40.h,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Text(
            "Sign Up",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget forgot() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Text(
        "forgot your password ?",
        style: TextStyle(
          color: Colors.blue,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget textfiled(TextEditingController controler, IconData icon, String type,
      FocusNode focusNode) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5.r)),
        child: TextField(
          style: TextStyle(fontSize: 18.sp, color: Colors.black),
          controller: controler,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: type,
            hintStyle: TextStyle(
              color: Colors.grey, // Màu xám nhẹ cho hintText
              fontSize: 16.sp,
              fontWeight: FontWeight.normal, // Đảm bảo không bị in đậm
            ),
            prefixIcon: Icon(
              icon,
              color: focusNode.hasFocus ? Colors.black : Colors.grey,
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide: BorderSide(color: Colors.grey, width: 2.w),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide: BorderSide(color: Colors.black, width: 2.w),
            ),
          ),
        ),
      ),
    );
  }
}
