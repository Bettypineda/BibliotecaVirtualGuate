import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Pool } from 'pg';

@Injectable()
export class DatabaseService implements OnModuleInit, OnModuleDestroy {
  private readonly pool: Pool;

  constructor(private readonly configService: ConfigService) {
    this.pool = new Pool({
      host: this.configService.get<string>('DB_HOST'),
      port: Number(this.configService.get<string>('DB_PORT')),
      user: this.configService.get<string>('DB_USER'),
      password: this.configService.get<string>('DB_PASSWORD'),
      database: this.configService.get<string>('DB_NAME'),
    });
  }

  async onModuleInit() {
    try {
      const client = await this.pool.connect();
      console.log(
        '✅ Conexión exitosa a PostgreSQL (' +
          this.configService.get<string>('DB_NAME') +
          ')',
      );
      client.release();
    } catch (error: any) {
      console.error('❌ Error al conectar a PostgreSQL:', error.message);
    }
  }

  async query(text: string, params?: unknown[]) {
    const res = await this.pool.query(text, params);
    return res.rows;
  }

  async probarConexion(): Promise<boolean> {
    const resultado = await this.pool.query('SELECT NOW() AS fecha_servidor;');
    return (resultado.rowCount ?? 0) > 0;
  }

  async onModuleDestroy() {
    await this.pool.end();
  }
}
