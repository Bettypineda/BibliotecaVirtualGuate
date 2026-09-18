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
import { LibrosService } from './libros.service';

@Controller()
export class LibrosController {
  constructor(private readonly librosService: LibrosService) {}

  // ============================================================
  // GET: CONSULTAR TODOS LOS LIBROS
  // ============================================================
  @Get('librosConsultar')
  async consultar() {
    return this.librosService.consultar();
  }

  // ============================================================
  // GET: BUSCAR LIBRO POR CODIGO
  // ============================================================
  @Get('librosBuscar/:codigoLibro')
  async buscar(@Param('codigoLibro', ParseIntPipe) codigoLibro: number) {
    return this.librosService.buscar(codigoLibro);
  }

  // ============================================================
  // POST: AGREGAR LIBRO
  // ============================================================
  @Post('librosAgregar')
  async agregar(@Body() datos: any) {
    return this.librosService.agregar(datos);
  }

  // ============================================================
  // PUT: EDITAR LIBRO
  // ============================================================
  @Put('librosEditar/:codigoLibro')
  async editar(
    @Param('codigoLibro', ParseIntPipe) codigoLibro: number,
    @Body() datos: any,
  ) {
    return this.librosService.editar(codigoLibro, datos);
  }

  // ============================================================
  // DELETE: ELIMINAR LIBRO
  // ============================================================
  @Delete('librosEliminar/:codigoLibro')
  async eliminar(@Param('codigoLibro', ParseIntPipe) codigoLibro: number) {
    return this.librosService.eliminar(codigoLibro);
  }
}
