-- =========================================================
-- Catalogos previos (editoriales y categorias) necesarios
-- para poder registrar libros, ya que dependen de estas
-- llaves foraneas.
-- =========================================================
INSERT INTO Tbl_Editoriales (NombreEditorial, IdentificacionFiscal, CorreoEditorial, TelefonoEditorial, SitioWebEditorial, PaisEditorial, DireccionEditorial)
VALUES
    ('Editorial Piedra Santa', '123456-7', 'contacto@piedrasanta.com', '22551234', 'https://www.piedrasanta.com', 'Guatemala', 'Zona 4, Ciudad de Guatemala'),
    ('Alfaguara',              '987654-3', 'contacto@alfaguara.com',   '22559876', 'https://www.alfaguara.com',   'Espana',    'Madrid');

INSERT INTO Tbl_Categorias (NombreCategoria, DescripcionCategoria, EdadMinima, PermiteVenta, PermiteRenta)
VALUES
    ('Novela',              'Obras de ficcion narrativa',                12, 1, 1),
    ('Testimonio',          'Relatos autobiograficos y testimoniales',   14, 1, 1),
    ('Ciencia Ficcion',     'Narrativa futurista y especulativa',        12, 1, 1),
    ('Desarrollo Personal', 'Libros de crecimiento y superacion',         0, 1, 1),
    ('Tecnico',             'Libros tecnicos y de programacion',         0, 1, 1),
    ('Poesia',              'Coleccion de poemas',                        0, 1, 1);

-- =========================================================
-- 10 registros de prueba - Tbl_Libros
-- Categorias: 1 Novela, 2 Testimonio, 3 Ciencia Ficcion, 4 Desarrollo Personal, 5 Tecnico, 6 Poesia
-- =========================================================
SELECT sp_libro_agregar(1, 1, '978-8420471839', 'Cien Anios de Soledad',        'La saga de los Buendia',              1967, 471, 'Espanol', 'Novela de realismo magico que cuenta la historia de la familia Buendia en Macondo', NULL);
SELECT sp_libro_agregar(1, 1, '978-0061120084', 'Ficciones',                    'Cuentos de Jorge Luis Borges',         1944, 208, 'Espanol', 'Coleccion de cuentos filosoficos que juegan con la realidad', NULL);
SELECT sp_libro_agregar(1, 1, '978-8445074282', 'La Casa de los Espiritus',     NULL,                                    1982, 568, 'Espanol', 'Novela intergeneracional de una familia chilena en el siglo XX', NULL);
SELECT sp_libro_agregar(1, 2, '978-8425406621', 'Me llamo Rigoberta Menchu',    'Mi vida y mi lucha',                    1983, 270, 'Espanol', 'Testimonio autobiografico de la Nobel de Paz sobre su lucha en Guatemala', NULL);
SELECT sp_libro_agregar(1, 1, '978-8437603957', 'El Senor Presidente',         NULL,                                    1946, 320, 'Espanol', 'Novela politica que critica la dictadura en Guatemala', NULL);
SELECT sp_libro_agregar(1, 3, '978-0545010770', 'El Juego de Ender',           'Una novela de ciencia ficcion',         1985, 324, 'Espanol', 'Novela futurista sobre un nino estratega en una batalla galactica', NULL);
SELECT sp_libro_agregar(1, 4, '978-8449302084', 'Los Cuatro Acuerdos',         'Sabiduria tolteca',                     1997, 256, 'Espanol', 'Guia de transformacion personal basada en sabiduria tolteca', NULL);
SELECT sp_libro_agregar(1, 5, '978-8449363121', 'Python para Data Science',    'Aprende Python desde cero',             2020, 450, 'Espanol', 'Guia tecnica completa de Python para analisis de datos', NULL);
SELECT sp_libro_agregar(2, 1, '978-8408095996', 'Rayuela',                     'Novela experimental',                   1963, 635, 'Espanol', 'Novela que puede leerse en diferente orden, desafiando la lectura lineal', NULL);
SELECT sp_libro_agregar(2, 6, '978-8408097747', '20 Poemas de Amor',           'Coleccion poetica',                     1924, 112, 'Espanol', 'Coleccion clasica de poemas romanticos de Pablo Neruda', NULL);

-- =========================================================
-- 10 registros de prueba - Tbl_Clientes
-- =========================================================
SELECT sp_cliente_agregar('Pedro',     'Perez Garcia',        '1990123450101', 'pedro.perez@email.com',     '7111-3000', 'Calle 1 Avenida 2, Zona 1, Ciudad de Guatemala',    'Clave2026*', '1990-05-15', 5);
SELECT sp_cliente_agregar('Andrea',    'Lopez Ruiz',          '1995987650102', 'andrea.lopez@email.com',    '7222-3001', 'Boulevard Principal 456, Zona 9, Ciudad de Guatemala','Clave2026*', '1995-08-22', 5);
SELECT sp_cliente_agregar('Roberto',   'Martinez Gomez',      '1988456780103', 'roberto.martinez@email.com','7333-3002', 'Avenida Central 789, Zona 3, Ciudad de Guatemala',  'Clave2026*', '1988-03-10', 5);
SELECT sp_cliente_agregar('Sofia',     'Rodriguez Hernandez', '1992345670104', 'sofia.rodriguez@email.com', '7444-3003', 'Calle 15 Avenida 10, Zona 10, Ciudad de Guatemala', 'Clave2026*', '1992-11-30', 5);
SELECT sp_cliente_agregar('Fernando',  'Gonzalez Lopez',      '1987567890105', 'fernando.gonzalez@email.com','7555-3004','Diagonal 5 Avenida 20, Zona 2, Ciudad de Guatemala','Clave2026*', '1987-07-18', 5);
SELECT sp_cliente_agregar('Mariana',   'Vega Mendoza',        '1993678901106', 'mariana.vega@email.com',    '7666-3005', 'Calle 8 Avenida 15, Zona 4, Ciudad de Guatemala',   'Clave2026*', '1993-01-25', 5);
SELECT sp_cliente_agregar('Eduardo',   'Ruiz Garcia',         '1989234567107', 'eduardo.ruiz@email.com',    '7777-3006', 'Boulevard 12 Calle 5, Zona 5, Ciudad de Guatemala', 'Clave2026*', '1989-09-12', 5);
SELECT sp_cliente_agregar('Claudia',   'Morales Chavez',      '1994789012108', 'claudia.morales@email.com', '7888-3007', 'Avenida 6 Calle 22, Zona 6, Ciudad de Guatemala',   'Clave2026*', '1994-06-08', 5);
SELECT sp_cliente_agregar('Tomas',     'Flores Sanchez',      '1991345678109', 'tomas.flores@email.com',    '7999-3008', 'Calle 18 Avenida 25, Zona 7, Ciudad de Guatemala',  'Clave2026*', '1991-04-20', 5);
SELECT sp_cliente_agregar('Valentina', 'Diaz Romero',         '1996012345110', 'valentina.diaz@email.com',  '8000-3009', 'Boulevard 20 Avenida 8, Zona 8, Ciudad de Guatemala','Clave2026*', '1996-12-02', 5);

-- =========================================================
-- Verificacion rapida
-- =========================================================
SELECT sp_libro_consultar();
SELECT sp_cliente_consultar();
