import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  ParseIntPipe,
  Post,
  Put,
} from '@nestjs/common';
import { ClientesService } from './clientes.service';

@Controller()
export class ClientesController {
  constructor(private readonly clientesService: ClientesService) {}

  // ============================================================
  // GET: CONSULTAR TODOS LOS CLIENTES
  // ============================================================
  @Get('clientesConsultar')
  async consultar() {
    return this.clientesService.consultar();
  }

  // ============================================================
  // GET: BUSCAR CLIENTE POR CODIGO
  // ============================================================
  @Get('clientesBuscar/:codigoCliente')
  async buscar(@Param('codigoCliente', ParseIntPipe) codigoCliente: number) {
    return this.clientesService.buscar(codigoCliente);
  }

  // ============================================================
  // POST: AGREGAR CLIENTE
  // ============================================================
  @Post('clientesAgregar')
  async agregar(@Body() datos: any) {
    return this.clientesService.agregar(datos);
  }

  // ============================================================
  // PUT: EDITAR CLIENTE
  // ============================================================
  @Put('clientesEditar/:codigoCliente')
  async editar(
    @Param('codigoCliente', ParseIntPipe) codigoCliente: number,
    @Body() datos: any,
  ) {
    return this.clientesService.editar(codigoCliente, datos);
  }

  // ============================================================
  // DELETE: ELIMINAR CLIENTE
  // ============================================================
  @Delete('clientesEliminar/:codigoCliente')
  async eliminar(@Param('codigoCliente', ParseIntPipe) codigoCliente: number) {
    return this.clientesService.eliminar(codigoCliente);
  }
}
