
import 'dart:collection';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram/state/post_settings/models/post_setting.dart';

class PostSettingNotifier extends StateNotifier<Map<PostSetting, bool>>{
  PostSettingNotifier() : super(
      UnmodifiableMapView({ //UnmodifiableMapView ensures that the map cannot be modified directly.
      for (final setting in PostSetting.values) setting: true, //This by default sets all as true until you change it yourself
      }),
  );

  void setSetting(PostSetting setting, bool value){
    final existingValue = state[setting];
    //This part checks whether the new value is different from the existing value for the specified setting.
    // If the new value is the same as the existing value or if the setting doesn't exist in the state, it does nothing (return;).
    if(existingValue == null || existingValue == value){
      return;
    }

    //Finally, if the new value is different from the existing value, it updates the state.
    state = Map.unmodifiable(
      Map.from(state)..[setting] = value, //Take map from current state and move it to the given value
    );
  }
}