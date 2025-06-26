// File: lib/features/5_qr_scanner/cubit/qr_scanner_state.dart
import 'package:equatable/equatable.dart';

enum QrStatus { initial, loading, success, failure }

class QrScannerState extends Equatable {
  final QrStatus status;
  final String? chatRoomId;
  final String? errorMessage;

  const QrScannerState({
    this.status = QrStatus.initial,
    this.chatRoomId,
    this.errorMessage,
  });

  QrScannerState copyWith({
    QrStatus? status,
    String? chatRoomId,
    String? errorMessage,
  }) {
    return QrScannerState(
      status: status ?? this.status,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, chatRoomId, errorMessage];
}
