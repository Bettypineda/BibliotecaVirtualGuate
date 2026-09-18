-- =========================================================
-- Stored Procedures CRUD - Tbl_Clientes y Tbl_Libros
-- Estructura de respuesta JSON: { exito, mensaje, datos }
-- =========================================================

-- =========================================================
-- CLIENTES
-- =========================================================

CREATE OR REPLACE FUNCTION sp_cliente_consultar()
RETURNS JSON AS $$
DECLARE
    v_datos JSON;
BEGIN
    SELECT COALESCE(json_agg(t), '[]'::json) INTO v_datos
    FROM (
        SELECT * FROM Tbl_Clientes
        WHERE EstadoCliente = 'Activo'
        ORDER BY CodigoCliente
    ) t;

    RETURN json_build_object(
        'exito', true,
        'mensaje', 'Consulta realizada correctamente',
        'datos', v_datos
    );
EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'exito', false,
            'mensaje', 'Error al consultar clientes: ' || SQLERRM,
            'datos', '[]'::json
        );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_cliente_buscar(p_codigo INT)
RETURNS JSON AS $$
DECLARE
    v_existe INT;
    v_datos  JSON;
BEGIN
    SELECT COUNT(*) INTO v_existe FROM Tbl_Clientes WHERE CodigoCliente = p_codigo;

    IF v_existe = 0 THEN
        RETURN json_build_object(
            'exito', false,
            'mensaje', 'No existe un cliente con el codigo ' || p_codigo,
            'datos', '[]'::json
        );
    END IF;

    SELECT row_to_json(t) INTO v_datos
    FROM (SELECT * FROM Tbl_Clientes WHERE CodigoCliente = p_codigo) t;

    RETURN json_build_object(
        'exito', true,
        'mensaje', 'Cliente encontrado',
        'datos', v_datos
    );
EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'exito', false,
            'mensaje', 'Error al buscar el cliente: ' || SQLERRM,
            'datos', '[]'::json
        );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_cliente_agregar(
    p_nombrescliente       VARCHAR,
    p_apellidoscliente     VARCHAR,
    p_numeroidentificacion VARCHAR,
    p_correocliente        VARCHAR,
    p_telefonocliente      VARCHAR,
    p_direccioncliente     VARCHAR,
    p_clavecliente         VARCHAR,
    p_fechanacimiento      DATE,
    p_limiterentas         INT
)
RETURNS JSON AS $$
DECLARE
    v_existe       INT;
    v_nuevo_codigo INT;
    v_datos        JSON;
BEGIN
    SELECT COUNT(*) INTO v_existe FROM Tbl_Clientes WHERE NumeroIdentificacion = p_numeroidentificacion;

    IF v_existe > 0 THEN
        RETURN json_build_object(
            'exito', false,
            'mensaje', 'Ya existe un cliente registrado con el numero de identificacion ' || p_numeroidentificacion,
            'datos', '[]'::json
        );
    END IF;

    INSERT INTO Tbl_Clientes (
        NombresCliente, ApellidosCliente, NumeroIdentificacion, CorreoCliente,
        TelefonoCliente, DireccionCliente, ClaveCliente, FechaNacimiento,
        FechaRegistro, LimiteRentas, EstadoCliente
    ) VALUES (
        p_nombrescliente, p_apellidoscliente, p_numeroidentificacion, p_correocliente,
        p_telefonocliente, p_direccioncliente, p_clavecliente, p_fechanacimiento,
        CURRENT_DATE, p_limiterentas, 'Activo'
    ) RETURNING CodigoCliente INTO v_nuevo_codigo;

    SELECT row_to_json(t) INTO v_datos
    FROM (SELECT * FROM Tbl_Clientes WHERE CodigoCliente = v_nuevo_codigo) t;

    RETURN json_build_object(
        'exito', true,
        'mensaje', 'Cliente agregado correctamente',
        'datos', v_datos
    );
EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'exito', false,
            'mensaje', 'Error al agregar el cliente: ' || SQLERRM,
            'datos', '[]'::json
        );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_cliente_editar(
    p_codigo               INT,
    p_nombrescliente       VARCHAR,
    p_apellidoscliente     VARCHAR,
    p_numeroidentificacion VARCHAR,
    p_correocliente        VARCHAR,
    p_telefonocliente      VARCHAR,
    p_direccioncliente     VARCHAR,
    p_clavecliente         VARCHAR,
    p_fechanacimiento      DATE,
    p_limiterentas         INT
)
RETURNS JSON AS $$
DECLARE
    v_existe             INT;
    v_identificacion_dup INT;
    v_datos              JSON;
BEGIN
    SELECT COUNT(*) INTO v_existe FROM Tbl_Clientes WHERE CodigoCliente = p_codigo;

    IF v_existe = 0 THEN
        RETURN json_build_object(
            'exito', false,
            'mensaje', 'No existe un cliente con el codigo ' || p_codigo,
            'datos', '[]'::json
        );
    END IF;

    SELECT COUNT(*) INTO v_identificacion_dup
    FROM Tbl_Clientes
    WHERE NumeroIdentificacion = p_numeroidentificacion AND CodigoCliente <> p_codigo;

    IF v_identificacion_dup > 0 THEN
        RETURN json_build_object(
            'exito', false,
            'mensaje', 'El numero de identificacion ' || p_numeroidentificacion || ' ya pertenece a otro cliente',
            'datos', '[]'::json
        );
    END IF;

    UPDATE Tbl_Clientes SET
        NombresCliente       = p_nombrescliente,
        ApellidosCliente     = p_apellidoscliente,
        NumeroIdentificacion = p_numeroidentificacion,
        CorreoCliente        = p_correocliente,
        TelefonoCliente      = p_telefonocliente,
        DireccionCliente     = p_direccioncliente,
        ClaveCliente         = p_clavecliente,
        FechaNacimiento      = p_fechanacimiento,
        LimiteRentas         = p_limiterentas
    WHERE CodigoCliente = p_codigo;

    SELECT row_to_json(t) INTO v_datos
    FROM (SELECT * FROM Tbl_Clientes WHERE CodigoCliente = p_codigo) t;

    RETURN json_build_object(
        'exito', true,
        'mensaje', 'Cliente actualizado correctamente',
        'datos', v_datos
    );
EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'exito', false,
            'mensaje', 'Error al actualizar el cliente: ' || SQLERRM,
            'datos', '[]'::json
        );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_cliente_eliminar(p_codigo INT)
RETURNS JSON AS $$
DECLARE
    v_existe INT;
BEGIN
    SELECT COUNT(*) INTO v_existe FROM Tbl_Clientes WHERE CodigoCliente = p_codigo;

    IF v_existe = 0 THEN
        RETURN json_build_object(
            'exito', false,
            'mensaje', 'No existe un cliente con el codigo ' || p_codigo,
            'datos', '[]'::json
        );
    END IF;

    DELETE FROM Tbl_Clientes WHERE CodigoCliente = p_codigo;

    RETURN json_build_object(
        'exito', true,
        'mensaje', 'Cliente eliminado correctamente',
        'datos', '[]'::json
    );
EXCEPTION
    WHEN foreign_key_violation THEN
        RETURN json_build_object(
            'exito', false,
            'mensaje', 'No se puede eliminar el cliente porque tiene registros relacionados (ventas, rentas, etc.)',
            'datos', '[]'::json
        );
    WHEN OTHERS THEN
        RETURN json_build_object(
            'exito', false,
            'mensaje', 'Error al eliminar el cliente: ' || SQLERRM,
            'datos', '[]'::json
        );
END;
$$ LANGUAGE plpgsql;

-- =========================================================
-- LIBROS
-- =========================================================

CREATE OR REPLACE FUNCTION sp_libro_consultar()
RETURNS JSON AS $$
DECLARE
    v_datos JSON;
BEGIN
    SELECT COALESCE(json_agg(t), '[]'::json) INTO v_datos
    FROM (
        SELECT * FROM Tbl_Libros
        WHERE EstadoLibro = 'Activo'
        ORDER BY CodigoLibro
    ) t;

    RETURN json_build_object(
        'exito', true,
        'mensaje', 'Consulta realizada correctamente',
        'datos', v_datos
    );
EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'exito', false,
            'mensaje', 'Error al consultar libros: ' || SQLERRM,
            'datos', '[]'::json
        );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_libro_buscar(p_codigo INT)
RETURNS JSON AS $$
DECLARE
    v_existe INT;
    v_datos  JSON;
BEGIN
    SELECT COUNT(*) INTO v_existe FROM Tbl_Libros WHERE CodigoLibro = p_codigo;

    IF v_existe = 0 THEN
        RETURN json_build_object(
            'exito', false,
            'mensaje', 'No existe un libro con el codigo ' || p_codigo,
            'datos', '[]'::json
        );
    END IF;

    SELECT row_to_json(t) INTO v_datos
    FROM (SELECT * FROM Tbl_Libros WHERE CodigoLibro = p_codigo) t;

    RETURN json_build_object(
        'exito', true,
        'mensaje', 'Libro encontrado',
        'datos', v_datos
    );
EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'exito', false,
            'mensaje', 'Error al buscar el libro: ' || SQLERRM,
            'datos', '[]'::json
        );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_libro_agregar(
    p_codigoeditorial  INT,
    p_codigocategoria  INT,
    p_isbn             VARCHAR,
    p_titulolibro      VARCHAR,
    p_subtitulolibro   VARCHAR,
    p_aniopublicacion  INT,
    p_numeropaginas    INT,
    p_idiomalibro      VARCHAR,
    p_descripcionlibro TEXT,
    p_portadalibro     VARCHAR
)
RETURNS JSON AS $$
DECLARE
    v_existe       INT;
    v_nuevo_codigo INT;
    v_datos        JSON;
BEGIN
    SELECT COUNT(*) INTO v_existe FROM Tbl_Libros WHERE ISBN = p_isbn;

    IF v_existe > 0 THEN
        RETURN json_build_object(
            'exito', false,
            'mensaje', 'Ya existe un libro registrado con el ISBN ' || p_isbn,
            'datos', '[]'::json
        );
    END IF;

    INSERT INTO Tbl_Libros (
        CodigoEditorial, CodigoCategoria, ISBN, TituloLibro, SubtituloLibro,
        AnioPublicacion, NumeroPaginas, IdiomaLibro, DescripcionLibro, PortadaLibro, EstadoLibro
    ) VALUES (
        p_codigoeditorial, p_codigocategoria, p_isbn, p_titulolibro, p_subtitulolibro,
        p_aniopublicacion, p_numeropaginas, p_idiomalibro, p_descripcionlibro, p_portadalibro, 'Activo'
    ) RETURNING CodigoLibro INTO v_nuevo_codigo;

    SELECT row_to_json(t) INTO v_datos
    FROM (SELECT * FROM Tbl_Libros WHERE CodigoLibro = v_nuevo_codigo) t;

    RETURN json_build_object(
        'exito', true,
        'mensaje', 'Libro agregado correctamente',
        'datos', v_datos
    );
EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'exito', false,
            'mensaje', 'Error al agregar el libro: ' || SQLERRM,
            'datos', '[]'::json
        );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_libro_editar(
    p_codigo           INT,
    p_codigoeditorial  INT,
    p_codigocategoria  INT,
    p_isbn             VARCHAR,
    p_titulolibro      VARCHAR,
    p_subtitulolibro   VARCHAR,
    p_aniopublicacion  INT,
    p_numeropaginas    INT,
    p_idiomalibro      VARCHAR,
    p_descripcionlibro TEXT,
    p_portadalibro     VARCHAR
)
RETURNS JSON AS $$
DECLARE
    v_existe   INT;
    v_isbn_dup INT;
    v_datos    JSON;
BEGIN
    SELECT COUNT(*) INTO v_existe FROM Tbl_Libros WHERE CodigoLibro = p_codigo;

    IF v_existe = 0 THEN
        RETURN json_build_object(
            'exito', false,
            'mensaje', 'No existe un libro con el codigo ' || p_codigo,
            'datos', '[]'::json
        );
    END IF;

    SELECT COUNT(*) INTO v_isbn_dup
    FROM Tbl_Libros
    WHERE ISBN = p_isbn AND CodigoLibro <> p_codigo;

    IF v_isbn_dup > 0 THEN
        RETURN json_build_object(
            'exito', false,
            'mensaje', 'El ISBN ' || p_isbn || ' ya pertenece a otro libro',
            'datos', '[]'::json
        );
    END IF;

    UPDATE Tbl_Libros SET
        CodigoEditorial  = p_codigoeditorial,
        CodigoCategoria  = p_codigocategoria,
        ISBN             = p_isbn,
        TituloLibro      = p_titulolibro,
        SubtituloLibro   = p_subtitulolibro,
        AnioPublicacion  = p_aniopublicacion,
        NumeroPaginas    = p_numeropaginas,
        IdiomaLibro      = p_idiomalibro,
        DescripcionLibro = p_descripcionlibro,
        PortadaLibro     = p_portadalibro
    WHERE CodigoLibro = p_codigo;

    SELECT row_to_json(t) INTO v_datos
    FROM (SELECT * FROM Tbl_Libros WHERE CodigoLibro = p_codigo) t;

    RETURN json_build_object(
        'exito', true,
        'mensaje', 'Libro actualizado correctamente',
        'datos', v_datos
    );
EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'exito', false,
            'mensaje', 'Error al actualizar el libro: ' || SQLERRM,
            'datos', '[]'::json
        );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_libro_eliminar(p_codigo INT)
RETURNS JSON AS $$
DECLARE
    v_existe INT;
BEGIN
    SELECT COUNT(*) INTO v_existe FROM Tbl_Libros WHERE CodigoLibro = p_codigo;

    IF v_existe = 0 THEN
        RETURN json_build_object(
            'exito', false,
            'mensaje', 'No existe un libro con el codigo ' || p_codigo,
            'datos', '[]'::json
        );
    END IF;

    DELETE FROM Tbl_Libros WHERE CodigoLibro = p_codigo;

    RETURN json_build_object(
        'exito', true,
        'mensaje', 'Libro eliminado correctamente',
        'datos', '[]'::json
    );
EXCEPTION
    WHEN foreign_key_violation THEN
        RETURN json_build_object(
            'exito', false,
            'mensaje', 'No se puede eliminar el libro porque tiene registros relacionados (ejemplares, autores, etc.)',
            'datos', '[]'::json
        );
    WHEN OTHERS THEN
        RETURN json_build_object(
            'exito', false,
            'mensaje', 'Error al eliminar el libro: ' || SQLERRM,
            'datos', '[]'::json
        );
END;
$$ LANGUAGE plpgsql;
