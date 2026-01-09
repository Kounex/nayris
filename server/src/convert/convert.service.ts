import { Injectable } from '@nestjs/common';
import { ErrorHandler, ErrorType } from 'src/utils/error_handler';

import {
  createReadStream,
  existsSync,
  mkdirSync,
  readdirSync,
  ReadStream,
  unlinkSync,
  writeFileSync,
} from 'fs';
import { join } from 'path';

import { randomUUID } from 'crypto';
import { SongData } from './dtos/song-data.dto';

import * as ffmpeg from 'fluent-ffmpeg';
import YTDlpWrap from 'yt-dlp-wrap';

@Injectable()
export class ConvertService {
  constructor() {
    // HYBRID PATH SETUP:
    // 1. Try to use @ffmpeg-installer (Local Mac convenience)
    // 2. If that package is missing (Docker), fluent-ffmpeg falls back to system PATH
    try {
      // eslint-disable-next-line @typescript-eslint/no-var-requires
      const ffmpegInstaller = require('@ffmpeg-installer/ffmpeg');
      ffmpeg.setFfmpegPath(ffmpegInstaller.path);
    } catch (e) {
      // @ffmpeg-installer not found.
      // Do nothing; fluent-ffmpeg will look for 'ffmpeg' in the system PATH (Docker)
    }

    // Ensure tmp directory exists
    const tmpDir = join(process.cwd(), 'tmp');
    if (!existsSync(tmpDir)) {
      mkdirSync(tmpDir);
    }
  }

  async createFile(songData: SongData): Promise<ReadStream> {
    if (!songData) {
      throw new Error('SongData is undefined');
    }

    const id = randomUUID();
    const tmpDir = join(process.cwd(), 'tmp');
    const coverPath = join(tmpDir, `${id}.png`);
    const outputMp3Path = join(tmpDir, `${id}.mp3`);

    try {
      // 1. Download Audio
      const ytDlpWrap = new YTDlpWrap();
      await ytDlpWrap.execPromise([
        songData.youtubeLink,
        '-o',
        join(tmpDir, `${id}.%(ext)s`),
        '-f',
        'bestaudio',
        '--no-playlist',
      ]);

      // 2. Find the downloaded audio file
      const files = readdirSync(tmpDir);
      const audioFile = files.find(
        (f) => f.startsWith(id) && !f.endsWith('.png') && !f.endsWith('.mp3'),
      );
      if (!audioFile) throw new Error('Audio file not found after download');
      const audioInputPath = join(tmpDir, audioFile);

      // 3. Write the cover image
      writeFileSync(coverPath, Buffer.from(songData.coverRAW));

      // UNIVERSAL SANITIZATION
      // Use Non-Breaking Spaces (\u00A0) instead of normal spaces.
      // - Mac: Prevents arguments from splitting.
      // - Linux/Docker: Valid UTF-8 character, renders as a space.
      const sanitize = (str: any) => {
        return String(str || '')
          .replace(/[";\\']/g, '') // Remove quotes/backslashes
          .replace(/\s+/g, ' ') // Normalize whitespace
          .trim()
          .replace(/ /g, '\u00A0'); // Replace Space with NBSP
      };

      // 4. Convert and Metadata
      await new Promise<void>((resolve, reject) => {
        ffmpeg()
          .input(audioInputPath)
          .input(coverPath)
          .outputOptions([
            '-map',
            '0:a',
            '-map',
            '1:0',
            '-c:v',
            'copy',
            '-id3v2_version',
            '4',
            '-metadata:s:v',
            'title=AlbumCover',
            '-metadata:s:v',
            'comment=CoverFront',

            // NO QUOTES needed because we used NBSP.
            // This bypasses the parsing issues on Mac completely.
            '-metadata',
            `artist=${sanitize(songData.artist)}`,
            '-metadata',
            `title=${sanitize(songData.title)}`,
            '-metadata',
            `album=${sanitize(songData.album)}`,
            '-metadata',
            `year=${sanitize(songData.year)}`,
          ])
          .audioCodec('libmp3lame')
          .audioQuality(2)
          .save(outputMp3Path)
          .on('end', () => resolve())
          .on('error', (err) => reject(err));
      });

      // 5. Create stream
      const fileReadStream = createReadStream(outputMp3Path);
      fileReadStream.on('close', () => this.cleanup(tmpDir, id));
      setTimeout(() => this.cleanup(tmpDir, id), 60000);

      return fileReadStream;
    } catch (e) {
      this.cleanup(tmpDir, id);
      console.error(e);
      throw ErrorHandler.httpException(ErrorType.convert);
    }
  }

  private cleanup(dir: string, id: string) {
    try {
      const files = readdirSync(dir);
      files
        .filter((f) => f.startsWith(id))
        .forEach((f) => {
          try {
            unlinkSync(join(dir, f));
          } catch (e) {
            /* ignore */
          }
        });
    } catch (e) {
      /* ignore */
    }
  }
}
