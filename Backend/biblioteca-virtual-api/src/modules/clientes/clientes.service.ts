import { Injectable } from '@nestjs/common';
import { DatabaseService } from '../../database/database.service';

@Injectable()
export class ClientesService {
  constructor(private readonly databaseService: DatabaseService) {}

  // ============================================================
  // FUNCIONALIDAD: CONSULTAR CLIENTES
  // ============================================================
  async consultar() {
    try {
      const result = await this.databaseService.query(
        'SELECT sp_cliente_consultar() AS resultado',
      );
      return result[0].resultado;
    } catch (error: any) {
      return { exito: false, mensaje: error.message, datos: [] };
    }
  }

  // ============================================================
  // FUNCIONALIDAD: BUSCAR CLIENTE
  // ============================================================
  async buscar(codigoCliente: number) {
    try {
      const result = await this.databaseService.query(
        'SELECT sp_cliente_buscar($1::integer) AS resultado',
        [codigoCliente],
      );
      return result[0].resultado;
    } catch (error: any) {
      return { exito: false, mensaje: error.message, datos: [] };
    }
  }

  // ============================================================
  // FUNCIONALIDAD: AGREGAR CLIENTE
  // ============================================================
  async agregar(datos: any) {
    try {
      const {
        nombresCliente,
        apellidosCliente,
        numeroIdentificacion,
        correoCliente,
        telefonoCliente,
        direccionCliente,
        claveCliente,
        fechaNacimiento,
        limiteRentas,
      } = datos;

      const result = await this.databaseService.query(
        `SELECT sp_cliente_agregar(
          $1::varchar, $2::varchar, $3::varchar, $4::varchar,
          $5::varchar, $6::varchar, $7::varchar, $8::date, $9::integer
        ) AS resultado`,
        [
          nombresCliente,
          apellidosCliente,
          numeroIdentificacion,
          correoCliente,
          telefonoCliente,
          direccionCliente,
          claveCliente,
          fechaNacimiento,
          limiteRentas ?? 5,
        ],
      );
      return result[0].resultado;
    } catch (error: any) {
      return { exito: false, mensaje: error.message, datos: [] };
    }
  }

  // ============================================================
  // FUNCIONALIDAD: EDITAR CLIENTE
  // ============================================================
  async editar(codigoCliente: number, datos: any) {
    try {
      const {
        nombresCliente,
        apellidosCliente,
        numeroIdentificacion,
        correoCliente,
        telefonoCliente,
        direccionCliente,
        claveCliente,
        fechaNacimiento,
        limiteRentas,
      } = datos;

      const result = await this.databaseService.query(
        `SELECT sp_cliente_editar(
          $1::integer, $2::varchar, $3::varchar, $4::varchar, $5::varchar,
          $6::varchar, $7::varchar, $8::varchar, $9::date, $10::integer
        ) AS resultado`,
        [
          codigoCliente,
          nombresCliente,
          apellidosCliente,
          numeroIdentificacion,
          correoCliente,
          telefonoCliente,
          direccionCliente,
          claveCliente,
          fechaNacimiento,
          limiteRentas ?? 5,
        ],
      );
      return result[0].resultado;
    } catch (error: any) {
      return { exito: false, mensaje: error.message, datos: [] };
    }
  }

  // ============================================================
  // FUNCIONALIDAD: ELIMINAR CLIENTE
  // ============================================================
  async eliminar(codigoCliente: number) {
    try {
      const result = await this.databaseService.query(
        'SELECT sp_cliente_eliminar($1::integer) AS resultado',
        [codigoCliente],
      );
      return result[0].resultado;
    } catch (error: any) {
      return { exito: false, mensaje: error.message, datos: [] };
    }
  }
}
