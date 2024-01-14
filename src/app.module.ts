import { Module } from '@nestjs/common';

import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PersonaModule } from './core/persona/persona.module';
import { PlanillaModule } from './rrhh/planilla/planilla.module';
import { TrabajadorModule } from './rrhh/trabajador/trabajador.module';
@Module({
  imports: [
    ConfigModule.forRoot(),
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: process.env.DB_HOST,
      port: +process.env.DB_PORT, // + is to convert string to number
      username: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
      schema: process.env.DB_SCHEMA,
      autoLoadEntities: true,
      // synchronize: true,
    }),

    PlanillaModule,

    PersonaModule,

    TrabajadorModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
