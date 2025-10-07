import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/bus_repository.dart';
import '../../data/models/bus_model.dart';

// QR Scanner State
class QrState {
  final bool isLoading;
  final String? error;
  final BusModel? scannedBus;

  const QrState({
    this.isLoading = false,
    this.error,
    this.scannedBus,
  });

  QrState copyWith({
    bool? isLoading,
    String? error,
    BusModel? scannedBus,
  }) {
    return QrState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      scannedBus: scannedBus ?? this.scannedBus,
    );
  }
}

// QR Controller
class QrController extends StateNotifier<QrState> {
  final BusRepository _busRepository;

  QrController(this._busRepository) : super(const QrState());

  Future<BusModel?> validateQrCode(String qrData) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Validate QR code format and decrypt if necessary
      final busId = _extractBusIdFromQr(qrData);

      if (busId == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Invalid QR code format',
        );
        return null;
      }

      // Check if QR code is still valid (not expired)
      if (!_isQrCodeValid(qrData)) {
        state = state.copyWith(
          isLoading: false,
          error: 'QR code has expired',
        );
        return null;
      }

      // Get bus information
      final bus = await _busRepository.getBusByQrCode(qrData);

      if (bus != null) {
        state = state.copyWith(
          isLoading: false,
          scannedBus: bus,
        );

        // Create trip session for feedback access
        await _createTripSession(bus.id);

        return bus;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Bus not found or inactive',
        );
        return null;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return null;
    }
  }

  String? _extractBusIdFromQr(String qrData) {
    try {
      // In a real app, you would decrypt the QR code data
      // For now, we'll assume the QR data is the bus ID
      if (qrData.isNotEmpty && qrData.length > 3) {
        return qrData;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  bool _isQrCodeValid(String qrData) {
    try {
      // In a real app, you would check the timestamp in the QR code
      // For now, we'll assume all QR codes are valid
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _createTripSession(String busId) async {
    try {
      // Create a trip session that allows feedback submission
      // This would typically involve creating a record in Firestore
      // For now, we'll just simulate this
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      // Log error but don't throw as it's not critical
      print('Failed to create trip session: $e');
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void reset() {
    state = const QrState();
  }
}

// Provider
final qrControllerProvider =
    StateNotifierProvider<QrController, QrState>((ref) {
  final busRepository = ref.read(busRepositoryProvider);
  return QrController(busRepository);
});

// Bus Repository Provider (if not defined elsewhere)
final busRepositoryProvider = Provider<BusRepository>((ref) {
  return BusRepository();
});
