// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'dart:async';

import 'package:animated_check/animated_check.dart';
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

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  int commentLen = 0;
  int interestedLen = 0;
  int attendeesLen = 0;
  //bool isLikeAnimating = false;
  bool isGoing = false; // Set this value based on user's selection
  bool isInterested = false; // Set this value based on user's selection

  //animation check
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCirc,
    ));

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

  void _showCheck() {
    _animationController.forward().then((_) {
      Future.delayed(Duration(milliseconds: 200), () {
        if (_animationController.status == AnimationStatus.completed) {
          _animationController.reset();
        }
      });
    });
  }

  // void _resetCheck() {
  //   _animationController.fling();
  // }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        color: Colors.grey.shade400,
                        height: MediaQuery.of(context).size.height * 0.60,
                        width: double.infinity,
                        child: ClipRRect(
                          child: Image.network(
                            widget.snap['postUrl'].toString(),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      AnimatedCheck(
                        progress: _animation,
                        size: 300,
                        color: Colors.grey.shade500,
                      ),
                    ],
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
                            ? lightBkgColor
                            : darkBkgColor,
                      ),
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.comment_rounded),
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => CommentsScreen(
                                      eventId:
                                          widget.snap['eventId'].toString(),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Transform.translate(
                                  offset: Offset(-1, 1),
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    child: Text(
                                      commentLen.toString(),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 8),
                            Row(children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade300,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.all(8),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      widget.snap['title'].toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ]),
                            const SizedBox(height: 6),
                            //username
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade300,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        children: <Widget>[
                                          CircleAvatar(
                                            radius: 18,
                                            backgroundImage: NetworkImage(
                                                widget.snap['profImage']),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  widget.snap['username']
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade400,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.place),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              widget.snap['location']
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),
                            //Date and time
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade300,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        _buildDateTimeRow(
                                          icon: Icons.date_range,
                                          text: DateFormat.yMMMd().format(widget
                                              .snap['startDate']
                                              .toDate()),
                                          textAlign: TextAlign.center,
                                        ),
                                        _buildDateTimeRow(
                                          icon: Icons.access_time,
                                          text: DateFormat.jm().format(widget
                                              .snap['startDate']
                                              .toDate()),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                _buildArrowIcon(),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade300,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.all(8),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildDateTimeRow(
                                            icon: Icons.date_range,
                                            text: DateFormat.yMMMd().format(
                                                widget.snap['endDate']
                                                    .toDate()),
                                            textAlign: TextAlign.center,
                                          ),
                                          _buildDateTimeRow(
                                            icon: Icons.access_time,
                                            text: DateFormat.jm().format(widget
                                                .snap['endDate']
                                                .toDate()),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //Going button
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 6.0, right: 6.0),
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
                        isGoing ? _showCheck() : 0;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isGoing ? Colors.grey.shade500 : Colors.green,
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
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'Going (${attendeesLen.toString()})',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeRow({
    required IconData icon,
    required String text,
    TextAlign textAlign = TextAlign.start,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon),
        const SizedBox(width: 2),
        Text(
          text,
          textAlign: textAlign,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildArrowIcon() {
    return Container(
      width: 40,
      child: Icon(
        Icons.arrow_right_alt,
        size: 24,
      ),
    );
  }
}
