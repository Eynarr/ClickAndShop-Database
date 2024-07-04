CREATE TABLE Vendedor (
    ven_id_vendedor NUMBER,
    ven_ventas_totales VARCHAR2(255) NOT NULL,
    ven_nombre_vendedor VARCHAR2(255) NOT NULL,
    ven_email_vendedor VARCHAR2(255) UNIQUE NOT NULL,
    ven_contrasenha_vendedor VARCHAR2(255) NOT NULL,
    CONSTRAINT pk_vendedor_id PRIMARY KEY (ven_id_vendedor)
);

CREATE TABLE Categoria (
    cat_id_categoria NUMBER,
    cat_nombre_categoria VARCHAR2(100) NOT NULL,
    cat_descripcion VARCHAR2(500),
    CONSTRAINT pk_id_categoria PRIMARY KEY (cat_id_categoria)
);

CREATE TABLE UsuarioComprador (
    usu_id_usuario NUMBER NOT NULL,
    usu_nombre_usuario VARCHAR2(255) NOT NULL,
    usu_apellido_usuario VARCHAR2(255) NOT NULL,
    usu_email_usuario VARCHAR2(255) UNIQUE NOT NULL,
    usu_contrasenha_usuario VARCHAR2(255) NOT NULL,
    usu_fecha_nacimiento_usuario DATE NOT NULL,
    usu_provincia VARCHAR2(255) NOT NULL,
    usu_distrito VARCHAR2(255) NOT NULL,
    usu_corregimiento VARCHAR2(255) NOT NULL,
    usu_calle VARCHAR2(255) NOT NULL,
    usu_numero_casa VARCHAR2(255) NOT NULL,
    CONSTRAINT pk_id_usuario PRIMARY KEY (usu_id_usuario)
);

CREATE TABLE Telefono (
    tel_id_telefono NUMBER ,
    tel_telefono VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_id_telefono PRIMARY KEY (tel_id_telefono)
);

CREATE TABLE Carrito (
    car_id_carrito NUMBER NOT NULL,
    car_id_usuario NUMBER NOT NULL,
    car_precio_total NUMBER DEFAULT 0 NOT NULL,
    car_items_total NUMBER DEFAULT 0 NOT NULL,
    CONSTRAINT pk_id_carrito PRIMARY KEY (car_id_carrito),
    CONSTRAINT fk_id_usuario FOREIGN KEY (car_id_usuario) REFERENCES UsuarioComprador(usu_id_usuario)
);

CREATE TABLE tipos_telefonos_vendedor (
    ttv_id_vendedor NUMBER NOT NULL,
    ttv_id_telefono NUMBER NOT NULL,
    ttv_tipo_telefono VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_telefonos_vendedor PRIMARY KEY (ttv_id_telefono, ttv_id_vendedor),
    CONSTRAINT fk_id_telefono FOREIGN KEY (ttv_id_telefono) REFERENCES Telefono(tel_id_telefono),
    CONSTRAINT fk_id_vendedor FOREIGN KEY (ttv_id_vendedor) REFERENCES Vendedor(ven_id_vendedor)
);

CREATE TABLE tipos_telefonos_usuario (
    ttu_id_usuario NUMBER NOT NULL,
    ttu_id_telefono NUMBER NOT NULL,
    ttu_tipo_telefono VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_telefonos_usuario PRIMARY KEY (ttu_id_telefono, ttu_id_usuario),
    CONSTRAINT fk_idtelefono FOREIGN KEY (ttu_id_telefono) REFERENCES Telefono(tel_id_telefono),
    CONSTRAINT fk_idusuario FOREIGN KEY (ttu_id_usuario) REFERENCES UsuarioComprador(usu_id_usuario)
);

CREATE TABLE Orden (
    ord_id_orden NUMBER NOT NULL,
    ord_id_carrito NUMBER NOT NULL,
    ord_id_usuario NUMBER NOT NULL,
    ord_estado_orden VARCHAR2(255) NOT NULL,
    ord_precio_total NUMBER NOT NULL,
    CONSTRAINT pk_id_orden PRIMARY KEY (ord_id_orden),
    CONSTRAINT fk_id_orden_carrito FOREIGN KEY (ord_id_carrito) REFERENCES Carrito(car_id_carrito),
    CONSTRAINT fk_id_orden_usuario FOREIGN KEY (ord_id_usuario) REFERENCES UsuarioComprador(usu_id_usuario)
);

CREATE TABLE Pago (
    pag_id_pago NUMBER NOT NULL,
    pag_id_usuario NUMBER NOT NULL,
    pag_modo_pago VARCHAR2(255) NOT NULL,
    pag_fecha_pago DATE DEFAULT SYSDATE,
    pag_id_orden NUMBER NOT NULL,
    CONSTRAINT pk_id_pago PRIMARY KEY (pag_id_pago),
    CONSTRAINT fk_id_pago_orden FOREIGN KEY (pag_id_orden) REFERENCES Orden(ord_id_orden),
    CONSTRAINT fk_id_pago_usuario FOREIGN KEY (pag_id_usuario) REFERENCES UsuarioComprador(usu_id_usuario)
);

CREATE TABLE Producto (
    pro_id_producto NUMBER NOT NULL,
    pro_nombre_producto VARCHAR2(255) NOT NULL,
    pro_descripcion_producto VARCHAR2(500) NOT NULL,
    pro_marca VARCHAR2(255) NOT NULL,
    pro_inventario NUMBER NOT NULL,
    pro_precio NUMBER NOT NULL,
    pro_id_categoria NUMBER NOT NULL,
    pro_id_vendedor NUMBER NOT NULL,
    CONSTRAINT pk_id_producto PRIMARY KEY (pro_id_producto),
    CONSTRAINT fk_id_producto_categoria FOREIGN KEY (pro_id_categoria) REFERENCES Categoria(cat_id_categoria),
    CONSTRAINT fk_id_producto_vendedor FOREIGN KEY (pro_id_vendedor) REFERENCES Vendedor(ven_id_vendedor)
);


CREATE TABLE OrdenItem (
    ori_id_orden NUMBER NOT NULL,
    ori_id_producto NUMBER NOT NULL,
    ori_cantidad NUMBER NOT NULL,
    ori_precio NUMBER NOT NULL,
    ori_fecha_de_orden DATE NOT NULL,
    ori_fecha_envio DATE,
    CONSTRAINT pk_ordenitem PRIMARY KEY (ori_id_orden, ori_id_producto ),
    CONSTRAINT fk_id_orden_item FOREIGN KEY (ori_id_orden) REFERENCES Orden(ord_id_orden),
    CONSTRAINT fk_id_producto_ordenitem FOREIGN KEY (ori_id_producto) REFERENCES Producto(pro_id_producto)
);

CREATE TABLE resenhas (
    res_id_resenha NUMBER NOT NULL,
    res_id_usuario NUMBER NOT NULL,
    res_calificacion VARCHAR2(255) NOT NULL,
    res_descripcion VARCHAR2(255) NOT NULL,
    res_id_producto NUMBER NOT NULL,
    CONSTRAINT pk_id_resenha PRIMARY KEY (res_id_resenha),
    CONSTRAINT fk_id_producto FOREIGN KEY (res_id_producto) REFERENCES Producto(pro_id_producto),
    CONSTRAINT fk_id_resenha_usuario FOREIGN KEY (res_id_usuario) REFERENCES UsuarioComprador(usu_id_usuario)
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


-- Actualizaciones a las tablas


-- Actualizar tabla UsuarioComprador

ALTER TABLE UsuarioComprador ADD usu_edad NUMBER DEFAULT 0 NOT NULL;
ALTER TABLE UsuarioComprador ADD usu_sexo CHAR(1) NOT NULL;
ALTER TABLE UsuarioComprador ADD CONSTRAINT chk_usu_sexo CHECK(usu_sexo IN('F', 'M', 'f', 'm'));

-- Actualizar la tabla Producto

ALTER TABLE Producto ADD CONSTRAINT chk_inventario CHECK (pro_inventario >= 0);
ALTER TABLE Producto ADD CONSTRAINT chk_precio CHECK (pro_precio >= 0);

-- Actualizar la tabla carrito

ALTER TABLE Carrito ADD CONSTRAINT chk_items CHECK (car_items_total >= 0);
ALTER TABLE Carrito ADD CONSTRAINT chk_precio_carrito CHECK (car_precio_total >= 0);

-- Actualizar la tabla pago

ALTER TABLE Pago ADD pag_monto_pagado NUMBER NOT NULL;
ALTER TABLE Pago ADD (pag_estado_pago VARCHAR2(50) DEFAULT 'Pendiente');
ALTER TABLE Pago ADD CONSTRAINT chk_monto_pagado CHECK (pag_monto_pagado >= 0);

-- Actualizar la tabla ordenitem

ALTER TABLE OrdenItem ADD CONSTRAINT chk_cantidad CHECK (ori_cantidad >=0);
ALTER TABLE OrdenItem ADD CONSTRAINT chk_precio_orden CHECK (ori_precio >=0);


-- Actualizar la tabla resenhas

ALTER TABLE Resenhas ADD res_fecha DATE DEFAULT SYSDATE;

-- Tabla intermedia para gestionar los productos del carrito

CREATE TABLE CarritoProducto (
    cap_id_carrito NUMBER,
    cap_id_producto NUMBER,
    cap_cantidad NUMBER,
    CONSTRAINT pk_carrito_producto PRIMARY KEY (cap_id_carrito, cap_id_producto),
    CONSTRAINT fk_carrito_producto FOREIGN KEY (cap_id_carrito) REFERENCES Carrito(car_id_carrito),
    CONSTRAINT fk_producto_carrito FOREIGN KEY (cap_id_producto) REFERENCES Producto(pro_id_producto)
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
            :NEW.pro_id_producto, :NEW.pro_precio, :NEW.pro_inventario
        );
    ELSIF UPDATING THEN
        INSERT INTO Auditoria (
            aud_id_transaccion, aud_tabla_afectada, aud_accion, aud_usuario, aud_fecha,
            aud_id_prod_afectado, aud_precio_prod_antes, aud_precio_prod_despues,
            aud_inven_antes, aud_inven_despues
        ) VALUES (
            seq_auditoria.NEXTVAL, 'Producto', 'U', USER, SYSDATE,
            :OLD.pro_id_producto, :OLD.pro_precio, :NEW.pro_precio,
            :OLD.pro_inventario, :NEW.pro_inventario
        );
    ELSIF DELETING THEN
        INSERT INTO Auditoria (
            aud_id_transaccion, aud_tabla_afectada, aud_accion, aud_usuario, aud_fecha,
            aud_id_prod_afectado, aud_precio_prod_antes, aud_inven_antes
        ) VALUES (
            seq_auditoria.NEXTVAL, 'Producto', 'D', USER, SYSDATE,
            :OLD.pro_id_producto, :OLD.pro_precio, :OLD.pro_inventario
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
            :NEW.ord_id_orden, :NEW.ord_estado_orden, :NEW.ord_id_usuario, :NEW.ord_precio_total
        );
    ELSIF UPDATING THEN
        INSERT INTO Auditoria (
            aud_id_transaccion, aud_tabla_afectada, aud_accion, aud_usuario, aud_fecha,
            aud_id_orden_afectada, aud_estado_orden_antes, aud_id_usuario_antes, aud_precio_total_antes,
            aud_estado_orden_despues, aud_id_usuario_despues, aud_precio_total_despues
        ) VALUES (
            seq_auditoria.NEXTVAL, 'Orden', 'U', USER, SYSDATE,
            :OLD.ord_id_orden, :OLD.ord_estado_orden, :OLD.ord_id_usuario, :OLD.ord_precio_total,
            :NEW.ord_estado_orden, :NEW.ord_id_usuario, :NEW.ord_precio_total
        );
    ELSIF DELETING THEN
        INSERT INTO Auditoria (
            aud_id_transaccion, aud_tabla_afectada, aud_accion, aud_usuario, aud_fecha,
            aud_id_orden_afectada, aud_estado_orden_antes, aud_id_usuario_antes, aud_precio_total_antes
        ) VALUES (
            seq_auditoria.NEXTVAL, 'Orden', 'D', USER, SYSDATE,
            :OLD.ord_id_orden, :OLD.ord_estado_orden, :OLD.ord_id_usuario, :OLD.ord_precio_total
        );
    END IF;
END;
/

-- Funciones

-- Funcion para calcular la edad del usuario

CREATE OR REPLACE FUNCTION EdadCliente(
    p_nacimiento_usuario UsuarioComprador.usu_fecha_nacimiento_usuario%TYPE
) RETURN NUMBER AS
    v_edad   UsuarioComprador.usu_edad%TYPE;
    v_fecha  UsuarioComprador.usu_fecha_nacimiento_usuario%TYPE := p_nacimiento_usuario;
BEGIN
    v_edad := FLOOR(MONTHS_BETWEEN(SYSDATE, v_fecha) / 12);
    RETURN v_edad;
END;
/

-- Procesos

-- Vendedor
CREATE OR REPLACE PROCEDURE AddVendedor(
    p_ventas_totales IN Vendedor.ven_ventas_totales%TYPE,
    p_nombre_vendedor IN Vendedor.ven_nombre_vendedor%TYPE,
    p_email_vendedor IN Vendedor.ven_email_vendedor%TYPE,
    p_contrasenha_vendedor IN Vendedor.ven_contrasenha_vendedor%TYPE
) AS
    e_ParametroNulo EXCEPTION;
BEGIN
    IF p_ventas_totales IS NULL OR p_nombre_vendedor IS NULL OR p_email_vendedor IS NULL OR p_contrasenha_vendedor IS NULL THEN
        RAISE e_ParametroNulo;
    END IF;

    INSERT INTO Vendedor (
        ven_id_vendedor, ven_ventas_totales, ven_nombre_vendedor, ven_email_vendedor, ven_contrasenha_vendedor
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
    p_nombre_categoria IN Categoria.cat_nombre_categoria%TYPE,
    p_descripcion IN Categoria.cat_descripcion%TYPE
) AS
    e_ParametroNulo EXCEPTION;
BEGIN
    IF p_nombre_categoria IS NULL THEN
        RAISE e_ParametroNulo;
    END IF;

    INSERT INTO Categoria (
        cat_id_categoria, cat_nombre_categoria, cat_descripcion
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
    p_nombre_usuario IN UsuarioComprador.usu_nombre_usuario%TYPE,
    p_apellido_usuario IN UsuarioComprador.usu_apellido_usuario%TYPE,
    p_email_usuario IN UsuarioComprador.usu_email_usuario%TYPE,
    p_contrasenha_usuario IN UsuarioComprador.usu_contrasenha_usuario%TYPE,
    p_fecha_nacimiento_usuario IN UsuarioComprador.usu_fecha_nacimiento_usuario%TYPE,
    p_provincia IN UsuarioComprador.usu_provincia%TYPE,
    p_distrito IN UsuarioComprador.usu_distrito%TYPE,
    p_corregimiento IN UsuarioComprador.usu_corregimiento%TYPE,
    p_calle IN UsuarioComprador.usu_calle%TYPE,
    p_numero_casa IN UsuarioComprador.usu_numero_casa%TYPE,
    p_sexo UsuarioComprador.usu_sexo%TYPE
) AS
    e_ParametroNulo EXCEPTION;
BEGIN
    IF p_nombre_usuario IS NULL OR p_apellido_usuario IS NULL OR p_email_usuario IS NULL OR p_contrasenha_usuario IS NULL OR p_fecha_nacimiento_usuario IS NULL THEN
        RAISE e_ParametroNulo;
    END IF;

    INSERT INTO UsuarioComprador (
        usu_id_usuario, usu_nombre_usuario, usu_apellido_usuario, usu_email_usuario, usu_contrasenha_usuario, usu_fecha_nacimiento_usuario, usu_provincia, usu_distrito, usu_corregimiento, usu_calle, usu_numero_casa, usu_edad, usu_sexo
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
    p_telefono IN Telefono.tel_telefono%TYPE
) AS
    e_ParametroNulo EXCEPTION;
BEGIN
    IF p_telefono IS NULL THEN
        RAISE e_ParametroNulo;
    END IF;

    INSERT INTO Telefono (
        tel_id_telefono,tel_telefono
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
    p_id_usuario IN Carrito.car_id_usuario%TYPE
) AS
    e_ParametroNulo EXCEPTION;
BEGIN
    IF p_id_usuario IS NULL THEN
        RAISE e_ParametroNulo;
    END IF;

    INSERT INTO Carrito (
        car_id_carrito, car_id_usuario, car_precio_total, car_items_total
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
    p_id_vendedor IN tipos_telefonos_vendedor.ttv_id_vendedor%TYPE,
    p_id_telefono IN tipos_telefonos_vendedor.ttv_id_telefono%TYPE,
    p_tipo_telefono IN tipos_telefonos_vendedor.ttv_tipo_telefono%TYPE
) AS
    e_ParametroNulo EXCEPTION;
BEGIN
    IF p_id_vendedor IS NULL OR p_id_telefono IS NULL OR p_tipo_telefono IS NULL THEN
        RAISE e_ParametroNulo;
    END IF;

    INSERT INTO tipos_telefonos_vendedor (
        ttv_id_vendedor, ttv_id_telefono, ttv_tipo_telefono
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
    p_id_usuario IN tipos_telefonos_usuario.ttu_id_usuario%TYPE,
    p_id_telefono IN tipos_telefonos_usuario.ttu_id_telefono%TYPE,
    p_tipo_telefono IN tipos_telefonos_usuario.ttu_tipo_telefono%TYPE
) AS
    e_ParametroNulo EXCEPTION;
BEGIN
    IF p_id_usuario IS NULL OR p_id_telefono IS NULL OR p_tipo_telefono IS NULL THEN
        RAISE e_ParametroNulo;
    END IF;

    INSERT INTO tipos_telefonos_usuario (
        ttu_id_usuario, ttu_id_telefono, ttu_tipo_telefono
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
    AddTipoTelefonoUsuario(1, 7, 'Celular');
    AddTipoTelefonoUsuario(2, 8, 'Celular');
    AddTipoTelefonoUsuario(3, 9, 'Celular');
    AddTipoTelefonoUsuario(4, 10, 'Celular');
    AddTipoTelefonoUsuario(5, 11, 'Celular');
    AddTipoTelefonoUsuario(6, 12, 'Celular');
END;
/

-- Producto
CREATE OR REPLACE PROCEDURE AddProducto(
    p_nombre_producto IN Producto.pro_nombre_producto%TYPE,
    p_descripcion_producto IN Producto.pro_descripcion_producto%TYPE,
    p_marca IN Producto.pro_marca%TYPE,
    p_inventario IN Producto.pro_inventario%TYPE,
    p_precio IN Producto.pro_precio%TYPE,
    p_id_categoria IN Producto.pro_id_categoria%TYPE,
    p_id_vendedor IN Producto.pro_id_vendedor%TYPE
) AS
    e_ParametroNulo EXCEPTION;
BEGIN
    IF p_nombre_producto IS NULL OR p_descripcion_producto IS NULL OR p_marca IS NULL OR p_inventario IS NULL OR p_precio IS NULL OR p_id_categoria IS NULL OR p_id_vendedor IS NULL THEN
        RAISE e_ParametroNulo;
    END IF;

    INSERT INTO Producto (
        pro_id_producto, pro_nombre_producto, pro_descripcion_producto, pro_marca, pro_inventario, pro_precio, pro_id_categoria, pro_id_vendedor
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

-- Insercion

BEGIN
    -- Categoria 1: Consolas y Videojuegos
    AddProducto('PlayStation 5', 'Consola de última generación de Sony.', 'Sony', 50, 499.99, 1, 1);
    AddProducto('Xbox Series X', 'Consola de Microsoft con gráficos 4K.', 'Microsoft', 30, 549.99, 1, 2);
    AddProducto('FIFA 23', 'Videojuego de fútbol para PlayStation y Xbox.', 'EA Sports', 100, 59.99, 1, 3);
    AddProducto('Nintendo Switch', 'Consola híbrida para jugar en casa y en movimiento.', 'Nintendo', 80, 299.99, 1, 4);
    AddProducto('Call of Duty: Modern Warfare', 'Videojuego de acción en primera persona.', 'Activision', 150, 29.99, 1, 5);

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
    p_id_usuario IN Resenhas.res_id_usuario%TYPE,
    p_calificacion IN Resenhas.res_calificacion%TYPE,
    p_descripcion IN Resenhas.res_descripcion%TYPE,
    p_id_producto IN Resenhas.res_id_producto%TYPE
) AS
    e_ParametroNulo EXCEPTION;
BEGIN
    IF p_id_usuario IS NULL OR p_calificacion IS NULL OR p_descripcion IS NULL OR p_id_producto IS NULL THEN
        RAISE e_ParametroNulo;
    END IF;

    INSERT INTO Resenhas (
        res_id_resenha, res_id_usuario, res_calificacion, res_descripcion, res_id_producto, res_fecha
    ) VALUES (
        seq_resenha.NEXTVAL, p_id_usuario, p_calificacion, p_descripcion, p_id_producto, SYSDATE
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
    p_id_carrito IN Carrito.car_id_carrito%TYPE,
    p_id_producto IN Producto.pro_id_producto%TYPE,
    p_cantidad IN NUMBER
) IS
    v_precio_producto NUMBER;
    v_inventario_producto NUMBER;
BEGIN
    -- Obtener precio e inventario del producto
    SELECT pro_precio, pro_inventario INTO v_precio_producto, v_inventario_producto
    FROM Producto
    WHERE pro_id_producto = p_id_producto;

    -- Validar que el inventario no sea negativo
    IF v_inventario_producto < p_cantidad THEN
        RAISE_APPLICATION_ERROR(-20001, 'Inventario insuficiente para el producto.');
    END IF;

    -- Actualizar inventario del producto
    UPDATE Producto
    SET pro_inventario = pro_inventario - p_cantidad
    WHERE pro_id_producto = p_id_producto;

    -- Verificar si el producto ya está en el carrito
    BEGIN
        UPDATE CarritoProducto
        SET cap_cantidad = cap_cantidad + p_cantidad
        WHERE cap_id_carrito = p_id_carrito AND cap_id_producto = p_id_producto;

        IF SQL%ROWCOUNT = 0 THEN
            -- Si el producto no está en el carrito, insertarlo
            INSERT INTO CarritoProducto (cap_id_carrito, cap_id_producto, cap_cantidad)
            VALUES (p_id_carrito, p_id_producto, p_cantidad);
        END IF;
    END;

    -- Actualizar totales del carrito
    UPDATE Carrito
    SET car_precio_total = car_precio_total + (v_precio_producto * p_cantidad),
        car_items_total = car_items_total + p_cantidad
    WHERE car_id_carrito = p_id_carrito;

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

-- Llamada al procedimiento 

BEGIN
    AgregarProductoCarrito(1,1,2);
    AgregarProductoCarrito(1,3,1);
    AgregarProductoCarrito(1,5,1);
END;
/

-- Procedimiento para eliminar del carrito

CREATE OR REPLACE PROCEDURE EliminarProductoCarrito (
    p_id_carrito IN Carrito.car_id_carrito%TYPE,
    p_id_producto IN Producto.pro_id_producto%TYPE,
    p_cantidad IN NUMBER
) IS
    v_precio_producto NUMBER;
    v_cantidad_actual NUMBER;
BEGIN
    -- Obtener precio del producto
    SELECT pro_precio INTO v_precio_producto
    FROM Producto
    WHERE pro_id_producto = p_id_producto;

    -- Obtener la cantidad actual del producto en el carrito
    SELECT cap_cantidad INTO v_cantidad_actual
    FROM CarritoProducto
    WHERE cap_id_carrito = p_id_carrito AND cap_id_producto = p_id_producto;

    -- Validar que la cantidad a eliminar no sea mayor que la cantidad actual
    IF v_cantidad_actual < p_cantidad THEN
        RAISE_APPLICATION_ERROR(-20002, 'La cantidad a eliminar es mayor que la cantidad actual en el carrito.');
    END IF;

    -- Actualizar inventario del producto
    UPDATE Producto
    SET pro_inventario = pro_inventario + p_cantidad
    WHERE pro_id_producto = p_id_producto;

    -- Actualizar o eliminar el producto del carrito
    IF v_cantidad_actual = p_cantidad THEN
        DELETE FROM CarritoProducto
        WHERE cap_id_carrito = p_id_carrito AND cap_id_producto = p_id_producto;
    ELSE
        UPDATE CarritoProducto
        SET cap_cantidad = cap_cantidad - p_cantidad
        WHERE cap_id_carrito = p_id_carrito AND cap_id_producto = p_id_producto;
    END IF;

    -- Actualizar totales del carrito
    UPDATE Carrito
    SET car_precio_total = car_precio_total - (v_precio_producto * p_cantidad),
        car_items_total = car_items_total - p_cantidad
    WHERE car_id_carrito = p_id_carrito;

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

-- Llamada al procedimiento

BEGIN
    EliminarProductoCarrito(1,1,3);
END;
/

-- Transacción para generar la orden

CREATE OR REPLACE PROCEDURE CrearOrden (
    p_id_carrito IN Carrito.car_id_carrito%TYPE
) IS
    v_id_orden NUMBER;
    v_id_usuario NUMBER;
    v_precio_total NUMBER;
    v_estado_orden VARCHAR2(255) := 'Pendiente';
BEGIN
    -- Obtener id_usuario y precio_total del carrito
    SELECT car_id_usuario, car_precio_total
    INTO v_id_usuario, v_precio_total
    FROM Carrito
    WHERE car_id_carrito = p_id_carrito;

    -- Crear nueva orden
    INSERT INTO Orden (ord_id_orden, ord_id_carrito, ord_id_usuario, ord_estado_orden, ord_precio_total)
    VALUES (seq_orden.NEXTVAL, p_id_carrito, v_id_usuario, v_estado_orden, v_precio_total)
    RETURNING ord_id_orden INTO v_id_orden;

    -- Mover productos del carrito a OrdenItem
    FOR i IN (
        SELECT cp.cap_id_producto, cp.cap_cantidad, p.pro_precio
        FROM CarritoProducto cp
        JOIN Producto p ON cp.cap_id_producto = p.pro_id_producto
        WHERE cp.cap_id_carrito = p_id_carrito
    ) LOOP
        INSERT INTO OrdenItem (ori_id_orden, ori_id_producto, ori_cantidad, ori_precio, ori_fecha_de_orden, ori_fecha_envio)
        VALUES (v_id_orden, i.cap_id_producto, i.cap_cantidad, i.pro_precio, SYSDATE, NULL);
    END LOOP;

    -- Vaciar carrito
    DELETE FROM CarritoProducto
    WHERE cap_id_carrito = p_id_carrito;

    -- Actualizar totales del carrito
    UPDATE Carrito
    SET car_precio_total = 0, car_items_total = 0
    WHERE car_id_carrito = p_id_carrito;

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

-- Llamada la procedimiento

BEGIN
    CrearOrden(1);
END;
/


-- Transaccion para realizar el pago

CREATE OR REPLACE PROCEDURE RealizarPago (
    p_id_orden IN Pago.pag_id_orden%TYPE,
    p_monto_pagado IN Pago.pag_monto_pagado%TYPE,
    p_modo_pago IN Pago.pag_modo_pago%TYPE
) IS
    v_precio_total NUMBER;
    v_id_usuario NUMBER;
    v_estado_orden VARCHAR2(20);
BEGIN
    -- Obtener el total de la orden, el id del usuario y el estado de la orden
    SELECT ord_precio_total, ord_id_usuario, ord_estado_orden INTO v_precio_total, v_id_usuario, v_estado_orden
    FROM Orden
    WHERE ord_id_orden = p_id_orden;

    -- Validar que la orden no haya sido enviada
    IF v_estado_orden = 'Enviada' THEN
        RAISE_APPLICATION_ERROR(-20006, 'La orden ya ha sido pagada.');
    END IF;

    -- Validar que el monto pagado coincida con el total de la orden
    IF p_monto_pagado != v_precio_total THEN
        RAISE_APPLICATION_ERROR(-20002, 'El monto pagado no coincide con el total de la orden.');
    END IF;

    -- Actualizar estado de la orden a Enviada
    UPDATE Orden
    SET ord_estado_orden = 'Enviada'
    WHERE ord_id_orden = p_id_orden;

    -- Actualizar fecha de envio de OrdenItem a un día después de haber pagado
    UPDATE OrdenItem
    SET ori_fecha_envio = SYSDATE + 1
    WHERE ori_id_orden = p_id_orden;

    -- Registrar el pago
    INSERT INTO Pago (pag_id_pago, pag_id_usuario, pag_modo_pago, pag_fecha_pago, pag_id_orden, pag_monto_pagado, pag_estado_pago)
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
    RealizarPago(1, 589.97, 'Tarjeta de Crédito');
END;
/

-- Cursor para imprimir el resumen del pedido

CREATE OR REPLACE PROCEDURE ResumenOrden(
    p_id_orden IN NUMBER
) IS
    CURSOR order_cursor IS
        SELECT o.ord_id_orden, o.ord_id_carrito, o.ord_estado_orden, o.ord_precio_total,
               oi.ori_id_producto, oi.ori_cantidad, oi.ori_precio, p.pro_nombre_producto
        FROM Orden o
        JOIN OrdenItem oi ON o.ord_id_orden = oi.ori_id_orden
        JOIN Producto p ON oi.ori_id_producto = p.pro_id_producto
        WHERE o.ord_id_orden = p_id_orden;

    v_order_row order_cursor%ROWTYPE;
    v_primera_fila BOOLEAN := TRUE;
    v_precio_total NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Resumen del pedido:');
    OPEN order_cursor;
    LOOP
        FETCH order_cursor INTO v_order_row;
        EXIT WHEN order_cursor%NOTFOUND;
        
        -- Imprimir el encabezado del pedido
        IF v_primera_fila THEN
            DBMS_OUTPUT.PUT_LINE('ID Orden: ' || v_order_row.ord_id_orden);
            DBMS_OUTPUT.PUT_LINE('ID Carrito: ' || v_order_row.ord_id_carrito);
            DBMS_OUTPUT.PUT_LINE('Estado de orden: ' || v_order_row.ord_estado_orden);
            v_precio_total := v_order_row.ord_precio_total; -- Guardar el precio total
            v_primera_fila := FALSE;
        END IF;
        
        -- Imprimir los productos del pedido
        DBMS_OUTPUT.PUT_LINE('Nombre del producto: ' || v_order_row.pro_nombre_producto);
        DBMS_OUTPUT.PUT_LINE('Precio del producto: ' || v_order_row.ori_precio);
        DBMS_OUTPUT.PUT_LINE('Cantidad: ' || v_order_row.ori_cantidad);
    END LOOP;
    CLOSE order_cursor;
    
    -- Imprimir el precio total al final del pedido
    IF NOT v_primera_fila THEN
        DBMS_OUTPUT.PUT_LINE('------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Precio total: ' || v_precio_total);
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos para la Orden ID: ' || p_id_orden);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END ResumenOrden;
/

-- Llamada al procedimiento

BEGIN
    ResumenOrden(1);
END;
/

-- Procedimiento para actualizar el inventario

CREATE OR REPLACE PROCEDURE ActualizarInventarioProductos(
    p_incremento IN NUMBER
) IS
    v_count NUMBER;
BEGIN
    -- Contar el número de productos con inventario bajo
    SELECT COUNT(*)
    INTO v_count
    FROM Producto
    WHERE pro_inventario <= 30; -- Valor para considerar inventario bajo

    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron productos con inventario bajo.');
    ELSE
        DECLARE
            CURSOR cursor_inventario_bajo IS
                SELECT pro_id_producto, pro_nombre_producto, pro_inventario
                FROM Producto
                WHERE pro_inventario <= 30; -- Valor para considerar inventario bajo

            v_inventario_bajo_row cursor_inventario_bajo%ROWTYPE;
        BEGIN
            OPEN cursor_inventario_bajo;
            LOOP
                FETCH cursor_inventario_bajo INTO v_inventario_bajo_row;
                EXIT WHEN cursor_inventario_bajo%NOTFOUND;

                -- Actualizar el inventario del producto
                UPDATE Producto
                SET pro_inventario = v_inventario_bajo_row.pro_inventario + p_incremento
                WHERE pro_id_producto = v_inventario_bajo_row.pro_id_producto;

                DBMS_OUTPUT.PUT_LINE('Inventario actualizado para el producto: ' || v_inventario_bajo_row.pro_nombre_producto || ' con ID: ' || v_inventario_bajo_row.pro_id_producto);
            END LOOP;
            CLOSE cursor_inventario_bajo;
            COMMIT;
        END;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron productos con inventario bajo.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END ActualizarInventarioProductos;
/

-- Llamada al procedimiento

BEGIN
    ActualizarInventarioProductos(50);
END;
/

-- Procedimiento para actualizar el precio de los productos

CREATE OR REPLACE PROCEDURE ActualizarPrecioProductos(
    p_porcentaje IN NUMBER
) IS
    CURSOR cursor_producto IS
        SELECT pro_id_producto, pro_precio
        FROM Producto;

    v_producto_row cursor_producto%ROWTYPE;
BEGIN
    OPEN cursor_producto;
    LOOP
        FETCH cursor_producto INTO v_producto_row;
        EXIT WHEN cursor_producto%NOTFOUND;
        
        -- Actualizar el precio del producto y redondear a dos decimales
        UPDATE Producto
        SET pro_precio = ROUND(pro_precio * (1 + p_porcentaje / 100), 2)
        WHERE pro_id_producto = v_producto_row.pro_id_producto;

        DBMS_OUTPUT.PUT_LINE('Precio actualizado para el Producto ID: ' || v_producto_row.pro_id_producto);
    END LOOP;
    CLOSE cursor_producto;
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron productos.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END ActualizarPrecioProductos;
/

BEGIN
    ActualizarPrecioProductos(3);
END;
/

-- Vistas


-- Vista de Producto

CREATE OR REPLACE VIEW VistaProducto AS
SELECT
    p.pro_nombre_producto AS "Producto",
    p.pro_inventario AS "Stock",
    p.pro_precio AS "Precio",
    c.cat_nombre_categoria AS "Categoria"
FROM Producto p
JOIN Categoria c ON p.pro_id_categoria = c.cat_id_categoria;

-- Llamada a la vista

SELECT *FROM VistaProducto;

-- Vista de Reseñas de Usuario

CREATE OR REPLACE VIEW VistaResenhasUsuario AS
SELECT 
    u.usu_nombre_usuario || ' ' || u.usu_apellido_usuario AS "Usuario",
    pr.pro_nombre_producto AS "Producto",
    r.res_calificacion AS "Calificacion",
    r.res_descripcion AS "Descripcion"
FROM 
    resenhas r
JOIN 
    UsuarioComprador u ON r.res_id_usuario = u.usu_id_usuario
JOIN 
    Producto pr ON r.res_id_producto = pr.pro_id_producto;

-- Consulta de la vista

SELECT * FROM VistaResenhasUsuario;


-- Vista de Carrito del Cliente

CREATE OR REPLACE VIEW VistaCarritoCliente AS
SELECT 
    u.usu_nombre_usuario || ' ' || u.usu_apellido_usuario AS "Usuario",
    p.pro_nombre_producto AS "Producto",
    cp.cap_cantidad AS "Cantidad",
    p.pro_precio AS "Precio",
    (cp.cap_cantidad * p.pro_precio) AS "Total"
FROM 
    CarritoProducto cp
JOIN 
    Carrito c ON cp.cap_id_carrito = c.car_id_carrito
JOIN 
    UsuarioComprador u ON c.car_id_usuario = u.usu_id_usuario
JOIN 
    Producto p ON cp.cap_id_producto = p.pro_id_producto;

-- Consulta de la vista

SELECT * FROM VistaCarritoCliente;


-- Vista de Órdenes por Cliente

CREATE OR REPLACE VIEW VistaOrdenesCliente AS
SELECT 
    u.usu_nombre_usuario || ' ' || u.usu_apellido_usuario AS "Usuario",
    o.ord_id_orden AS "ID Orden",
    o.ord_estado_orden AS "Estado Orden",
    o.ord_precio_total AS "Total"
FROM 
    Orden o
JOIN 
    UsuarioComprador u ON o.ord_id_usuario = u.usu_id_usuario;

-- Consulta de la vista

SELECT * FROM VistaOrdenesCliente;


-- Vista de Pagos por Cliente

CREATE OR REPLACE VIEW VistaPagosCliente AS
SELECT 
    u.usu_nombre_usuario || ' ' || u.usu_apellido_usuario AS "Usuario",
    p.pag_modo_pago AS "Modo Pago",
    p.pag_fecha_pago AS "Fecha Pago",
    p.pag_monto_pagado AS "Monto",
    p.pag_estado_pago AS "Estado"
FROM 
    Pago p
JOIN 
    UsuarioComprador u ON p.pag_id_usuario = u.usu_id_usuario;

-- Consulta de la vista

SELECT * FROM VistaPagosCliente;
