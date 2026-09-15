import { Injectable } from '@nestjs/common';
import { DatabaseService } from '../../database/database.service';

@Injectable()
export class LibrosService {
  constructor(private readonly databaseService: DatabaseService) {}

  async consultar() {
    try {
      const result = await this.databaseService.query('SELECT sp_libro_consultar() AS resultado');
      return result[0]?.resultado ?? result;
    } catch (error: any) {
      return { estado: false, mensaje: error.message };
    }
  }

  async buscar(id: number) {
    try {
      const result = await this.databaseService.query(
        'SELECT sp_libro_buscar($1::integer) AS resultado',
        [Number(id)],
      );
      return result[0]?.resultado ?? result;
    } catch (error: any) {
      return { estado: false, mensaje: error.message };
    }
  }

  async agregar(body: any) {
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
      } = body;

      const result = await this.databaseService.query(
        'SELECT sp_libro_agregar($1::integer, $2::integer, $3::text, $4::text, $5::text, $6::integer, $7::integer, $8::text, $9::text) AS resultado',
        [
          Number(codigoEditorial),
          Number(codigoCategoria),
          String(isbn ?? ''),
          String(tituloLibro ?? ''),
          String(subtituloLibro ?? ''),
          Number(anioPublicacion),
          Number(numeroPaginas),
          String(idiomaLibro ?? ''),
          String(descripcionLibro ?? ''),
        ],
      );
      return result[0]?.resultado ?? result;
    } catch (error: any) {
      return { estado: false, mensaje: error.message };
    }
  }

  async editar(id: number, body: any) {
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
      } = body;

      const result = await this.databaseService.query(
        'SELECT sp_libro_editar($1::integer, $2::integer, $3::integer, $4::text, $5::text, $6::text, $7::integer, $8::integer, $9::text, $10::text) AS resultado',
        [
          Number(id),
          Number(codigoEditorial),
          Number(codigoCategoria),
          String(isbn ?? ''),
          String(tituloLibro ?? ''),
          String(subtituloLibro ?? ''),
          Number(anioPublicacion),
          Number(numeroPaginas),
          String(idiomaLibro ?? ''),
          String(descripcionLibro ?? ''),
        ],
      );
      return result[0]?.resultado ?? result;
    } catch (error: any) {
      return { estado: false, mensaje: error.message };
    }
  }

  async eliminar(id: number) {
    try {
      const result = await this.databaseService.query(
        'SELECT sp_libro_eliminar($1::integer) AS resultado',
        [Number(id)],
      );
      return result[0]?.resultado ?? result;
    } catch (error: any) {
      return { estado: false, mensaje: error.message };
    }
  }
}