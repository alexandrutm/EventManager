// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:eventmanager/models/user.dart' as model;
import 'package:eventmanager/providers/user_provider.dart';
import 'package:eventmanager/resources/firestore_methods.dart';
import 'package:eventmanager/pages/comments_page.dart';
import 'package:eventmanager/utils/colors.dart';
import 'package:eventmanager/utils/utils.dart';
import 'package:eventmanager/components/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final dynamic snap;
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  bool isLikeAnimating = false;

  @override
  void initState() {
    super.initState();
    fetchCommentLen();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    if (mounted) {
      // Only call setState if the widget is still mounted
      setState(() {
        // Update your state here
      });
    }
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    String dropdownValue = 'Going';

    return Container(
      // boundary needed for web
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 8,
          )),
          // HEADER SECTION OF THE POST
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 2,
              horizontal: 8,
            ).copyWith(right: 8),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(
                    widget.snap['profImage'].toString(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.snap['username'].toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  DateFormat.yMMMd()
                      .format(widget.snap['datePublished'].toDate()),
                ),
                // widget.snap['uid'].toString() == user.uid
                //     ? IconButton(
                //         onPressed: () {
                //           showDialog(
                //             useRootNavigator: false,
                //             context: context,
                //             builder: (context) {
                //               return Dialog(
                //                 child: ListView(
                //                     padding: const EdgeInsets.symmetric(
                //                         vertical: 16),
                //                     shrinkWrap: true,
                //                     children: [
                //                       'Delete',
                //                     ]
                //                         .map(
                //                           (e) => InkWell(
                //                               child: Container(
                //                                 padding:
                //                                     const EdgeInsets.symmetric(
                //                                         vertical: 12,
                //                                         horizontal: 16),
                //                                 child: Text(e),
                //                               ),
                //                               onTap: () {
                //                                 deletePost(
                //                                   widget.snap['postId']
                //                                       .toString(),
                //                                 );
                //                                 // remove the dialog box
                //                                 Navigator.of(context).pop();
                //                               }),
                //                         )
                //                         .toList()),
                //               );
                //             },
                //           );
                //         },
                //         icon: const Icon(Icons.more_vert),
                //       )
                //     : Container(),
              ],
            ),
          ),
          // IMAGE SECTION OF THE POST
          Stack(alignment: Alignment.bottomRight, children: [
            GestureDetector(
              onDoubleTap: () {
                FireStoreMethods().likePost(
                  widget.snap['postId'].toString(),
                  user.uid,
                  widget.snap['likes'],
                );
                setState(() {
                  isLikeAnimating = true;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.50,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          widget.snap['postUrl'].toString(),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isLikeAnimating ? 1 : 0,
                    child: LikeAnimation(
                      isAnimating: isLikeAnimating,
                      duration: const Duration(
                        milliseconds: 400,
                      ),
                      onEnd: () {
                        setState(() {
                          isLikeAnimating = false;
                        });
                      },
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 100,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: mobileBkgColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(
                              Icons.comment_rounded,
                            ),
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CommentsScreen(
                                  eventId: widget.snap['postId'].toString(),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            commentLen.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          IconButton(
                              icon: const Icon(
                                Icons.share,
                              ),
                              onPressed: () {}),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ]),
          //Bottom section of the post
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //TITLE,DESCRIPTION, WHERE, WHEN
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Title Widget
                        Text(
                          widget.snap['title'].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 8),
                        // Description Widget with Scroll
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: mobileBkgColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                height: 60,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Text(
                                    widget.snap['description'].toString(),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        // Place Container
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: mobileBkgColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.place),
                                    SizedBox(width: 4),
                                    Text(
                                      widget.snap['location'].toString(),
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: mobileBkgColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              height: 40,
                              child: DropdownButton<String>(
                                value: dropdownValue,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                  });
                                },
                                items: <String>[
                                  'Going',
                                  'Interested'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        // Date and Time Widgets
                        Row(
                          children: <Widget>[
                            // Date Container
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: mobileBkgColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.date_range),
                                    SizedBox(width: 4),
                                    Text(
                                      DateFormat.yMMMd().format(
                                          widget.snap['startDate'].toDate()),
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            // Time Container
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: mobileBkgColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.access_time),
                                    SizedBox(width: 4),
                                    Text(
                                      DateFormat.jm().format(
                                          widget.snap['startDate'].toDate()),
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // LIKE, COMMENT SECTION OF THE POST
              ],
            ),
          ),
        ],
      ),
    );
  }
}
