import { Body, Controller, Get, Post, Req, StreamableFile } from '@nestjs/common';
import { SongData } from './dtos/song-data.dto';
import { ConvertService } from './convert.service';
import { Request } from 'express';
import { createReadStream } from 'fs';
import { join } from 'path';

@Controller()
export class ConvertController {

  constructor(private convertService: ConvertService) { }

  @Post('/convert')
  public async convert(@Body() songData: SongData): Promise<StreamableFile> {
    const file = await this.convertService.createFile(songData);

    return new StreamableFile(file);
  }

  @Get('/test')
  public async test(): Promise<string> {
    this.convertService.testExec();

    return 'done';
  }
}
