import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String profilePic;
  final String name;
  final String uid;
  final String text;
  final String commentId;
  final datePublication;
  final likes;

  const Comment({
    required this.profilePic,
    required this.name,
    required this.uid,
    required this.text,
    required this.commentId,
    required this.datePublication,
    required this.likes,
  });
   Map<String, dynamic> toJson() => {
       'profilePic': profilePic,
      'name': name,
      'uid': uid,
      'text': text,
      'commentId': commentId,
      "datePublication": datePublication,
      "likes":likes,
      };

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Comment(
      profilePic: snapshot['profilePic'],
      name: snapshot['name'],
      uid: snapshot['uid'],
      
      text: snapshot['text'],
      commentId: snapshot['commentId'],
      datePublication: snapshot['datePublication'],
      likes: snapshot['likes'],
      
    );
  }
}
