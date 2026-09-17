
CREATE OR REPLACE FUNCTION sp_libro_consultar(
    p_codigo_libro INT
)
RETURNS json AS $$
DECLARE
    v_resultado json;  -- Variable para guardar el resultado en formato JSON
BEGIN
    -- Buscar el libro en la BD con el codigo exacto
    -- Solo busca libros activos (Estado = 1)
    SELECT json_build_object(
        'exito', true,                          -- Indica que la operacion fue exitosa
        'mensaje', 'Libro encontrado',
        'datos', json_build_object(             -- Empaqueta todos los datos del libro en JSON
            'codigoLibro', CodigoLibro,
            'codigoEditorial', CodigoEditorial,
            'codigoCategoria', CodigoCategoria,
            'isbn', ISBN,
            'tituloLibro', TituloLibro,
            'subtituloLibro', SubtituloLibro,
            'anioPublicacion', AnioPublicacion,
            'numeroPaginas', NumeroPaginas,
            'idiomaLibro', IdiomaLibro,
            'descripcionLibro', DescripcionLibro,
            'portadaLibro', PortadaLibro,
            'estado', Estado
        )
    ) INTO v_resultado
    FROM Tbl_Libros
    WHERE CodigoLibro = p_codigo_libro AND Estado = 1;

    -- Si no encontro el libro, retorna un mensaje de error
    IF v_resultado IS NULL THEN
        v_resultado := json_build_object(
            'exito', false,
            'mensaje', 'Libro no encontrado',
            'datos', NULL
        );
    END IF;

    RETURN v_resultado;
END;
$$ LANGUAGE plpgsql;

-- ========== FUNCION 2: BUSCAR ==========
-- Proposito: Buscar libros por titulo, ISBN o descripcion
-- Entrada: p_criterio (texto a buscar, ej: "Cien A?os")
-- Salida: JSON con array de libros encontrados

CREATE OR REPLACE FUNCTION sp_libro_buscar(
    p_criterio VARCHAR
)
RETURNS json AS $$
DECLARE
    v_resultado json;  -- Variable para guardar el resultado
BEGIN
    -- Busca libros que coincidan con el criterio en titulo, ISBN o descripcion
    -- Usa LOWER para hacer busqueda sin diferenciar mayusculas/minusculas
    SELECT json_build_object(
        'exito', true,
        'mensaje', 'Busqueda completada',
        'datos', json_agg(                      -- Agrupa todos los resultados en un array JSON
            json_build_object(
                'codigoLibro', CodigoLibro,
                'tituloLibro', TituloLibro,
                'isbn', ISBN,
                'anioPublicacion', AnioPublicacion,
                'estado', Estado
            )
        )
    ) INTO v_resultado
    FROM Tbl_Libros
    WHERE (LOWER(TituloLibro) LIKE LOWER('%' || p_criterio || '%')      -- Busca en titulo
        OR LOWER(ISBN) LIKE LOWER('%' || p_criterio || '%')            -- Busca en ISBN
        OR LOWER(DescripcionLibro) LIKE LOWER('%' || p_criterio || '%')) -- Busca en descripcion
        AND Estado = 1;  -- Solo libros activos

    -- Si no encontro nada, retorna un mensaje vacio
    IF v_resultado->'datos' IS NULL THEN
        v_resultado := json_build_object(
            'exito', false,
            'mensaje', 'No se encontraron resultados',
            'datos', '[]'::json
        );
    END IF;

    RETURN v_resultado;
END;
$$ LANGUAGE plpgsql;

-- ========== FUNCION 3: AGREGAR ==========
-- Proposito: Crear un nuevo libro en la BD
-- Entrada: Todos los datos del nuevo libro
-- Salida: JSON con confirmacion y codigo del libro creado

CREATE OR REPLACE FUNCTION sp_libro_agregar(
    p_codigo_editorial INT,
    p_codigo_categoria INT,
    p_isbn VARCHAR,
    p_titulo_libro VARCHAR,
    p_subtitulo_libro VARCHAR,
    p_anio_publicacion INT,
    p_numero_paginas INT,
    p_idioma_libro VARCHAR,
    p_descripcion_libro TEXT
)
RETURNS json AS $$
DECLARE
    v_codigo_libro INT;     -- Variable para guardar el ID del libro creado
    v_resultado json;       -- Variable para guardar el resultado
BEGIN
    -- Inserta un nuevo libro en la tabla
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
    ) VALUES (
        p_codigo_editorial,
        p_codigo_categoria,
        p_isbn,
        p_titulo_libro,
        p_subtitulo_libro,
        p_anio_publicacion,
        p_numero_paginas,
        COALESCE(p_idioma_libro, 'Espa?ol'),  -- Si no se especifica idioma, usa Espa?ol por defecto
        p_descripcion_libro,
        1  -- Estado activo
    ) RETURNING CodigoLibro INTO v_codigo_libro;  -- Captura el ID generado

    -- Prepara respuesta exitosa
    v_resultado := json_build_object(
        'exito', true,
        'mensaje', 'Libro agregado exitosamente',
        'datos', json_build_object(
            'codigoLibro', v_codigo_libro,
            'tituloLibro', p_titulo_libro
        )
    );

    RETURN v_resultado;
EXCEPTION WHEN OTHERS THEN
    -- Si hay error (ej: ISBN duplicado), captura el error
    v_resultado := json_build_object(
        'exito', falseO
        'mensaje', 'Error al agregar libro: ' || SQLERRM,  -- SQLERRM da el mensaje del error
        'datos', NULL
    );
    RETURN v_resultado;
END;
$$ LANGUAGE plpgsql;

-- ========== FUNCION 4: EDITAR ==========
-- Proposito: Modificar datos de un libro existente
-- Entrada: Codigo del libro y los campos a actualizar
-- Salida: JSON con confirmacion de actualizacion

CREATE OR REPLACE FUNCTION sp_libro_editar(
    p_codigo_libro INT,
    p_titulo_libro VARCHAR,
    p_subtitulo_libro VARCHAR,
    p_numero_paginas INT,
    p_descripcion_libro TEXT
)
RETURNS json AS $$
DECLARE
    v_resultado json;           -- Variable para guardar el resultado
    v_filas_afectadas INT;      -- Variable para contar cuantas filas se actualizaron
BEGIN
    -- Actualiza solo los campos que se proporcionan (si son NULL, usa el valor existente)
    -- COALESCE: si p_titulo_libro es NULL, mantiene el valor actual (TituloLibro)
    UPDATE Tbl_Libros
    SET TituloLibro = COALESCE(p_titulo_libro, TituloLibro),
        SubtituloLibro = COALESCE(p_subtitulo_libro, SubtituloLibro),
        NumeroPaginas = COALESCE(p_numero_paginas, NumeroPaginas),
        DescripcionLibro = COALESCE(p_descripcion_libro, DescripcionLibro)
    WHERE CodigoLibro = p_codigo_libro AND Estado = 1;  -- Solo edita libros activos

    -- GET DIAGNOSTICS obtiene el numero de filas afectadas
    GET DIAGNOSTICS v_filas_afectadas = ROW_COUNT;

    -- Si no se actualizo nada, el libro no existe
    IF v_filas_afectadas = 0 THEN
        v_resultado := json_build_object(
            'exito', false,
            'mensaje', 'Libro no encontrado',
            'datos', NULL
        );
    ELSE
        v_resultado := json_build_object(
            'exito', true,
            'mensaje', 'Libro actualizado exitosamente',
            'datos', json_build_object(
                'codigoLibro', p_codigo_libro,
                'filasAfectadas', v_filas_afectadas
            )
        );
    END IF;

    RETURN v_resultado;
EXCEPTION WHEN OTHERS THEN
    v_resultado := json_build_object(
        'exito', false,
        'mensaje', 'Error al editar libro: ' || SQLERRM,
        'datos', NULL
    );
    RETURN v_resultado;
END;
$$ LANGUAGE plpgsql;

-- ========== FUNCION 5: ELIMINAR ==========
-- Proposito: Eliminar un libro (eliminacion logica)
-- Entrada: Codigo del libro a eliminar
-- Salida: JSON con confirmacion de eliminacion
-- NOTA: No se borra realmente, solo se marca como inactivo (Estado = 0)

CREATE OR REPLACE FUNCTION sp_libro_eliminar(
    p_codigo_libro INT
)
RETURNS json AS $$
DECLARE
    v_resultado json;           -- Variable para guardar el resultado
    v_filas_afectadas INT;      -- Variable para contar filas actualizadas
BEGIN
    -- Eliminacion LOGICA: Solo marca el libro como inactivo (Estado = 0)
    -- No se borra de la BD por si se necesitan recuperar datos despues
    UPDATE Tbl_Libros
    SET Estado = 0  -- Marca como inactivo
    WHERE CodigoLibro = p_codigo_libro AND Estado = 1;

    GET DIAGNOSTICS v_filas_afectadas = ROW_COUNT;

    -- Si no se actualizo nada, el libro no existe
    IF v_filas_afectadas = 0 THEN
        v_resultado := json_build_object(
            'exito', false,
            'mensaje', 'Libro no encontrado',
            'datos', NULL
        );
    ELSE
        v_resultado := json_build_object(
            'exito', true,
            'mensaje', 'Libro eliminado exitosamente',
            'datos', json_build_object(
                'codigoLibro', p_codigo_libro,
                'filasAfectadas', v_filas_afectadas
            )
        );
    END IF;

    RETURN v_resultado;
EXCEPTION WHEN OTHERS THEN
    v_resultado := json_build_object(
        'exito', false,
        'mensaje', 'Error al eliminar libro: ' || SQLERRM,
        'datos', NULL
    );
    RETURN v_resultado;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM information_schema.routines WHERE routine_name LIKE 'sp_libro%';


CREATE OR REPLACE FUNCTION sp_cliente_consultar(
    p_codigo_cliente INT
)
RETURNS json AS $$
DECLARE
    v_resultado json;  -- Variable para guardar el resultado en formato JSON
BEGIN
    -- Buscar el cliente en la BD con el codigo exacto
    -- Solo busca clientes activos (Estado = 1)
    SELECT json_build_object(
        'exito', true,                          -- Indica que la operacion fue exitosa
        'mensaje', 'Cliente encontrado',
        'datos', json_build_object(             -- Empaqueta todos los datos del cliente en JSON
            'codigoCliente', CodigoCliente,
            'nombresCliente', NombresCliente,
            'apellidosCliente', ApellidosCliente,
            'numeroIdentificacion', NumeroIdentificacion,
            'correoCliente', CorreoCliente,
            'telefonoCliente', TelefonoCliente,
            'direccionCliente', DireccionCliente,
            'fechaNacimiento', FechaNacimiento,
            'fechaRegistro', FechaRegistro,
            'limiteRentas', LimiteRentas,
            'estado', Estado
        )
    ) INTO v_resultado
    FROM Tbl_Clientes
    WHERE CodigoCliente = p_codigo_cliente AND Estado = 1;

    -- Si no encontro el cliente, retorna un mensaje de error
    IF v_resultado IS NULL THEN
        v_resultado := json_build_object(
            'exito', false,
            'mensaje', 'Cliente no encontrado',
            'datos', NULL
        );
    END IF;

    RETURN v_resultado;
END;
$$ LANGUAGE plpgsql;

-- ========== FUNCION 2: BUSCAR CLIENTE ==========
-- Proposito: Buscar clientes por nombre, apellido, DPI o email
-- Entrada: p_criterio (texto a buscar, ej: "Pedro" o "1990123450101")
-- Salida: JSON con array de clientes encontrados

CREATE OR REPLACE FUNCTION sp_cliente_buscar(
    p_criterio VARCHAR
)
RETURNS json AS $$
DECLARE
    v_resultado json;  -- Variable para guardar el resultado
BEGIN
    -- Busca clientes que coincidan con el criterio en nombre, apellido, DPI o email
    -- Usa LOWER para hacer busqueda sin diferenciar mayusculas/minusculas
    SELECT json_build_object(
        'exito', true,
        'mensaje', 'Busqueda completada',
        'datos', json_agg(                      -- Agrupa todos los resultados en un array JSON
            json_build_object(
                'codigoCliente', CodigoCliente,
                'nombresCliente', NombresCliente,
                'apellidosCliente', ApellidosCliente,
                'numeroIdentificacion', NumeroIdentificacion,
                'correoCliente', CorreoCliente,
                'estado', Estado
            )
        )
    ) INTO v_resultado
    FROM Tbl_Clientes
    WHERE (LOWER(NombresCliente) LIKE LOWER('%' || p_criterio || '%')      -- Busca en nombres
        OR LOWER(ApellidosCliente) LIKE LOWER('%' || p_criterio || '%')    -- Busca en apellidos
        OR NumeroIdentificacion LIKE '%' || p_criterio || '%'              -- Busca en DPI
        OR LOWER(CorreoCliente) LIKE LOWER('%' || p_criterio || '%'))     -- Busca en email
        AND Estado = 1;  -- Solo clientes activos

    -- Si no encontro nada, retorna un mensaje vacio
    IF v_resultado->'datos' IS NULL THEN
        v_resultado := json_build_object(
            'exito', false,
            'mensaje', 'No se encontraron resultados',
            'datos', '[]'::json
        );
    END IF;

    RETURN v_resultado;
END;
$$ LANGUAGE plpgsql;

-- ========== FUNCION 3: AGREGAR CLIENTE ==========
-- Proposito: Crear un nuevo cliente en la BD
-- Entrada: Todos los datos del nuevo cliente
-- Salida: JSON con confirmacion y codigo del cliente creado

CREATE OR REPLACE FUNCTION sp_cliente_agregar(
    p_nombres_cliente VARCHAR,
    p_apellidos_cliente VARCHAR,
    p_numero_identificacion VARCHAR,
    p_correo_cliente VARCHAR,
    p_telefono_cliente VARCHAR,
    p_direccion_cliente VARCHAR,
    p_fecha_nacimiento DATE
)
RETURNS json AS $$
DECLARE
    v_codigo_cliente INT;     -- Variable para guardar el ID del cliente creado
    v_resultado json;         -- Variable para guardar el resultado
BEGIN
    -- Inserta un nuevo cliente en la tabla
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
    ) VALUES (
        p_nombres_cliente,
        p_apellidos_cliente,
        p_numero_identificacion,
        p_correo_cliente,
        p_telefono_cliente,
        p_direccion_cliente,
        p_fecha_nacimiento,
        CURRENT_DATE,  -- Fecha de registro automatica (hoy)
        5,             -- Limite de rentas por defecto
        1              -- Estado activo
    ) RETURNING CodigoCliente INTO v_codigo_cliente;  -- Captura el ID generado

    -- Prepara respuesta exitosa
    v_resultado := json_build_object(
        'exito', true,
        'mensaje', 'Cliente agregado exitosamente',
        'datos', json_build_object(
            'codigoCliente', v_codigo_cliente,
            'nombresCliente', p_nombres_cliente,
            'apellidosCliente', p_apellidos_cliente
        )
    );

    RETURN v_resultado;
EXCEPTION WHEN OTHERS THEN
    -- Si hay error (ej: DPI duplicado), captura el error
    v_resultado := json_build_object(
        'exito', false,
        'mensaje', 'Error al agregar cliente: ' || SQLERRM,  -- SQLERRM da el mensaje del error
        'datos', NULL
    );
    RETURN v_resultado;
END;
$$ LANGUAGE plpgsql;

-- ========== FUNCION 4: EDITAR CLIENTE ==========
-- Proposito: Modificar datos de un cliente existente
-- Entrada: Codigo del cliente y los campos a actualizar
-- Salida: JSON con confirmacion de actualizacion

CREATE OR REPLACE FUNCTION sp_cliente_editar(
    p_codigo_cliente INT,
    p_nombres_cliente VARCHAR,
    p_apellidos_cliente VARCHAR,
    p_telefono_cliente VARCHAR,
    p_direccion_cliente VARCHAR
)
RETURNS json AS $$
DECLARE
    v_resultado json;           -- Variable para guardar el resultado
    v_filas_afectadas INT;      -- Variable para contar cuantas filas se actualizaron
BEGIN
    -- Actualiza solo los campos que se proporcionan (si son NULL, usa el valor existente)
    -- COALESCE: si p_nombres_cliente es NULL, mantiene el valor actual (NombresCliente)
    UPDATE Tbl_Clientes
    SET NombresCliente = COALESCE(p_nombres_cliente, NombresCliente),
        ApellidosCliente = COALESCE(p_apellidos_cliente, ApellidosCliente),
        TelefonoCliente = COALESCE(p_telefono_cliente, TelefonoCliente),
        DireccionCliente = COALESCE(p_direccion_cliente, DireccionCliente)
    WHERE CodigoCliente = p_codigo_cliente AND Estado = 1;  -- Solo edita clientes activos

    -- GET DIAGNOSTICS obtiene el numero de filas afectadas
    GET DIAGNOSTICS v_filas_afectadas = ROW_COUNT;

    -- Si no se actualizo nada, el cliente no existe
    IF v_filas_afectadas = 0 THEN
        v_resultado := json_build_object(
            'exito', false,
            'mensaje', 'Cliente no encontrado',
            'datos', NULL
        );
    ELSE
        v_resultado := json_build_object(
            'exito', true,
            'mensaje', 'Cliente actualizado exitosamente',
            'datos', json_build_object(
                'codigoCliente', p_codigo_cliente,
                'filasAfectadas', v_filas_afectadas
            )
        );
    END IF;

    RETURN v_resultado;
EXCEPTION WHEN OTHERS THEN
    v_resultado := json_build_object(
        'exito', false,
        'mensaje', 'Error al editar cliente: ' || SQLERRM,
        'datos', NULL
    );
    RETURN v_resultado;
END;
$$ LANGUAGE plpgsql;

-- ========== FUNCION 5: ELIMINAR CLIENTE ==========
-- Proposito: Eliminar un cliente (eliminacion logica)
-- Entrada: Codigo del cliente a eliminar
-- Salida: JSON con confirmacion de eliminacion
-- NOTA: No se borra realmente, solo se marca como inactivo (Estado = 0)

CREATE OR REPLACE FUNCTION sp_cliente_eliminar(
    p_codigo_cliente INT
)
RETURNS json AS $$
DECLARE
    v_resultado json;           -- Variable para guardar el resultado
    v_filas_afectadas INT;      -- Variable para contar filas actualizadas
BEGIN
    -- Eliminacion LoGICA: Solo marca el cliente como inactivo (Estado = 0)
    -- No se borra de la BD por si se necesitan recuperar datos despues
    UPDATE Tbl_Clientes
    SET Estado = 0  -- Marca como inactivo
    WHERE CodigoCliente = p_codigo_cliente AND Estado = 1;

    GET DIAGNOSTICS v_filas_afectadas = ROW_COUNT;

    -- Si no se actualizo nada, el cliente no existe
    IF v_filas_afectadas = 0 THEN
        v_resultado := json_build_object(
            'exito', false,
            'mensaje', 'Cliente no encontrado',
            'datos', NULL
        );
    ELSE
        v_resultado := json_build_object(
            'exito', true,
            'mensaje', 'Cliente eliminado exitosamente',
            'datos', json_build_object(
                'codigoCliente', p_codigo_cliente,
                'filasAfectadas', v_filas_afectadas
            )
        );
    END IF;

    RETURN v_resultado;
EXCEPTION WHEN OTHERS THEN
    v_resultado := json_build_object(
        'exito', false,
        'mensaje', 'Error al eliminar cliente: ' || SQLERRM,
        'datos', NULL
    );
    RETURN v_resultado;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM information_schema.routines WHERE routine_name LIKE 'sp_cliente%';

