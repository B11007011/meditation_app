import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/features/music/domain/models/music_track.dart';
import 'package:meditation_app/features/music/domain/controllers/music_player_controller.dart';

class MusicSelectorWidget extends ConsumerWidget {
  final double volume;
  final ValueChanged<double> onVolumeChanged;

  const MusicSelectorWidget({
    super.key,
    required this.volume,
    required this.onVolumeChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final musicState = ref.watch(musicPlayerControllerProvider);
    final musicController = ref.read(musicPlayerControllerProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Background Music',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(
                musicState.playerState == PlayerState.playing
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () {
                if (musicState.playerState == PlayerState.playing) {
                  musicController.pause();
                } else {
                  musicController.resume();
                }
              },
            ),
            Expanded(
              child: Slider(
                value: volume,
                onChanged: onVolumeChanged,
                activeColor: Colors.white,
                inactiveColor: Color.fromRGBO(255, 255, 255, 0.3),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.queue_music,
                color: Colors.white,
              ),
              onPressed: () => _showMusicSelector(context, ref),
            ),
          ],
        ),
      ],
    );
  }

  void _showMusicSelector(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _MusicSelectorBottomSheet(),
    );
  }
}

class _MusicSelectorBottomSheet extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final musicState = ref.watch(musicPlayerControllerProvider);
    final musicController = ref.read(musicPlayerControllerProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Select Background Music',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: musicState.playlist.length,
              itemBuilder: (context, index) {
                final track = musicState.playlist[index];
                final isSelected = track.id == musicState.currentTrack?.id;
                
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: track.imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              track.imageUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.music_note),
                  ),
                  title: Text(track.title),
                  subtitle: Text(track.artist),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  onTap: () {
                    musicController.playTrack(track);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 