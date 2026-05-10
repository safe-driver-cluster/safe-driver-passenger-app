import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

class EmailService {
  EmailService({FirebaseFunctions? functions})
      : _functions =
            functions ?? FirebaseFunctions.instanceFor(region: 'asia-south1');

  final FirebaseFunctions _functions;

  Future<bool> sendPasswordChangedEmail({
    String source = 'in_app_change',
  }) async {
    try {
      final callable = _functions.httpsCallable('sendPasswordChangedEmail');
      final result = await callable.call({'source': source});
      final data = Map<String, dynamic>.from(result.data as Map);
      return data['success'] == true || data['skipped'] == true;
    } on FirebaseFunctionsException catch (error) {
      debugPrint(
        'EmailService.sendPasswordChangedEmail failed: '
        '${error.code} ${error.message}',
      );
      return false;
    } catch (error) {
      debugPrint('EmailService.sendPasswordChangedEmail failed: $error');
      return false;
    }
  }
}
