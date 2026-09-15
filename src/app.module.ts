import { Module } from '@nestjs/common';
import { DatabaseModule } from './database/database.module';
import { LibrosModule } from './modules/libros/libros.module';
import { ClientesModule } from './modules/clientes/clientes.module';

@Module({
  imports: [DatabaseModule, LibrosModule, ClientesModule],
})
export class AppModule {}