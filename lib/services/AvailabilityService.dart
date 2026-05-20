import 'package:cloud_firestore/cloud_firestore.dart';

class AvailabilityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> checkAvailability(String pincode) async {
    try {
      final doc = await _firestore
          .collection('serviceAreas')
          .doc(pincode)
          .get();

      if (!doc.exists) {
        return false;
      }

      final data = doc.data() as Map<String, dynamic>;

      print(data);

      return data['available'] ?? false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
