import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';
import { DatabaseService } from './database/database.service';

@Controller()
export class AppController {
  constructor(
    private readonly appService: AppService,
    private readonly databaseService: DatabaseService,
  ) {}

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  @Get('database/test')
  async probarConexion() {
    const conexion = await this.databaseService.probarConexion();
    return {
      exito: conexion ? 1 : 0,
      mensaje: conexion
        ? 'Conexión con PostgreSQL realizada correctamente.'
        : 'No fue posible conectar con PostgreSQL.',
    };
  }
}
