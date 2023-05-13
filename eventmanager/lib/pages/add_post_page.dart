import 'package:eventmanager/pages/create_event_page.dart';
import 'package:flutter/material.dart';
import 'package:eventmanager/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() {
    return _AddPostScreenState();
  }
}

class _AddPostScreenState extends State<AddPostScreen> {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
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
