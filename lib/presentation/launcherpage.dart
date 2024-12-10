import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pocketwise/router/approuter.dart';
import 'package:pocketwise/utils/constants/colors.dart';
import 'package:pocketwise/utils/constants/customAppBar.dart';
import 'package:pocketwise/utils/constants/defaultPadding.dart';
import 'package:pocketwise/utils/globals.dart';
import 'package:pocketwise/utils/widgets/pockets/customElevatedButton.dart';
import 'package:video_player/video_player.dart';

import '../utils/constants/textutil.dart';

class Launcher extends StatefulWidget {
  const Launcher({super.key});

  @override
  State<Launcher> createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Stack(
        children: [
          
         
          Positioned(
             bottom: 50,
            top: 0,
            left: 0,
            right: 0,
            child: VideoPlayerScreen()),
           Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
                height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [black.withOpacity(0.2), black],
                )
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: defaultPadding,
            right: defaultPadding,
            child: Column(
              children: [
                 Positioned(
            top: 50,
            left: defaultPadding,
            right: defaultPadding,
            child: Column(
              children: [
               
                Text("pocketwise".tr(), style: AppTextStyles.largeBold.copyWith(color: white),)
              ],
            )
          ),  SizedBox(height: defaultPadding,),
                Customelevatedbutton(
                  // textcolor: white,
                  color: white,
                  text: "login.login".tr(), onPressed:(){
                  Navigator.pushNamed(context, AppRouter.login);
                } ),
                SizedBox(height: 10,),
                Customelevatedbutton(
                  textcolor: white,
                  text: "register.register".tr(), onPressed:(){
                  Navigator.pushNamed(context, AppRouter.phone);
                } ),
              ],
            ),
          ),
           Positioned(
            top: 50,
            left: defaultPadding,
            right: defaultPadding,
            child: Column(
              children: [
                PocketWiseLogo(),
                Text("pocketwise".tr(), style: AppTextStyles.largeBold.copyWith(color: white),)
              ],
            )
          ),
          //   Positioned(
          //   top: 60,
          //   left: defaultPadding,
          //   right: defaultPadding,
          //   child: Text("home.pocketwise".tr(), style: AppTextStyles.medium.copyWith(color: white),)
          // ),
        ],
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the VideoPlayerController with your asset video
    _controller = VideoPlayerController.asset("assets/videos/intro.mp4");

    // Prepare the video for playback
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {
        _controller.setLooping(true);
        _controller.play(); // Start playing the video automatically
      });
    });
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
