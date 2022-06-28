import { Body, Controller, Get, Post, Req } from '@nestjs/common';
import { YoutubeInfo } from './dtos/youtube-info.dto';
import { FetchService } from './fetch.service';
import { Request } from 'express';

@Controller()
export class FetchController {

    constructor(private fetchService: FetchService) { }

    @Get('/https://www.youtube.com/:videoFragment')
    public getByYoutubeFragment1(@Req() request: Request): Promise<YoutubeInfo> {
        return this.fetchService.search(request.url.split('com/')[1]);
    }

    @Get('/https://youtube.com/:videoFragment')
    public getByYoutubeFragment2(@Req() request: Request): Promise<YoutubeInfo> {
        return this.fetchService.search(request.url.split('com/')[1]);
    }

    @Get('/www.youtube.com/:videoFragment')
    public getByYoutubeFragment3(@Req() request: Request): Promise<YoutubeInfo> {
        return this.fetchService.search(request.url.split('com/')[1]);
    }

    @Get('/youtube.com/:videoFragment')
    public getByYoutubeFragment4(@Req() request: Request): Promise<YoutubeInfo> {
        return this.fetchService.search(request.url.split('com/')[1]);
    }

    @Get('/watch')
    public getByYoutubeFragment5(@Req() request: Request): Promise<YoutubeInfo> {
        return this.fetchService.search(request.url.split('/')[1]);
    }

    @Post('/fetch')
    public fetch(@Body('videoFragment') videoFragment: string): Promise<YoutubeInfo> {
        return this.fetchService.search(videoFragment);
    }
}
