import { Injectable } from '@nestjs/common';
import { DatabaseService } from '../../database/database.service';

@Injectable()
export class ClientesService {
  constructor(private readonly databaseService: DatabaseService) {}

  async consultar() {
    const result = await this.databaseService.query('SELECT sp_cliente_consultar() AS resultado');
    return result[0].resultado;
  }

  async buscar(id: number) {
    const result = await this.databaseService.query('SELECT sp_cliente_buscar($1) AS resultado', [id]);
    return result[0].resultado;
  }

  async agregar(body: any) {
    const {
      nombresCliente,
      apellidosCliente,
      numeroIdentificacion,
      telefonoCliente,
      direccionCliente,
      fechaNacimiento,
      correoCliente,
    } = body;

    const result = await this.databaseService.query(
      'SELECT sp_cliente_agregar($1, $2, $3, $4, $5, $6, $7) AS resultado',
      [
        nombresCliente,
        apellidosCliente,
        numeroIdentificacion,
        telefonoCliente,
        direccionCliente,
        fechaNacimiento,
        correoCliente,
      ],
    );
    return result[0].resultado;
  }

  async editar(id: number, body: any) {
    const {
      nombresCliente,
      apellidosCliente,
      numeroIdentificacion,
      telefonoCliente,
      direccionCliente,
      fechaNacimiento,
      correoCliente,
    } = body;

    const result = await this.databaseService.query(
      'SELECT sp_cliente_editar($1, $2, $3, $4, $5, $6, $7, $8) AS resultado',
      [
        id,
        nombresCliente,
        apellidosCliente,
        numeroIdentificacion,
        telefonoCliente,
        direccionCliente,
        fechaNacimiento,
        correoCliente,
      ],
    );
    return result[0].resultado;
  }

  async eliminar(id: number) {
    const result = await this.databaseService.query('SELECT sp_cliente_eliminar($1) AS resultado', [id]);
    return result[0].resultado;
  }
}