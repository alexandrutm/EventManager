import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/event.dart';

class UpcomingEvents extends StatefulWidget {
  const UpcomingEvents({Key? key}) : super(key: key);

  @override
  State<UpcomingEvents> createState() {
    return _UpcomingEvents();
  }
}

class _UpcomingEvents extends State<UpcomingEvents> {
  List<Event> upcomingEvents = []; // List to store upcoming events

  @override
  void initState() {
    super.initState();
    fetchUpcomingEvents();
  }

  Future<void> fetchUpcomingEvents() async {
    var currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    var eventsRef = FirebaseFirestore.instance.collection('events');

    var createdEventsQuerySnapshot =
        await eventsRef.where('uid', isEqualTo: currentUserUid).get();

    var attendedEventsQuerySnapshot =
        await eventsRef.where('attendees', arrayContains: currentUserUid).get();

    List<Event> createdEvents = createdEventsQuerySnapshot.docs
        .map((doc) => Event.fromSnapshot(doc))
        .toList();
    List<Event> attendedEvents = attendedEventsQuerySnapshot.docs
        .map((doc) => Event.fromSnapshot(doc))
        .toList();

    List<Event> allEvents = [...createdEvents, ...attendedEvents];

    // Delete duplicate
    List<Event> events = [];
    allEvents.forEach((event) {
      if (!events.any((e) => e.eventId == event.eventId)) {
        events.add(event);
      }
    });

    // Filter out past events
    DateTime currentDate = DateTime.now();
    events =
        events.where((event) => event.startDate.isAfter(currentDate)).toList();

    // Sort events by startDate in ascending order
    events.sort((a, b) => a.startDate.compareTo(b.startDate));

    setState(() {
      upcomingEvents = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Events'),
      ),
      body: ListView.builder(
        itemCount: upcomingEvents.length,
        itemBuilder: (BuildContext context, int index) {
          Event event = upcomingEvents[index];

          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            leading: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(event
                      .postUrl), // Replace with the appropriate image source
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(
              event.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMMM d, yyyy')
                      .format(event.startDate), // Format the date
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  event.location,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(event.profImage),
                ),
                const SizedBox(height: 4),
                Text(
                  event.username,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
