import '../../models/song_data/song_data.dart';

class ConvertData {
  final SongData songData;
  int downloadedCount = 0;
  int totalCount = 0;

  ConvertData(this.songData);

  ConvertData.all(this.songData, this.downloadedCount, this.totalCount);

  ConvertData update(int downloadedCount, int totalCount) =>
      ConvertData.all(songData, downloadedCount, totalCount);
}
