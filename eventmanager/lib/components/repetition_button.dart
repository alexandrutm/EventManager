import 'package:flutter/material.dart';

class EventRepetitionButton extends StatefulWidget {
  const EventRepetitionButton({super.key});

  @override
  State<EventRepetitionButton> createState() {
    return _EventRepetitionButtonState();
  }
}

class _EventRepetitionButtonState extends State<EventRepetitionButton> {
  String _selectedOption = 'None';

  void _openRepetitionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Repetition'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  setState(() {
                    _selectedOption = 'None';
                  });
                  Navigator.pop(context);
                },
                title: const Text('None'),
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    _selectedOption = 'Every Day';
                  });
                  Navigator.pop(context);
                },
                title: const Text('Every Day'),
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    _selectedOption = 'Every Month';
                  });
                  Navigator.pop(context);
                },
                title: const Text('Every Month'),
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    _selectedOption = 'Every Year';
                  });
                  Navigator.pop(context);
                },
                title: const Text('Every Year'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: _openRepetitionDialog,
          icon: const Icon(Icons.repeat),
        ),
        TextButton(
          onPressed: _openRepetitionDialog,
          child: Row(
            children: [
              const Text(
                'Repetition: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(_selectedOption),
            ],
          ),
        ),
      ],
    );
  }
}
