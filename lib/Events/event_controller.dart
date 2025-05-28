import 'package:college_connectd/Events/event_repository.dart';
import 'package:college_connectd/auth/controller/auth_controller.dart';
import 'package:college_connectd/core/Firebase/firebase_providers.dart';
import 'package:college_connectd/model/event_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

  final eventControllerProvider = StateNotifierProvider<EventController,bool>((ref) {
    return EventController(eventRepository: ref.read(eventRepositoryProvider), ref: ref);
  });

  final upcomingEventsProvider = StreamProvider<List<EventModel>>((ref) {
    return ref.read(eventRepositoryProvider).getUpcomingEvents();
  });

  final pastEventsProvider = StreamProvider<List<EventModel>>((ref) {
    return ref.read(eventRepositoryProvider).getPastEvents();
  });

  // final myEventProvider = Future<List<EventModel>>((ref) {
  //   final userId = ref.read(userProvider)!.registrationId;
  //   return ref.read(eventRepositoryProvider).getMyEvents(userId!);
  // });

  final getEventProvider = StreamProvider.family<EventModel?,String>((ref,eventId) {
   return ref.read(eventRepositoryProvider).getEvent(eventId);
  });

class EventController extends StateNotifier<bool> {
  final EventRepository _eventRepository;
  final Ref _ref;

  EventController({
    required EventRepository eventRepository,
    required Ref ref
  }) : _eventRepository = eventRepository, _ref = ref,super(false);

 

  Future<bool> createEvent(EventModel event) async{
    try{
       state = true;
       await _eventRepository.addEvent(event);
       state = false;
       return true;
    }catch(e){
      state = false;
      return false;
    }
  }

  Future<bool> registerUser(String eventId, String userId) async{
    try{
      state = true;
      await _eventRepository.registerUser(eventId, userId);
      state = false;
      return true;
    }catch(e){
      state = false;
      return false;
    }
  }

  Future<bool> isUserRegistered(String eventId, String userId) async{
    try{
      return _eventRepository.isUserRegistered(eventId, userId);
       
    }catch(e){
      return false;
    }
  }

}