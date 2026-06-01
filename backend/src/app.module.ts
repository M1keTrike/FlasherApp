import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { FlashcardsModule } from './flashcards/flashcards.module';
import { HealthController } from './health/health.controller';

@Module({
  imports: [
    // Variables de entorno disponibles en toda la app.
    ConfigModule.forRoot({ isGlobal: true }),

    // Configuración de TypeORM + PostgreSQL leída del entorno.
    TypeOrmModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        type: 'postgres',
        host: config.get<string>('DB_HOST', 'localhost'),
        port: parseInt(config.get<string>('DB_PORT', '5432'), 10),
        username: config.get<string>('DB_USER', 'flasher'),
        password: config.get<string>('DB_PASSWORD', 'flasher'),
        database: config.get<string>('DB_NAME', 'flasher_db'),
        autoLoadEntities: true,
        // synchronize crea/actualiza el esquema automáticamente. Suficiente
        // para este proyecto académico; en producción real se usarían migraciones.
        synchronize: true,
      }),
    }),

    UsersModule,
    AuthModule,
    FlashcardsModule,
  ],
  controllers: [HealthController],
})
export class AppModule {}
