# Biblioteca Virtual de Guate

Sistema para administrar la venta y renta de libros fisicos y digitales.

## Estructura del repositorio

- **Backend/** - Proyecto NestJS + PostgreSQL con el API REST. CRUD completo (Consultar, Buscar, Agregar, Editar, Eliminar) implementado para las tablas `Tbl_Clientes` y `Tbl_Libros`.
- **Database/** - Scripts de base de datos PostgreSQL:
  - `01_bd_biblioteca.sql`: creacion de tablas (`Tbl_Clientes`, `Tbl_Libros` y las tablas prerequisito `Tbl_Editoriales`/`Tbl_Categorias`).
  - `02_stored_procedures.sql`: stored procedures CRUD (`sp_cliente_*`, `sp_libro_*`).
  - `03_datos_prueba.sql`: datos de prueba.
- **FrontEnd/** - Pendiente.
- **Docs/** - Pendiente.
- **docker-compose.yml** - Levanta PostgreSQL y el backend juntos con Docker.

## Como levantar el backend

### Opcion A: con Docker (recomendado)

1. En la raiz del repositorio, ejecutar `docker-compose up --build`. Esto crea el contenedor de PostgreSQL (cargando automaticamente, en orden, los scripts de `Database/`) y el contenedor del backend NestJS.
2. Probar en Postman contra `http://localhost:3000/api/...` (ver endpoints en el codigo de los controllers de `clientes` y `libros`).

### Opcion B: manual (sin Docker)

1. Ejecutar en PostgreSQL, en orden: `Database/01_bd_biblioteca.sql` -> `Database/02_stored_procedures.sql` -> `Database/03_datos_prueba.sql`.
2. En `Backend/biblioteca-virtual-api`, copiar `.env.example` a `.env` y ajustar credenciales.
3. `npm install` y `npm run start:dev`.
4. Probar en Postman contra `http://localhost:3000/api/...` (ver endpoints en el codigo de los controllers de `clientes` y `libros`).
