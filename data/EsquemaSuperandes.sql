--- Sentencias SQL para la creacion del esquema de superandesç

create sequence superandes_sequence;
CREATE TABLE SUCURSAL(
    ID NUMBER,
    CIUDAD VARCHAR2 (20)        NOT NULL,
    DIRECCION VARCHAR2 (40)     NOT NULL,
    NOMBRE VARCHAR2 (30)        NOT NULL,
    CONSTRAINT SUCURSAL_PK PRIMARY KEY (ID)
);

CREATE TABLE CATEGORIA(
    ID NUMBER,
    NOMBRE  VARCHAR2(20)        NOT NULL,
    CONSTRAINT CATEGORIA_PK PRIMARY KEY(ID)
);

CREATE TABLE CATEGORIASUCURSAL(
    IDCATEGORIA NUMBER,
    IDSUCURSAL NUMBER,
    CONSTRAINT CATEGORIASUCURSAL_PK PRIMARY KEY (IDCATEGORIA,IDSUCURSAL)
);

ALTER TABLE CATEGORIASUCURSAL
    ADD CONSTRAINT FK_CATEGORIA_CS
    FOREIGN KEY (IDCATEGORIA)
    REFERENCES CATEGORIA(ID)
ENABLE;

ALTER TABLE CATEGORIASUCURSAL
    ADD CONSTRAINT FK_SUCURSAL_CS
    FOREIGN KEY (IDSUCURSAL)
    REFERENCES SUCURSAL(ID)
ENABLE;


CREATE TABLE TIPOPRODUCTO(
    ID NUMBER,
    NOMBRE VARCHAR2(20)          NOT NULL,
    IDCATEGORIA NUMBER          NOT NULL,
    CONSTRAINT TIPOPRODUCTO_PK PRIMARY KEY(ID)
);

ALTER TABLE TIPOPRODUCTO
    ADD CONSTRAINT FK_CATEGORIA
    FOREIGN KEY (IDCATEGORIA)
    REFERENCES CATEGORIA (ID)
ENABLE;

CREATE TABLE PRODUCTO(
    ID NUMBER,
    NOMBRE VARCHAR2(20)          NOT NULL,
    MARCA VARCHAR2(20)           NOT NULL,
    IDTIPOPRODUCTO NUMBER       NOT NULL,
    PRESENTACION VARCHAR2(100)   NOT NULL,
    CANTPRESENTACION NUMBER    NOT NULL,
    UNIMEDIDA VARCHAR2(5)        NOT NULL,
    VOLEMPAQUE NUMBER           NOT NULL,
    PESOEMPAQUE NUMBER          NOT NULL,
    CODBARRAS VARCHAR2(15)       NOT NULL,
    CONSTRAINT PRODUCTO_PK PRIMARY KEY(ID)
);


ALTER TABLE PRODUCTO
    ADD CONSTRAINT FK_TIPOPRODUCTO
    FOREIGN KEY (IDTIPOPRODUCTO)
    REFERENCES TIPOPRODUCTO(ID)
ENABLE;

ALTER TABLE PRODUCTO
    ADD CONSTRAINT CK_CANTPRESENTACION
    CHECK (CANTPRESENTACION > 0)
ENABLE;

ALTER TABLE PRODUCTO
    ADD CONSTRAINT CK_UNIMEDIDA
    CHECK (UNIMEDIDA IN ('gr', 'ml'))
ENABLE;

ALTER TABLE PRODUCTO
    ADD CONSTRAINT CK_VOLEMPAQUE
    CHECK (VOLEMPAQUE > 0)
ENABLE;

ALTER TABLE PRODUCTO
    ADD CONSTRAINT CK_PESOEMPAQUE
    CHECK (PESOEMPAQUE > 0)
ENABLE;

CREATE TABLE VENDE(
    IDSUCURSAL NUMBER,
    IDPRODUCTO NUMBER,
    PRECIO     NUMBER,
    PRECIOUNIMEDIDA NUMBER,
    NIVREORDEN NUMBER (4,0),
    CANTRECOMPRA NUMBER(4,0),
    CONSTRAINT VENDE_PK PRIMARY KEY(IDSUCURSAL,IDPRODUCTO,PRECIO,PRECIOUNIMEDIDA,NIVREORDEN,CANTRECOMPRA)
);

ALTER TABLE VENDE
    ADD CONSTRAINT FK_IDSUCURSAL
    FOREIGN KEY (IDSUCURSAL)
    REFERENCES SUCURSAL(ID)
ENABLE;

ALTER TABLE VENDE
    ADD CONSTRAINT FK_IDPRODUCTO
    FOREIGN KEY (IDPRODUCTO)
    REFERENCES PRODUCTO(ID)
ENABLE;

ALTER TABLE VENDE
    ADD CONSTRAINT CK_PRECIO
    CHECK (PRECIO > 0)
ENABLE;

ALTER TABLE VENDE
    ADD CONSTRAINT CK_PRECIOUNIMEDIDA
    CHECK (PRECIOUNIMEDIDA > 0)
ENABLE;

ALTER TABLE VENDE
    ADD CONSTRAINT CK_NIVREORDEN
    CHECK (NIVREORDEN > 0)
ENABLE;

ALTER TABLE VENDE
    ADD CONSTRAINT CK_CANTRECOMPRA
    CHECK (CANTRECOMPRA > 0)
ENABLE;

CREATE TABLE ESTANTE(
    ID NUMBER,
    IDSUCURSAL NUMBER       NOT NULL,
    IDTIPOPRODUCTO NUMBER   NOT NULL,
    VOLUMEN NUMBER          NOT NULL,
    PESO NUMBER             NOT NULL,
    NIVABASTECIMIENTO NUMBER       NOT NULL,
    CONSTRAINT ESTANTE_PK PRIMARY KEY (ID)
);

ALTER TABLE ESTANTE
    ADD CONSTRAINT FK_IDSUCURSAL_ESTANTE
    FOREIGN KEY (IDSUCURSAL)
    REFERENCES SUCURSAL (ID)
ENABLE;

ALTER TABLE ESTANTE
    ADD CONSTRAINT FK_TIPOPRODUCTO_ESTANTE
    FOREIGN KEY (IDTIPOPRODUCTO)
    REFERENCES TIPOPRODUCTO (ID)
ENABLE;

ALTER TABLE ESTANTE
    ADD CONSTRAINT CK_VOLUMEN
    CHECK (VOLUMEN > 0)
ENABLE;

ALTER TABLE ESTANTE
    ADD CONSTRAINT CK_PESO
    CHECK (PESO > 0)
ENABLE;

ALTER TABLE ESTANTE
    ADD CONSTRAINT CK_NIVABASTECIMIENTO
    CHECK (NIVABASTECIMIENTO > 0)
ENABLE;

CREATE TABLE BODEGA(
    ID NUMBER,
    IDSUCURSAL NUMBER       NOT NULL,
    IDTIPOPRODUCTO NUMBER   NOT NULL,
    VOLUMEN NUMBER          NOT NULL,
    PESO NUMBER             NOT NULL,
    CONSTRAINT BODEGA_PK PRIMARY KEY(ID)
);

ALTER TABLE BODEGA
    ADD CONSTRAINT FK_SUCURSAL_BODEGA
    FOREIGN KEY (IDSUCURSAL)
    REFERENCES SUCURSAL(ID)
ENABLE;

ALTER TABLE BODEGA
    ADD CONSTRAINT FK_TIPOPRODUCTO_BODEGA
    FOREIGN KEY (IDTIPOPRODUCTO)
    REFERENCES TIPOPRODUCTO(ID)
ENABLE;

ALTER TABLE BODEGA
    ADD CONSTRAINT CK_VOLUMEN_BODEGA
    CHECK (VOLUMEN >0)
ENABLE;

ALTER TABLE BODEGA
    ADD CONSTRAINT CK_PESO_BODEGA
    CHECK (PESO >0)
ENABLE;

CREATE TABLE PROVEEDOR(
    ID NUMBER,
    NIT NUMBER          NOT NULL,
    NOMBRE VARCHAR2(40)  NOT NULL,
    CONSTRAINT PK_PROVEEDOR PRIMARY KEY(ID)
);

ALTER TABLE PROVEEDOR
    ADD CONSTRAINT UNI_NIT
    UNIQUE (NIT)
ENABLE;

CREATE TABLE ORDEN(
    ID NUMBER,
    IDPROVEEDOR NUMBER     NOT NULL,
    IDSUCURSAL NUMBER      NOT NULL,
    IDPRODUCTO NUMBER       NOT NULL,
    CANTIDAD NUMBER         NOT NULL,
    PRECIO NUMBER           NOT NULL,
    ESTADO VARCHAR2(12)     NOT NULL,
    FECHAESPERADAENTREGA DATE   NOT NULL,
    FECHAENTREGA DATE,
    CALIFICACION VARCHAR2(9),
    CONSTRAINT ORDEN_PK PRIMARY KEY(ID)
);

ALTER TABLE ORDEN
    ADD CONSTRAINT FK_PROVEEDOR
    FOREIGN KEY (IDPROVEEDOR)
    REFERENCES PROVEEDOR(ID)
ENABLE;

ALTER TABLE ORDEN
    ADD CONSTRAINT FK_SUCURSAL_ORDEN
    FOREIGN KEY (IDSUCURSAL)
    REFERENCES SUCURSAL(ID)
ENABLE;

ALTER TABLE ORDEN
    ADD CONSTRAINT FK_PRODUCTO_ORDEN
    FOREIGN KEY (IDPRODUCTO)
    REFERENCES PRODUCTO(ID)
ENABLE;

ALTER TABLE ORDEN
    ADD CONSTRAINT CK_ESTADO
    CHECK (ESTADO IN ('ENTREGADO', 'NO ENTREGADO'))
ENABLE;

ALTER TABLE ORDEN
    ADD CONSTRAINT CK_CALIFICACION
    CHECK (CALIFICACION IN ('EXCELENTE', 'BUENO', 'ACEPTABLE', 'MALO'))
ENABLE;

ALTER TABLE ORDEN
    ADD CONSTRAINT CK_CANTIDAD_ORDEN
    CHECK (CANTIDAD IN (CANTIDAD > 0))
ENABLE;

ALTER TABLE ORDEN
    ADD CONSTRAINT CK_PRECIO_ORDEN
    CHECK (PRECIO IN (PRECIO>0))
ENABLE;


CREATE TABLE CLIENTE(
    ID NUMBER,
    TIPO VARCHAR2(7)     NOT NULL,
    NOMBRE VARCHAR2(50)  NOT NULL,
    CORREO VARCHAR2(50)  NOT NULL,
    DIRECCION VARCHAR2(100),
    PUNTOS NUMBER,
    CONSTRAINT CLIENTE_PK PRIMARY KEY (ID)
);

ALTER TABLE CLIENTE
    ADD CONSTRAINT CK_TIPO
    CHECK (TIPO IN ('NATURAL','EMPRESA'))
ENABLE;


CREATE TABLE FACTURA(
    ID NUMBER,
    IDCLIENTE NUMBER    NOT NULL,
    IDSUCURSAL NUMBER   NOT NULL,
    FECHA DATE          NOT NULL,
    TOTAL NUMBER,
    CONSTRAINT FACTURA_PK PRIMARY KEY(ID)
);

ALTER TABLE FACTURA
    ADD CONSTRAINT FK_CLIENTE
    FOREIGN KEY (IDCLIENTE)
    REFERENCES CLIENTE(ID)
ENABLE;

ALTER TABLE FACTURA
    ADD CONSTRAINT FK_SUCURSAL_FACTURA
    FOREIGN KEY (IDSUCURSAL)
    REFERENCES SUCURSAL(ID)
ENABLE;

ALTER TABLE FACTURA
    ADD CONSTRAINT CK_TOTAL
    CHECK (TOTAL > 0)
ENABLE;

CREATE TABLE FACTURAPRODUCTO(
    IDFACTURA NUMBER,
    IDPRODUCTO NUMBER,
    UNIVENDIDAS NUMBER,
    CONSTRAINT FACTURAPRODUCTO_PK PRIMARY KEY(IDFACTURA,IDPRODUCTO,UNIVENDIDAS)
);

ALTER TABLE FACTURAPRODUCTO
    ADD CONSTRAINT FK_FACTURA
    FOREIGN KEY (IDFACTURA)
    REFERENCES FACTURA(ID)
ENABLE;

ALTER TABLE FACTURAPRODUCTO
    ADD CONSTRAINT FK_PRODUCTO_FACT
    FOREIGN KEY (IDPRODUCTO)
    REFERENCES PRODUCTO(ID)
ENABLE;

ALTER TABLE FACTURAPRODUCTO
    ADD CONSTRAINT CK_UNIVENDIDAS
    CHECK (UNIVENDIDAS > 0)
ENABLE;

CREATE TABLE PRODUCTOESTANTE(
    IDPRODUCTO NUMBER,
    IDESTANTE NUMBER,
    CANTIDAD NUMBER,
    CONSTRAINT PRODUCTOESTANTE_PK PRIMARY KEY(IDPRODUCTO,IDESTANTE,CANTIDAD)
);

ALTER TABLE PRODUCTOESTANTE
    ADD CONSTRAINT FK_PRODUCTO_EST
    FOREIGN KEY (IDPRODUCTO)
    REFERENCES PRODUCTO(ID)
ENABLE;

ALTER TABLE PRODUCTOESTANTE
    ADD CONSTRAINT FK_ESTANTE
    FOREIGN KEY (IDESTANTE)
    REFERENCES ESTANTE(ID)
ENABLE;

ALTER TABLE PRODUCTOESTANTE
    ADD CONSTRAINT CK_CANTIDAD_PE
    CHECK (CANTIDAD >= 0)
ENABLE;

CREATE TABLE PRODUCTOBODEGA(
    IDPRODUCTO NUMBER,
    IDBODEGA NUMBER,
    CANTIDAD NUMBER,
    CONSTRAINT PRODUCTOBODEGA_PK PRIMARY KEY(IDPRODUCTO,IDBODEGA,CANTIDAD)
);

ALTER TABLE PRODUCTOBODEGA
    ADD CONSTRAINT FK_PRODUCTO_BOD
    FOREIGN KEY (IDPRODUCTO)
    REFERENCES PRODUCTO(ID)
ENABLE;

ALTER TABLE PRODUCTOBODEGA
    ADD CONSTRAINT FK_BODEGA_PB
    FOREIGN KEY (IDBODEGA)
    REFERENCES BODEGA(ID)
ENABLE;

ALTER TABLE PRODUCTOBODEGA
    ADD CONSTRAINT CK_CANTIDAD_PB
    CHECK (CANTIDAD > 0)
ENABLE;

CREATE TABLE PROVEE(
    IDPROVEEDOR NUMBER,
    IDPRODUCTO NUMBER,
    CONSTRAINT PROVEE_PK PRIMARY KEY (IDPROVEEDOR,IDPRODUCTO)
);

ALTER TABLE PROVEE
    ADD CONSTRAINT FK_PROVEEDOR_PROVEE
    FOREIGN KEY(IDPROVEEDOR)
    REFERENCES PROVEEDOR(ID)
ENABLE;

ALTER TABLE PROVEE
    ADD CONSTRAINT FK_PRODUCTO_PROVEE
    FOREIGN KEY(IDPRODUCTO)
    REFERENCES PRODUCTO(ID)
ENABLE;

CREATE TABLE PROMOCION(
    ID      NUMBER,
    IDPRODUCTO NUMBER NOT NULL,
    FECHAINICIO DATE    NOT NULL,
    FECHAFIN    DATE    NOT NULL,
    CANTIDADPRODUCTOS NUMBER NOT NULL,
    DISPONIBLE NUMBER (1)     NOT NULL,
    IDPROVEEDOR NUMBER      NOT NULL,
    CANTIDADPRODUCTOSVENDIDOS NUMBER,
    CONSTRAINT PROMOCION_PK PRIMARY KEY (ID)
);

ALTER TABLE PROMOCION
    ADD CONSTRAINT FK_IDPRODUCTO_PROMOCION
    FOREIGN KEY (IDPRODUCTO)
    REFERENCES PRODUCTO(ID)
ENABLE;

ALTER TABLE PROMOCION
    ADD CONSTRAINT CK_CANTIDADPRODUCTOS
    CHECK (CANTIDADPRODUCTOS >= 0)
ENABLE;

ALTER TABLE PROMOCION
    ADD CONSTRAINT CK_DISPONIBLE
    CHECK(DISPONIBLE = 0 OR DISPONIBLE = 1)
ENABLE;

ALTER TABLE PROMOCION
    ADD CONSTRAINT FK_PROVEEDOR_PROMOCION
    FOREIGN KEY (IDPROVEEDOR)
    REFERENCES PROVEEDOR(ID)
ENABLE;

CREATE TABLE PROMOCIONSUCURSAL(
    IDPROMOCION NUMBER,
    IDSUCURSAL NUMBER,
    CONSTRAINT PROMOCIONSUCURSAL_PK PRIMARY KEY(IDPROMOCION,IDSUCURSAL)
);

ALTER TABLE PROMOCIONSUCURSAL
    ADD CONSTRAINT FK_IDPROMOCION_PS
    FOREIGN KEY (IDPROMOCION)
    REFERENCES PROMOCION(ID)
ENABLE;

ALTER TABLE PROMOCIONSUCURSAL
    ADD CONSTRAINT FK_IDSUCURSAL_PS
    FOREIGN KEY (IDSUCURSAL)
    REFERENCES SUCURSAL(ID)
ENABLE;

CREATE TABLE CARRITOCOMPRAS
(
  ID NUMBER,
  ESTADO VARCHAR(15),
  IDCLIENTE NUMBER,
  IDSUCURSAL NUMBER,
  CONSTRAINT CARRITOCOMPRAS_PK PRIMARY KEY (ID)
);

ALTER TABLE CARRITOCOMPRAS
    ADD CONSTRAINT FK_IDCLIENTE_CC
    FOREIGN KEY (IDCLIENTE)
    REFERENCES CLIENTE(ID)
ENABLE;

ALTER TABLE CARRITOCOMPRAS
    ADD CONSTRAINT CK_ESTADO_CC
    CHECK (ESTADO IN ('DISPONIBLE', 'NO DISPONIBLE'))
    ENABLE;

ALTER TABLE CARRITOCOMPRAS
    ADD CONSTRAINT FK_IDSUCURSAL_CC
    FOREIGN KEY (IDSUCURSAL)
    REFERENCES SUCURSAL(ID)
ENABLE;

CREATE TABLE VENDECARRITO (
  IDCARRITO NUMBER,
  IDPRODUCTO NUMBER,
  CANTIDADCARRITO NUMBER,
  CONSTRAINT VENDECARRITO_PK PRIMARY KEY (IDCARRITO, IDPRODUCTO, IDSUCURSAL)
);

ALTER TABLE VENDECARRITO
  ADD CONSTRAINT FK_IDCARRITO_VC
  FOREIGN KEY (IDCARRITO)
  REFERENCES CARRITOCOMPRAS(ID)
ENABLE;

ALTER TABLE VENDECARRITO
  ADD CONSTRAINT FK_IDPRODUCTO_VC
  FOREIGN KEY (IDPRODUCTO)
  REFERENCES PRODUCTO(ID)
ENABLE;
