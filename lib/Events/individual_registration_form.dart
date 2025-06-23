import 'package:college_connectd/Events/event_controller.dart';
import 'package:college_connectd/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class IndividualRegistrationForm extends ConsumerStatefulWidget {
  final String eventId;
  const IndividualRegistrationForm({required this.eventId, super.key});

  @override
  ConsumerState<IndividualRegistrationForm> createState() => _IndividualRegistrationFormState();
}

class _IndividualRegistrationFormState extends ConsumerState<IndividualRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventAsync = ref.watch(getEventProvider(widget.eventId));
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      body: eventAsync.when(
        data: (data) {
          final controller = ref.read(eventControllerProvider.notifier);

          return FutureBuilder<bool>(
            future: getStatus(data!.id, userAsync!.registrationId!, controller),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final isRegistered = snapshot.data;
                print('reggggggggggggg $isRegistered');

                if (isRegistered!) {
                  return _buildTicketView(data, userAsync);
                }

                return _buildRegistrationForm(data, userAsync, controller);
              }
            },
          );
        },
        error: (error, stack) => _buildErrorView(),
        loading: () => _buildLoadingView(),
      ),
    );
  }

  Widget _buildRegistrationForm(dynamic event, dynamic user, EventController controller) {
    if (_phoneController.text.isEmpty && user.phone != null) {
      _phoneController.text = user.phone;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Registration'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Routemaster.of(context).history.back(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade600, Colors.purple.shade400],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('MMM dd, yyyy - hh:mm a').format(event.startTime),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.venue ?? 'Venue TBA',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Your Details Section
              _buildSectionTitle('Your Details'),
              _buildInfoCard([
                _buildReadOnlyField('Name', user.name ?? 'Not provided'),
                _buildReadOnlyField('Email', user.email ?? 'Not provided'),
                _buildReadOnlyField('College', user.collegeName ?? 'Not provided'),
                _buildReadOnlyField('Department', user.departmentName ?? 'Not provided'),
                _buildReadOnlyField('Programme', user.programmeName ?? 'Not provided'),
                _buildReadOnlyField('Year', user.year?.toString() ?? 'Not provided'),
              ]),

              const SizedBox(height: 20),

              // Contact Information
              _buildSectionTitle('Contact Information'),
              _buildInfoCard([
                _buildEditableField(
                  'Phone Number', 
                  _phoneController, 
                  'Enter your phone number', 
                  TextInputType.phone,
                  true
                ),
                _buildEditableField(
                  'WhatsApp Number (Optional)', 
                  _whatsappController, 
                  'If different from phone number', 
                  TextInputType.phone,
                  false
                ),
              ]),

              const SizedBox(height: 32),

              // Register Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _canRegister() ? () => _showConfirmationDialog(event, user, controller) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Register for Event',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketView(dynamic event, dynamic user) {
    final qrData = 'Event=>___ reg confirmed___${user.registrationId} unique-code_-${event.id}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Ticket'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareTicket(event, user),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Ticket Container
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Ticket Header
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade600, Colors.purple.shade400],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(

                                //user.departmentName?.toUpperCase() ?? 'EVENT',
                                'ISTE-CSE',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 2,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Text(
                                'CONFIRMED',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          event.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat('EEEE, MMM dd, yyyy').format(event.startTime),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Dotted Line Separator
                  Container(
                    height: 1,
                    child: Row(
                      children: List.generate(
                        20,
                        (index) => Expanded(
                          child: Container(
                            height: 1,
                            color: index % 2 == 0 ? Colors.grey.shade300 : Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Ticket Body
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Participant Info
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildTicketRow('PARTICIPANT', user.name ?? 'N/A'),
                                  const SizedBox(height: 12),
                                  _buildTicketRow('TICKET ID', 'CC-${user.ukid.toString()}'),
                                  const SizedBox(height: 12),
                                  _buildTicketRow('VENUE', event.venue ?? 'TBA'),
                                  const SizedBox(height: 12),
                                  _buildTicketRow('TIME', DateFormat('hh:mm a').format(event.startTime)),
                                  const SizedBox(height: 12),
                                  _buildTicketRow('COLLEGE', user.collegeName ?? 'N/A'),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            // QR Code
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: QrImageView(
                                data: qrData,
                                version: QrVersions.auto,
                                size: 100,
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Instructions
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Important:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '• Please arrive 15 minutes before the event\n'
                                '• Bring this QR code for entry\n'
                                '• Contact organizers for any queries',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue.shade700,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: value,
        enabled: false,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller, String hint, [TextInputType? keyboardType, bool required = true]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
        validator: required ? (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        } : null,
      ),
    );
  }

  Widget _buildTicketRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 60,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please try again later',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Routemaster.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(height: 16),
            Text(
              'Loading event details...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canRegister() {
    return _phoneController.text.isNotEmpty && !_isLoading;
  }

  void _showConfirmationDialog(dynamic event, dynamic user, EventController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Registration'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Event: ${event.title}'),
              Text('Date: ${DateFormat('MMM dd, yyyy').format(event.startTime)}'),
              Text('Time: ${DateFormat('hh:mm a').format(event.startTime)}'),
              Text('Participant: ${user.name}'),
              const SizedBox(height: 16),
              const Text('Are you sure you want to register?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _registerUser(event, user, controller);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Confirm', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _registerUser(dynamic event, dynamic user, EventController controller) async {
    setState(() => _isLoading = true);

    try {
      await controller.registerUser(event.id, user.registrationId!);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful! Your ticket is ready.'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Trigger rebuild to show ticket
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _shareTicket(dynamic event, dynamic user) {
    Share.share(
      'Check out my event ticket!\n\n'
      'Event: ${event.title}\n'
      'Date: ${DateFormat('MMM dd, yyyy').format(event.startTime)}\n'
      'Time: ${DateFormat('hh:mm a').format(event.startTime)}\n'
      'Venue: ${event.venue ?? 'TBA'}\n'
      'Participant: ${user.name}\n\n'
      'See you there!',
      subject: 'Event Ticket - ${event.title}',
    );
  }
}

Future<bool> getStatus(String? eventId, String userId, EventController controller) async {
  return await controller.isUserRegistered(eventId!, userId);
}