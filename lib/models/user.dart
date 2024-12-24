import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;
  final String token;

  const User(
      { required this.token,
      required this.username,
      required this.uid,
      required this.photoUrl,
      required this.email,
      required this.bio,
      required this.followers,
      required this.following});

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      token: snapshot["token"] ?? '',
      username: snapshot["username"] ?? '', // Provide default value
      uid: snapshot["uid"] ?? '', // Provide default value
      email: snapshot["email"] ?? '', // Provide default value
      photoUrl: snapshot["photourl"] ?? '', // Provide default value
      bio: snapshot["bio"] ?? '', // Provide default value
      followers: snapshot["followers"] ?? [], // Provide empty list if null
      following: snapshot["following"] ?? [], // Provide empty list if null
    );
  }

  Map<String, dynamic> toJson() => {
        "token": token,
        "username": username,
        "uid": uid,
        "email": email,
        "photourl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
      };
}
