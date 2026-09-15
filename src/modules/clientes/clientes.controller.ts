import { Controller, Get, Post, Put, Delete, Body, Param } from '@nestjs/common';
import { ClientesService } from './clientes.service';

@Controller('clientes')
export class ClientesController {
  constructor(private readonly clientesService: ClientesService) {}

  @Get()
  consultar() {
    return this.clientesService.consultar();
  }

  @Get(':id')
  buscar(@Param('id') id: string) {
    return this.clientesService.buscar(+id);
  }

  @Post()
  agregar(@Body() body: any) {
    return this.clientesService.agregar(body);
  }

  @Put(':id')
  editar(@Param('id') id: string, @Body() body: any) {
    return this.clientesService.editar(+id, body);
  }

  @Delete(':id')
  eliminar(@Param('id') id: string) {
    return this.clientesService.eliminar(+id);
  }
}