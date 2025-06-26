// File: lib/features/5_qr_scanner/cubit/qr_scanner_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/features/2_chat/domain/repositories/chat_repository.dart';
import 'qr_scanner_state.dart';

class QrScannerCubit extends Cubit<QrScannerState> {
  final ChatRepository _chatRepository;
  QrScannerCubit(this._chatRepository) : super(const QrScannerState());

  Future<void> onQrCodeScanned(String partnerUid) async {
    if (state.status == QrStatus.loading) return;
    emit(state.copyWith(status: QrStatus.loading));

    try {
      // You might want to add validation here to ensure the partnerUid is a valid user
      final chatRoomId = await _chatRepository.createChatRoom(partnerUid: partnerUid);
      emit(state.copyWith(status: QrStatus.success, chatRoomId: chatRoomId));
    } catch (e) {
      emit(state.copyWith(status: QrStatus.failure, errorMessage: 'Failed to create chat.'));
    }
  }
}