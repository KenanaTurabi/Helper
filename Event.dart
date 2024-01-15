class Doctor {
  final String name;
  final String image; // You can replace this with the actual type for storing images
final int specialistId;
 final String? currentworkingplace;

  Doctor({required this.name, required this.image, required this.specialistId, this.currentworkingplace});
}

class Patient {
  final String name;
  final String image; // You can replace this with the actual type for storing images
final int patientId;
  Patient({required this.name, required this.image, required this.patientId});
}
class Event {
  final String? meetingType; 
  final String eventTitle;
  final DateTime eventDate;
  final Doctor? doctor; // Selected doctor for the event
  final Patient? patient; // Selected doctor for the event

  final String? availabletimes; // Selected time for the event

  Event({
    required this.meetingType, 
    required this.eventTitle,
    required this.eventDate,
    this.doctor,
    this.patient,
    this.availabletimes,
  });
}
