USE [GD1C2024]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Creacion de schema si no existe

IF NOT EXISTS ( SELECT *
FROM sys.schemas
WHERE name = 'LOS_REZAGADOS')
BEGIN
  EXECUTE('CREATE SCHEMA LOS_REZAGADOS')
END
GO

-- Borrado de FK Constraints

DECLARE @DropConstraints NVARCHAR(max) = ''
SELECT @DropConstraints += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.'
                        +  QUOTENAME(OBJECT_NAME(parent_object_id)) + ' ' + 'DROP CONSTRAINT' + QUOTENAME(name)
FROM sys.foreign_keys
EXECUTE sp_executesql @DropConstraints;
GO

-- Borrado de funciones auxiliar si existe

DROP FUNCTION IF EXISTS [LOS_REZAGADOS].fn_GetTipoComprobanteId;

-- Borrado de tablas si existen en caso que el schema exista

IF OBJECT_ID('LOS_REZAGADOS.Supermercados','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Supermercados;
IF OBJECT_ID('LOS_REZAGADOS.Sucursales','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Sucursales;
IF OBJECT_ID('LOS_REZAGADOS.Cajas','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Cajas;
IF OBJECT_ID('LOS_REZAGADOS.Empleados','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Empleados;
IF OBJECT_ID('LOS_REZAGADOS.Clientes','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Clientes;
IF OBJECT_ID('LOS_REZAGADOS.Localidades','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Localidades;
IF OBJECT_ID('LOS_REZAGADOS.Provincias','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Provincias;
IF OBJECT_ID('LOS_REZAGADOS.Tipos_comprobantes','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Tipos_comprobantes;
IF OBJECT_ID('LOS_REZAGADOS.Tickets_Venta','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Tickets_Venta;
IF OBJECT_ID('LOS_REZAGADOS.Estados_envios','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Estados_envios;
IF OBJECT_ID('LOS_REZAGADOS.Envios','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Envios;
IF OBJECT_ID('LOS_REZAGADOS.Pagos_Ventas','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Pagos_Ventas;
IF OBJECT_ID('LOS_REZAGADOS.Detalles_pagos','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Detalles_pagos;
IF OBJECT_ID('LOS_REZAGADOS.Medios_de_pago','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Medios_de_pago;
IF OBJECT_ID('LOS_REZAGADOS.Tipos_medio_pago','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Tipos_medio_pago;
IF OBJECT_ID('LOS_REZAGADOS.Descuentos','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Descuentos;
IF OBJECT_ID('LOS_REZAGADOS.Subcategorias_x_producto','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Subcategorias_x_producto;
IF OBJECT_ID('LOS_REZAGADOS.Subcategorias','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Subcategorias;
IF OBJECT_ID('LOS_REZAGADOS.Categorias','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Categorias;
IF OBJECT_ID('LOS_REZAGADOS.Marcas','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Marcas;
IF OBJECT_ID('LOS_REZAGADOS.Ticket_venta_x_producto','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Ticket_venta_x_producto;
IF OBJECT_ID('LOS_REZAGADOS.Productos','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Productos;
IF OBJECT_ID('LOS_REZAGADOS.Reglas','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Reglas;
IF OBJECT_ID('LOS_REZAGADOS.Promociones_x_venta','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Promociones_x_venta;
IF OBJECT_ID('LOS_REZAGADOS.Promociones','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Promociones;
IF OBJECT_ID('LOS_REZAGADOS.Promociones_x_producto','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Promociones_x_producto;
IF OBJECT_ID('LOS_REZAGADOS.Promociones_x_regla','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Promociones_x_regla;

-- Creacion de tablas
BEGIN TRANSACTION

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Supermercados')
CREATE TABLE [LOS_REZAGADOS].[Supermercados]
(
  supermercado_id INT IDENTITY(1,1) PRIMARY KEY,
  supermercado_nombre NVARCHAR(255),
  supermercado_cuit NVARCHAR(255),
  supermercado_razon_social NVARCHAR(255),
  supermercado_iibb NVARCHAR(255),
  supermercado_domicilio NVARCHAR(255),
  supermercado_fecha_inicio_act DATETIME,
  supermercado_condicion_fiscal NVARCHAR(255),
  supermercado_localidad DECIMAL(18, 0), -- FK
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Sucursales')
CREATE TABLE [LOS_REZAGADOS].[Sucursales]
(
  sucursal_id DECIMAL (18, 0) IDENTITY(1,1) PRIMARY KEY,
  supermercado INT, -- FK
  sucursal_nombre NVARCHAR(255),
  sucursal_localidad DECIMAL(18, 0), -- FK
  sucursal_direccion NVARCHAR(255),
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Cajas')
CREATE TABLE [LOS_REZAGADOS].[Cajas]
(
  caja_id DECIMAL (18, 0) IDENTITY(1,1) PRIMARY KEY,
  caja_numero DECIMAL(18, 0),
  caja_tipo NVARCHAR(255),
  sucursal DECIMAL(18, 0), -- FK
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Empleados')
CREATE TABLE [LOS_REZAGADOS].[Empleados]
(
  empleado_id DECIMAL (18, 0) IDENTITY(1,1) PRIMARY KEY,
  empleado_nombre NVARCHAR(255),
  empleado_apellido NVARCHAR(255),
  empleado_dni DECIMAL(18, 0),
  empleado_fecha_registro DATETIME,
  empleado_telefono DECIMAL(18, 0),
  empleado_mail NVARCHAR(255),
  empleado_fecha_nacimiento DATETIME,
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Clientes')
CREATE TABLE [LOS_REZAGADOS].[Clientes]
(
  cliente_id DECIMAL (18, 0) IDENTITY(1,1) PRIMARY KEY,
  cliente_nombre NVARCHAR(255),
  cliente_apellido NVARCHAR(255),
  cliente_dni DECIMAL(18, 0),
  cliente_fecha_registro DATETIME,
  cliente_telefono DECIMAL(18, 0),
  cliente_mail NVARCHAR(255),
  cliente_fecha_nacimiento DATETIME,
  cliente_domicilio NVARCHAR(255),
  cliente_localidad DECIMAL(18, 0), -- FK
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Localidades')
CREATE TABLE [LOS_REZAGADOS].[Localidades]
(
  localidad_id DECIMAL (18, 0) IDENTITY(1,1) PRIMARY KEY,
  localidad_descripcion NVARCHAR(255),
  provincia DECIMAL(18, 0), -- FK
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Provincias')
CREATE TABLE [LOS_REZAGADOS].[Provincias]
(
  provincia_id DECIMAL (18, 0) IDENTITY(1,1) PRIMARY KEY,
  provincia_descripcion NVARCHAR(255),
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Tipos_comprobantes')
CREATE TABLE [LOS_REZAGADOS].[Tipos_comprobantes]
(
  tipo_comprobante_id DECIMAL (18, 0) IDENTITY(1,1) PRIMARY KEY,
  tipos_comprobantes_descripcion NVARCHAR(255),
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Tickets_Venta')
CREATE TABLE [LOS_REZAGADOS].[Tickets_Venta]
(
  ticket_id DECIMAL (18, 0) IDENTITY(1,1) PRIMARY KEY,
  ticket_numero DECIMAL (18, 0),
  ticket_fecha_hora DATETIME,
  caja DECIMAL(18, 0), -- FK
  empleado DECIMAL(18, 0), -- FK
  tipo_comprobante DECIMAL(18, 0), --FK
  ticket_sub_total_productos DECIMAL(18, 2),
  ticket_total_descuento DECIMAL(18, 2),
  ticket_total_descuento_aplicado DECIMAL(18, 2),
  ticket_total_ticket DECIMAL(18, 2),
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Estados_envios')
CREATE TABLE [LOS_REZAGADOS].[Estados_envios]
(
  estado_id DECIMAL (18, 0) IDENTITY(1,1) PRIMARY KEY,
  estado_descripcion NVARCHAR(255),
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Envios')
CREATE TABLE [LOS_REZAGADOS].[Envios]
(
  envio_id DECIMAL (18, 0) IDENTITY(1,1) PRIMARY KEY,
  ticket_id DECIMAL (18, 0), -- FK
  estado DECIMAL (18, 0), -- FK
  cliente DECIMAL (18, 0), -- FK
  envio_fecha_programada DATETIME,
  envio_hora_inicio DECIMAL (18, 0),
  envio_hora_fin DECIMAL (18, 0),
  envio_costo DECIMAL (18, 2),
  envio_fecha_entrega DATETIME,
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Pagos_Ventas')
CREATE TABLE [LOS_REZAGADOS].[Pagos_Ventas]
(
  nro_pago DECIMAL (18, 0) IDENTITY(1,1) PRIMARY KEY,
  pago_fecha_hora DATETIME,
  ticket_id DECIMAL (18, 0), -- FK
  detalle DECIMAL (18, 0), -- FK
  medio_de_pago DECIMAL (18, 0), -- FK
  cod_descuento DECIMAL (18, 0), -- FK
  pago_importe DECIMAL (18, 0),
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Detalles_pagos')
CREATE TABLE [LOS_REZAGADOS].[Detalles_pagos]
(
  detalle_id DECIMAL (18, 0) IDENTITY(1,1) PRIMARY KEY,
  cliente DECIMAL (18, 0), -- FK
  detalle_nro_tarjeta NVARCHAR (50),
  detalle_vencimiento DATETIME,
  detalle_cuotas DECIMAL (18, 0),
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Medios_de_pago')
CREATE TABLE [LOS_REZAGADOS].[Medios_de_pago]
(
  medio_de_pago_id DECIMAL(18, 0) IDENTITY(1,1) PRIMARY KEY,
  descripcion NVARCHAR(255),
  tipo_id DECIMAL(18, 0), -- FK
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Tipos_medio_pago')
CREATE TABLE [LOS_REZAGADOS].[Tipos_medio_pago]
(
  tipo_id DECIMAL(18, 0) IDENTITY(1,1) PRIMARY KEY,
  tipo_descripcion NVARCHAR(255),
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Descuentos')
CREATE TABLE [LOS_REZAGADOS].[Descuentos]
(
  descuento_id DECIMAL(18, 0) IDENTITY(1,1) PRIMARY KEY,
  descuento_codigo DECIMAL (18, 0),
  descuento_descripcion NVARCHAR(255),
  descuento_fecha_inicio DATETIME,
  descuento_fecha_fin DATETIME,
  descuento_porcentaje DECIMAL (18, 2),
  descuento_tope DECIMAL (18, 2),
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Subcategorias_x_producto')
CREATE TABLE [LOS_REZAGADOS].[Subcategorias_x_producto]
(
  subcategoria_id DECIMAL(18, 0), -- FK
  producto_id DECIMAL (18, 0), -- FK
  PRIMARY KEY (subcategoria_id, producto_id)
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Subcategorias')
CREATE TABLE [LOS_REZAGADOS].[Subcategorias]
(
  subcategoria_id DECIMAL(18, 0) IDENTITY(1,1) PRIMARY KEY,
  subcategoria_descripcion NVARCHAR(255),
  categoria DECIMAL (18, 0), -- FK
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Categorias')
CREATE TABLE [LOS_REZAGADOS].[Categorias]
(
  categoria_id DECIMAL(18, 0) IDENTITY(1,1) PRIMARY KEY,
  categoria_descripcion NVARCHAR(255),
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Marcas')
CREATE TABLE [LOS_REZAGADOS].[Marcas]
(
  marca_id DECIMAL(18, 0) IDENTITY(1,1) PRIMARY KEY,
  marca_descripcion NVARCHAR(255),
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Productos')
CREATE TABLE [LOS_REZAGADOS].[Productos]
(
  producto_id DECIMAL(18, 0) IDENTITY(1,1) PRIMARY KEY,
  producto_precio_unitario DECIMAL (18, 2),
  producto_marca DECIMAL (18, 0), -- FK
  producto_descripcion NVARCHAR(255),
  producto_nombre NVARCHAR(255),
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Ticket_venta_x_producto')
CREATE TABLE [LOS_REZAGADOS].[Ticket_venta_x_producto]
(
  ticket_venta_producto DECIMAL(18, 0) IDENTITY(1,1) PRIMARY KEY,
  ticket_id DECIMAL(18, 0), -- FK
  producto DECIMAL(18,0), -- FK
  ticket_det_cantidad DECIMAL (18, 0),
  ticket_det_precio DECIMAL (18, 2),
  ticket_det_total DECIMAL (18, 2),
  promo_aplicada_descuento DECIMAL (18, 2),
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Reglas')
CREATE TABLE [LOS_REZAGADOS].[Reglas]
(
  regla_id DECIMAL(18, 0) IDENTITY(1,1) PRIMARY KEY,
  regla_descripcion NVARCHAR(255),
  regla_descuento_aplicable_prod DECIMAL (18, 2),
  regla_cant_aplica_regla DECIMAL (18, 0),
  regla_cant_aplica_descuento DECIMAL (18, 0),
  regla_cant_max_prod DECIMAL (18, 0),
  regla_aplica_misma_marca DECIMAL (18, 0),
  regla_aplica_mismo_prod DECIMAL (18, 0),
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Promociones')
CREATE TABLE [LOS_REZAGADOS].[Promociones]
(
  cod_promocion DECIMAL(18, 0) IDENTITY(1,1) PRIMARY KEY,
  promocion_descripcion NVARCHAR(255),
  promocion_fecha_inicio DATETIME,
  promocion_fecha_fin DATETIME,
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Promociones_x_venta')
CREATE TABLE [LOS_REZAGADOS].[Promociones_x_venta]
(
  cod_promocion DECIMAL(18, 0),
  ticket_venta_producto DECIMAL (18, 0),
  producto DECIMAL (18,0),
  PRIMARY KEY(cod_promocion, ticket_venta_producto),
  FOREIGN KEY(ticket_venta_producto) REFERENCES [LOS_REZAGADOS].[Ticket_venta_x_producto],
  FOREIGN KEY(cod_promocion) REFERENCES [LOS_REZAGADOS].[Promociones],
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Promociones_x_producto')
CREATE TABLE [LOS_REZAGADOS].[Promociones_x_producto]
(
  cod_promocion DECIMAL(18, 0),
  producto DECIMAL (18, 0),
  PRIMARY KEY (cod_promocion, producto)
)

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Promociones_x_regla')
CREATE TABLE [LOS_REZAGADOS].[Promociones_x_regla]
(
  cod_promocion DECIMAL(18, 0),
  regla DECIMAL (18, 0),
  PRIMARY KEY (cod_promocion, regla)
)

COMMIT
GO

-- ================= Definicion de FKs =============================

BEGIN TRANSACTION

ALTER TABLE [LOS_REZAGADOS].[Supermercados]
ADD FOREIGN KEY (supermercado_localidad) REFERENCES [LOS_REZAGADOS].Localidades(localidad_id);

ALTER TABLE [LOS_REZAGADOS].[Sucursales]
ADD FOREIGN KEY (supermercado) REFERENCES [LOS_REZAGADOS].Supermercados(supermercado_id);

ALTER TABLE [LOS_REZAGADOS].[Sucursales]
ADD FOREIGN KEY (sucursal_localidad) REFERENCES [LOS_REZAGADOS].Localidades(localidad_id);

ALTER TABLE [LOS_REZAGADOS].[Cajas]
ADD FOREIGN KEY (sucursal) REFERENCES [LOS_REZAGADOS].Sucursales(sucursal_id);

ALTER TABLE [LOS_REZAGADOS].[Clientes]
ADD FOREIGN KEY (cliente_localidad) REFERENCES [LOS_REZAGADOS].Localidades(localidad_id);

ALTER TABLE [LOS_REZAGADOS].[Localidades]
ADD FOREIGN KEY (provincia) REFERENCES [LOS_REZAGADOS].Provincias(provincia_id);

ALTER TABLE [LOS_REZAGADOS].[Tickets_Venta]
ADD FOREIGN KEY (caja) REFERENCES [LOS_REZAGADOS].Cajas(caja_id);

ALTER TABLE [LOS_REZAGADOS].[Tickets_Venta]
ADD FOREIGN KEY (empleado) REFERENCES [LOS_REZAGADOS].Empleados(empleado_id);

ALTER TABLE [LOS_REZAGADOS].[Tickets_Venta]
ADD FOREIGN KEY (tipo_comprobante) REFERENCES [LOS_REZAGADOS].Tipos_comprobantes(tipo_comprobante_id);

ALTER TABLE [LOS_REZAGADOS].[Envios]
ADD FOREIGN KEY (ticket_id) REFERENCES [LOS_REZAGADOS].Tickets_Venta(ticket_id);

ALTER TABLE [LOS_REZAGADOS].[Envios]
ADD FOREIGN KEY (estado) REFERENCES [LOS_REZAGADOS].Estados_envios(estado_id);

ALTER TABLE [LOS_REZAGADOS].[Envios]
ADD FOREIGN KEY (cliente) REFERENCES [LOS_REZAGADOS].Clientes(cliente_id);

ALTER TABLE [LOS_REZAGADOS].[Pagos_Ventas]
ADD FOREIGN KEY (ticket_id) REFERENCES [LOS_REZAGADOS].Tickets_Venta(ticket_id);

ALTER TABLE [LOS_REZAGADOS].[Pagos_Ventas]
ADD FOREIGN KEY (detalle) REFERENCES [LOS_REZAGADOS].Detalles_pagos(detalle_id);

ALTER TABLE [LOS_REZAGADOS].[Pagos_Ventas]
ADD FOREIGN KEY (medio_de_pago) REFERENCES [LOS_REZAGADOS].Medios_de_pago(medio_de_pago_id);

ALTER TABLE [LOS_REZAGADOS].[Pagos_Ventas]
ADD FOREIGN KEY (cod_descuento) REFERENCES [LOS_REZAGADOS].Descuentos(descuento_id);

ALTER TABLE [LOS_REZAGADOS].[Detalles_pagos]
ADD FOREIGN KEY (cliente) REFERENCES [LOS_REZAGADOS].Clientes(cliente_id);

ALTER TABLE [LOS_REZAGADOS].[Medios_de_pago]
ADD FOREIGN KEY (tipo_id) REFERENCES [LOS_REZAGADOS].Tipos_medio_pago(tipo_id);

ALTER TABLE [LOS_REZAGADOS].[Subcategorias_x_producto]
ADD FOREIGN KEY (subcategoria_id) REFERENCES [LOS_REZAGADOS].Subcategorias(subcategoria_id);

ALTER TABLE [LOS_REZAGADOS].[Subcategorias_x_producto]
ADD FOREIGN KEY (producto_id) REFERENCES [LOS_REZAGADOS].Productos(producto_id);

ALTER TABLE [LOS_REZAGADOS].[Subcategorias]
ADD FOREIGN KEY (categoria) REFERENCES [LOS_REZAGADOS].Categorias(categoria_id);

ALTER TABLE [LOS_REZAGADOS].[Productos]
ADD FOREIGN KEY (producto_marca) REFERENCES [LOS_REZAGADOS].Marcas(marca_id);

ALTER TABLE [LOS_REZAGADOS].[Promociones_x_producto]
ADD FOREIGN KEY (cod_promocion) REFERENCES [LOS_REZAGADOS].Promociones(cod_promocion);

ALTER TABLE [LOS_REZAGADOS].[Promociones_x_producto]
ADD FOREIGN KEY (producto) REFERENCES [LOS_REZAGADOS].Productos(producto_id);

ALTER TABLE [LOS_REZAGADOS].[Promociones_x_regla]
ADD FOREIGN KEY (cod_promocion) REFERENCES [LOS_REZAGADOS].Promociones(cod_promocion);

ALTER TABLE [LOS_REZAGADOS].[Promociones_x_regla]
ADD FOREIGN KEY (regla) REFERENCES [LOS_REZAGADOS].Reglas(regla_id);

ALTER TABLE [LOS_REZAGADOS].[Ticket_venta_x_producto]
ADD FOREIGN KEY (ticket_id) REFERENCES [LOS_REZAGADOS].Tickets_Venta(ticket_id);

ALTER TABLE [LOS_REZAGADOS].[Ticket_venta_x_producto]
ADD FOREIGN KEY (producto) REFERENCES [LOS_REZAGADOS].Productos(producto_id);

COMMIT
GO

-- ================= Funciones auxiliares ==================

CREATE FUNCTION [LOS_REZAGADOS].fn_GetTipoComprobanteId(@TipoComprobanteDescripcion NVARCHAR(255)) RETURNS DECIMAL (18, 0)
AS BEGIN
  RETURN (SELECT TOP 1
    tipo_comprobante_id
  FROM [LOS_REZAGADOS].Tipos_comprobantes
  WHERE tipos_comprobantes_descripcion = @TipoComprobanteDescripcion)
END
GO

-- ================= Migracion =============================

BEGIN TRANSACTION

INSERT INTO [LOS_REZAGADOS].[Provincias]
  ([provincia_descripcion])
SELECT DISTINCT PROVINCIA
FROM (
  SELECT SUPER_PROVINCIA AS PROVINCIA
    FROM gd_esquema.Maestra
  UNION
    SELECT SUCURSAL_PROVINCIA AS PROVINCIA
    FROM gd_esquema.Maestra
  UNION
    SELECT CLIENTE_PROVINCIA AS PROVINCIA
    FROM gd_esquema.Maestra
) AS PROVINCIAS
WHERE PROVINCIA IS NOT NULL;
GO

INSERT INTO [LOS_REZAGADOS].[Localidades]
  ([localidad_descripcion], [provincia])
SELECT DISTINCT localidad_descripcion, provincia
FROM (
  SELECT DISTINCT
      dato.SUPER_LOCALIDAD AS localidad_descripcion,
      tprovincia.provincia_id AS provincia
  FROM gd_esquema.Maestra dato
  JOIN [LOS_REZAGADOS].Provincias tprovincia ON tprovincia.provincia_descripcion = dato.SUPER_PROVINCIA
  UNION
  SELECT DISTINCT
      dato.SUCURSAL_LOCALIDAD AS localidad_descripcion,
      tprovincia.provincia_id AS provincia
  FROM gd_esquema.Maestra dato
  JOIN [LOS_REZAGADOS].Provincias tprovincia ON tprovincia.provincia_descripcion = dato.SUCURSAL_PROVINCIA
  UNION
    SELECT DISTINCT
      dato.CLIENTE_LOCALIDAD AS localidad_descripcion,
      tprovincia.provincia_id AS provincia
    FROM gd_esquema.Maestra dato
      JOIN [LOS_REZAGADOS].Provincias tprovincia ON tprovincia.provincia_descripcion = dato.CLIENTE_PROVINCIA
) AS LOCALIDADES
WHERE localidad_descripcion IS NOT NULL
GO

INSERT INTO [LOS_REZAGADOS].[Clientes]
  ([cliente_nombre],[cliente_apellido],[cliente_dni],[cliente_fecha_registro],[cliente_telefono],[cliente_mail],[cliente_fecha_nacimiento],[cliente_domicilio],[cliente_localidad])
SELECT DISTINCT
  dato.CLIENTE_NOMBRE,
  dato.CLIENTE_APELLIDO,
  dato.CLIENTE_DNI,
  dato.CLIENTE_FECHA_REGISTRO,
  dato.CLIENTE_TELEFONO,
  dato.CLIENTE_MAIL,
  dato.CLIENTE_FECHA_NACIMIENTO,
  dato.CLIENTE_DOMICILIO,
  l.localidad_id
FROM gd_esquema.Maestra dato
LEFT JOIN [LOS_REZAGADOS].Provincias p
  ON p.provincia_descripcion = dato.CLIENTE_PROVINCIA
LEFT JOIN [LOS_REZAGADOS].Localidades l
  ON l.localidad_descripcion = dato.CLIENTE_LOCALIDAD
  AND l.provincia = p.provincia_id
WHERE dato.CLIENTE_DNI IS NOT NULL;
GO

INSERT INTO [LOS_REZAGADOS].[Empleados]
  ([empleado_nombre],[empleado_apellido],[empleado_dni],[empleado_fecha_registro],[empleado_telefono],[empleado_mail],[empleado_fecha_nacimiento])
SELECT DISTINCT
  dato.EMPLEADO_NOMBRE,
  dato.EMPLEADO_APELLIDO,
  dato.EMPLEADO_DNI,
  dato.EMPLEADO_FECHA_REGISTRO,
  dato.EMPLEADO_TELEFONO,
  dato.EMPLEADO_MAIL,
  dato.EMPLEADO_FECHA_NACIMIENTO
FROM gd_esquema.Maestra dato
WHERE dato.EMPLEADO_DNI IS NOT NULL;
GO

INSERT INTO [LOS_REZAGADOS].[Categorias]
  ([categoria_descripcion])
SELECT DISTINCT
  dato.PRODUCTO_CATEGORIA
FROM gd_esquema.Maestra dato
WHERE dato.PRODUCTO_CATEGORIA IS NOT NULL;
GO

INSERT INTO [LOS_REZAGADOS].[Subcategorias]
  ([subcategoria_descripcion],[categoria])
SELECT DISTINCT
  dato.PRODUCTO_SUB_CATEGORIA,
  c.categoria_id
FROM gd_esquema.Maestra dato
LEFT JOIN [LOS_REZAGADOS].Categorias c
  ON c.categoria_descripcion = dato.PRODUCTO_CATEGORIA
WHERE dato.PRODUCTO_SUB_CATEGORIA IS NOT NULL;
GO

INSERT INTO [LOS_REZAGADOS].[Supermercados]
  ([supermercado_nombre],[supermercado_cuit],[supermercado_razon_social],[supermercado_iibb],[supermercado_domicilio],[supermercado_fecha_inicio_act],[supermercado_condicion_fiscal],[supermercado_localidad])
SELECT DISTINCT
  dato.SUPER_NOMBRE,
  dato.SUPER_CUIT,
  dato.SUPER_RAZON_SOC,
  dato.SUPER_IIBB,
  dato.SUPER_DOMICILIO,
  dato.SUPER_FECHA_INI_ACTIVIDAD,
  dato.SUPER_CONDICION_FISCAL,
  l.localidad_id
FROM gd_esquema.Maestra dato
LEFT JOIN [LOS_REZAGADOS].[Localidades] l
  ON l.localidad_descripcion = dato.SUPER_LOCALIDAD
WHERE dato.SUPER_NOMBRE IS NOT NULL
  AND dato.SUPER_CUIT IS NOT NULL
  AND dato.SUPER_IIBB IS NOT NULL
  AND dato.SUPER_DOMICILIO IS NOT NULL;
GO

INSERT INTO [LOS_REZAGADOS].[Sucursales]
  ([sucursal_nombre],[sucursal_localidad],[sucursal_direccion],[supermercado])
SELECT DISTINCT
  dato.SUCURSAL_NOMBRE,
  l.localidad_id,
  dato.SUCURSAL_DIRECCION,
  s.supermercado_id
FROM gd_esquema.Maestra dato
LEFT JOIN [LOS_REZAGADOS].Localidades l
  ON l.localidad_descripcion = dato.SUCURSAL_LOCALIDAD
LEFT JOIN [LOS_REZAGADOS].Supermercados s
  ON s.supermercado_nombre = dato.SUPER_NOMBRE
WHERE dato.SUCURSAL_NOMBRE IS NOT NULL
GO

INSERT INTO [LOS_REZAGADOS].[Cajas]
  ([caja_numero],[caja_tipo],[sucursal])
SELECT DISTINCT
  dato.CAJA_NUMERO,
  dato.CAJA_TIPO,
  s.sucursal_id
FROM gd_esquema.Maestra dato
LEFT JOIN [LOS_REZAGADOS].Localidades l ON dato.SUCURSAL_LOCALIDAD = l.localidad_descripcion
LEFT JOIN [LOS_REZAGADOS].Sucursales s
  ON s.sucursal_localidad = l.localidad_id
  AND s.sucursal_nombre = dato.SUCURSAL_NOMBRE
  AND s.sucursal_direccion = dato.SUCURSAL_DIRECCION
WHERE dato.CAJA_NUMERO IS NOT NULL
  AND dato.CAJA_TIPO IS NOT NULL;
GO

INSERT INTO [LOS_REZAGADOS].[Tipos_Medio_Pago]
  ([tipo_descripcion])
SELECT DISTINCT
  dato.[PAGO_TIPO_MEDIO_PAGO]
FROM [gd_esquema].[Maestra] dato
WHERE PAGO_MEDIO_PAGO IS NOT NULL
GO

INSERT INTO [LOS_REZAGADOS].[Medios_de_pago]
  ([descripcion], [tipo_id])
SELECT DISTINCT
  dato.[PAGO_MEDIO_PAGO],
  tmp.tipo_id
FROM [gd_esquema].[Maestra] dato
  INNER JOIN [LOS_REZAGADOS].[Tipos_Medio_Pago] tmp ON dato.[PAGO_TIPO_MEDIO_PAGO] = tmp.tipo_descripcion
WHERE dato.[PAGO_TIPO_MEDIO_PAGO] IS NOT NULL;
GO

INSERT INTO [LOS_REZAGADOS].[Estados_Envios]
  ([estado_descripcion])
SELECT DISTINCT
  dato.[ENVIO_ESTADO]
FROM [gd_esquema].[Maestra] dato
GO

INSERT INTO [LOS_REZAGADOS].[Descuentos]
  ([descuento_codigo],[descuento_descripcion],[descuento_fecha_inicio],[descuento_fecha_fin],[descuento_porcentaje],[descuento_tope])
SELECT DISTINCT
  dato.[DESCUENTO_CODIGO],
  dato.[DESCUENTO_DESCRIPCION],
  dato.[DESCUENTO_FECHA_INICIO],
  dato.[DESCUENTO_FECHA_FIN],
  dato.[DESCUENTO_PORCENTAJE_DESC],
  dato.[DESCUENTO_TOPE]
FROM [gd_esquema].[Maestra] dato
WHERE dato.[DESCUENTO_CODIGO] IS NOT NULL
GO

INSERT INTO [LOS_REZAGADOS].[Marcas]
  ([marca_descripcion])
SELECT DISTINCT
  dato.[PRODUCTO_MARCA]
FROM [gd_esquema].[Maestra] dato
WHERE PRODUCTO_MARCA IS NOT NULL
GO

INSERT INTO [LOS_REZAGADOS].[Productos]
  ([producto_precio_unitario], [producto_marca], [producto_descripcion], [producto_nombre])
SELECT DISTINCT
  dato.[PRODUCTO_PRECIO],
  m.marca_id,
  dato.[PRODUCTO_DESCRIPCION],
  dato.[PRODUCTO_NOMBRE]
FROM [gd_esquema].[Maestra] dato
JOIN [LOS_REZAGADOS].Marcas m
  ON dato.[PRODUCTO_MARCA] = m.marca_descripcion
WHERE dato.[PRODUCTO_NOMBRE] IS NOT NULL
GO

INSERT INTO [LOS_REZAGADOS].[Detalles_pagos]
  ([cliente], [detalle_nro_tarjeta], [detalle_vencimiento], [detalle_cuotas])
SELECT DISTINCT c.cliente_id, dato.PAGO_TARJETA_NRO, dato.PAGO_TARJETA_FECHA_VENC, dato.PAGO_TARJETA_CUOTAS
FROM gd_esquema.Maestra dato
LEFT JOIN [LOS_REZAGADOS].[Clientes] c
  ON c.cliente_nombre = dato.CLIENTE_NOMBRE
  AND c.cliente_apellido = dato.CLIENTE_APELLIDO
  AND c.cliente_dni = dato.CLIENTE_DNI
WHERE dato.PAGO_TARJETA_NRO IS NOT NULL
  AND dato.PAGO_TARJETA_FECHA_VENC IS NOT NULL
  AND dato.PAGO_TARJETA_CUOTAS IS NOT NULL
GO

INSERT INTO [LOS_REZAGADOS].[Tipos_comprobantes]
  ([tipos_comprobantes_descripcion])
SELECT DISTINCT TICKET_TIPO_COMPROBANTE
FROM gd_esquema.Maestra
WHERE TICKET_TIPO_COMPROBANTE IS NOT NULL
ORDER BY 1
GO

INSERT INTO [LOS_REZAGADOS].[Tickets_Venta]
  ([ticket_numero],
  [ticket_fecha_hora],
  [caja],
  [empleado],
  [tipo_comprobante],
  [ticket_sub_total_productos],
  [ticket_total_descuento],
  [ticket_total_descuento_aplicado],
  [ticket_total_ticket])
SELECT DISTINCT
  dato.TICKET_NUMERO,
  dato.TICKET_FECHA_HORA,
  c.caja_id,
  e.empleado_id,
  tc.tipo_comprobante_id,
  dato.TICKET_SUBTOTAL_PRODUCTOS,
  dato.TICKET_TOTAL_DESCUENTO_APLICADO,
  dato.TICKET_TOTAL_DESCUENTO_APLICADO_MP,
  dato.TICKET_TOTAL_TICKET
FROM gd_esquema.Maestra dato
LEFT JOIN [LOS_REZAGADOS].Tipos_comprobantes tc
  ON tc.tipos_comprobantes_descripcion = dato.TICKET_TIPO_COMPROBANTE
LEFT JOIN [LOS_REZAGADOS].Empleados e
  ON e.empleado_dni = dato.EMPLEADO_DNI
LEFT JOIN [LOS_REZAGADOS].Supermercados s
  ON s.supermercado_cuit = dato.SUPER_CUIT
LEFT JOIN [LOS_REZAGADOS].Provincias p ON p.provincia_descripcion = dato.SUCURSAL_PROVINCIA
LEFT JOIN [LOS_REZAGADOS].Localidades l
  ON l.localidad_descripcion = dato.SUCURSAL_LOCALIDAD
  AND l.provincia = p.provincia_id
LEFT JOIN [LOS_REZAGADOS].Sucursales suc
  ON suc.sucursal_nombre = dato.SUCURSAL_NOMBRE
  AND suc.sucursal_direccion = dato.SUCURSAL_DIRECCION
  AND suc.supermercado = s.supermercado_id
  AND suc.sucursal_localidad = l.localidad_id
LEFT JOIN [LOS_REZAGADOS].Cajas c
  ON c.caja_numero = dato.CAJA_NUMERO
  AND c.caja_tipo = dato.CAJA_TIPO
  AND c.sucursal = suc.sucursal_id
WHERE dato.CAJA_NUMERO IS NOT NULL
GO

SET IDENTITY_INSERT [LOS_REZAGADOS].[Promociones] ON
INSERT INTO [LOS_REZAGADOS].[Promociones]
  ([cod_promocion], [promocion_descripcion], [promocion_fecha_inicio], [promocion_fecha_fin])
SELECT DISTINCT PROMO_CODIGO, PROMOCION_DESCRIPCION, PROMOCION_FECHA_INICIO, PROMOCION_FECHA_FIN
FROM gd_esquema.Maestra
WHERE PROMO_CODIGO IS NOT NULL
SET IDENTITY_INSERT [LOS_REZAGADOS].[Promociones] OFF
GO

INSERT INTO [LOS_REZAGADOS].[Reglas]
  ([regla_descripcion], [regla_descuento_aplicable_prod], [regla_cant_aplica_regla], [regla_cant_aplica_descuento], [regla_cant_max_prod], [regla_aplica_misma_marca], [regla_aplica_mismo_prod])
SELECT DISTINCT REGLA_DESCRIPCION, REGLA_DESCUENTO_APLICABLE_PROD, REGLA_CANT_APLICABLE_REGLA, REGLA_CANT_APLICA_DESCUENTO, REGLA_CANT_MAX_PROD, REGLA_APLICA_MISMA_MARCA, REGLA_APLICA_MISMO_PROD
FROM gd_esquema.Maestra
WHERE REGLA_DESCRIPCION IS NOT NULL
  AND REGLA_DESCUENTO_APLICABLE_PROD IS NOT NULL
  AND REGLA_CANT_APLICABLE_REGLA IS NOT NULL
  AND REGLA_CANT_APLICA_DESCUENTO IS NOT NULL
  AND REGLA_CANT_MAX_PROD IS NOT NULL
  AND REGLA_APLICA_MISMA_MARCA IS NOT NULL
  AND REGLA_APLICA_MISMO_PROD IS NOT NULL
GO

INSERT INTO [LOS_REZAGADOS].[Promociones_x_regla]
  ([cod_promocion], [regla])
SELECT DISTINCT p.cod_promocion, r.regla_id
FROM [LOS_REZAGADOS].[Reglas] r
  JOIN [gd_esquema].[Maestra] dato ON r.regla_descripcion = dato.REGLA_DESCRIPCION
  JOIN [LOS_REZAGADOS].[Promociones] p ON dato.PROMOCION_DESCRIPCION = p.promocion_descripcion
GROUP BY p.cod_promocion, r.regla_id
GO

INSERT INTO [LOS_REZAGADOS].[Promociones_x_producto]
  ([cod_promocion], [producto])
SELECT DISTINCT promo.cod_promocion, prod.producto_id
FROM [LOS_REZAGADOS].[Productos] prod
JOIN [gd_esquema].[Maestra] dato
  ON prod.producto_descripcion = dato.PRODUCTO_DESCRIPCION
  AND prod.producto_nombre = dato.PRODUCTO_NOMBRE
  AND prod.producto_precio_unitario = dato.PRODUCTO_PRECIO
JOIN [LOS_REZAGADOS].[Promociones] promo
  ON dato.PROMOCION_DESCRIPCION = promo.promocion_descripcion
  AND dato.PROMO_CODIGO = promo.cod_promocion
  AND dato.PROMOCION_FECHA_INICIO = promo.promocion_fecha_inicio
  AND dato.PROMOCION_FECHA_FIN = promo.promocion_fecha_fin
WHERE dato.PRODUCTO_NOMBRE IS NOT NULL OR dato.PROMO_CODIGO IS NOT NULL
GO

INSERT INTO [LOS_REZAGADOS].[Ticket_venta_x_producto]
  ([ticket_id],
  [producto],
  [ticket_det_cantidad],
  [ticket_det_precio],
  [ticket_det_total],
  [promo_aplicada_descuento])
SELECT DISTINCT
  tv.ticket_id,
  p.producto_id,
  dato.TICKET_DET_CANTIDAD,
  dato.TICKET_DET_PRECIO,
  dato.TICKET_DET_TOTAL,
  ISNULL(dato.PROMO_APLICADA_DESCUENTO, 0) AS promo_aplicada_descuento
FROM gd_esquema.Maestra dato
INNER JOIN [LOS_REZAGADOS].Tickets_Venta tv
  ON dato.TICKET_NUMERO = tv.ticket_numero
  AND [LOS_REZAGADOS].fn_GetTipoComprobanteId(dato.TICKET_TIPO_COMPROBANTE) = tv.tipo_comprobante

INNER JOIN [LOS_REZAGADOS].Marcas m
  ON m.marca_descripcion = dato.PRODUCTO_MARCA

INNER JOIN [LOS_REZAGADOS].Productos p
  ON p.producto_descripcion = dato.PRODUCTO_DESCRIPCION
  AND p.producto_nombre = dato.PRODUCTO_NOMBRE
  AND p.producto_precio_unitario = dato.PRODUCTO_PRECIO
  AND p.producto_marca = m.marca_id
GO

INSERT INTO [LOS_REZAGADOS].[Envios]
  ([ticket_id],
  [estado], -- FK
  [cliente], -- FK
  [envio_fecha_programada],
  [envio_hora_inicio],
  [envio_hora_fin],
  [envio_costo],
  [envio_fecha_entrega])
SELECT DISTINCT [LOS_REZAGADOS].fn_GetTipoComprobanteId(dato.TICKET_TIPO_COMPROBANTE), ee.estado_id, c.cliente_id, dato.ENVIO_FECHA_PROGRAMADA, dato.ENVIO_HORA_INICIO, dato.ENVIO_HORA_FIN, dato.ENVIO_COSTO, dato.ENVIO_FECHA_ENTREGA
FROM [LOS_REZAGADOS].[Clientes] c
JOIN [gd_esquema].[Maestra] dato
  ON c.cliente_nombre = dato.CLIENTE_NOMBRE
  AND c.cliente_apellido = dato.CLIENTE_APELLIDO
  AND c.cliente_dni = dato.CLIENTE_DNI
JOIN [LOS_REZAGADOS].[Estados_envios] ee
  ON dato.ENVIO_ESTADO = ee.estado_descripcion
GO

INSERT INTO [LOS_REZAGADOS].[Pagos_Ventas]
  ([pago_fecha_hora],
  [ticket_id],
  [detalle],
  [medio_de_pago],
  [cod_descuento],
  [pago_importe])
SELECT DISTINCT
  dato.PAGO_FECHA,
  tv.ticket_id,
  dp.detalle_id,
  mdp.medio_de_pago_id,
  d.descuento_id,
  dato.PAGO_IMPORTE
FROM gd_esquema.Maestra dato
LEFT JOIN [LOS_REZAGADOS].Clientes c
  ON c.cliente_dni = dato.CLIENTE_DNI
LEFT JOIN [LOS_REZAGADOS].Detalles_pagos dp
  ON dp.detalle_nro_tarjeta = dato.PAGO_TARJETA_NRO
  AND dp.detalle_cuotas = dato.PAGO_TARJETA_CUOTAS
  AND dp.detalle_vencimiento = dato.PAGO_TARJETA_FECHA_VENC
  AND dp.cliente = c.cliente_id
LEFT JOIN [LOS_REZAGADOS].Tipos_comprobantes tc
  ON tc.tipos_comprobantes_descripcion = dato.TICKET_TIPO_COMPROBANTE
LEFT JOIN [LOS_REZAGADOS].Tickets_Venta tv
  ON tv.ticket_numero = dato.TICKET_NUMERO
  AND tv.tipo_comprobante = tc.tipo_comprobante_id
LEFT JOIN [LOS_REZAGADOS].Tipos_medio_pago tmp
  ON tmp.tipo_descripcion = dato.PAGO_TIPO_MEDIO_PAGO
LEFT JOIN [LOS_REZAGADOS].Medios_de_pago mdp
  ON mdp.tipo_id = tmp.tipo_id
  AND mdp.descripcion = dato.PAGO_MEDIO_PAGO
LEFT JOIN [LOS_REZAGADOS].Descuentos d
  ON d.descuento_codigo = dato.DESCUENTO_CODIGO
  AND d.descuento_descripcion = dato.DESCUENTO_DESCRIPCION
  AND d.descuento_fecha_inicio = dato.DESCUENTO_FECHA_INICIO
  AND d.descuento_fecha_fin = dato.DESCUENTO_FECHA_FIN
  AND d.descuento_porcentaje = dato.DESCUENTO_PORCENTAJE_DESC
  AND d.descuento_tope = dato.DESCUENTO_TOPE;
GO

INSERT INTO [LOS_REZAGADOS].[Promociones_x_venta]
  ([cod_promocion], [ticket_venta_producto])
SELECT DISTINCT
  p.cod_promocion,
  tvp.ticket_venta_producto
FROM gd_esquema.Maestra dato
INNER JOIN [LOS_REZAGADOS].Promociones p
  ON p.promocion_descripcion = dato.PROMOCION_DESCRIPCION
  AND p.promocion_fecha_inicio = dato.PROMOCION_FECHA_INICIO
  AND p.promocion_fecha_fin = dato.PROMOCION_FECHA_FIN
INNER JOIN [LOS_REZAGADOS].Ticket_venta_x_producto tvp
  ON tvp.promo_aplicada_descuento = dato.PROMO_APLICADA_DESCUENTO
  AND tvp.ticket_det_total = dato.TICKET_DET_TOTAL
  AND tvp.ticket_det_precio = dato.TICKET_DET_PRECIO
GO

INSERT INTO [LOS_REZAGADOS].[Subcategorias_x_producto]
([subcategoria_id], [producto_id])
SELECT DISTINCT
  s.subcategoria_id,
  p.producto_id
FROM gd_esquema.Maestra dato
INNER JOIN [LOS_REZAGADOS].Marcas m
  ON m.marca_descripcion = dato.PRODUCTO_MARCA
INNER JOIN [LOS_REZAGADOS].Productos p
  ON p.producto_descripcion = dato.PRODUCTO_DESCRIPCION
  AND p.producto_nombre = dato.PRODUCTO_NOMBRE
  AND p.producto_precio_unitario = dato.PRODUCTO_PRECIO
  AND p.producto_marca = m.marca_id
INNER JOIN [LOS_REZAGADOS].Subcategorias s
  ON s.subcategoria_descripcion = dato.PRODUCTO_SUB_CATEGORIA
INNER JOIN [LOS_REZAGADOS].Categorias c
  ON c.categoria_descripcion = dato.PRODUCTO_CATEGORIA
GO

COMMIT
GO