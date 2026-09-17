
INSERT INTO Tbl_Libros (
    CodigoEditorial,
    CodigoCategoria,
    ISBN,
    TituloLibro,
    SubtituloLibro,
    AnioPublicacion,
    NumeroPaginas,
    IdiomaLibro,
    DescripcionLibro,
    Estado
) VALUES
-- Libro 1: Clásico de realismo mágico
(1, 1, '978-8420471839', 'Cien Años de Soledad', 'La saga de los Buendía', 1967, 471, 'Español', 'Novela de realismo mágico que cuenta la historia de la familia Buendía en Macondo', 1),

-- Libro 2: Cuentos filosóficos
(1, 1, '978-0061120084', 'Ficciones', 'Cuentos de Jorge Luis Borges', 1944, 208, 'Español', 'Colección de cuentos filosóficos que juegan con la realidad', 1),

-- Libro 3: Novela intergeneracional
(1, 1, '978-8445074282', 'La Casa de los Espíritus', NULL, 1982, 568, 'Español', 'Novela intergeneracional de una familia chilena en el siglo XX', 1),

-- Libro 4: Testimonio autobiográfico
(1, 2, '978-8425406621', 'Me llamo Rigoberta Menchú', 'Mi vida y mi lucha', 1983, 270, 'Español', 'Testimonio autobiográfico de la Nobel de Paz sobre su lucha en Guatemala', 1),

-- Libro 5: Novela política
(1, 1, '978-8437603957', 'El Señor Presidente', NULL, 1946, 320, 'Español', 'Novela política que critica la dictadura en Guatemala', 1),

-- Libro 6: Ciencia ficción
(1, 3, '978-0545010770', 'El Juego de Ender', 'Una novela de ciencia ficción', 1985, 324, 'Español', 'Novela futurista sobre un niño estratega en una batalla galáctica', 1),

-- Libro 7: Desarrollo personal
(1, 4, '978-8449302084', 'Los Cuatro Acuerdos', 'Sabiduría tolteca', 1997, 256, 'Español', 'Guía de transformación personal basada en sabiduría tolteca', 1),

-- Libro 8: Programación
(1, 5, '978-8449363121', 'Python para Data Science', 'Aprende Python desde cero', 2020, 450, 'Español', 'Guía técnica completa de Python para análisis de datos', 1),

-- Libro 9: Novela experimental
(1, 1, '978-8408095996', 'Rayuela', 'Novela experimental', 1963, 635, 'Español', 'Novela que puede leerse en diferente orden, desafiando la lectura lineal', 1),

-- Libro 10: Poesía
(1, 6, '978-8408097747', '20 Poemas de Amor', 'Colección poética', 1924, 112, 'Español', 'Colección clásica de poemas románticos de Pablo Neruda', 1);

-- ======================== INSERTAR CLIENTES ========================
-- Insertamos 10 clientes de prueba con información ficticia
-- Estos clientes se usarán para probar las funciones CRUD en Postman

INSERT INTO Tbl_Clientes (
    NombresCliente,
    ApellidosCliente,
    NumeroIdentificacion,
    CorreoCliente,
    TelefonoCliente,
    DireccionCliente,
    FechaNacimiento,
    FechaRegistro,
    LimiteRentas,
    Estado
) VALUES
-- Cliente 1: Pedro Pérez
(
    'Pedro',
    'Pérez García',
    '1990123450101',
    'pedro.perez@email.com',
    '7111-3000',
    'Calle 1 Avenida 2, Zona 1, Ciudad de Guatemala',
    '1990-05-15',      -- Nace el 15 de mayo de 1990
    CURRENT_DATE,      -- Se registra hoy
    5,                 -- Puede rentar hasta 5 libros simultáneamente
    1                  -- Estado: Activo
),

-- Cliente 2: Andrea López
(
    'Andrea',
    'López Ruiz',
    '1995987650102',
    'andrea.lopez@email.com',
    '7222-3001',
    'Boulevard Principal 456, Zona 9, Ciudad de Guatemala',
    '1995-08-22',
    CURRENT_DATE,
    5,
    1
),

-- Cliente 3: Roberto Martínez
(
    'Roberto',
    'Martínez Gómez',
    '1988456780103',
    'roberto.martinez@email.com',
    '7333-3002',
    'Avenida Central 789, Zona 3, Ciudad de Guatemala',
    '1988-03-10',
    CURRENT_DATE,
    5,
    1
),

-- Cliente 4: Sofía Rodríguez
(
    'Sofía',
    'Rodríguez Hernández',
    '1992345670104',
    'sofia.rodriguez@email.com',
    '7444-3003',
    'Calle 15 Avenida 10, Zona 10, Ciudad de Guatemala',
    '1992-11-30',
    CURRENT_DATE,
    5,
    1
),

-- Cliente 5: Fernando González
(
    'Fernando',
    'González López',
    '1987567890105',
    'fernando.gonzalez@email.com',
    '7555-3004',
    'Diagonal 5 Avenida 20, Zona 2, Ciudad de Guatemala',
    '1987-07-18',
    CURRENT_DATE,
    5,
    1
),

-- Cliente 6: Mariana Vega
(
    'Mariana',
    'Vega Mendoza',
    '1993678901106',
    'mariana.vega@email.com',
    '7666-3005',
    'Calle 8 Avenida 15, Zona 4, Ciudad de Guatemala',
    '1993-01-25',
    CURRENT_DATE,
    5,
    1
),

-- Cliente 7: Eduardo Ruiz
(
    'Eduardo',
    'Ruiz García',
    '1989234567107',
    'eduardo.ruiz@email.com',
    '7777-3006',
    'Boulevard 12 Calle 5, Zona 5, Ciudad de Guatemala',
    '1989-09-12',
    CURRENT_DATE,
    5,
    1
),

-- Cliente 8: Claudia Morales
(
    'Claudia',
    'Morales Chávez',
    '1994789012108',
    'claudia.morales@email.com',
    '7888-3007',
    'Avenida 6 Calle 22, Zona 6, Ciudad de Guatemala',
    '1994-06-08',
    CURRENT_DATE,
    5,
    1
),

-- Cliente 9: Tomás Flores
(
    'Tomás',
    'Flores Sánchez',
    '1991345678109',
    'tomas.flores@email.com',
    '7999-3008',
    'Calle 18 Avenida 25, Zona 7, Ciudad de Guatemala',
    '1991-04-20',
    CURRENT_DATE,
    5,
    1
),

-- Cliente 10: Valentina Díaz
(
    'Valentina',
    'Díaz Romero',
    '1996012345110',
    'valentina.diaz@email.com',
    '8000-3009',
    'Boulevard 20 Avenida 8, Zona 8, Ciudad de Guatemala',
    '1996-12-02',
    CURRENT_DATE,
    5,
    1
);

-- ======================== VERIFICACIÓN ========================
-- Ejecuta estos SELECT para verificar que los datos se insertaron correctamente

SELECT 'VERIFICACIÓN DE DATOS INSERTADOS' as titulo;
SELECT '---' as separador;

-- Contar libros insertados
SELECT 'Total de Libros:' as descripcion, COUNT(*) as cantidad FROM Tbl_Libros WHERE Estado = 1;

-- Contar clientes insertados
SELECT 'Total de Clientes:' as descripcion, COUNT(*) as cantidad FROM Tbl_Clientes WHERE Estado = 1;

-- Mostrar los primeros 3 libros como muestra
SELECT 'Muestra de Libros:' as descripcion;
SELECT CodigoLibro, TituloLibro, ISBN, AnioPublicacion FROM Tbl_Libros LIMIT 3;

-- Mostrar los primeros 3 clientes como muestra
SELECT 'Muestra de Clientes:' as descripcion;
SELECT CodigoCliente, NombresCliente, ApellidosCliente, NumeroIdentificacion FROM Tbl_Clientes LIMIT 3;
