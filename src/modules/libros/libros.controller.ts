import { Controller, Get, Post, Put, Delete, Body, Param } from '@nestjs/common';
import { LibrosService } from './libros.service';

@Controller('libros')
export class LibrosController {
  constructor(private readonly librosService: LibrosService) {}

  @Get()
  consultar() {
    return this.librosService.consultar();
  }

  @Get(':id')
  buscar(@Param('id') id: string) {
    return this.librosService.buscar(+id);
  }

  @Post()
  agregar(@Body() body: any) {
    return this.librosService.agregar(body);
  }

  @Put(':id')
  editar(@Param('id') id: string, @Body() body: any) {
    return this.librosService.editar(+id, body);
  }

  @Delete(':id')
  eliminar(@Param('id') id: string) {
    return this.librosService.eliminar(+id);
  }
}