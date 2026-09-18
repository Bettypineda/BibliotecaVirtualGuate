import { Injectable } from '@nestjs/common';
import { DatabaseService } from '../../database/database.service';

@Injectable()
export class LibrosService {
  constructor(private readonly databaseService: DatabaseService) {}

  // ============================================================
  // FUNCIONALIDAD: CONSULTAR LIBROS
  // ============================================================
  async consultar() {
    try {
      const result = await this.databaseService.query(
        'SELECT sp_libro_consultar() AS resultado',
      );
      return result[0].resultado;
    } catch (error: any) {
      return { exito: false, mensaje: error.message, datos: [] };
    }
  }

  // ============================================================
  // FUNCIONALIDAD: BUSCAR LIBRO
  // ============================================================
  async buscar(codigoLibro: number) {
    try {
      const result = await this.databaseService.query(
        'SELECT sp_libro_buscar($1::integer) AS resultado',
        [codigoLibro],
      );
      return result[0].resultado;
    } catch (error: any) {
      return { exito: false, mensaje: error.message, datos: [] };
    }
  }

  // ============================================================
  // FUNCIONALIDAD: AGREGAR LIBRO
  // ============================================================
  async agregar(datos: any) {
    try {
      const {
        codigoEditorial,
        codigoCategoria,
        isbn,
        tituloLibro,
        subtituloLibro,
        anioPublicacion,
        numeroPaginas,
        idiomaLibro,
        descripcionLibro,
        portadaLibro,
      } = datos;

      const result = await this.databaseService.query(
        `SELECT sp_libro_agregar(
          $1::integer, $2::integer, $3::varchar, $4::varchar, $5::varchar,
          $6::integer, $7::integer, $8::varchar, $9::text, $10::varchar
        ) AS resultado`,
        [
          codigoEditorial,
          codigoCategoria,
          isbn,
          tituloLibro,
          subtituloLibro ?? null,
          anioPublicacion,
          numeroPaginas,
          idiomaLibro,
          descripcionLibro ?? null,
          portadaLibro ?? null,
        ],
      );
      return result[0].resultado;
    } catch (error: any) {
      return { exito: false, mensaje: error.message, datos: [] };
    }
  }

  // ============================================================
  // FUNCIONALIDAD: EDITAR LIBRO
  // ============================================================
  async editar(codigoLibro: number, datos: any) {
    try {
      const {
        codigoEditorial,
        codigoCategoria,
        isbn,
        tituloLibro,
        subtituloLibro,
        anioPublicacion,
        numeroPaginas,
        idiomaLibro,
        descripcionLibro,
        portadaLibro,
      } = datos;

      const result = await this.databaseService.query(
        `SELECT sp_libro_editar(
          $1::integer, $2::integer, $3::integer, $4::varchar, $5::varchar,
          $6::varchar, $7::integer, $8::integer, $9::varchar, $10::text, $11::varchar
        ) AS resultado`,
        [
          codigoLibro,
          codigoEditorial,
          codigoCategoria,
          isbn,
          tituloLibro,
          subtituloLibro ?? null,
          anioPublicacion,
          numeroPaginas,
          idiomaLibro,
          descripcionLibro ?? null,
          portadaLibro ?? null,
        ],
      );
      return result[0].resultado;
    } catch (error: any) {
      return { exito: false, mensaje: error.message, datos: [] };
    }
  }

  // ============================================================
  // FUNCIONALIDAD: ELIMINAR LIBRO
  // ============================================================
  async eliminar(codigoLibro: number) {
    try {
      const result = await this.databaseService.query(
        'SELECT sp_libro_eliminar($1::integer) AS resultado',
        [codigoLibro],
      );
      return result[0].resultado;
    } catch (error: any) {
      return { exito: false, mensaje: error.message, datos: [] };
    }
  }
}
