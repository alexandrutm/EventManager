import 'package:eventmanager/pages/create_event_page.dart';
import 'package:flutter/material.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({Key? key}) : super(key: key);

  @override
  State<AddEventScreen> createState() {
    return _AddEventScreenState();
  }
}

class _AddEventScreenState extends State<AddEventScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
          icon: const Icon(
            Icons.create,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const CreateEventPage();
                },
              ),
            );
          }),
    );
  }
}
