import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/Widgets/like_animation.dart';
import 'package:insta_clone/models/user.dart';
import 'package:insta_clone/providers/User_providers.dart';
import 'package:insta_clone/resources/firestore_methods.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  final postId;
  const CommentCard({
    Key? key,
    required this.snap,
    required this.postId,
  }) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap["profilePic"]),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: widget.snap["name"],
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: " ${widget.snap["text"]}",
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '    ${DateFormat.yMMMd().format((widget.snap["datePublished"] as Timestamp).toDate()).toString()}',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(right: 8, left: 8),
                child: LikeAnimation(
                    isAnimating: widget.snap['likes'].contains(user.uid),
                    smallLike: true,
                    child: IconButton(
                      onPressed: () async {
                        FireStoreMethods().likeComment(widget.postId, user.uid,
                            widget.snap['likes'], widget.snap['commentId']);
                      },
                      icon: widget.snap['likes'].contains(user.uid)
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : Icon(
                              Icons.favorite_border,
                            ),
                    )),
              ),
              Text(
                widget.snap['likes'].length.toString(),
              )
            ],
          )
        ],
      ),
    );
  }
}
