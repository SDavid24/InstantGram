import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram/state/auth/providers/auth_state_provider.dart';
import 'package:instantgram/state/image_upload/helpers/image_picker_helper.dart';
import 'package:instantgram/state/image_upload/models/file_type.dart';
import 'package:instantgram/state/post_settings/provider/post_setting_provider.dart';
import 'package:instantgram/views/components/dialogs/alert_dialog_model.dart';
import 'package:instantgram/views/constants/strings.dart';
import 'package:instantgram/views/create_new_post/create_new_post_view.dart';
import 'package:instantgram/views/tabs/users_posts/user_posts_view.dart';

import '../components/dialogs/log_out_dialog.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.appName),
          actions: [
            IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.film,
              ),
              onPressed: () async {
                //pick a video first
                final videoFile =
                    await ImagePickerHelper.pickVideoFromGallery();
                if(videoFile == null) {
                  return;
                }
                ref.refresh(postSettingProvider);

                // go to the screen to create a new post
                if(!mounted){
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateNewPostView(
                      fileToPost: videoFile,
                      fileType: FileType.video,
                    ),
                  ),
                );
              },
            ),

            IconButton(
              icon: const Icon(
                Icons.add_photo_alternate_outlined,
              ),
              onPressed: () async {
                //pick a video first
                final imageFile = await ImagePickerHelper.pickImageFromGallery();

                if(imageFile == null) {
                  return;
                }
                ref.refresh(postSettingProvider);

                // go to the screen to create a new post
                if(!mounted){
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateNewPostView(
                      fileToPost: imageFile,
                      fileType: FileType.image,
                    ),
                  ),
                );
              },
            ),

            IconButton(
              icon: const Icon(
                Icons.logout,
              ),
              onPressed: () async {
                final shouldLogOut = await const LogoutDialog()
                    .present(context)
                    .then((value) => value ?? false);
                if(shouldLogOut){
                  await ref.read(authStateProvider.notifier).logout();
                }
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.person),
              ),
              Tab(
                icon: Icon(Icons.search),
              ),
              Tab(
                icon: Icon(Icons.home),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            UserPostView(),
            UserPostView(),
            UserPostView(),
          ],
        ),
      ),
    );
  }
}

