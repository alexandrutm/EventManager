import 'dart:typed_data';

import 'package:eventmanager/utils/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import '../utils/utils.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() {
    return _CreateEventPageState();
  }
}

class _CreateEventPageState extends State<CreateEventPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  File? _imageFile;

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
                    _imageFile = File(file.path);
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  var file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _imageFile = File(file.path);
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

  void _selectDateRange() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: CupertinoPopupSurface(
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime.now(),
              minimumDate: DateTime.now().subtract(const Duration(days: 365)),
              maximumDate: DateTime.now().add(const Duration(days: 365)),
              onDateTimeChanged: (DateTime newDateTime) {
                setState(() {
                  _selectedStartDate = newDateTime;
                  _selectedEndDate = newDateTime;
                });
              },
            ),
          ),
        );
      },
    );
  }

  void _selectTime() {
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
                  _selectedTime = TimeOfDay.fromDateTime(newDateTime);
                });
              },
            ),
          ),
        );
      },
    );
  }

  void _createEvent() {
    String title = _titleController.text;
    String description = _descriptionController.text;

    // Combine selected date and time
    DateTime eventStartTime = DateTime(
      _selectedStartDate.year,
      _selectedStartDate.month,
      _selectedStartDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    DateTime eventEndTime = DateTime(
      _selectedEndDate.year,
      _selectedEndDate.month,
      _selectedEndDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    // Implement your logic here to create the event
    // Example: eventService.createEvent(title, description, eventStartTime, eventEndTime, _imageFile);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Event Created'),
        content: Text('The event "$title" has been created.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Optionally, you can navigate to a different page here
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () => _selectImage(context),
              child: SizedBox(
                width: double.infinity,
                height: 200,
                child: _imageFile != null
                    ? Image.file(
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
            ),
            const SizedBox(height: 12.0),
            GestureDetector(
              onTap: _selectDateRange,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'Start Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      controller: TextEditingController(
                        text: _selectedStartDate.toString().split(' ')[0],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: TextFormField(
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'End Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      controller: TextEditingController(
                        text: _selectedEndDate.toString().split(' ')[0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12.0),
            GestureDetector(
              onTap: _selectTime,
              child: TextFormField(
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'Time',
                  suffixIcon: Icon(Icons.access_time),
                ),
                controller: TextEditingController(
                  text: _selectedTime.format(context),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _createEvent,
              child: const Text('Create Event'),
            ),
          ],
        ),
      ),
    );
  }
}
