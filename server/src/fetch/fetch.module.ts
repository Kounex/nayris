import { Module } from '@nestjs/common';
import { FetchController } from './fetch.controller';
import { FetchService } from './fetch.service';

@Module({
  imports: [],
  controllers: [FetchController],
  providers: [FetchService],
})
export class FetchModule {}
