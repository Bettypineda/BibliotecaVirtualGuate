import { Injectable, OnModuleInit } from '@nestjs/common';
import { Pool } from 'pg';

@Injectable()
export class DatabaseService implements OnModuleInit {
  private pool: Pool;

  constructor() {
    this.pool = new Pool({
      host: process.env.DB_HOST || 'localhost',
      port: Number(process.env.DB_PORT) || 5432,
      user: process.env.DB_USER || 'postgres',
      password: process.env.DB_PASSWORD || 'Desarrolloweb_2026*',
      database: process.env.DB_NAME || 'db_sanatoriomedico',
    });
  }

  async onModuleInit() {
    try {
      const client = await this.pool.connect();
      console.log('✅ Conexión exitosa a PostgreSQL');
      client.release();
    } catch (error: any) {
      console.error('❌ Error al conectar a PostgreSQL:', error.message);
    }
  }

  async query(text: string, params?: any[]) {
    const res = await this.pool.query(text, params);
    return res.rows;
  }
}