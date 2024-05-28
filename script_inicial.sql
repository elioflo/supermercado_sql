USE [GD1C2024]
GO

-- Creacion de schema si no existe
IF NOT EXISTS ( SELECT * FROM sys.schemas WHERE name = 'LOS_REZAGADOS')
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

-- -- Borrado de tablas si existen en caso que el schema exista
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
IF OBJECT_ID('LOS_REZAGADOS.Promocion_x_venta','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Promocion_x_venta;
IF OBJECT_ID('LOS_REZAGADOS.Promocion','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Promocion;
IF OBJECT_ID('LOS_REZAGADOS.Promocion_x_producto','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Promocion_x_producto;
IF OBJECT_ID('LOS_REZAGADOS.Promocion_x_regla','U') IS NOT NULL
  DROP TABLE [LOS_REZAGADOS].Promocion_x_regla;

-- Creacion de tablas
BEGIN TRANSACTION

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Supermercados')
CREATE TABLE [LOS_REZAGADOS].[Supermercados] (
  supermercado_id INT PRIMARY KEY,
  supermercado_nombre NVARCHAR(255),
  supermercado_cuit NVARCHAR(255),
  supermercado_razon_social NVARCHAR(255),
  supermercado_iibb NVARCHAR(255),
  supermercado_domicilio NVARCHAR(255),
  supermercado_fecha_inicio_act DATETIME,
  supermercado_condicion_fiscal NVARCHAR(255),
  supermercado_localidad DECIMAL(18, 0), -- FK
)

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Sucursales')
CREATE TABLE [LOS_REZAGADOS].[Sucursales] (
  sucursal_id DECIMAL (18, 0) PRIMARY KEY,
  supermercado INT, -- FK
  sucursal_nombre NVARCHAR(255),
  sucursal_localidad DECIMAL(18, 0), -- FK
  sucursal_direccion NVARCHAR(255),
)

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Cajas')
CREATE TABLE [LOS_REZAGADOS].[Cajas] (
  caja_id DECIMAL (18, 0) PRIMARY KEY,
  caja_numero DECIMAL(18, 0),
  caja_tipo NVARCHAR(255),
  sucursal DECIMAL(18, 0), -- FK
)

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Empleados')
CREATE TABLE [LOS_REZAGADOS].[Empleados] (
  empleado_id DECIMAL (18, 0) PRIMARY KEY,
  empleado_nombre NVARCHAR(255),
  empleado_apellido NVARCHAR(255),
  empleado_dni DECIMAL(18, 0),
  empleado_fecha_registro DATETIME,
  empleado_telefono DECIMAL(18, 0),
  empleado_mail NVARCHAR(255),
  empleado_fecha_nacimiento DATETIME,
)

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Clientes')
CREATE TABLE [LOS_REZAGADOS].[Clientes] (
  cliente_id DECIMAL (18, 0) PRIMARY KEY,
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

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Localidades')
CREATE TABLE [LOS_REZAGADOS].[Localidades] (
  localidad_id DECIMAL (18, 0) PRIMARY KEY,
  localidad_descripcion NVARCHAR(255),
  provincia DECIMAL(18, 0), -- FK
)

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Provincias')
CREATE TABLE [LOS_REZAGADOS].[Provincias] (
  provincia_id DECIMAL (18, 0) PRIMARY KEY,
  provincia_descripcion NVARCHAR(255),
)

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Tipos_comprobantes')
CREATE TABLE [LOS_REZAGADOS].[Tipos_comprobantes] (
  tipos_comprobante_id DECIMAL (18, 0) PRIMARY KEY,
  tipos_comprobantes_descripcion NVARCHAR(255),
)

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Tickets_Venta')
CREATE TABLE [LOS_REZAGADOS].[Tickets_Venta] (
  ticket_numero DECIMAL (18, 0) PRIMARY KEY,
  ticket_fecha_hora DATETIME,
  caja DECIMAL(18, 0), -- FK
  empleado DECIMAL(18, 0), -- FK
  tipo_comprobante DECIMAL(18, 0), --FK
  ticket_sub_total_productos DECIMAL(18, 2),
  ticket_total_descuento DECIMAL(18, 2),
  ticket_total_descuento_aplicado DECIMAL(18, 2),
  ticket_total_ticket DECIMAL(18, 2),
)

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Estados_envios')
CREATE TABLE [LOS_REZAGADOS].[Estados_envios] (
  estado_id DECIMAL (18, 0) PRIMARY KEY,
  estado_descripcion NVARCHAR(255),
)

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Envios')
CREATE TABLE [LOS_REZAGADOS].[Envios] (
  envio_id DECIMAL (18, 0) PRIMARY KEY,
  ticket_numero DECIMAL (18, 0), -- FK
  estado DECIMAL (18, 0), -- FK
  cliente DECIMAL (18, 0), -- FK
  envio_fecha_programada DATETIME,
  envio_hora_inicio DECIMAL (18, 0),
  envio_hora_fin DECIMAL (18, 0),
  envio_costo DECIMAL (18, 2),
  envio_fecha_entrega DATETIME,
)

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Pagos_Ventas')
CREATE TABLE [LOS_REZAGADOS].[Pagos_Ventas] (
  nro_pago DECIMAL (18, 0) PRIMARY KEY,
  pago_fecha_hora DATETIME,
  ticket_numero DECIMAL (18, 0), -- FK
  detalle DECIMAL (18, 0), -- FK
  medio_de_pago DECIMAL (18, 0), -- FK
  cod_descuento DECIMAL (18, 0), -- FK
  pago_importe DECIMAL (18, 0),
)

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Detalles_pagos')
CREATE TABLE [LOS_REZAGADOS].[Detalles_pagos] (
  detalle_id DECIMAL (18, 0) PRIMARY KEY,
  cliente DECIMAL (18, 0), -- FK
  detalle_nro_tarjeta DECIMAL (18, 0),
  detalle_vencimiento DECIMAL (18, 0),
  detalle_cuotas DECIMAL (18, 0),
)

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Medios_de_pago')
CREATE TABLE [LOS_REZAGADOS].[Medios_de_pago] (
  medio_de_pago_id DECIMAL(18, 0) PRIMARY KEY,
  descripcion NVARCHAR(255),
  tipo_medio_pago DECIMAL(18, 0), -- FK
)

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Tipos_medio_pago')
CREATE TABLE [LOS_REZAGADOS].[Tipos_medio_pago] (
  tipo_id DECIMAL(18, 0) PRIMARY KEY,
  tipo_descripcion NVARCHAR(255),
)

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Descuentos')
CREATE TABLE [LOS_REZAGADOS].[Descuentos] (
  descuento_id DECIMAL(18, 0) PRIMARY KEY,
  descuento_codigo DECIMAL (18, 0),
  descuento_descripcion NVARCHAR(255),
  descuento_fecha_incio DATETIME,
  descuento_fecha_fin DATETIME,
  descuento_porcentaje DECIMAL (18, 2),
  descuento_tope DECIMAL (18, 2),
)

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Subcategorias_x_producto')
CREATE TABLE [LOS_REZAGADOS].[Subcategorias_x_producto] (
  subcategoria_id DECIMAL(18, 0), -- FK
  producto_id DECIMAL (18, 0), -- FK
  PRIMARY KEY (subcategoria_id, producto_id)
)

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Subcategorias')
CREATE TABLE [LOS_REZAGADOS].[Subcategorias] (
  subcategoria_id DECIMAL(18, 0) PRIMARY KEY,
  subcategoria_descripcion NVARCHAR(255),
  categoria DECIMAL (18, 0), -- FK
)

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Categorias')
CREATE TABLE [LOS_REZAGADOS].[Categorias] (
  categoria_id DECIMAL(18, 0) PRIMARY KEY,
  categoria_descripcion NVARCHAR(255),
)

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Marcas')
CREATE TABLE [LOS_REZAGADOS].[Marcas] (
  marca_id DECIMAL(18, 0) PRIMARY KEY,
  marca_descripcion NVARCHAR(255),
)

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Ticket_venta_x_producto')
CREATE TABLE [LOS_REZAGADOS].[Ticket_venta_x_producto] (
  ticket_numero DECIMAL(18, 0),
  producto DECIMAL(18,0),
  ticket_det_cantidad DECIMAL (18, 0),
  ticket_det_precio DECIMAL (18, 2),
  ticket_det_total DECIMAL (18, 2),
  promo_aplicada_descuento DECIMAL (18, 2),
  PRIMARY KEY (ticket_numero, producto)
)

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Productos')
CREATE TABLE [LOS_REZAGADOS].[Productos] (
  producto_id DECIMAL(18, 0) PRIMARY KEY,
  producto_precio_unitario DECIMAL (18, 2),
  subcategoria DECIMAL (18, 0), -- FK
  marca DECIMAL (18, 0), -- FK
  producto_descripcion NVARCHAR(255),
  producto_nombre NVARCHAR(255),
)

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Reglas')
CREATE TABLE [LOS_REZAGADOS].[Reglas] (
  regla_id DECIMAL(18, 0) PRIMARY KEY,
  regla_descripcion NVARCHAR(255),
  regla_descuento_aplicable_prod DECIMAL (18, 2),
  regla_cant_aplica_regla DECIMAL (18, 0),
  regla_cant_aplica_descuento DECIMAL (18, 0),
  regla_cant_max_prod DECIMAL (18, 0),
  regla_aplica_misma_marca_ DECIMAL (18, 0),
  regla_aplica_mismo_prod DECIMAL (18, 0),
)

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Promocion_x_venta')
CREATE TABLE [LOS_REZAGADOS].[Promocion_x_venta] (
  promocion_codigo DECIMAL(18, 0),
  ticket_numero DECIMAL (18, 0),
  producto DECIMAL (18, 2),
  PRIMARY KEY (cod_promocion, ticket_numero, producto)
)

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Promocion')
CREATE TABLE [LOS_REZAGADOS].[Promocion] (
  promocion_codigo DECIMAL(18, 0) PRIMARY KEY,
  promocion_descripcion NVARCHAR(255),
  promocion_fecha_inicio DATETIME,
  promocion_fecha_fin DATETIME,
)

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Promocion_x_producto')
CREATE TABLE [LOS_REZAGADOS].[Promocion_x_producto] (
  promocion_codigo DECIMAL(18, 0),
  producto DECIMAL (18, 0),
  PRIMARY KEY (promocion_codigo, producto)
)

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Promocion_x_regla')
CREATE TABLE [LOS_REZAGADOS].[Promocion_x_regla] (
  promocion_codigo DECIMAL(18, 0),
  regla DECIMAL (18, 0),
  PRIMARY KEY (promocion_codigo, regla)
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
ADD FOREIGN KEY (tipo_comprobante) REFERENCES [LOS_REZAGADOS].Tipos_comprobantes(tipo_comprobante_id); -- ??????

ALTER TABLE [LOS_REZAGADOS].[Envios]
ADD FOREIGN KEY (ticket_numero) REFERENCES [LOS_REZAGADOS].Tickets_VentaEmpleados(ticket_numero);

ALTER TABLE [LOS_REZAGADOS].[Envios]
ADD FOREIGN KEY (estado) REFERENCES [LOS_REZAGADOS].Estados_envios(estado_id);

ALTER TABLE [LOS_REZAGADOS].[Envios]
ADD FOREIGN KEY (cliente) REFERENCES [LOS_REZAGADOS].Clientes(cliente_id);

ALTER TABLE [LOS_REZAGADOS].[Pagos_Ventas]
ADD FOREIGN KEY (ticket_numero) REFERENCES [LOS_REZAGADOS].Tickets_VentaClientes(ticket_numero);

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

ALTER TABLE [LOS_REZAGADOS].[Ticket_venta_x_producto]
ADD FOREIGN KEY (ticket_numero) REFERENCES [LOS_REZAGADOS].Tickets_Venta(ticket_numero);

ALTER TABLE [LOS_REZAGADOS].[Ticket_venta_x_producto]
ADD FOREIGN KEY (producto_id) REFERENCES [LOS_REZAGADOS].Productos(producto_id);

ALTER TABLE [LOS_REZAGADOS].[Productos]
ADD FOREIGN KEY (subcategoria_id) REFERENCES [LOS_REZAGADOS].Subcategorias_x_producto(subcategoria_id);

ALTER TABLE [LOS_REZAGADOS].[Productos]
ADD FOREIGN KEY (marca) REFERENCES [LOS_REZAGADOS].Marcas(marca_id);

ALTER TABLE [LOS_REZAGADOS].[Productos]
ADD FOREIGN KEY (marca) REFERENCES [LOS_REZAGADOS].Marcas(marca_id);

ALTER TABLE [LOS_REZAGADOS].[Promocion_x_producto]
ADD FOREIGN KEY (promocion_codigo) REFERENCES [LOS_REZAGADOS].Promocion(promocion_codigo);

ALTER TABLE [LOS_REZAGADOS].[Promocion_x_producto]
ADD FOREIGN KEY (producto_id) REFERENCES [LOS_REZAGADOS].Productos(producto_id);

ALTER TABLE [LOS_REZAGADOS].[Promocion_x_regla]
ADD FOREIGN KEY (promocion_codigo) REFERENCES [LOS_REZAGADOS].Promocion(promocion_codigo);

ALTER TABLE [LOS_REZAGADOS].[Promocion_x_regla]
ADD FOREIGN KEY (regla_id) REFERENCES [LOS_REZAGADOS].Reglas(regla_id);

ALTER TABLE [LOS_REZAGADOS].[Promocion_x_venta]
ADD FOREIGN KEY (promocion_codigo) REFERENCES [LOS_REZAGADOS].Promocion(promocion_codigo);

ALTER TABLE [LOS_REZAGADOS].[Promocion_x_venta]
ADD FOREIGN KEY (ticket_numero, producto) REFERENCES [LOS_REZAGADOS].Tickets_Venta(ticket_numero);

COMMIT
GO

-- ================= Migracion =============================

BEGIN TRANSACTION



COMMIT
GO