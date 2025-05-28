import 'package:college_connectd/Events/event_controller.dart';
import 'package:flutter/material.dart';
import 'package:college_connectd/model/event_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEventForm extends ConsumerStatefulWidget {
  const AddEventForm({super.key});

  @override
  ConsumerState<AddEventForm> createState() => _AddEventFormState();
}

class _AddEventFormState extends ConsumerState<AddEventForm> {
  final _formKey = GlobalKey<FormState>();
  
  // Text Controllers
  final _titleController = TextEditingController();
  final _shortDescriptionController = TextEditingController();
  final _venueController = TextEditingController();
  final _prizeMoneyController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rulesController = TextEditingController();
  final _eligibilityController = TextEditingController();
  final _departmentController = TextEditingController();
  final _minTeamSizeController = TextEditingController();
  final _maxTeamSizeController = TextEditingController();
  final _tracksController = TextEditingController();

  // Date and Time
  DateTime? _startTime;
  DateTime? _endTime;

  // Boolean values
  bool _isTeamEvent = false;
  bool _isRegistrationOpen = true;

  @override
  void dispose() {
    _titleController.dispose();
    _shortDescriptionController.dispose();
    _venueController.dispose();
    _prizeMoneyController.dispose();
    _descriptionController.dispose();
    _rulesController.dispose();
    _eligibilityController.dispose();
    _departmentController.dispose();
    _minTeamSizeController.dispose();
    _maxTeamSizeController.dispose();
    _tracksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Event'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Event Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Short Description
              TextFormField(
                controller: _shortDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Short Description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.short_text),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter short description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Venue
              TextFormField(
                controller: _venueController,
                decoration: const InputDecoration(
                  labelText: 'Venue',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter venue';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Prize Money
              TextFormField(
                controller: _prizeMoneyController,
                decoration: const InputDecoration(
                  labelText: 'Prize Money',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter prize money';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Department
              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(
                  labelText: 'Department',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter department';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Rules
              TextFormField(
                controller: _rulesController,
                decoration: const InputDecoration(
                  labelText: 'Rules',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.rule),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter rules';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Eligibility
              TextFormField(
                controller: _eligibilityController,
                decoration: const InputDecoration(
                  labelText: 'Eligibility',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter eligibility criteria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Tracks (comma separated)
              TextFormField(
                controller: _tracksController,
                decoration: const InputDecoration(
                  labelText: 'Tracks (comma separated)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.track_changes),
                  helperText: 'e.g. Web Development, Mobile App, AI/ML',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter tracks';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Start Time
              ListTile(
                leading: const Icon(Icons.schedule),
                title: Text(_startTime == null 
                    ? 'Select Start Time' 
                    : 'Start: ${_startTime.toString()}'),
                subtitle: const Text('Tap to select start date and time'),
                onTap: () => _selectDateTime(true),
                tileColor: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey[400]!),
                ),
              ),
              const SizedBox(height: 16),

              // End Time
              ListTile(
                leading: const Icon(Icons.schedule),
                title: Text(_endTime == null 
                    ? 'Select End Time' 
                    : 'End: ${_endTime.toString()}'),
                subtitle: const Text('Tap to select end date and time'),
                onTap: () => _selectDateTime(false),
                tileColor: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey[400]!),
                ),
              ),
              const SizedBox(height: 16),

              // Team Event Toggle
              SwitchListTile(
                title: const Text('Team Event'),
                subtitle: const Text('Toggle if this is a team event'),
                value: _isTeamEvent,
                onChanged: (value) {
                  setState(() {
                    _isTeamEvent = value;
                  });
                },
                tileColor: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey[400]!),
                ),
              ),
              const SizedBox(height: 16),

              // Team Size Fields (only show if team event)
              if (_isTeamEvent) ...[
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _minTeamSizeController,
                        decoration: const InputDecoration(
                          labelText: 'Min Team Size',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.people),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (_isTeamEvent && (value == null || value.isEmpty)) {
                            return 'Required for team events';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _maxTeamSizeController,
                        decoration: const InputDecoration(
                          labelText: 'Max Team Size',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.people),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (_isTeamEvent && (value == null || value.isEmpty)) {
                            return 'Required for team events';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // Registration Open Toggle
              SwitchListTile(
                title: const Text('Registration Open'),
                subtitle: const Text('Toggle registration status'),
                value: _isRegistrationOpen,
                onChanged: (value) {
                  setState(() {
                    _isRegistrationOpen = value;
                  });
                },
                tileColor: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey[400]!),
                ),
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Create Event',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateTime(bool isStartTime) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          if (isStartTime) {
            _startTime = selectedDateTime;
          } else {
            _endTime = selectedDateTime;
          }
        });
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_startTime == null || _endTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select start and end times')),
        );
        return;
      }

      if (_endTime!.isBefore(_startTime!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('End time must be after start time')),
        );
        return;
      }

      // Create EventModel
      final event = EventModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        shortDescription: _shortDescriptionController.text.trim(),
        venue: _venueController.text.trim(),
        prizeMoney: _prizeMoneyController.text.trim(),
        description: _descriptionController.text.trim(),
        rules: _rulesController.text.trim(),
        startTime: _startTime!,
        endTime: _endTime!,
        eligibility: _eligibilityController.text.trim(),
        registrationCount: 0,
        tracks: _tracksController.text
            .split(',')
            .map((track) => track.trim())
            .where((track) => track.isNotEmpty)
            .toList(),
        department: _departmentController.text.trim(),
        isTeamEvent: _isTeamEvent,
        minTeamSize: _isTeamEvent ? int.parse(_minTeamSizeController.text) : 1,
        maxTeamSize: _isTeamEvent ? int.parse(_maxTeamSizeController.text) : 1,
        isRegistrationOpen: _isRegistrationOpen,
      );

      ref.read(eventControllerProvider.notifier).createEvent(event);
      
      print('Event Created: ${event.toString()}');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event created successfully!')),
      );
      
      Navigator.pop(context);
    }
  }
}