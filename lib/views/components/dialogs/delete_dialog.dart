
import 'package:flutter/foundation.dart' show immutable;
import 'package:instantgram/views/components/constants/strings.dart';
import 'package:instantgram/views/components/dialogs/alert_dialog_model.dart';

@immutable
class DeleteDialog extends AlertDialogModel<bool> {
  const DeleteDialog({
    required String titleOfObjectToDelete
  }) : super(
    title: '${Strings.delete} $titleOfObjectToDelete?',
    message: '${Strings.areYouSureThatYouWantToLogOutOfTheApp} $titleOfObjectToDelete?',
    buttons: const{
      Strings.cancel: false,
      Strings.delete: true,
    }
  );
}