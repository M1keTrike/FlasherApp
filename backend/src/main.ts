import { NestFactory, Reflector } from '@nestjs/core';
import { ClassSerializerInterceptor, ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const config = app.get(ConfigService);

  // CORS habilitado para que la app móvil pueda consumir la API.
  app.enableCors();

  // ValidationPipe global: descarta propiedades no declaradas (whitelist) y
  // rechaza el request si llegan propiedades extra (forbidNonWhitelisted).
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  // Interceptor que aplica @Exclude()/@Expose() de las entidades, de modo que
  // el campo password nunca viaje en las respuestas.
  app.useGlobalInterceptors(new ClassSerializerInterceptor(app.get(Reflector)));

  const port = config.get<number>('PORT') ?? 3000;
  await app.listen(port, '0.0.0.0');
}
bootstrap();
