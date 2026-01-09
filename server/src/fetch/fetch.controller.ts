import { Body, Controller, Get, Post, Req } from '@nestjs/common';
import { Request } from 'express';
import { YoutubeInfo } from './dtos/youtube-info.dto';
import { FetchService } from './fetch.service';

@Controller()
export class FetchController {
  constructor(private fetchService: FetchService) {}

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
  public fetch(
    @Body('videoFragment') videoFragment: string,
  ): Promise<YoutubeInfo> {
    console.log('--- REQUEST RECEIVED ---');
    console.log('Body content:', videoFragment);

    try {
      return this.fetchService.search(videoFragment);
    } catch (e) {
      console.error('--- ERROR CAUGHT IN CONTROLLER ---');
      console.error(e);
      throw e; // Re-throw so Nest handles it, or return your custom error
    }
  }
}
