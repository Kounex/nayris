import { Module } from '@nestjs/common';
import { ConvertController } from './convert.controller';
import { ConvertService } from './convert.service';

@Module({
  imports: [],
  controllers: [ConvertController],
  providers: [ConvertService],
})
export class ConvertModule { }
