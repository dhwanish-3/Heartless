import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';

class DemoPage extends StatefulWidget {
  final String videoUrl;
  final String title;

  const DemoPage({
    Key? key,
    required this.title,
    required this.videoUrl,
  });
  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  late CachedVideoPlayerController _videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;
  // late CustomVideoPlayerWebController _customVideoPlayerWebController;

  final CustomVideoPlayerSettings _customVideoPlayerSettings =
      const CustomVideoPlayerSettings(showSeekButtons: true);

  @override
  void initState() {
    super.initState();

    _videoPlayerController = CachedVideoPlayerController.network(
      widget.videoUrl,
    )..initialize().then((value) => setState(() {}));

    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
      customVideoPlayerSettings: _customVideoPlayerSettings,
    );
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomVideoPlayer(
                customVideoPlayerController: _customVideoPlayerController,
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Steps',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text('''
- place arms at shoulder width
- straighten out your back
- feel the weight on your toes, shoulders and forearms
- focus on some point right infront of you 
- in one fluid motion move your arms downward
- stand still
- do not move until your muscles endure fatigue
                  '''),
                    Divider(),
                    Text(
                      'Advantages',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text('''
- place arms at shoulder width
- straighten out your back
- feel the weight on your toes, shoulders and forearms
- focus on some point right infront of you 
- in one fluid motion move your arms downward
- stand still
- do not move until your muscles endure fatigue
                  '''),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
