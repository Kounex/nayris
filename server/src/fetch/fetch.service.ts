import { Injectable } from '@nestjs/common';
import { ErrorHandler, ErrorType } from 'src/utils/error_handler';
import { YoutubeInfo } from './dtos/youtube-info.dto';

import fetch from 'node-fetch';

import * as ytsr from 'ytsr';

@Injectable()
export class FetchService {
    async search(youtubeFragment: string): Promise<YoutubeInfo> {
        if (youtubeFragment == null || youtubeFragment.length <= 3) {
            throw ErrorHandler.httpException(ErrorType.emptySearch);
        }

        const filters1 = await ytsr.getFilters(youtubeFragment);
        const filter1 = filters1.get('Type').get('Video');

        const result = await ytsr(filter1.url);

        if (result.items.length <= 0 || result.items[0].type != 'video') {
            throw ErrorHandler.httpException(ErrorType.noResult);
        }

        const video = result.items[0] as ytsr.Video;
        var rawImage = new Uint8Array();

        try {
            rawImage = new Uint8Array((await (await fetch(video.bestThumbnail.url)).arrayBuffer()));
        } catch (e) {
            console.log(e);
        }

        return new YoutubeInfo(
            video.author?.name,
            video.title,
            video.description,
            Array.from(rawImage),
            video.badges,
            video.views,
            video.duration,
            video.uploadedAt,
            video.url,
        );
    }
}
