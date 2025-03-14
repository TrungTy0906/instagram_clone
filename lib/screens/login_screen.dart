import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/data/firebase_services/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback show;
  const LoginScreen(this.show, {super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final FocusNode _email = FocusNode();
  final password = TextEditingController();
  final FocusNode _password = FocusNode();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
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
              height: 100.h,
            ),
            Center(
              child: Image.asset('assets/images/logo.jpg'),
            ),
            SizedBox(
              height: 120.h,
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
            textfiled(password, Icons.password, 'password', _password),
            SizedBox(
              height: 10.h,
            ),
            forgot(),
            SizedBox(
              height: 10.h,
            ),
            login(),
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
            'Don\'t have account?',
            style: TextStyle(fontSize: 13.sp, color: Colors.grey),
          ),
          GestureDetector(
            onTap: widget.show,
            child: Text(
              'Sign up',
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

  Widget login() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: InkWell(
        onTap: () async {
          await Authentication()
              .logIn(email: email.text, password: password.text);
        },
        child: Container(
          alignment: Alignment.center,
          height: 40.h,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Text(
            "Log in",
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
