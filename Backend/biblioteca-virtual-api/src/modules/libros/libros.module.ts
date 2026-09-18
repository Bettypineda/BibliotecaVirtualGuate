import { Module } from '@nestjs/common';
import { LibrosController } from './libros.controller';
import { LibrosService } from './libros.service';
import { DatabaseModule } from '../../database/database.module';

@Module({
  imports: [DatabaseModule],
  controllers: [LibrosController],
  providers: [LibrosService],
})
export class LibrosModule {}