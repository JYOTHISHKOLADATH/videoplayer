import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late FlickManager flickManager;
  List<String> videoUrls = [
    "https://drive.google.com/uc?export=download&id=1q9Buq03A-u5E5aWAepBk_2aTz0yXxKKj",
    "https://drive.google.com/uc?export=download&id=13iy0PONAwA7TmNJhRW1r7-Gc2IrAizPt",
    "https://drive.google.com/uc?export=download&id=17yTyeftHy2Mu-_pzSO2TeRlqh7QtqLlm"
  ];
  int currentVideoIndex = 0;

  @override
  void initState() {
    _preventScreenShotsOn();
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(
        videoUrls[currentVideoIndex],
      ),
    );
  }

  void _preventScreenShotsOn() async =>
      await ScreenProtector.preventScreenshotOn();

  void playNextVideo() {
    setState(() {
      currentVideoIndex = (currentVideoIndex + 1) % videoUrls.length;
      flickManager.handleChangeVideo(
        VideoPlayerController.network(videoUrls[currentVideoIndex]),
      );
    });
  }

  void playPreviousVideo() {
    setState(() {
      currentVideoIndex =
          (currentVideoIndex - 1 + videoUrls.length) % videoUrls.length;
      flickManager.handleChangeVideo(
        VideoPlayerController.network(videoUrls[currentVideoIndex]),
      );
    });
  }

  Future<void> downloadVideo(String url) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      var dir = await getExternalStorageDirectory();
      if (dir != null) {
        String savePath =
            "${dir.path}/video_${DateTime.now().millisecondsSinceEpoch}.mp4";
        try {
          await Dio().download(url, savePath);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Video downloaded to $savePath')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to download video: $e')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission denied')),
      );
    }
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  final ValueNotifier<ThemeMode> _notifier = ValueNotifier(ThemeMode.light);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0XFFF3F3F3),
        body: Column(
          children: [
            Stack(
              children: [
                FlickVideoPlayer(flickManager: flickManager),
                Positioned(
                  top: 10,
                  left: 20,
                  right: 15,
                  child: Container(
                    width: double.maxFinite,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Builder(builder: (context) {
                          return InkWell(
                            onTap: () {
                              Scaffold.of(context).openDrawer();
                            },
                            child: SizedBox(
                              height: 43,
                              child: SvgPicture.asset(
                                'assets/svg/Group 1.svg',
                              ),
                            ),
                          );
                        }),
                        Container(
                          height: 43,
                          width: 43,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: playPreviousVideo,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.arrow_back_ios_new),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => downloadVideo(videoUrls[currentVideoIndex]),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(right: 13),
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_drop_down_sharp,
                              color: Color(0XFF57EE9D),
                              size: 45,
                            ),
                            Text("Download"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: playNextVideo,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        drawer: Drawer(
          width: width * 0.65,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: ListView(
              children: [
                ListTile(
                  title: const Text("Profile"),
                  onTap: () {},
                ),
                ListTile(
                  title: const Row(
                    children: [
                      Text("Theme"),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.sunny),
                      // Icon(Icons.nights_stay),
                    ],
                  ),
                  onTap: () {
                    // _notifier.value = mode = ThemeData.light()?
                  },
                ),
                ListTile(
                  title: const Text("Logout"),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
