import 'package:college_connectd/Events/event_controller.dart';
import 'package:college_connectd/auth/controller/auth_controller.dart';
import 'package:college_connectd/model/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:intl/intl.dart';

class EventDetailsScreen extends ConsumerStatefulWidget {
  final String eventId;
  const EventDetailsScreen({required this.eventId, super.key});

  @override
  ConsumerState<EventDetailsScreen> createState() => _EventDetailscreenState();
}

class _EventDetailscreenState extends ConsumerState<EventDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    final eventAsync = ref.watch(getEventProvider(widget.eventId));
    final userAsync = ref.watch(userProvider);
    final isReg = userAsync!= null ?  ref.watch(userRegistrationStatusProvider((widget.eventId,userAsync.registrationId!))) : const AsyncValue.data(false);;




    return Scaffold(
      body: eventAsync.when(
        data: (data) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Routemaster.of(context).pop(),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue.shade600,
                          Colors.purple.shade400,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 60),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              data!.department.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            data.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status and Registration Count Row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: data.isRegistrationOpen ? Colors.green.shade50 : Colors.grey.shade100,
                              border: Border.all(
                                color: data.isRegistrationOpen ? Colors.green : Colors.grey.shade400,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  data.isRegistrationOpen ? Icons.check_circle : Icons.cancel,
                                  size: 16,
                                  color: data.isRegistrationOpen ? Colors.green : Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  data.isRegistrationOpen ? 'Open' : 'Closed',
                                  style: TextStyle(
                                    color: data.isRegistrationOpen ? Colors.green.shade700 : Colors.grey.shade600,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              border: Border.all(color: Colors.blue.shade200),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.people, size: 16, color: Colors.blue.shade600),
                                const SizedBox(width: 4),
                                Text(
                                  '${data.registrationCount} registered',
                                  style: TextStyle(
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Short Description
                      Text(
                        data.shortDescription,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Event Details Cards
                      _buildInfoCard(
                        icon: Icons.access_time,
                        title: 'Event Schedule',
                        child: Column(
                          children: [
                            _buildDetailRow('Start Time', DateFormat('MMM dd, yyyy - hh:mm a').format(data.startTime)),
                            const SizedBox(height: 8),
                            _buildDetailRow('End Time', DateFormat('MMM dd, yyyy - hh:mm a').format(data.endTime)),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      _buildInfoCard(
                        icon: Icons.location_on,
                        title: 'Event Details',
                        child: Column(
                          children: [
                            _buildDetailRow('Venue', data.venue),
                            const SizedBox(height: 8),
                            _buildDetailRow('Eligibility', data.eligibility),
                            if (data.prizeMoney.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              _buildDetailRow('Prize Money', data.prizeMoney),
                            ],
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Team Information (if team event)
                      if (data.isTeamEvent)
                        _buildInfoCard(
                          icon: Icons.group,
                          title: 'Team Information',
                          child: Column(
                            children: [
                              _buildDetailRow('Event Type', 'Team Event'),
                              const SizedBox(height: 8),
                              _buildDetailRow('Team Size', '${data.minTeamSize} - ${data.maxTeamSize} members'),
                            ],
                          ),
                        ),
                      
                      if (data.isTeamEvent) const SizedBox(height: 16),
                      
                      // Tracks (if available)
                      if (data.tracks.isNotEmpty)
                        _buildInfoCard(
                          icon: Icons.category,
                          title: 'Event Tracks',
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: data.tracks.map((track) => 
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  border: Border.all(color: Colors.orange.shade200),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  track,
                                  style: TextStyle(
                                    color: Colors.orange.shade700,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            ).toList(),
                          ),
                        ),
                      
                      if (data.tracks.isNotEmpty) const SizedBox(height: 16),
                      
                      // Description
                      _buildInfoCard(
                        icon: Icons.description,
                        title: 'Description',
                        child: Text(
                          data.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            height: 1.6,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Rules
                      _buildInfoCard(
                        icon: Icons.rule,
                        title: 'Rules & Guidelines',
                        child: Text(
                          data.rules,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            height: 1.6,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 100), // Bottom padding for FAB
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        error: (error, stack) => Scaffold(
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
                  'Oops! Server is busy',
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
        ),
        loading: () => const Scaffold(
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
        ),
      ),
      
      floatingActionButton: eventAsync.maybeWhen(
        data: (data) => data!.isRegistrationOpen ? 
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: FloatingActionButton.extended(
              onPressed: () {

                data.isTeamEvent ? 
                  Routemaster.of(context).push(
                    '/individualRegistrationForm',
                    queryParameters: {'id' : data.id}
                  ) :

                  Routemaster.of(context).push(
                    '/individualRegistrationForm',
                    queryParameters: {'id' : data.id}
                  );

              },
              backgroundColor: Colors.green,
              elevation: 8,
              icon: const Icon(Icons.event, color: Colors.white),
              label: isReg.when(
  data: (value) => value ? Text('View Status',style: TextStyle(color: Colors.white),) : Text('Register Now',style: TextStyle(color: Colors.white),),
  loading: () => CircularProgressIndicator(color: Colors.white,),
  error: (err, _) => Text('Error'),
),

            ),
          ) : null,
        orElse: () => null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.blue.shade600,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}