-- =========================================================
-- Biblioteca Virtual de Guate - Semana 9
-- TABLA: Tbl_Libros
-- Descripción: Almacena todos los libros disponibles
-- =========================================================
CREATE DATABASE biblioteca_virtual_guate;

-- ====== CREAR TABLA Tbl_Libros ======
-- Esta tabla almacena información de cada libro
-- Prefijo: Tbl_ (según requisito de la tarea)
-- PK: CodigoLibro con SERIAL (auto-incrementable)

CREATE TABLE IF NOT EXISTS Tbl_Libros (
    -- PRIMARY KEY: Identificador único de cada libro (auto-incrementable)
    CodigoLibro         SERIAL PRIMARY KEY,
    
    -- REFERENCIAS A OTRAS TABLAS (para futuro uso)
    -- Nota: Estos campos los dejamos preparados para cuando crees las tablas de Editoriales y Categorías
    CodigoEditorial     INT NOT NULL,           -- Quién publica el libro
    CodigoCategoria     INT NOT NULL,           -- A qué categoría pertenece
    
    -- DATOS DEL LIBRO
    ISBN                VARCHAR(20) NOT NULL UNIQUE,  -- ISBN único (no puede haber 2 libros con mismo ISBN)
    TituloLibro         VARCHAR(200) NOT NULL,        -- Título del libro (máximo 200 caracteres)
    SubtituloLibro      VARCHAR(200),                 -- Subtítulo opcional
    AnioPublicacion     INT NOT NULL,                 -- Año en que fue publicado
    NumeroPaginas       INT,                          -- Cantidad de páginas (opcional)
    IdiomaLibro         VARCHAR(50) NOT NULL DEFAULT 'Español',  -- Idioma (por defecto Español)
    DescripcionLibro    TEXT,                         -- Descripción larga del libro (opcional)
    PortadaLibro        VARCHAR(255),                 -- Ruta a la imagen de portada (opcional)
    
    -- ESTADO DEL REGISTRO
    -- 1 = Activo (se muestra en búsquedas)
    -- 0 = Inactivo (eliminado lógicamente)
    Estado              SMALLINT NOT NULL DEFAULT 1   -- Por defecto los libros están activos
);

COMMENT ON TABLE Tbl_Libros IS 'Libros disponibles en Biblioteca Virtual de Guate';


SELECT * FROM information_schema.tables WHERE table_name = 'Tbl_Libros';
SELECT COUNT(*) FROM Tbl_Libros;



CREATE TABLE IF NOT EXISTS Tbl_Clientes (
    -- PRIMARY KEY: Identificador único de cada cliente (auto-incrementable)
    CodigoCliente           SERIAL PRIMARY KEY,
    
    -- DATOS PERSONALES DEL CLIENTE
    NombresCliente          VARCHAR(100) NOT NULL,      -- Nombre(s) del cliente
    ApellidosCliente        VARCHAR(100) NOT NULL,      -- Apellido(s) del cliente
    NumeroIdentificacion    VARCHAR(25) NOT NULL UNIQUE,-- DPI o cédula (único, no hay 2 clientes con mismo DPI)
    CorreoCliente           VARCHAR(100),               -- Email para comunicación (opcional)
    TelefonoCliente         VARCHAR(20) NOT NULL,       -- Teléfono de contacto
    DireccionCliente        VARCHAR(255) NOT NULL,      -- Dirección física del cliente
    FechaNacimiento         DATE NOT NULL,              -- Fecha de nacimiento
    
    -- INFORMACIÓN DE REGISTRO Y CONTROL
    FechaRegistro           DATE NOT NULL DEFAULT CURRENT_DATE,  -- Fecha cuando se registró el cliente
    
    -- LÍMITES DE NEGOCIO
    -- Controla cuántos libros puede rentar simultáneamente
    LimiteRentas            INT NOT NULL DEFAULT 5,     -- Máximo 5 rentas activas por defecto
    
    -- ESTADO DEL REGISTRO
    -- 1 = Activo (cliente puede comprar/rentar)
    -- 0 = Inactivo (cliente desactivado/eliminado)
    Estado                  SMALLINT NOT NULL DEFAULT 1 -- Por defecto los clientes están activos
);

COMMENT ON TABLE Tbl_Clientes IS 'Clientes registrados en Biblioteca Virtual de Guate';

SELECT * FROM information_schema.tables WHERE table_name = 'Tbl_Clientes';
SELECT COUNT(*) FROM Tbl_Clientes;
