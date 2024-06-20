import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mindcast/models/PublicVar.dart';

class PlayingControls extends StatelessWidget {
  final bool isPlaying;
  final LoopMode? loopMode;
  final bool isPlaylist, saved;
  final Function()? onPrevious;
  final Function() onPlay;
  final Function()? onNext;
  final Function()? toggleLoop;
  final Function()? onStop;

  PlayingControls({
    required this.isPlaying,
    this.isPlaylist = false,
    this.loopMode,
    this.toggleLoop,
    this.onPrevious,
    required this.onPlay,
    this.onNext,
    this.onStop,
    required this.saved,
  });

  Widget _loopIcon(BuildContext context) {
    final iconSize = 34.0;
    if (loopMode == LoopMode.none) {
      return Icon(
        Icons.loop,
        size: iconSize,
        color: Colors.grey,
      );
    } else if (loopMode == LoopMode.playlist) {
      return Icon(
        Icons.loop,
        size: iconSize,
        color: Colors.black,
      );
    } else {
      //single
      return Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.loop,
            size: iconSize,
            color: Colors.black,
          ),
          Center(
            child: Text(
              '1',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        NeumorphicButton(
          style: NeumorphicStyle(
            color: Colors.transparent,
            boxShape: NeumorphicBoxShape.circle(),
          ),
          padding: EdgeInsets.all(16),
          onPressed: onStop,
          child: saved
              ? Icon(
                  FontAwesome.heart,
                  color: Color(PublicVar.primaryColor),
                )
              : Icon(
                  FontAwesome.heart_o,
                  color: Colors.grey,
                ),
        ),
        SizedBox(
          width: 12,
        ),
        NeumorphicButton(
          style: NeumorphicStyle(
            color: Colors.transparent,
            boxShape: NeumorphicBoxShape.circle(),
          ),
          padding: EdgeInsets.all(10),
          onPressed: isPlaylist ? onPrevious : null,
          child: Icon(Icons.fast_rewind),
        ),
        SizedBox(
          width: 12,
        ),
        NeumorphicButton(
          style: NeumorphicStyle(
            color: Color(PublicVar.primaryColor),
            boxShape: NeumorphicBoxShape.circle(),
          ),
          padding: EdgeInsets.all(24),
          onPressed: onPlay,
          child: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            size: 32,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 12,
        ),
        NeumorphicButton(
          style: NeumorphicStyle(
            color: Colors.transparent,
            boxShape: NeumorphicBoxShape.circle(),
          ),
          padding: EdgeInsets.all(10),
          onPressed: isPlaylist ? onNext : null,
          child: Icon(
            Icons.fast_forward,
            color: Colors.black,
          ),
        ),
        SizedBox(
          width: 12,
        ),
        GestureDetector(
          onTap: () {
            if (toggleLoop != null) toggleLoop!();
          },
          child: _loopIcon(context),
        ),
      ],
    );
  }
}
