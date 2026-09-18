-- =========================================================
-- Biblioteca Virtual de Guate
-- Tablas asignadas para el CRUD de esta practica: Tbl_Clientes y Tbl_Libros
-- =========================================================

-- La base de datos ya existe (biblioteca_virtual_guate segun tu .env), no
-- es necesario volver a crearla. Si en algun momento la necesitas crear:
-- CREATE DATABASE biblioteca_virtual_guate;

-- ---------------------------------------------------------
-- Se eliminan primero (si existen) para dejar el esquema limpio,
-- respetando el orden por llaves foraneas (hijos antes que padres).
-- ---------------------------------------------------------
DROP TABLE IF EXISTS Tbl_Libros CASCADE;
DROP TABLE IF EXISTS Tbl_Categorias CASCADE;
DROP TABLE IF EXISTS Tbl_Editoriales CASCADE;
DROP TABLE IF EXISTS Tbl_Clientes CASCADE;

-- ---------------------------------------------------------
-- Tablas prerequisito (forman parte del modelo completo de 12
-- tablas de Biblioteca Virtual, pero NO tienen su propio CRUD en
-- esta practica). Se crean con lo minimo indispensable porque
-- Tbl_Libros depende de ellas por llave foranea.
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS Tbl_Editoriales (
    CodigoEditorial      SERIAL PRIMARY KEY,
    NombreEditorial      VARCHAR(120) NOT NULL,
    IdentificacionFiscal VARCHAR(25),
    CorreoEditorial      VARCHAR(120),
    TelefonoEditorial    VARCHAR(20),
    SitioWebEditorial    VARCHAR(200),
    PaisEditorial        VARCHAR(60),
    DireccionEditorial   VARCHAR(200),
    EstadoEditorial      VARCHAR(20) NOT NULL DEFAULT 'Activo'
);

COMMENT ON TABLE Tbl_Editoriales IS 'Editoriales de los libros (tabla prerequisito para Tbl_Libros).';

CREATE TABLE IF NOT EXISTS Tbl_Categorias (
    CodigoCategoria      SERIAL PRIMARY KEY,
    CodigoCategoriaPadre INT REFERENCES Tbl_Categorias(CodigoCategoria),
    NombreCategoria      VARCHAR(80) NOT NULL,
    DescripcionCategoria VARCHAR(200),
    EdadMinima           INT NOT NULL DEFAULT 0,
    PermiteVenta         SMALLINT NOT NULL DEFAULT 1,
    PermiteRenta         SMALLINT NOT NULL DEFAULT 1,
    FechaRegistro        DATE NOT NULL DEFAULT CURRENT_DATE,
    EstadoCategoria      VARCHAR(20) NOT NULL DEFAULT 'Activo'
);

COMMENT ON TABLE Tbl_Categorias IS 'Categorias de los libros (tabla prerequisito para Tbl_Libros).';

-- ---------------------------------------------------------
-- Tabla asignada 1: Tbl_Libros
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS Tbl_Libros (
    CodigoLibro       SERIAL PRIMARY KEY,
    CodigoEditorial   INT NOT NULL REFERENCES Tbl_Editoriales(CodigoEditorial),
    CodigoCategoria   INT NOT NULL REFERENCES Tbl_Categorias(CodigoCategoria),
    ISBN              VARCHAR(20) NOT NULL UNIQUE,
    TituloLibro       VARCHAR(180) NOT NULL,
    SubtituloLibro    VARCHAR(180),
    AnioPublicacion   INT,
    NumeroPaginas     INT,
    IdiomaLibro       VARCHAR(40),
    DescripcionLibro  TEXT,
    PortadaLibro      VARCHAR(255),
    EstadoLibro       VARCHAR(20) NOT NULL DEFAULT 'Activo'
);

COMMENT ON TABLE Tbl_Libros IS 'Libros fisicos y digitales que administra Biblioteca Virtual de Guate.';

-- ---------------------------------------------------------
-- Tabla asignada 2: Tbl_Clientes
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS Tbl_Clientes (
    CodigoCliente        SERIAL PRIMARY KEY,
    NombresCliente       VARCHAR(80) NOT NULL,
    ApellidosCliente     VARCHAR(80) NOT NULL,
    NumeroIdentificacion VARCHAR(25) NOT NULL UNIQUE,
    CorreoCliente        VARCHAR(120),
    TelefonoCliente      VARCHAR(20),
    DireccionCliente     VARCHAR(250),
    ClaveCliente         VARCHAR(255) NOT NULL,
    FechaNacimiento      DATE,
    FechaRegistro        DATE NOT NULL DEFAULT CURRENT_DATE,
    LimiteRentas         INT NOT NULL DEFAULT 5,
    EstadoCliente        VARCHAR(20) NOT NULL DEFAULT 'Activo'
);

COMMENT ON TABLE Tbl_Clientes IS 'Clientes que compran o rentan ejemplares en Biblioteca Virtual de Guate.';
