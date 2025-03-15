import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/data/model/user_model.dart';
import 'package:instagram/utils/exception.dart';
import 'package:uuid/uuid.dart';

class FirebaseFirestor {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> createUser({
    required String email,
    required String username,
    required String bio,
    required String profile,
  }) async {
    await _firebaseFirestore
        .collection('user')
        .doc(_auth.currentUser!.uid)
        .set({
      'email': email,
      'username': username,
      'bio': bio,
      'profile': profile,
      'followers': [],
      'following': [],
    });
    return true;
  }

  Future<UserModel> getUser() async {
    try {
      final user = await _firebaseFirestore
          .collection('user')
          .doc(_auth.currentUser!.uid)
          .get();
      final snapuser = user.data()!;
      return UserModel(
          snapuser['bio'],
          snapuser['email'],
          snapuser['followers'],
          snapuser['following'],
          snapuser['profile'],
          snapuser['username']);
    } on FirebaseException catch (e) {
      throw Exceptions(e.message.toString());
    }
  }

  Future<bool> CreatePost({
    required String postImage,
    required String caption,
    required String location,
  }) async {
    var uid = Uuid().v4();
    DateTime data = new DateTime.now();
    UserModel user = await getUser();
    await _firebaseFirestore.collection('posts').doc(uid).set({
      'postImage': postImage,
      'userName': user.username,
      'profileImage': user.profile,
      'caption': caption,
      'location': location,
      'uid': _auth.currentUser!.uid,
      'postId': uid,
      'like': [],
      'time': data,
    });
    return true;
  }

  Future<bool> CreateReels({
    required String video,
    required String caption,
  }) async {
    var uid = Uuid().v4();
    DateTime data = new DateTime.now();
    UserModel user = await getUser();
    await _firebaseFirestore.collection('reels').doc(uid).set({
      'reelsVideo': video,
      'userName': user.username,
      'profileImage': user.profile,
      'caption': caption,
      'uid': _auth.currentUser!.uid,
      'postId': uid,
      'like': [],
      'time': data,
    });
    return true;
  }
}
