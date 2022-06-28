import { NestFactory } from '@nestjs/core';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import * as compression from 'compression';
import * as cors from 'cors';
import { json } from 'express';
import { AppModule } from './app.module';


async function bootstrap() {
  const app = await NestFactory.create(AppModule, { bodyParser: false, },);

  app.setGlobalPrefix('api/v1');

  app.use(cors());
  app.use(compression());
  app.use(json({ limit: '10mb' }));

  const config = new DocumentBuilder()
    .setTitle('NAYRIS API')
    .setDescription('Endpoints to fetch meta information for YouTube videos and trigger a convert and download to .mp3')
    .setVersion('1.0')
    .addTag('youtube')
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  await app.listen(process.env.PORT || 4444);
}
bootstrap();
