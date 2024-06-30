CREATE TABLE Vendedor (
    id_vendedor NUMBER,
    ventas_totales VARCHAR2(255) NOT NULL,
    nombre_vendedor VARCHAR2(255) NOT NULL,
    email_vendedor VARCHAR2(255) UNIQUE NOT NULL,
    contrasenha_vendedor VARCHAR2(255) NOT NULL,
    CONSTRAINT pk_vendedor_id PRIMARY KEY (id_vendedor)
);

CREATE TABLE Categoria (
    id_categoria NUMBER,
    nombre_categoria VARCHAR2(100) NOT NULL,
    descripcion VARCHAR2(500),
    CONSTRAINT pk_id_categoria PRIMARY KEY (id_categoria)
);

CREATE TABLE UsuarioComprador (
    id_usuario NUMBER NOT NULL,
    nombre_usuario VARCHAR2(255) NOT NULL,
    apellido_usuario VARCHAR2(255) NOT NULL,
    email_usuario VARCHAR2(255) UNIQUE NOT NULL,
    contrasenha_usuario VARCHAR2(255) NOT NULL,
    fecha_nacimiento_usuario DaTE NOT NULL,
    provincia VARCHAR2(255) NOT NULL,
    distrito VARCHAR2(255) NOT NULL,
    corregimiento VARCHAR2(255) NOT NULL,
    calle VARCHAR2(255) NOT NULL,
    numero_casa VARCHAR2(255) NOT NULL,
    id_carrito NUMBER NOT NULL,
    CONSTRAINT pk_id_usuario PRIMARY KEY (id_usuario)
);

CREATE TABLE Telefono (
    id_telefono NUMBER ,
    telefono VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_id_telefono PRIMARY KEY (id_telefono)
);

CREATE TABLE Carrito (
    id_carrito NUMBER NOT NULL,
    id_usuario NUMBER NOT NULL,
    precio_total NUMBER NOT NULL,
    items_total NUMBER NOT NULL,
    CONSTRAINT pk_id_carrito PRIMARY KEY (id_carrito),
    CONSTRAINT fk_id_usuario FOREIGN KEY (id_usuario) REFERENCES UsuarioComprador(id_usuario)
);

CREATE TABLE tipos_telefonos_vendedor (
    id_vendedor NUMBER NOT NULL,
    id_telefono NUMBER NOT NULL,
    tipo_telefono VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_telefonos_vendedor PRIMARY KEY (id_telefono, id_vendedor),
    CONSTRAINT fk_id_telefono FOREIGN KEY (id_telefono) REFERENCES Telefono(id_telefono),
    CONSTRAINT fk_id_vendedor FOREIGN KEY (id_vendedor) REFERENCES Vendedor(id_vendedor)
);

CREATE TABLE tipos_telefonos_usuario (
    id_usuario NUMBER NOT NULL,
    id_telefono NUMBER NOT NULL,
    tipo_telefono VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_telefonos_usuario PRIMARY KEY (id_telefono, id_usuario),
    CONSTRAINT fk_idtelefono FOREIGN KEY (id_telefono) REFERENCES Telefono(id_telefono),
    CONSTRAINT fk_idusuario FOREIGN KEY (id_usuario) REFERENCES UsuarioComprador(id_usuario)
);

CREATE TABLE Orden (
    id_orden NUMBER NOT NULL,
    cantidad_orden NUMBER NOT NULL,
    estado_orden VARCHAR2(255) NOT NULL,
    id_carrito NUMBER NOT NULL,
    id_usuario NUMBER NOT NULL,
    CONSTRAINT pk_id_orden PRIMARY KEY (id_orden),
    CONSTRAINT fk_id_orden_carrito FOREIGN KEY (id_carrito) REFERENCES Carrito(id_carrito),
    CONSTRAINT fk_id_orden_usuario FOREIGN KEY (id_usuario) REFERENCES UsuarioComprador(id_usuario)
);

CREATE TABLE Pago (
    id_pago NUMBER NOT NULL,
    id_usuario NUMBER NOT NULL,
    modo_pago VARCHAR2(255) NOT NULL,
    fecha_pago DaTE DEFAULT SYSDATE,
    id_orden NUMBER NOT NULL,
    CONSTRAINT pk_id_pago PRIMARY KEY (id_pago),
    CONSTRAINT fk_id_pago_orden FOREIGN KEY (id_orden) REFERENCES Orden(id_orden),
    CONSTRAINT fk_id_pago_usuario FOREIGN KEY (id_usuario) REFERENCES UsuarioComprador(id_usuario)
);

CREATE TABLE Producto (
    id_producto NUMBER NOT NULL,
    nombre_producto VARCHAR2(255) NOT NULL,
    descripcion_producto VARCHAR2(500) NOT NULL,
    marca VARCHAR2(255) NOT NULL,
    inventario NUMBER NOT NULL,
    precio NUMBER NOT NULL,
    id_categoria NUMBER NOT NULL,
    id_vendedor NUMBER NOT NULL,
    id_pago NUMBER NOT NULL,
    CONSTRAINT pk_id_producto PRIMARY KEY (id_producto),
    CONSTRAINT fk_id_producto_categoria FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria),
    CONSTRAINT fk_id_producto_vendedor FOREIGN KEY (id_vendedor) REFERENCES Vendedor(id_vendedor),
    CONSTRAINT fk_id_producto_pago FOREIGN KEY (id_pago) REFERENCES Pago(id_pago)
);


CREATE TABLE OrdenItem (
    id_orden NUMBER NOT NULL,
    id_producto NUMBER NOT NULL,
    cantidad NUMBER NOT NULL,
    precio NUMBER NOT NULL,
    fecha_de_orden DaTE NOT NULL,
    fecha_envio DaTE NOT NULL,
    CONSTRAINT pk_ordenitem PRIMARY KEY (id_orden, id_producto ),
    CONSTRAINT fk_id_orden_item FOREIGN KEY (id_orden) REFERENCES Orden(id_orden),
    CONSTRAINT fk_id_producto_ordenitem FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

CREATE TABLE resenhas (
    id_resenha NUMBER NOT NULL,
    id_usuario NUMBER NOT NULL,
    calificacion VARCHAR2(255) NOT NULL,
    descripcion VARCHAR2(255) NOT NULL,
    id_producto NUMBER NOT NULL,
    CONSTRAINT pk_id_resenha PRIMARY KEY (id_resenha),
    CONSTRAINT fk_id_producto FOREIGN KEY (id_producto) REFERENCES Producto(id_producto),
    CONSTRAINT fk_id_resenha_usuario FOREIGN KEY (id_usuario) REFERENCES UsuarioComprador(id_usuario)
);

--Tabla Auditoria

CREATE TABLE Auditoria (
    aud_id_transaccion NUMBER NOT NULL,
    aud_tabla_afectada VARCHAR2(50) NOT NULL,
    aud_accion VARCHAR2(10) NOT NULL,
    aud_usuario VARCHAR2(35) NOT NULL,
    aud_fecha DATE NOT NULL,
    -- Atributos de la tabla Orden
    aud_id_orden_afectada NUMBER,
    aud_estado_orden_antes VARCHAR2(255),
    aud_fecha_orden_antes DATE,
    aud_id_usuario_antes NUMBER,
    aud_precio_total_antes NUMBER,
    aud_items_total_antes NUMBER,
    aud_estado_orden_despues VARCHAR2(255),
    aud_fecha_orden_despues DATE,
    aud_id_usuario_despues NUMBER,
    aud_precio_total_despues NUMBER,
    aud_items_total_despues NUMBER,
    -- Atributos de la tabla Producto
    aud_id_producto_afectado NUMBER,
    aud_precio_producto_antes NUMBER,
    aud_precio_producto_despues NUMBER,
    aud_inventario_producto_antes NUMBER,
    aud_inventario_producto_despues NUMBER,
    CONSTRAINT pk_aud_id_transaccion PRIMARY KEY (aud_id_transaccion),
    CONSTRAINT chk_aud_accion CHECK (aud_accion IN ('I','U','D'))
);

-- Secuencias

CREATE SEQUENCE seq_vendedor START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_categoria START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_usuario START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_telefono START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_carrito START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_orden START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_pago START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_producto START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_resenha START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_auditoria START WITH 1 INCREMENT BY 1;

-- Actualizar tabla UsuarioComprador

ALTER TABLE UsuarioComprador ADD usu_edad NUMBER DEFAULT 0 NOT NULL;
ALTER TABLE UsuarioComprador ADD usu_sexo CHAR(1) NOT NULL;
ALTER TABLE UsuarioComprador ADD CONSTRAINT chk_usu_sexo CHECK(usu_sexo IN('F', 'M', 'f', 'm'));

-- Triggers

-- Trigger para auditar la tabla producto

CREATE OR REPLACE TRIGGER trg_audit_producto
AFTER INSERT OR UPDATE OR DELETE
ON Producto
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO Auditoria (
            aud_id_transaccion, aud_tabla_afectada, aud_accion, aud_usuario, aud_fecha,
            aud_id_producto_afectado, aud_precio_producto_despues, aud_inventario_producto_despues
        ) VALUES (
            seq_auditoria.NEXTVAL, 'Producto', 'I', USER, SYSDATE,
            :NEW.id_producto, :NEW.precio, :NEW.inventario
        );
    ELSIF UPDATING THEN
        INSERT INTO Auditoria (
            aud_id_transaccion, aud_tabla_afectada, aud_accion, aud_usuario, aud_fecha,
            aud_id_producto_afectado, aud_precio_producto_antes, aud_precio_producto_despues,
            aud_inventario_producto_antes, aud_inventario_producto_despues
        ) VALUES (
            seq_auditoria.NEXTVAL, 'Producto', 'U', USER, SYSDATE,
            :OLD.id_producto, :OLD.precio, :NEW.precio,
            :OLD.inventario, :NEW.inventario
        );
    ELSIF DELETING THEN
        INSERT INTO Auditoria (
            aud_id_transaccion, aud_tabla_afectada, aud_accion, aud_usuario, aud_fecha,
            aud_id_producto_afectado, aud_precio_producto_antes, aud_inventario_producto_antes
        ) VALUES (
            seq_auditoria.NEXTVAL, 'Producto', 'D', USER, SYSDATE,
            :OLD.id_producto, :OLD.precio, :OLD.inventario
        );
    END IF;
END;

-- Trigger para auditar la tabla orden

CREATE OR REPLACE TRIGGER trg_audit_orden
AFTER INSERT OR UPDATE OR DELETE
ON Orden
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO Auditoria (
            aud_id_transaccion, aud_tabla_afectada, aud_accion, aud_usuario, aud_fecha,
            aud_id_orden_afectada, aud_estado_orden_despues, aud_fecha_orden_despues,
            aud_id_usuario_despues, aud_precio_total_despues, aud_items_total_despues
        ) VALUES (
            seq_auditoria.NEXTVAL, 'Orden', 'I', USER, SYSDATE,
            :NEW.id_orden, :NEW.estado_orden, :NEW.fecha_orden,
            :NEW.id_usuario, :NEW.precio_total, :NEW.items_total
        );
    ELSIF UPDATING THEN
        INSERT INTO Auditoria (
            aud_id_transaccion, aud_tabla_afectada, aud_accion, aud_usuario, aud_fecha,
            aud_id_orden_afectada, aud_estado_orden_antes, aud_fecha_orden_antes,
            aud_id_usuario_antes, aud_precio_total_antes, aud_items_total_antes,
            aud_estado_orden_despues, aud_fecha_orden_despues, aud_id_usuario_despues,
            aud_precio_total_despues, aud_items_total_despues
        ) VALUES (
            seq_auditoria.NEXTVAL, 'Orden', 'U', USER, SYSDATE,
            :OLD.id_orden, :OLD.estado_orden, :OLD.fecha_orden,
            :OLD.id_usuario, :OLD.precio_total, :OLD.items_total,
            :NEW.estado_orden, :NEW.fecha_orden, :NEW.id_usuario,
            :NEW.precio_total, :NEW.items_total
        );
    ELSIF DELETING THEN
        INSERT INTO Auditoria (
            aud_id_transaccion, aud_tabla_afectada, aud_accion, aud_usuario, aud_fecha,
            aud_id_orden_afectada, aud_estado_orden_antes, aud_fecha_orden_antes,
            aud_id_usuario_antes, aud_precio_total_antes, aud_items_total_antes
        ) VALUES (
            seq_auditoria.NEXTVAL, 'Orden', 'D', USER, SYSDATE,
            :OLD.id_orden, :OLD.estado_orden, :OLD.fecha_orden,
            :OLD.id_usuario, :OLD.precio_total, :OLD.items_total
        );
    END IF;
END;


-- Funciones

-- Funcion para calcular la edad del usuario

CREATE OR REPLACE FUNCTION EdadCliente(
    p_nacimiento_usuario UsuarioComprador.fecha_nacimiento_usuario%TYPE
) RETURN NUMBER AS
    v_edad   UsuarioComprador.usu_edad%TYPE;
    v_fecha  UsuarioComprador.fecha_nacimiento_usuario%TYPE := p_nacimiento_usuario;
BEGIN
    v_edad := FLOOR(MONTHS_BETWEEN(SYSDATE, v_fecha) / 12);
    RETURN v_edad;
END;
/


-- Procesos

-- Vendedor
CREATE OR REPLACE PROCEDURE AddVendedor(
    p_ventas_totales IN Vendedor.ventas_totales%TYPE,
    p_nombre_vendedor IN Vendedor.nombre_vendedor%TYPE,
    p_email_vendedor IN Vendedor.email_vendedor%TYPE,
    p_contrasenha_vendedor IN Vendedor.contrasenha_vendedor%TYPE
) AS
    e_ParametroNulo EXCEPTION;
BEGIN
    IF p_ventas_totales IS NULL OR p_nombre_vendedor IS NULL OR p_email_vendedor IS NULL OR p_contrasenha_vendedor IS NULL THEN
        RAISE e_ParametroNulo;
    END IF;

    INSERT INTO Vendedor (
        id_vendedor, ventas_totales, nombre_vendedor, email_vendedor, contrasenha_vendedor
    ) VALUES (
        seq_vendedor.NEXTVAL, p_ventas_totales, p_nombre_vendedor, p_email_vendedor, p_contrasenha_vendedor
    );

EXCEPTION
    WHEN e_ParametroNulo THEN
        DBMS_OUTPUT.PUT_LINE('Los parámetros obligatorios no aceptan valores nulos');
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Llave primaria duplicada en la inserción');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error: ' || SQLERRM);
END AddVendedor;

-- Categoria
CREATE OR REPLACE PROCEDURE AddCategoria(
    p_nombre_categoria IN Categoria.nombre_categoria%TYPE,
    p_descripcion IN Categoria.descripcion%TYPE
) AS
    e_ParametroNulo EXCEPTION;
BEGIN
    IF p_nombre_categoria IS NULL THEN
        RAISE e_ParametroNulo;
    END IF;

    INSERT INTO Categoria (
        id_categoria, nombre_categoria, descripcion
    ) VALUES (
        seq_categoria.NEXTVAL, p_nombre_categoria, p_descripcion
    );

EXCEPTION
    WHEN e_ParametroNulo THEN
        DBMS_OUTPUT.PUT_LINE('El nombre de la categoría no acepta valores nulos');
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Llave primaria duplicada en la inserción');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error: ' || SQLERRM);
END AddCategoria;

-- Usuario
CREATE OR REPLACE PROCEDURE AddUsuarioComprador(
    p_nombre_usuario IN UsuarioComprador.nombre_usuario%TYPE,
    p_apellido_usuario IN UsuarioComprador.apellido_usuario%TYPE,
    p_email_usuario IN UsuarioComprador.email_usuario%TYPE,
    p_contrasenha_usuario IN UsuarioComprador.contrasenha_usuario%TYPE,
    p_fecha_nacimiento_usuario IN UsuarioComprador.fecha_nacimiento_usuario%TYPE,
    p_provincia IN UsuarioComprador.provincia%TYPE,
    p_distrito IN UsuarioComprador.distrito%TYPE,
    p_corregimiento IN UsuarioComprador.corregimiento%TYPE,
    p_calle IN UsuarioComprador.calle%TYPE,
    p_numero_casa IN UsuarioComprador.numero_casa%TYPE,
    p_id_carrito IN UsuarioComprador.id_carrito%TYPE,
    p_edad UsuarioComprador.usu_edad%TYPE
) AS
    e_ParametroNulo EXCEPTION;
BEGIN
    IF p_nombre_usuario IS NULL OR p_apellido_usuario IS NULL OR p_email_usuario IS NULL OR p_contrasenha_usuario IS NULL OR p_fecha_nacimiento_usuario IS NULL THEN
        RAISE e_ParametroNulo;
    END IF;

    INSERT INTO UsuarioComprador (
        id_usuario, nombre_usuario, apellido_usuario, email_usuario, contrasenha_usuario, fecha_nacimiento_usuario, provincia, distrito, corregimiento, calle, numero_casa, id_carrito, usu_edad
    ) VALUES (
        seq_usuario.NEXTVAL, p_nombre_usuario, p_apellido_usuario, p_email_usuario, p_contrasenha_usuario, p_fecha_nacimiento_usuario, p_provincia, p_distrito, p_corregimiento, p_calle, p_numero_casa, p_id_carrito, EdadCliente(p_fecha_nacimiento_usuario)
    );

EXCEPTION
    WHEN e_ParametroNulo THEN
        DBMS_OUTPUT.PUT_LINE('Los parámetros obligatorios no aceptan valores nulos');
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Llave primaria duplicada en la inserción');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error: ' || SQLERRM);
END AddUsuarioComprador;
/

-- Telefono
CREATE OR REPLACE PROCEDURE AddTelefono(
    p_telefono IN Telefono.telefono%TYPE
) AS
    e_ParametroNulo EXCEPTION;
BEGIN
    IF p_telefono IS NULL THEN
        RAISE e_ParametroNulo;
    END IF;

    INSERT INTO Telefono (
        id_telefono, telefono
    ) VALUES (
        seq_telefono.NEXTVAL, p_telefono
    );

EXCEPTION
    WHEN e_ParametroNulo THEN
        DBMS_OUTPUT.PUT_LINE('El número de teléfono no acepta valores nulos');
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Llave primaria duplicada en la inserción');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error: ' || SQLERRM);
END AddTelefono;

-- Carrito
CREATE OR REPLACE PROCEDURE AddCarrito(
    p_id_usuario IN Carrito.id_usuario%TYPE,
    p_precio_total IN Carrito.precio_total%TYPE,
    p_items_total IN Carrito.items_total%TYPE
) AS
    e_ParametroNulo EXCEPTION;
BEGIN
    IF p_id_usuario IS NULL OR p_precio_total IS NULL OR p_items_total IS NULL THEN
        RAISE e_ParametroNulo;
    END IF;

    INSERT INTO Carrito (
        id_carrito, id_usuario, precio_total, items_total
    ) VALUES (
        seq_carrito.NEXTVAL, p_id_usuario, p_precio_total, p_items_total
    );

EXCEPTION
    WHEN e_ParametroNulo THEN
        DBMS_OUTPUT.PUT_LINE('Los parámetros obligatorios no aceptan valores nulos');
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Llave primaria duplicada en la inserción');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error: ' || SQLERRM);
END AddCarrito;

-- Telefono vendedor
CREATE OR REPLACE PROCEDURE AddTipoTelefonoVendedor(
    p_id_vendedor IN tipos_telefonos_vendedor.id_vendedor%TYPE,
    p_id_telefono IN tipos_telefonos_vendedor.id_telefono%TYPE,
    p_tipo_telefono IN tipos_telefonos_vendedor.tipo_telefono%TYPE
) AS
    e_ParametroNulo EXCEPTION;
BEGIN
    IF p_id_vendedor IS NULL OR p_id_telefono IS NULL OR p_tipo_telefono IS NULL THEN
        RAISE e_ParametroNulo;
    END IF;

    INSERT INTO tipos_telefonos_vendedor (
        id_vendedor, id_telefono, tipo_telefono
    ) VALUES (
        p_id_vendedor, p_id_telefono, p_tipo_telefono
    );

EXCEPTION
    WHEN e_ParametroNulo THEN
        DBMS_OUTPUT.PUT_LINE('Los parámetros obligatorios no aceptan valores nulos');
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Llave primaria duplicada en la inserción');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error: ' || SQLERRM);
END AddTipoTelefonoVendedor;
/

-- Telefono usuario
CREATE OR REPLACE PROCEDURE AddTipoTelefonoUsuario(
    p_id_usuario IN tipos_telefonos_usuario.id_usuario%TYPE,
    p_id_telefono IN tipos_telefonos_usuario.id_telefono%TYPE,
    p_tipo_telefono IN tipos_telefonos_usuario.tipo_telefono%TYPE
) AS
    e_ParametroNulo EXCEPTION;
BEGIN
    IF p_id_usuario IS NULL OR p_id_telefono IS NULL OR p_tipo_telefono IS NULL THEN
        RAISE e_ParametroNulo;
    END IF;

    INSERT INTO tipos_telefonos_usuario (
        id_usuario, id_telefono, tipo_telefono
    ) VALUES (
        p_id_usuario, p_id_telefono, p_tipo_telefono
    );

EXCEPTION
    WHEN e_ParametroNulo THEN
        DBMS_OUTPUT.PUT_LINE('Los parámetros obligatorios no aceptan valores nulos');
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Llave primaria duplicada en la inserción');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error: ' || SQLERRM);
END AddTipoTelefonoUsuario;
/

-- Orden
CREATE OR REPLACE PROCEDURE AddOrden(
    p_cantidad_orden IN Orden.cantidad_orden%TYPE,
    p_estado_orden IN Orden.estado_orden%TYPE,
    p_id_carrito IN Orden.id_carrito%TYPE,
    p_id_usuario IN Orden.id_usuario%TYPE
) AS
    e_ParametroNulo EXCEPTION;
BEGIN
    IF p_cantidad_orden IS NULL OR p_estado_orden IS NULL OR p_id_carrito IS NULL OR p_id_usuario IS NULL THEN
        RAISE e_ParametroNulo;
    END IF;

    INSERT INTO Orden (
        id_orden, cantidad_orden, estado_orden, id_carrito, id_usuario
    ) VALUES (
        seq_orden.NEXTVAL, p_cantidad_orden, p_estado_orden, p_id_carrito, p_id_usuario
    );

EXCEPTION
    WHEN e_ParametroNulo THEN
        DBMS_OUTPUT.PUT_LINE('Los parámetros obligatorios no aceptan valores nulos');
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Llave primaria duplicada en la inserción');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error: ' || SQLERRM);
END AddOrden;
/

-- Pago
CREATE OR REPLACE PROCEDURE AddPago(
    p_id_usuario IN Pago.id_usuario%TYPE,
    p_modo_pago IN Pago.modo_pago%TYPE,
    p_id_orden IN Pago.id_orden%TYPE
) AS
    e_ParametroNulo EXCEPTION;
BEGIN
    IF p_id_usuario IS NULL OR p_modo_pago IS NULL OR p_id_orden IS NULL THEN
        RAISE e_ParametroNulo;
    END IF;

    INSERT INTO Pago (
        id_pago, id_usuario, modo_pago, fecha_pago, id_orden
    ) VALUES (
        seq_pago.NEXTVAL, p_id_usuario, p_modo_pago, SYSDATE, p_id_orden
    );

EXCEPTION
    WHEN e_ParametroNulo THEN
        DBMS_OUTPUT.PUT_LINE('Los parámetros obligatorios no aceptan valores nulos');
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Llave primaria duplicada en la inserción');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error: ' || SQLERRM);
END AddPago;
/

-- Producto
CREATE OR REPLACE PROCEDURE AddProducto(
    p_nombre_producto IN Producto.nombre_producto%TYPE,
    p_descripcion_producto IN Producto.descripcion_producto%TYPE,
    p_marca IN Producto.marca%TYPE,
    p_inventario IN Producto.inventario%TYPE,
    p_precio IN Producto.precio%TYPE,
    p_id_categoria IN Producto.id_categoria%TYPE,
    p_id_vendedor IN Producto.id_vendedor%TYPE,
    p_id_pago IN Producto.id_pago%TYPE
) AS
    e_ParametroNulo EXCEPTION;
BEGIN
    IF p_nombre_producto IS NULL OR p_descripcion_producto IS NULL OR p_marca IS NULL OR p_inventario IS NULL OR p_precio IS NULL OR p_id_categoria IS NULL OR p_id_vendedor IS NULL OR p_id_pago IS NULL THEN
        RAISE e_ParametroNulo;
    END IF;

    INSERT INTO Producto (
        id_producto, nombre_producto, descripcion_producto, marca, inventario, precio, id_categoria, id_vendedor, id_pago
    ) VALUES (
        seq_producto.NEXTVAL, p_nombre_producto, p_descripcion_producto, p_marca, p_inventario, p_precio, p_id_categoria, p_id_vendedor, p_id_pago
    );

EXCEPTION
    WHEN e_ParametroNulo THEN
        DBMS_OUTPUT.PUT_LINE('Los parámetros obligatorios no aceptan valores nulos');
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Llave primaria duplicada en la inserción');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error: ' || SQLERRM);
END AddProducto;
/

-- OrdenItem
CREATE OR REPLACE PROCEDURE AddOrdenItem(
    p_id_orden IN OrdenItem.id_orden%TYPE,
    p_id_producto IN OrdenItem.id_producto%TYPE,
    p_cantidad IN OrdenItem.cantidad%TYPE,
    p_precio IN OrdenItem.precio%TYPE,
    p_fecha_de_orden IN OrdenItem.fecha_de_orden%TYPE,
    p_fecha_envio IN OrdenItem.fecha_envio%TYPE
) AS
    e_ParametroNulo EXCEPTION;
BEGIN
    IF p_id_orden IS NULL OR p_id_producto IS NULL OR p_cantidad IS NULL OR p_precio IS NULL OR p_fecha_de_orden IS NULL OR p_fecha_envio IS NULL THEN
        RAISE e_ParametroNulo;
    END IF;

    INSERT INTO OrdenItem (
        id_orden, id_producto, cantidad, precio, fecha_de_orden, fecha_envio
    ) VALUES (
        p_id_orden, p_id_producto, p_cantidad, p_precio, p_fecha_de_orden, p_fecha_envio
    );

EXCEPTION
    WHEN e_ParametroNulo THEN
        DBMS_OUTPUT.PUT_LINE('Los parámetros obligatorios no aceptan valores nulos');
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Llave primaria duplicada en la inserción');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error: ' || SQLERRM);
END AddOrdenItem;
/

-- Resenhas
CREATE OR REPLACE PROCEDURE AddResenha(
    p_id_usuario IN Resenhas.id_usuario%TYPE,
    p_calificacion IN Resenhas.calificacion%TYPE,
    p_descripcion IN Resenhas.descripcion%TYPE,
    p_id_producto IN Resenhas.id_producto%TYPE
) AS
    e_ParametroNulo EXCEPTION;
BEGIN
    IF p_id_usuario IS NULL OR p_calificacion IS NULL OR p_descripcion IS NULL OR p_id_producto IS NULL THEN
        RAISE e_ParametroNulo;
    END IF;

    INSERT INTO Resenhas (
        id_resenha, id_usuario, calificacion, descripcion, id_producto
    ) VALUES (
        seq_resenha.NEXTVAL, p_id_usuario, p_calificacion, p_descripcion, p_id_producto
    );

EXCEPTION
    WHEN e_ParametroNulo THEN
        DBMS_OUTPUT.PUT_LINE('Los parámetros obligatorios no aceptan valores nulos');
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Llave primaria duplicada en la inserción');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error: ' || SQLERRM);
END AddResenha;
/

-- Actualizar estatus de ordenes

CREATE OR REPLACE PROCEDURE ActualizarOrdenEstado(
    p_old_status Orden.estado_orden%TYPE,
    p_new_status Orden.estado_orden%TYPE,
    p_dias_limite NUMBER
) AS
    CURSOR c_ordenes IS
        SELECT id_orden, estado_orden, fecha_orden, id_usuario, precio_total, items_total
        FROM Orden
        WHERE estado_orden = p_old_status
        AND fecha_orden <= SYSDATE - p_dias_limite;
    
    v_id_orden Orden.id_orden%TYPE;
    v_estado_orden Orden.estado_orden%TYPE;
    v_fecha_orden Orden.fecha_orden%TYPE;
    v_id_usuario Orden.id_usuario%TYPE;
    v_precio_total Orden.precio_total%TYPE;
    v_items_total Orden.items_total%TYPE;
BEGIN
    OPEN c_ordenes;
    LOOP
        FETCH c_ordenes INTO v_id_orden, v_estado_orden, v_fecha_orden, v_id_usuario, v_precio_total, v_items_total;
        EXIT WHEN c_ordenes%NOTFOUND;
        
        -- Actualizar el estado de la orden
        UPDATE Orden
        SET estado_orden = p_new_status
        WHERE id_orden = v_id_orden;

        -- Insertar registro en la tabla de auditoría
        INSERT INTO Auditoria (
            aud_id_transaccion, aud_tabla_afectada, aud_accion, aud_usuario, aud_fecha,
            aud_id_orden_afectada, aud_estado_orden_antes, aud_estado_orden_despues,
            aud_fecha_orden_antes, aud_fecha_orden_despues, aud_id_usuario_antes,
            aud_id_usuario_despues, aud_precio_total_antes, aud_precio_total_despues,
            aud_items_total_antes, aud_items_total_despues
        ) VALUES (
            seq_auditoria.NEXTVAL, 'Orden', 'U', USER, SYSDATE,
            v_id_orden, v_estado_orden, p_new_status,
            v_fecha_orden, v_fecha_orden, v_id_usuario, v_id_usuario,
            v_precio_total, v_precio_total, v_items_total, v_items_total
        );
    END LOOP;
    CLOSE c_ordenes;
    
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Llave primaria duplicada en la inserción');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error al actualizar el estado de las órdenes: ' || SQLERRM);
END ActualizarOrdenEstado;

-- BEGIN
--     ActualizarOrdenEstado('Pendiente', 'Completada', 7);
-- END;

-- Procedimiento para hacer un reporte de ventar por vendedor

CREATE OR REPLACE PROCEDURE ReporteVentasPorVendedor(
    p_fecha_inicio DATE,
    p_fecha_fin DATE,
    p_resultado OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_resultado FOR
    SELECT v.nombre_vendedor, SUM(o.precio_total) AS total_ventas
    FROM Orden o
    JOIN Producto p ON o.id_orden = p.id_orden
    JOIN Vendedor v ON p.id_vendedor = v.id_vendedor
    WHERE o.fecha_orden BETWEEN p_fecha_inicio AND p_fecha_fin
    GROUP BY v.nombre_vendedor
    ORDER BY total_ventas DESC;
END ReporteVentasPorVendedor;
/

