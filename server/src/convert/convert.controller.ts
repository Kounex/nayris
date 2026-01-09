import { Body, Controller, Post, StreamableFile } from '@nestjs/common';
import { ConvertService } from './convert.service';
import { SongData } from './dtos/song-data.dto';

@Controller()
export class ConvertController {

  constructor(private convertService: ConvertService) { }

  @Post('/convert')
  public async convert(@Body() songData: SongData): Promise<StreamableFile> {
    const file = await this.convertService.createFile(songData);

    return new StreamableFile(file);
  }
}
