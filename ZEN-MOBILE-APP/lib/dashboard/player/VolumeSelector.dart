import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class VolumeSelector extends StatelessWidget {
  final double volume;
  final Function(double) onChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Volume ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: NeumorphicSlider(
              min: AssetsAudioPlayer.minVolume,
              max: AssetsAudioPlayer.maxVolume,
              value: volume,
              style:
                  SliderStyle(variant: Colors.grey, accent: Colors.grey[500]),
              onChanged: (value) {
                onChange(value);
              },
            ),
          )
        ],
      ),
    );
  }

  const VolumeSelector({
    required this.volume,
    required this.onChange,
  });
}
