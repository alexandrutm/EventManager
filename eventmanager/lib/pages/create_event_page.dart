import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../utils/utils.dart';

class CreateEventPage extends StatefulWidget {
  final VoidCallback onEventCreated;

  const CreateEventPage({Key? key, required this.onEventCreated})
      : super(key: key);

  @override
  State<CreateEventPage> createState() {
    return _CreateEventPageState();
  }
}

class _CreateEventPageState extends State<CreateEventPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  DateTime currentTime = DateTime.now();
  DateTime oneHourLater = DateTime.now().add(const Duration(hours: 1));
  TimeOfDay _selectedEndTime =
      TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 1)));

  Uint8List? _imageFile;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Create New Event'),
            content: const Text('Do you want to proceed with event creation?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();

                  // Navigate back to the previous page or home page
                  //
                  //here
                },
              ),
              TextButton(
                child: const Text('Create'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  var file = await pickImage(ImageSource.camera);
                  setState(() {
                    _imageFile = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  var file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _imageFile = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void _selectDateRange(String aButtonType) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: CupertinoPopupSurface(
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (DateTime newDateTime) {
                setState(() {
                  if (aButtonType == 'start') {
                    _selectedStartDate = newDateTime;
                  } else if (aButtonType == 'end') {
                    _selectedEndDate = newDateTime;
                  }
                });
              },
            ),
          ),
        );
      },
    );
  }

  void _selectTime(String aButtonType) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: CupertinoPopupSurface(
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (DateTime newDateTime) {
                setState(() {
                  if (aButtonType == 'start') {
                    _selectedStartTime = TimeOfDay.fromDateTime(newDateTime);
                  } else {
                    _selectedEndTime = TimeOfDay.fromDateTime(newDateTime);
                  }
                });
              },
            ),
          ),
        );
      },
    );
  }

  void handleEventCreated() {
    widget.onEventCreated();
  }

  void _createEvent() async {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    String title = _titleController.text;
    // Combine selected date and time
    DateTime eventStartTime = DateTime(
      _selectedStartDate.year,
      _selectedStartDate.month,
      _selectedStartDate.day,
      _selectedStartTime.hour,
      _selectedStartTime.minute,
    );

    DateTime eventEndTime = DateTime(
      _selectedEndDate.year,
      _selectedEndDate.month,
      _selectedEndDate.day,
      _selectedStartTime.hour,
      _selectedStartTime.minute,
    );

    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadEvent(
          _titleController.text,
          _descriptionController.text,
          _imageFile!,
          userProvider.getUser.uid,
          "${userProvider.getUser.mFirstName} ${userProvider.getUser.mLastName}",
          userProvider.getUser.photoUrl,
          eventStartTime,
          eventEndTime,
          _locationController.text);
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        // showSnackBar(
        //   context,
        //   'Posted!',
        // );
        // clearImage();
      }
      //else {
      //   showSnackBar(context, res);
      // }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Event Created'),
        content: Text('The event "$title" has been created.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              handleEventCreated();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _selectImage(context),
                    child: SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: _imageFile != null
                          ? Image.memory(
                              _imageFile!,
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              Icons.camera_alt,
                              size: 50,
                            ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: "Title",
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectDateRange("start"),
                          child: TextFormField(
                            enabled: false,
                            decoration: const InputDecoration(
                              labelText: 'Start Date',
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            controller: TextEditingController(
                              text: DateFormat('MMMM dd, yyyy')
                                  .format(_selectedStartDate),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      SizedBox(
                        width: 120,
                        child: GestureDetector(
                          onTap: () => _selectTime("start"),
                          child: TextFormField(
                            enabled: false,
                            decoration: const InputDecoration(
                              labelText: 'Start Time',
                              suffixIcon: Icon(Icons.access_time),
                            ),
                            controller: TextEditingController(
                              text: _selectedStartTime.format(context),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a location',
                      suffixIcon: Icon(Icons.place),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _createEvent,
              child: const Text('Create Event'),
            ),
          ),
        ],
      ),
    );
  }
}
