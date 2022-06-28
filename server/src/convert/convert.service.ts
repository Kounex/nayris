import { Injectable } from '@nestjs/common';
import { ErrorHandler, ErrorType } from 'src/utils/error_handler';

import { createReadStream, fstat, ReadStream } from 'fs';
import { join } from 'path';
import { exec, execSync } from 'child_process';
import * as fs from 'fs';

import { SongData } from './dtos/song-data.dto';
import { randomUUID } from 'crypto';

@Injectable()
export class ConvertService {
    async createFile(songData: SongData): Promise<ReadStream> {
        const tmpName = randomUUID();
        try {
            execSync(`yt-dlp -x -o 'tmp/${tmpName}.%(ext)s' ${songData.youtubeLink}`, { encoding: 'utf8' });
            fs.writeFileSync(`tmp/${tmpName}.png`, Buffer.from(songData.coverRAW));
            execSync(`ffmpeg -i tmp/${tmpName}.opus -i tmp/${tmpName}.png -map 0:0 -map 1:0 -c copy -id3v2_version 4 -codec:a libmp3lame -qscale:a 2 -metadata artist="${songData.artist}" -metadata title="${songData.title}" -metadata album="${songData.album}" -metadata year="${songData.year}" tmp/${tmpName}.mp3`);

            const fileReadStream = createReadStream(`tmp/${tmpName}.mp3`);

            setTimeout(() => exec(`rm ${join(process.cwd())}/tmp/${tmpName}.*`), 5000);

            return fileReadStream;
        } catch (e) {
            setTimeout(() => exec(`rm ${join(process.cwd())}/tmp/${tmpName}.*`), 5000);

            throw ErrorHandler.httpException(ErrorType.convert);
        }
    }

    async testExec(): Promise<void> {
        const res = execSync('youtube-dl -x --audio-format mp3 --postprocessor-args "-metadata album=Podcasts" -o "tmp/test.%(ext)s" https://www.youtube.com/watch?v=N_jA5cTznGA', { encoding: 'utf8' });

        console.log(res);

    }
}
