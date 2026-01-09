import { Injectable } from '@nestjs/common';
import { ErrorHandler, ErrorType } from 'src/utils/error_handler';
import { YoutubeInfo } from './dtos/youtube-info.dto';

import fetch from 'node-fetch';

import YTDlpWrap from 'yt-dlp-wrap';

@Injectable()
export class FetchService {
  async search(youtubeFragment: string): Promise<YoutubeInfo> {
    if (youtubeFragment == null || youtubeFragment.length <= 3) {
      throw ErrorHandler.httpException(ErrorType.emptySearch);
    }

    const ytDlpWrap = new YTDlpWrap();
    let metadata: any;

    try {
      // Check if input is a URL or a search term/ID
      const isUrl =
        youtubeFragment.includes('youtube.com') ||
        youtubeFragment.includes('youtu.be');
      const query = isUrl ? youtubeFragment : `ytsearch1:${youtubeFragment}`;

      const jsonOutput = await ytDlpWrap.execPromise([
        query,
        '--dump-json',
        '--no-playlist',
        '--skip-download',
      ]);
      metadata = JSON.parse(jsonOutput);
    } catch (e) {
      throw ErrorHandler.httpException(ErrorType.noResult);
    }

    var rawImage = new Uint8Array();

    try {
      if (metadata.thumbnail) {
        rawImage = new Uint8Array(
          await (await fetch(metadata.thumbnail)).arrayBuffer(),
        );
      }
    } catch (e) {
      console.log(e);
    }

    const url =
      metadata.webpage_url || `https://www.youtube.com/watch?v=${metadata.id}`;

    return new YoutubeInfo(
      metadata.uploader,
      metadata.title,
      metadata.description,
      Array.from(rawImage),
      [], // Badges are not available in yt-dlp JSON
      metadata.view_count,
      metadata.duration_string,
      metadata.upload_date,
      url,
    );
  }
}
