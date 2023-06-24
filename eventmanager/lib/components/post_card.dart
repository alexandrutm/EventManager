// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eventmanager/resources/firestore_methods.dart';
import 'package:eventmanager/pages/comments_page.dart';
import 'package:eventmanager/utils/colors.dart';
import 'package:eventmanager/utils/utils.dart';
import 'package:intl/intl.dart';

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
  int interestedLen = 0;
  int attendeesLen = 0;
  bool isLikeAnimating = false;
  bool isGoing = false; // Set this value based on user's selection
  bool isInterested = false; // Set this value based on user's selection

  @override
  void initState() {
    super.initState();

    if (widget.snap['attendees']
        .contains(FirebaseAuth.instance.currentUser!.uid)) isGoing = true;

    fetchCommentLen();
    fetchInterestedLen();
    fetchAttendeesLen();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.snap['eventId'])
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

  fetchInterestedLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.snap['eventId'])
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

  fetchAttendeesLen() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.snap['eventId'])
          .get();

      if (snap.exists) {
        var attendees = snap.data()!['attendees'];
        if (attendees != null && attendees is List) {
          attendeesLen = attendees.length;
        } else {
          attendeesLen = 0;
        }
      } else {
        attendeesLen = 0;
      }
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

  deletePost(String eventId) async {
    try {
      await FireStoreMethods().deletePost(eventId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: .1),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.55,
                    width: double.infinity,
                    child: ClipRRect(
                      child: Image.network(
                        widget.snap['postUrl'].toString(),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                        ),
                        color: Theme.of(context).brightness == Brightness.light
                            ? lightBkgColor // Set black color for light theme
                            : darkBkgColor, // Set white color for dark theme
                      ),
                      child: Column(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              isGoing
                                  ? Icons.check_circle_sharp
                                  : Icons.add_circle_outlined,
                              color: isGoing
                                  ? Colors.black
                                  : Theme.of(context).iconTheme.color,
                            ),
                            onPressed: () {
                              setState(() {
                                isGoing = !isGoing;
                              });
                            },
                          ),
                          Text(
                            attendeesLen.toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.star,
                              color: isInterested
                                  ? Colors.black
                                  : Theme.of(context).iconTheme.color,
                            ),
                            onPressed: () {
                              setState(() {
                                isInterested = !isInterested;
                              });
                            },
                          ),
                          Text(
                            interestedLen.toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                          IconButton(
                            icon: const Icon(Icons.comment_rounded),
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CommentsScreen(
                                  eventId: widget.snap['eventId'].toString(),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            commentLen.toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                          IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 8),
                        Text(
                          widget.snap['title'].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 8),
                        //Event host
                        Row(
                          children: <Widget>[
                            Icon(Icons.account_circle),
                            const SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.snap['username'].toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        //Location
                        Row(
                          children: <Widget>[
                            Icon(Icons.place),
                            const SizedBox(width: 4),
                            Text(
                              widget.snap['location'].toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        //Date and time
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.date_range),
                                  const SizedBox(width: 4),
                                  Text(
                                    DateFormat.yMMMd().format(
                                      widget.snap['startDate'].toDate(),
                                    ),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.access_time),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat.jm().format(
                                    widget.snap['startDate'].toDate(),
                                  ),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(width: 15)
                          ],
                        ),
                        const SizedBox(height: 8),
                        //Going/Interested button
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  // Handle "Going" button press
                                  await FireStoreMethods().attendToEvent(
                                    widget.snap['eventId'],
                                    FirebaseAuth.instance.currentUser!.uid,
                                    widget.snap['attendees'],
                                  );

                                  setState(() {
                                    isGoing = !isGoing;
                                    isGoing ? attendeesLen++ : attendeesLen--;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isGoing
                                      ? Colors.grey.shade500
                                      : Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      isGoing
                                          ? Icons.check_circle_sharp
                                          : Icons.add_circle_outlined,
                                      color:
                                          isGoing ? Colors.black : Colors.white,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      'Going',
                                      style: TextStyle(
                                        color: isGoing
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Handle "Interested" button press
                                setState(() {
                                  isInterested = !isInterested;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isInterested
                                    ? Colors.grey.shade400
                                    : Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: isInterested
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    'Interested',
                                    style: TextStyle(
                                      color: isInterested
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          height: 114,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Text(
                              widget.snap['description'].toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
