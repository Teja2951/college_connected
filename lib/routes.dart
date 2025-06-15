import 'package:college_connectd/Events/EventDetailScreen.dart';
import 'package:college_connectd/Events/Teams/team_registration_form.dart';
import 'package:college_connectd/Events/add_event_form.dart';
import 'package:college_connectd/Events/individual_registration_form.dart';
import 'package:college_connectd/attendance/view/live_attendence.dart';
import 'package:college_connectd/auth/view/login_screen.dart';
import 'package:college_connectd/Events/event_screen.dart';
import 'package:college_connectd/homscreen/home_screen.dart';
import 'package:college_connectd/opputunities/oppurtunities_screen.dart';
import 'package:college_connectd/opputunities/oppurtunity_detail_screen.dart';
import 'package:college_connectd/peers/peer_profile.dart';
import 'package:college_connectd/peers/peer_screen.dart';
import 'package:college_connectd/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoutes = RouteMap(routes: {
  '/' : (_) => MaterialPage(child: LoginScreen()),
});

final loggedInRoutes = RouteMap(routes: {

  '/peers' : (_) => MaterialPage(child: PeerScreen()),
  '/profile' : (_) => MaterialPage(child: PeerProfile()),


  '/' : (_) => MaterialPage(child: HomeScreen()),
  '/events' : (_) => MaterialPage(child: EventsScreen()),
  '/addEventForm' : (_) => MaterialPage(child: AddEventForm()),
  '/eventDetailsScreen': (route) {
    final eventId = route.queryParameters['id']!;
    return MaterialPage(child: EventDetailsScreen(eventId: eventId));
  },
  '/individualRegistrationForm' : (route) {
      final eventId = route.queryParameters['id']!;
      return MaterialPage(child: IndividualRegistrationForm(eventId: eventId,));
  },
  '/teamRegistrationForm' : (route) {
      final eventId = route.queryParameters['id']!;
      return MaterialPage(child: TeamRegistrationForm(eventId: eventId,));
  },
  '/profile' : (_) => MaterialPage(child: ProfileScreen()),
  '/liveAttendence' : (_) => MaterialPage(child: LiveAttendence()),
  '/oppurtunies' : (_) => MaterialPage(child: OpportunitiesScreen()),
  '/opportunity/:id': (routeData) => MaterialPage(
      child: OpportunityDetailsScreen(
        opportunityId: routeData.pathParameters['id']!,
      ),
    ),
});