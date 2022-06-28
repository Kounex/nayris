import { Module } from '@nestjs/common';
import { ConvertModule } from './convert/convert.module';
import { FetchModule } from './fetch/fetch.module';

@Module({
  imports: [FetchModule, ConvertModule],
  controllers: [],
  providers: [],
})
export class AppModule { }
