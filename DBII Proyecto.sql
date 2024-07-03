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
    fecha_nacimiento_usuario DATE NOT NULL,
    provincia VARCHAR2(255) NOT NULL,
    distrito VARCHAR2(255) NOT NULL,
    corregimiento VARCHAR2(255) NOT NULL,
    calle VARCHAR2(255) NOT NULL,
    numero_casa VARCHAR2(255) NOT NULL,
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
    precio_total NUMBER DEFAULT 0 NOT NULL,
    items_total NUMBER DEFAULT 0 NOT NULL,
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
    id_carrito NUMBER NOT NULL,
    id_usuario NUMBER NOT NULL,
    estado_orden VARCHAR2(255) NOT NULL,
    precio_total NUMBER NOT NULL,
    CONSTRAINT pk_id_orden PRIMARY KEY (id_orden),
    CONSTRAINT fk_id_orden_carrito FOREIGN KEY (id_carrito) REFERENCES Carrito(id_carrito),
    CONSTRAINT fk_id_orden_usuario FOREIGN KEY (id_usuario) REFERENCES UsuarioComprador(id_usuario)
);

CREATE TABLE Pago (
    id_pago NUMBER NOT NULL,
    id_usuario NUMBER NOT NULL,
    modo_pago VARCHAR2(255) NOT NULL,
    fecha_pago DATE DEFAULT SYSDATE,
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
    CONSTRAINT pk_id_producto PRIMARY KEY (id_producto),
    CONSTRAINT fk_id_producto_categoria FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria),
    CONSTRAINT fk_id_producto_vendedor FOREIGN KEY (id_vendedor) REFERENCES Vendedor(id_vendedor)
);


CREATE TABLE OrdenItem (
    id_orden NUMBER NOT NULL,
    id_producto NUMBER NOT NULL,
    cantidad NUMBER NOT NULL,
    precio NUMBER NOT NULL,
    fecha_de_orden DATE NOT NULL,
    fecha_envio DATE,
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
    aud_id_usuario_antes NUMBER,
    aud_precio_total_antes NUMBER,
    aud_estado_orden_despues VARCHAR2(255),
    aud_id_usuario_despues NUMBER,
    aud_precio_total_despues NUMBER,
    -- Atributos de la tabla Producto
    aud_id_prod_afectado NUMBER,
    aud_precio_prod_antes NUMBER,
    aud_precio_prod_despues NUMBER,
    aud_inven_antes NUMBER,
    aud_inven_despues NUMBER,
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


SET SERVEROUTPUT ON;

-- Actualizar tabla UsuarioComprador

ALTER TABLE UsuarioComprador ADD usu_edad NUMBER DEFAULT 0 NOT NULL;
ALTER TABLE UsuarioComprador ADD usu_sexo CHAR(1) NOT NULL;
ALTER TABLE UsuarioComprador ADD CONSTRAINT chk_usu_sexo CHECK(usu_sexo IN('F', 'M', 'f', 'm'));

-- Actualizar la tabla Producto

ALTER TABLE Producto ADD CONSTRAINT chk_inventario CHECK (inventario >= 0);
ALTER TABLE Producto ADD CONSTRAINT chk_precio CHECK (precio >= 0);

-- Actualizar la tabla carrito

ALTER TABLE Carrito ADD CONSTRAINT chk_items CHECK (items_total >= 0);
ALTER TABLE Carrito ADD CONSTRAINT chk_precio_carrito CHECK (precio_total >= 0);

-- Actualizar la tabla pago

ALTER TABLE Pago ADD monto_pagado NUMBER NOT NULL;
ALTER TABLE Pago ADD (estado_pago VARCHAR2(50) DEFAULT 'Pendiente');
ALTER TABLE Pago ADD CONSTRAINT chk_monto_pagado CHECK (monto_pagado >= 0);

-- Actualizar la tabla ordenitem

ALTER TABLE OrdenItem ADD CONSTRAINT chk_cantidad CHECK (cantidad >=0);
ALTER TABLE OrdenItem ADD CONSTRAINT chk_precio_orden CHECK (precio >=0);


-- Tabla intermedia para gestionar los productos del carrito

CREATE TABLE CarritoProducto (
    id_carrito NUMBER,
    id_producto NUMBER,
    cantidad NUMBER,
    CONSTRAINT pk_carrito_producto PRIMARY KEY (id_carrito, id_producto),
    CONSTRAINT fk_carrito_producto FOREIGN KEY (id_carrito) REFERENCES Carrito(id_carrito),
    CONSTRAINT fk_producto_carrito FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);


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
            aud_id_prod_afectado, aud_precio_prod_despues, aud_inven_despues
        ) VALUES (
            seq_auditoria.NEXTVAL, 'Producto', 'I', USER, SYSDATE,
            :NEW.id_producto, :NEW.precio, :NEW.inventario
        );
    ELSIF UPDATING THEN
        INSERT INTO Auditoria (
            aud_id_transaccion, aud_tabla_afectada, aud_accion, aud_usuario, aud_fecha,
            aud_id_prod_afectado, aud_precio_prod_antes, aud_precio_prod_despues,
            aud_inven_antes, aud_inven_despues
        ) VALUES (
            seq_auditoria.NEXTVAL, 'Producto', 'U', USER, SYSDATE,
            :OLD.id_producto, :OLD.precio, :NEW.precio,
            :OLD.inventario, :NEW.inventario
        );
    ELSIF DELETING THEN
        INSERT INTO Auditoria (
            aud_id_transaccion, aud_tabla_afectada, aud_accion, aud_usuario, aud_fecha,
            aud_id_prod_afectado, aud_precio_prod_antes, aud_inven_antes
        ) VALUES (
            seq_auditoria.NEXTVAL, 'Producto', 'D', USER, SYSDATE,
            :OLD.id_producto, :OLD.precio, :OLD.inventario
        );
    END IF;
END;
/

-- Trigger para auditar la tabla orden

CREATE OR REPLACE TRIGGER trg_audit_orden
AFTER INSERT OR UPDATE OR DELETE
ON Orden
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO Auditoria (
            aud_id_transaccion, aud_tabla_afectada, aud_accion, aud_usuario, aud_fecha,
            aud_id_orden_afectada, aud_estado_orden_despues, aud_id_usuario_despues, aud_precio_total_despues
        ) VALUES (
            seq_auditoria.NEXTVAL, 'Orden', 'I', USER, SYSDATE,
            :NEW.id_orden, :NEW.estado_orden, :NEW.id_usuario, :NEW.precio_total
        );
    ELSIF UPDATING THEN
        INSERT INTO Auditoria (
            aud_id_transaccion, aud_tabla_afectada, aud_accion, aud_usuario, aud_fecha,
            aud_id_orden_afectada, aud_estado_orden_antes, aud_id_usuario_antes, aud_precio_total_antes,
            aud_estado_orden_despues, aud_id_usuario_despues, aud_precio_total_despues
        ) VALUES (
            seq_auditoria.NEXTVAL, 'Orden', 'U', USER, SYSDATE,
            :OLD.id_orden, :OLD.estado_orden, :OLD.id_usuario, :OLD.precio_total,
            :NEW.estado_orden, :NEW.id_usuario, :NEW.precio_total
        );
    ELSIF DELETING THEN
        INSERT INTO Auditoria (
            aud_id_transaccion, aud_tabla_afectada, aud_accion, aud_usuario, aud_fecha,
            aud_id_orden_afectada, aud_estado_orden_antes, aud_id_usuario_antes, aud_precio_total_antes
        ) VALUES (
            seq_auditoria.NEXTVAL, 'Orden', 'D', USER, SYSDATE,
            :OLD.id_orden, :OLD.estado_orden, :OLD.id_usuario, :OLD.precio_total
        );
    END IF;
END;
/

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
/

-- Inserciones
BEGIN
    AddVendedor('1000', 'Carlos Martínez', 'carlos.martinez@email.com', 'pass456');
    AddVendedor('500', 'Juan Rodriguez', 'juan.rodriguez@email.com', 'pass212');
    AddVendedor('1500', 'Ana Gomez', 'ana.gomez@email.com', 'pass789');
    AddVendedor('2000', 'Maria Lopez', 'maria.lopez@email.com', 'pass123');
    AddVendedor('800', 'Luis Fernandez', 'luis.fernandez@email.com', 'pass321');
    AddVendedor('600', 'Pedro Suarez', 'pedro.suarez@email.com', 'pass654');
END;
/


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
/

-- Inserciones
BEGIN
    AddCategoria('Consolas y Videojuegos', 'Consolas de videojuegos, juegos y accesorios.');
    AddCategoria('Computadoras', 'Desktops, laptops, y otros dispositivos informáticos.');
    AddCategoria('Telefonía', 'Teléfonos móviles, accesorios y servicios relacionados.');
    AddCategoria('Televisores', 'Televisores de alta definición y accesorios.');
    AddCategoria('Audio', 'Equipos de sonido, auriculares y altavoces.');
    AddCategoria('Accesorios', 'Accesorios varios para dispositivos electrónicos.');
END;
/


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
    p_sexo UsuarioComprador.usu_sexo%TYPE
) AS
    e_ParametroNulo EXCEPTION;
BEGIN
    IF p_nombre_usuario IS NULL OR p_apellido_usuario IS NULL OR p_email_usuario IS NULL OR p_contrasenha_usuario IS NULL OR p_fecha_nacimiento_usuario IS NULL THEN
        RAISE e_ParametroNulo;
    END IF;

    INSERT INTO UsuarioComprador (
        id_usuario, nombre_usuario, apellido_usuario, email_usuario, contrasenha_usuario, fecha_nacimiento_usuario, provincia, distrito, corregimiento, calle, numero_casa, usu_edad, usu_sexo
    ) VALUES (
        seq_usuario.NEXTVAL, p_nombre_usuario, p_apellido_usuario, p_email_usuario, p_contrasenha_usuario, p_fecha_nacimiento_usuario, p_provincia, p_distrito, p_corregimiento, p_calle, p_numero_casa, EdadCliente(p_fecha_nacimiento_usuario), p_sexo
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

-- Inserciones
BEGIN
    AddUsuarioComprador('Juan', 'Pérez', 'juan.perez@email.com', 'pass123', TO_DATE('2003-05-06', 'YYYY-MM-DD'), 'Panamá', 'Panamá', 'San Francisco', 'Calle 50', '123', 'M');
    AddUsuarioComprador('Luz', 'Gonzales', 'luz.gonzales@email.com', 'pass512', TO_DATE('1985-03-23', 'YYYY-MM-DD'), 'Panamá', 'Panamá', 'Ancon', 'Calle 90', '512', 'F');
    AddUsuarioComprador('Ana', 'Gomez', 'ana.gomez@email.com', 'pass456', TO_DATE('1995-12-15', 'YYYY-MM-DD'), 'Panamá', 'Panamá', 'Bella Vista', 'Calle 60', '456','F');
    AddUsuarioComprador('Maria', 'Lopez', 'maria.lopez@email.com', 'pass789', TO_DATE('1988-03-23', 'YYYY-MM-DD'), 'Panamá', 'Panamá', 'El Cangrejo', 'Calle 70', '789', 'F');
    AddUsuarioComprador('Luis', 'Fernandez', 'luis.fernandez@email.com', 'pass321', TO_DATE('2000-08-30', 'YYYY-MM-DD'), 'Panamá', 'Panamá', 'Betania', 'Calle 40', '321', 'M');
    AddUsuarioComprador('Pedro', 'Suarez', 'pedro.suarez@email.com', 'pass654', TO_DATE('1992-11-11', 'YYYY-MM-DD'), 'Panamá', 'Panamá', 'Paitilla', 'Calle 80', '654', 'M');
END;
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
/

-- Inserciones
BEGIN
    AddTelefono('6214-6335');
    AddTelefono('6874-8524');
    AddTelefono('6345-7890');
    AddTelefono('6987-1234');
    AddTelefono('6778-5643');
    AddTelefono('6453-9876');
    AddTelefono('6754-6305');
    AddTelefono('6574-8054');
    AddTelefono('6855-7150');
    AddTelefono('6017-1577');
    AddTelefono('6144-4851');
    AddTelefono('6010-1444');
END;
/


-- Carrito
CREATE OR REPLACE PROCEDURE AddCarrito(
    p_id_usuario IN Carrito.id_usuario%TYPE
) AS
    e_ParametroNulo EXCEPTION;
BEGIN
    IF p_id_usuario IS NULL THEN
        RAISE e_ParametroNulo;
    END IF;

    INSERT INTO Carrito (
        id_carrito, id_usuario, precio_total, items_total
    ) VALUES (
        seq_carrito.NEXTVAL, p_id_usuario, 0, 0
    );

EXCEPTION
    WHEN e_ParametroNulo THEN
        DBMS_OUTPUT.PUT_LINE('Los parámetros obligatorios no aceptan valores nulos');
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Llave primaria duplicada en la inserción');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error: ' || SQLERRM);
END AddCarrito;
/

-- Inserciones
BEGIN
    AddCarrito(1);
    AddCarrito(2);
    AddCarrito(3);
    AddCarrito(4);
    AddCarrito(5);
    AddCarrito(6);
END;
/


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

-- Inserciones
BEGIN
    AddTipoTelefonoVendedor(1, 1, 'Celular');
    AddTipoTelefonoVendedor(2, 2, 'Celular');
    AddTipoTelefonoVendedor(3, 3, 'Celular');
    AddTipoTelefonoVendedor(4, 4, 'Celular');
    AddTipoTelefonoVendedor(5, 5, 'Celular');
    AddTipoTelefonoVendedor(6, 6, 'Celular');

END;
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

-- Inserciones
BEGIN
    AddTipoTelefonoVendedor(1, 7, 'Celular');
    AddTipoTelefonoVendedor(2, 8, 'Celular');
    AddTipoTelefonoVendedor(3, 9, 'Celular');
    AddTipoTelefonoVendedor(4, 10, 'Celular');
    AddTipoTelefonoVendedor(5, 11, 'Celular');
    AddTipoTelefonoVendedor(6, 12, 'Celular');
END;
/

-- Producto
CREATE OR REPLACE PROCEDURE AddProducto(
    p_nombre_producto IN Producto.nombre_producto%TYPE,
    p_descripcion_producto IN Producto.descripcion_producto%TYPE,
    p_marca IN Producto.marca%TYPE,
    p_inventario IN Producto.inventario%TYPE,
    p_precio IN Producto.precio%TYPE,
    p_id_categoria IN Producto.id_categoria%TYPE,
    p_id_vendedor IN Producto.id_vendedor%TYPE
) AS
    e_ParametroNulo EXCEPTION;
BEGIN
    IF p_nombre_producto IS NULL OR p_descripcion_producto IS NULL OR p_marca IS NULL OR p_inventario IS NULL OR p_precio IS NULL OR p_id_categoria IS NULL OR p_id_vendedor IS NULL THEN
        RAISE e_ParametroNulo;
    END IF;

    INSERT INTO Producto (
        id_producto, nombre_producto, descripcion_producto, marca, inventario, precio, id_categoria, id_vendedor
    ) VALUES (
        seq_producto.NEXTVAL, p_nombre_producto, p_descripcion_producto, p_marca, p_inventario, p_precio, p_id_categoria, p_id_vendedor
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

BEGIN
    -- Categoria 1: Consolas y Videojuegos
    AddProducto('PlayStation 5', 'Consola de última generación de Sony.', 'Sony', 50, 499.99, 1, 1);
    AddProducto('Xbox Series X', 'Consola de Microsoft con gráficos 4K.', 'Microsoft', 30, 549.99, 1, 2);
    AddProducto('FIFA 23', 'Videojuego de fútbol para PlayStation y Xbox.', 'EA Sports', 100, 59.99, 1, 3);
    AddProducto('Nintendo Switch', 'Consola híbrida para jugar en casa y en movimiento.', 'Nintendo', 80, 299.99, 1, 4);
    AddProducto('Call of Duty: Warzone', 'Videojuego de acción en primera persona.', 'Activision', 150, 29.99, 1, 5);

    -- Categoria 2: Computadoras
    AddProducto('MacBook Pro', 'Laptop potente para profesionales.', 'Apple', 20, 1999.99, 2, 4);
    AddProducto('Alienware Aurora', 'PC de alta gama para gaming.', 'Dell', 15, 2499.99, 2, 5);
    AddProducto('HP Pavilion', 'Laptop económica para uso diario.', 'HP', 50, 799.99, 2, 6);
    AddProducto('Lenovo ThinkPad X1 Carbon', 'Laptop empresarial ultraligera y duradera.', 'Lenovo', 30, 1799.99, 2, 1);
    AddProducto('ASUS ROG Strix G15', 'PC gaming con pantalla de alta tasa de refresco.', 'ASUS', 25, 2199.99, 2, 2);

    -- Categoria 3: Telefonía
    AddProducto('iPhone 13 Pro', 'Teléfono móvil con cámara mejorada.', 'Apple', 100, 1099.99, 3, 1);
    AddProducto('Samsung Galaxy S22', 'Teléfono Android con pantalla AMOLED.', 'Samsung', 80, 999.99, 3, 2);
    AddProducto('Google Pixel 7', 'Teléfono con excelente cámara y rendimiento.', 'Google', 70, 899.99, 3, 3);
    AddProducto('OnePlus 10 Pro', 'Teléfono con cámara Hasselblad y carga ultra rápida.', 'OnePlus', 60, 1199.99, 3, 4);
    AddProducto('Xiaomi Mi 12', 'Teléfono con tecnología de carga inalámbrica de alta potencia.', 'Xiaomi', 50, 999.99, 3, 5);

    -- Categoria 4: Televisores
    AddProducto('Sony Bravia 4K', 'Televisor 4K con tecnología HDR.', 'Sony', 40, 899.99, 4, 4);
    AddProducto('LG OLED C1', 'Televisor OLED con colores vibrantes.', 'LG', 30, 1499.99, 4, 5);
    AddProducto('Samsung QLED Q80A', 'Televisor QLED con modo juego.', 'Samsung', 50, 1199.99, 4, 6);
    AddProducto('TCL 6-Series 4K', 'Televisor 4K con Roku integrado.', 'TCL', 35, 799.99, 4, 2);
    AddProducto('Hisense U8G Quantum Series', 'Televisor con tecnología Quantum Dot para colores brillantes.', 'Hisense', 45, 1399.99, 4, 3);

    -- Categoria 5: Audio
    AddProducto('Bose QuietComfort 45', 'Auriculares con cancelación de ruido.', 'Bose', 120, 299.99, 5, 1);
    AddProducto('Sonos Arc', 'Barra de sonido premium para cine en casa.', 'Sonos', 60, 799.99, 5, 2);
    AddProducto('JBL Flip 6', 'Altavoz Bluetooth resistente al agua.', 'JBL', 200, 129.99, 5, 3);
    AddProducto('Sennheiser HD 660 S', 'Auriculares de alta fidelidad con diseño abierto.', 'Sennheiser', 80, 399.99, 5, 5);
    AddProducto('Harman Kardon Citation One', 'Altavoz inteligente con sonido premium.', 'Harman Kardon', 100, 199.99, 5, 6);

    -- Categoria 6: Accesorios
    AddProducto('Logitech MX Master 3', 'Mouse ergonómico para productividad.', 'Logitech', 300, 99.99, 6, 4);
    AddProducto('Anker PowerCore 20000', 'Batería externa de alta capacidad.', 'Anker', 150, 49.99, 6, 5);
    AddProducto('Samsung EVO 970', 'SSD rápido para almacenamiento.', 'Samsung', 80, 149.99, 6, 6);
    AddProducto('Razer DeathAdder V2', 'Mouse gaming con sensor óptico avanzado.', 'Razer', 200, 79.99, 6, 1);
    AddProducto('Corsair K70 RGB MK.2', 'Teclado mecánico gaming con retroiluminación RGB.', 'Corsair', 150, 149.99, 6, 3);
END;
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

-- Inserciones

BEGIN
    -- Reseñas para productos en la categoría 1: Consolas y Videojuegos
    AddResenha(1, 5, '¡Excelente consola! Me encanta la calidad gráfica y la velocidad.', 1); 
    AddResenha(2, 4, 'Buena consola, pero podría mejorar en la duración de la batería.', 4); 
    AddResenha(3, 4, 'Juego emocionante con gráficos impresionantes. Recomendado.', 3); 

    -- Reseñas para productos en la categoría 2: Computadoras
    AddResenha(4, 5, 'La MacBook Pro es perfecta para mi trabajo creativo. Rápida y confiable.', 6); 
    AddResenha(5, 3, 'El Alienware Aurora tiene un rendimiento increíble, pero el precio es alto.', 7); 
    AddResenha(6, 4, 'HP Pavilion es una buena opción para tareas básicas. Buen valor por el dinero.', 8); 

    -- Reseñas para productos en la categoría 3: Telefonía
    AddResenha(1, 5, 'iPhone 13 Pro tiene una cámara espectacular y un diseño elegante.', 11); 
    AddResenha(2, 4, 'El Galaxy S22 tiene una pantalla brillante y funciona sin problemas.', 12); 
    AddResenha(3, 4, 'Pixel 7 es rápido y tiene una gran cámara. Perfecto para fotos.', 13); 

    -- Reseñas para productos en la categoría 4: Televisores
    AddResenha(4, 5, 'Sony Bravia 4K ofrece colores vibrantes y excelente calidad de imagen.', 16); 
    AddResenha(5, 4, 'El LG OLED C1 tiene negros profundos y una experiencia de visualización envolvente.', 17); 
    AddResenha(6, 3, 'QLED Q80A es bueno para juegos, pero el sonido podría ser mejor.', 18); 

    -- Reseñas para productos en la categoría 5: Audio
    AddResenha(1, 5, 'Bose QuietComfort 45 tiene una cancelación de ruido excepcional y sonido claro.', 21); 
    AddResenha(2, 4, 'Sonos Arc es perfecto para cine en casa. Audio envolvente y fácil de configurar.', 22); 
    AddResenha(3, 3, 'JBL Flip 6 tiene buen sonido y es resistente al agua, ideal para actividades al aire libre.', 23); 

    -- Reseñas para productos en la categoría 6: Accesorios
    AddResenha(4, 5, 'Logitech MX Master 3 es cómodo y preciso. Perfecto para largas sesiones de trabajo.', 26); 
    AddResenha(5, 4, 'Anker PowerCore 20000 ofrece mucha carga en un diseño compacto. Muy útil.', 27); 
    AddResenha(6, 3, 'Samsung EVO 970 es rápido, pero esperaba un poco más de rendimiento.', 28); 
END;
/

-- Procedimiento para agregar productos al carrito

CREATE OR REPLACE PROCEDURE AgregarProductoCarrito (
    p_id_carrito IN NUMBER,
    p_id_producto IN NUMBER,
    p_cantidad IN NUMBER
) IS
    v_precio_producto NUMBER;
    v_inventario_producto NUMBER;
BEGIN
    -- Obtener precio e inventario del producto
    SELECT precio, inventario INTO v_precio_producto, v_inventario_producto
    FROM Producto
    WHERE id_producto = p_id_producto;

    -- Validar que el inventario no sea negativo
    IF v_inventario_producto < p_cantidad THEN
        RAISE_APPLICATION_ERROR(-20001, 'Inventario insuficiente para el producto.');
    END IF;

    -- Actualizar inventario del producto
    UPDATE Producto
    SET inventario = inventario - p_cantidad
    WHERE id_producto = p_id_producto;

    -- Verificar si el producto ya está en el carrito
    BEGIN
        UPDATE CarritoProducto
        SET cantidad = cantidad + p_cantidad
        WHERE id_carrito = p_id_carrito AND id_producto = p_id_producto;

        IF SQL%ROWCOUNT = 0 THEN
            -- Si el producto no está en el carrito, insertarlo
            INSERT INTO CarritoProducto (id_carrito, id_producto, cantidad)
            VALUES (p_id_carrito, p_id_producto, p_cantidad);
        END IF;
    END;

    -- Actualizar totales del carrito
    UPDATE Carrito
    SET precio_total = precio_total + (v_precio_producto * p_cantidad),
        items_total = items_total + p_cantidad
    WHERE id_carrito = p_id_carrito;

    COMMIT;

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20003, 'Error: Producto duplicado en el carrito.');
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20004, 'Error: Producto no encontrado.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20005, 'Error inesperado: ' || SQLERRM);
END AgregarProductoCarrito;
/


BEGIN
    AgregarProductoCarrito(1,1,1);
    AgregarProductoCarrito(1,3,1);
    AgregarProductoCarrito(1,5,1);
END;
/

-- Procedimiento para eliminar del carrito

CREATE OR REPLACE PROCEDURE EliminarProductoCarrito (
    p_id_carrito IN NUMBER,
    p_id_producto IN NUMBER,
    p_cantidad IN NUMBER
) IS
    v_precio_producto NUMBER;
    v_cantidad_actual NUMBER;
BEGIN
    -- Obtener precio del producto
    SELECT precio INTO v_precio_producto
    FROM Producto
    WHERE id_producto = p_id_producto;

    -- Obtener la cantidad actual del producto en el carrito
    SELECT cantidad INTO v_cantidad_actual
    FROM CarritoProducto
    WHERE id_carrito = p_id_carrito AND id_producto = p_id_producto;

    -- Validar que la cantidad a eliminar no sea mayor que la cantidad actual
    IF v_cantidad_actual < p_cantidad THEN
        RAISE_APPLICATION_ERROR(-20002, 'La cantidad a eliminar es mayor que la cantidad actual en el carrito.');
    END IF;

    -- Actualizar inventario del producto
    UPDATE Producto
    SET inventario = inventario + p_cantidad
    WHERE id_producto = p_id_producto;

    -- Actualizar o eliminar el producto del carrito
    IF v_cantidad_actual = p_cantidad THEN
        DELETE FROM CarritoProducto
        WHERE id_carrito = p_id_carrito AND id_producto = p_id_producto;
    ELSE
        UPDATE CarritoProducto
        SET cantidad = cantidad - p_cantidad
        WHERE id_carrito = p_id_carrito AND id_producto = p_id_producto;
    END IF;

    -- Actualizar totales del carrito
    UPDATE Carrito
    SET precio_total = precio_total - (v_precio_producto * p_cantidad),
        items_total = items_total - p_cantidad
    WHERE id_carrito = p_id_carrito;

    COMMIT;

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20003, 'Error: Producto duplicado en la tabla.');
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20004, 'Error: Producto o Carrito no encontrado.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20005, 'Error inesperado: ' || SQLERRM);
END EliminarProductoCarrito;
/

BEGIN
    EliminarProductoCarrito(1,1,1);
END;
/

-- Transacción para generar la orden

CREATE OR REPLACE PROCEDURE CrearOrden (
    p_id_carrito IN NUMBER
) IS
    v_id_orden NUMBER;
    v_id_usuario NUMBER;
    v_precio_total NUMBER;
    v_estado_orden VARCHAR2(255) := 'Pendiente';
BEGIN
    -- Obtener id_usuario y precio_total del carrito
    SELECT id_usuario, precio_total
    INTO v_id_usuario, v_precio_total
    FROM Carrito
    WHERE id_carrito = p_id_carrito;

    -- Crear nueva orden
    INSERT INTO Orden (id_orden, id_carrito, id_usuario, estado_orden, precio_total)
    VALUES (seq_orden.NEXTVAL, p_id_carrito, v_id_usuario, v_estado_orden, v_precio_total)
    RETURNING id_orden INTO v_id_orden;

    -- Mover productos del carrito a OrdenItem
    FOR r IN (
        SELECT cp.id_producto, cp.cantidad, p.precio
        FROM CarritoProducto cp
        JOIN Producto p ON cp.id_producto = p.id_producto
        WHERE cp.id_carrito = p_id_carrito
    ) LOOP
        INSERT INTO OrdenItem (id_orden, id_producto, cantidad, precio, fecha_de_orden, fecha_envio)
        VALUES (v_id_orden, r.id_producto, r.cantidad, r.precio, SYSDATE, NULL);
    END LOOP;

    -- Vaciar carrito
    DELETE FROM CarritoProducto
    WHERE id_carrito = p_id_carrito;

    -- Actualizar totales del carrito
    UPDATE Carrito
    SET precio_total = 0, items_total = 0
    WHERE id_carrito = p_id_carrito;

    COMMIT;

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20003, 'Error: Orden duplicada.');
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20004, 'Error: Carrito no encontrado.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20005, 'Error inesperado: ' || SQLERRM);
END CrearOrden;
/


BEGIN
    CrearOrden(1);
END;
/


-- Transaccion para realizar el pago

CREATE OR REPLACE PROCEDURE RealizarPago (
    p_id_orden IN NUMBER,
    p_monto_pagado IN NUMBER,
    p_modo_pago IN VARCHAR2
) IS
    v_precio_total NUMBER;
    v_id_usuario NUMBER;
BEGIN
    -- Obtener el total de la orden y el id del usuario
    SELECT precio_total, id_usuario INTO v_precio_total, v_id_usuario
    FROM Orden
    WHERE id_orden = p_id_orden;

    -- Validar que el monto pagado coincida con el total de la orden
    IF p_monto_pagado != v_precio_total THEN
        RAISE_APPLICATION_ERROR(-20002, 'El monto pagado no coincide con el total de la orden.');
    END IF;

    -- Actualizar estado de la orden a Pagado
    UPDATE Orden
    SET estado_orden = 'Enviado'
    WHERE id_orden = p_id_orden;

    -- Actualizar fecha de envio de ordenitem a un dia despues de haber pagado
    UPDATE OrdenItem
    SET fecha_envio = SYSDATE + 1
    WHERE id_orden = p_id_orden;

    -- Registrar el pago
    INSERT INTO Pago (id_pago, id_usuario, modo_pago, fecha_pago, id_orden, monto_pagado, estado_pago)
    VALUES (seq_pago.NEXTVAL, v_id_usuario, p_modo_pago, SYSDATE, p_id_orden, p_monto_pagado, 'Pagado');

    COMMIT;

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20003, 'Error: Pago duplicado.');
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20004, 'Error: Orden no encontrada.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20005, 'Error inesperado: ' || SQLERRM);
END RealizarPago;
/

BEGIN
    RealizarPago(1, 89.98, 'Tarjeta de Crédito');
END;
/


-- Vista de inventario de productos

CREATE OR REPLACE VIEW VistaProducto AS
SELECT p.nombre_producto AS "Producto", p.inventario AS "Stock", p.precio AS "Precio", c.nombre_categoria AS "Categoria"
FROM Producto p
JOIN Categoria c ON p.id_categoria = c.id_categoria;

SELECT *FROM VistaProducto;

