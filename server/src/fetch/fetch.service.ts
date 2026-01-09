import { Injectable } from '@nestjs/common';
import { ErrorHandler, ErrorType } from 'src/utils/error_handler';
import { YoutubeInfo } from './dtos/youtube-info.dto';

import fetch from 'node-fetch';

import { existsSync, readFileSync } from 'fs';

import YTDlpWrap from 'yt-dlp-wrap';

@Injectable()
export class FetchService {
  async search(youtubeFragment: string): Promise<YoutubeInfo> {
    if (youtubeFragment == null || youtubeFragment.length <= 3) {
      throw ErrorHandler.httpException(ErrorType.emptySearch);
    }

    let metadata: any;

    try {
      // Check if input is a URL or a search term/ID
      const isUrl =
        youtubeFragment.includes('youtube.com') ||
        youtubeFragment.includes('youtu.be');
      const query = isUrl ? youtubeFragment : `ytsearch1:${youtubeFragment}`;

      // 1. Setup Binary Path
      // Docker: uses ENV var (/usr/local/bin/yt-dlp)
      // Local: uses undefined (default search)
      const binaryPath = process.env.YTDLP_PATH || undefined;
      const ytDlpWrap = new YTDlpWrap(binaryPath);

      // 2. Get the PO Token
      // In production, mount this file via ExternalSecret
      const poTokenPath = '/etc/secrets/youtube/po_token';
      let poToken = '';

      if (existsSync(poTokenPath)) {
        poToken = readFileSync(poTokenPath, 'utf8').trim();
      } else {
        poToken = process.env.NAYRIS_PO_TOKEN || '';
      }

      // 3. Construct Arguments
      const args = [
        query,
        '--dump-json',
        '--no-playlist',
        '--skip-download',
        // Crucial for Docker environments to allow signature decryption
        '--js-runtimes',
        'node',
      ];

      // 4. Inject PO Token if available
      if (poToken) {
        args.push(
          '--extractor-args',
          `youtube:player_client=web;po_token=web+${poToken}`,
        );
      } else {
        // FALLBACK: Impersonate iOS (often looser bot checks)
        args.push('--extractor-args', 'youtube:player_client=ios');
      }

      const jsonOutput = await ytDlpWrap.execPromise(args);
      metadata = JSON.parse(jsonOutput);
    } catch (e) {
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
      console.log('Thumbnail fetch failed:', e);
    }

    const url =
      metadata.webpage_url || `https://www.youtube.com/watch?v=${metadata.id}`;

    return new YoutubeInfo(
      metadata.uploader,
      metadata.title,
      metadata.description,
      Array.from(rawImage),
      [],
      metadata.view_count,
      metadata.duration_string,
      metadata.upload_date,
      url,
    );
  }
}
