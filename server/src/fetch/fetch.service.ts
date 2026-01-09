import { Injectable } from '@nestjs/common';
import { ErrorHandler, ErrorType } from 'src/utils/error_handler';
import { YoutubeInfo } from './dtos/youtube-info.dto';

import fetch from 'node-fetch';

import { existsSync } from 'fs';

import YTDlpWrap from 'yt-dlp-wrap';

@Injectable()
export class FetchService {
  async search(youtubeFragment: string): Promise<YoutubeInfo> {
    if (youtubeFragment == null || youtubeFragment.length <= 3) {
      throw ErrorHandler.httpException(ErrorType.emptySearch);
    }

    // 1. Try to use the path from environment variable (Docker)
    // 2. Fallback to default (Local - lets the library handle it)
    const binaryPath = process.env.YTDLP_PATH || undefined;
    const ytDlpWrap = new YTDlpWrap(binaryPath);

    let metadata: any;

    try {
      // Check if input is a URL or a search term/ID
      const isUrl =
        youtubeFragment.includes('youtube.com') ||
        youtubeFragment.includes('youtu.be');
      const query = isUrl ? youtubeFragment : `ytsearch1:${youtubeFragment}`;

      // Define potential paths for the cookie file
      // 1. /etc/secrets/youtube/cookies.txt (Production/OpenShift Mount)
      // 2. ./cookies.txt (Local Development)
      const prodCookies = '/etc/secrets/youtube/cookies.txt';
      const localCookies = './cookies.txt';

      // Determine which file to use
      const cookiePath = existsSync(prodCookies) ? prodCookies : localCookies;

      const args = [
        query,
        '--dump-json',
        '--no-playlist',
        '--skip-download',
        '--cookies',
        cookiePath, // Use the detected path
        '--js-runtimes',
        'node',
      ];

      const jsonOutput = await ytDlpWrap.execPromise(args);
      metadata = JSON.parse(jsonOutput);
    } catch (e) {
      // CRITICAL: Keep this logging here to debug if it still fails
      console.error('--- YT-DLP ERROR ---');
      console.error(e);
      console.error('--------------------');
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
