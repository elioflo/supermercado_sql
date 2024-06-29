USE GD1C2024
DROP TABLE [LOS_REZAGADOS].BI_hechos_ventas
DROP TABLE [LOS_REZAGADOS].BI_dimension_rangos
DROP TABLE [LOS_REZAGADOS].BI_dimension_ubicaciones
DROP TABLE [LOS_REZAGADOS].BI_dimension_turnos
DROP TABLE [LOS_REZAGADOS].BI_dimension_tiempos

CREATE TABLE [LOS_REZAGADOS].[BI_hechos_ventas](
	ubicacion_id DECIMAL(18,0),
	tiempo_id DECIMAL(18,0),
	rango_empleado DECIMAL(18,0),
	rango_cliente DECIMAL(18,0),
	turno_id DECIMAL(18,0),
	caja_tipo VARCHAR(255),
	promedio_venta DECIMAL(10,2),
	unidades_promedios DECIMAL(10,2),
	porcentaje_anual_ventas DECIMAL(10,2),
	cantidad_ventas DECIMAL(10,2)
)

CREATE TABLE [LOS_REZAGADOS].[BI_dimension_rangos](
	rango_id DECIMAL(18, 0) IDENTITY(1,1) PRIMARY KEY,
	rango_descripcion VARCHAR(255)
)

CREATE TABLE [LOS_REZAGADOS].[BI_dimension_ubicaciones](
	ubicacion_id DECIMAL(18, 0) IDENTITY(1,1) PRIMARY KEY,
	localidad_descripcion VARCHAR(255),
	provincia_descripcion VARCHAR(255)
)

CREATE TABLE [LOS_REZAGADOS].[BI_dimension_turnos](
	turno_id DECIMAL(18, 0) IDENTITY(1,1) PRIMARY KEY,
	hora_inicio DATETIME,
	hora_fin DATETIME
)

CREATE TABLE [LOS_REZAGADOS].[BI_dimension_tiempos](
	tiempo_id DECIMAL(18, 0) IDENTITY(1,1) PRIMARY KEY,
	dia DECIMAL(18, 0),
	mes DECIMAL(18, 0),
	cuatrimestre DECIMAL(18, 0),
	anio DECIMAL(18, 0)
)
--probando
select * from LOS_REZAGADOS.Ticket_venta_x_producto
-- funciones 
-- Esta función nos permite obtener el id para un mes, año y cuatrimestre especificos 

CREATE FUNCTION LOS_REZAGADOS.OBTENER_ID_TIEMPO(@fecha DATE) RETURNS DECIMAL(18) AS
BEGIN
	DECLARE @anio DECIMAL(18),
			@mes DECIMAL(18),
			@cuatrimestre DECIMAL(18),
			@id_tiempo DECIMAL(18)

	SET @anio = DATEPART(YEAR, @fecha)
	SET @mes = DATEPART(MONTH, @fecha)

	IF @mes BETWEEN 1 AND 4
		SET @cuatrimestre = 1
	ELSE IF @mes BETWEEN 5 AND 8
		SET @cuatrimestre = 2
	ELSE
		SET @cuatrimestre = 3

	SELECT @id_tiempo = tiempo_id 
		FROM LOS_REZAGADOS.BI_dimension_tiempos
		WHERE anio = @anio AND mes = @mes AND cuatrimestre = @cuatrimestre

	RETURN @id_tiempo
END
GO
-- Esta función nos permite obtener el id del rango de la edad de un cliente

CREATE FUNCTION LOS_REZAGADOS.OBTENER_ID_EDAD(@FECHA_NACIMIENTO DATE) RETURNS DECIMAL(18) AS
BEGIN
	DECLARE @id_edad DECIMAL(18);
	DECLARE @HOY DATE;
	DECLARE @EDAD INT;
	SET @HOY = GETDATE();
	SET @EDAD = (DATEDIFF(DAY, @FECHA_NACIMIENTO, @HOY) / 365)

	IF @EDAD < 25
		SELECT @id_edad = rango_id FROM LOS_REZAGADOS.BI_dimension_rangos WHERE rango_descripcion = '< 25 años'
	ELSE IF @EDAD BETWEEN 25 AND 35
		SELECT @id_edad = rango_id FROM LOS_REZAGADOS.BI_dimension_rangos WHERE rango_descripcion = '25 - 35 años'
	ELSE IF @EDAD BETWEEN 35 AND 50
		SELECT @id_edad = rango_id FROM LOS_REZAGADOS.BI_dimension_rangos WHERE rango_descripcion = '35 - 50 años'
	ELSE
		SELECT @id_edad = rango_id FROM LOS_REZAGADOS.BI_dimension_rangos WHERE rango_descripcion = '> 50 años'

	RETURN @id_edad;
END
GO
--
------ MIGRACION/CARGA DIMENSIONES --------

GO
CREATE PROCEDURE LAWE.migrar_bi_tipo_pc AS
BEGIN
  INSERT INTO LAWE.bi_tipo_pc (pc_codigo, precio_compra, precio_venta)
    SELECT pc_codigo, precio_compra, 1.2 * precio_compra  FROM LAWE.tipo_pc
END
GO

GO
CREATE PROCEDURE LAWE.migrar_bi_sucursal AS
BEGIN
  INSERT INTO LAWE.bi_sucursal (id_sucursal, direccion, mail, telefono, ciudad)
    SELECT id_sucursal, direccion, mail, telefono, LAWE.OBTENER_NOMBRE_CIUDAD(id_ciudad) 
    FROM LAWE.sucursal
END
GO

-- La dimension "bi_tiempo" almacena las posibles fechas de facturas y compras
-- asociando mes y año apartir de la fecha original

GO
CREATE PROCEDURE LOS_REZAGADOS.cargar_BI_dimension_tiempos AS
BEGIN
	INSERT INTO LOS_REZAGADOS.BI_dimension_tiempos(anio, mes)
		SELECT DISTINCT YEAR(ticket_fecha_hora), MONTH(ticket_fecha_hora)
		FROM LOS_REZAGADOS.Tickets_Venta
		--UNION
		--SELECT DISTINCT YEAR(fecha), MONTH(fecha)
		--FROM LAWE.factura
END
GO


-- La dimension "bi_edad" almacena los posibles rangos de edad de los clientes
-- a partir de su fecha de nacimiento

GO
CREATE PROCEDURE LOS_REZAGADOS.cargar_BI_dimension_rangos AS
BEGIN
	INSERT INTO LOS_REZAGADOS.BI_dimension_rangos(rango_descripcion)
		VALUES 	('< 25 años'),
				('18 - 30 años'),
				('31 - 50 años'),
				('> 50 años')
END
GO

--1
CREATE VIEW vista_promedio_ventas AS
SELECT 
    localidad_descripcion, 
    anio, 
    mes, 
    AVG(importe_venta) AS promedio_venta
FROM LOS_REZAGADOS.BI_hechos_ventas
JOIN BI_dimension_ubicaciones ON BI_hechos_ventas.ubicacion_id = BI_dimension_ubicaciones.ubicacion_id
JOIN BI_dimension_tiempos ON BI_hechos_ventas.tiempo_id = BI_dimension_tiempos.tiempo_id
GROUP BY localidad_descripcion, anio, mes;

--8
CREATE VIEW cant_envios_x_edad AS
SELECT 
    anio, 
    cuatrimestre, 
    rango_descripcion, 
    COUNT(nro_envio) AS cantidad_envíos
FROM LOS_REZAGADOS.hechos_envíos
JOIN BI_dimension_rangos ON hechos_envíos.rango_id = BI_dimension_rangos.id_rango_etario
JOIN BI_dimension_tiempos ON hechos_envíos.tiempo_id = BI_dimension_tiempos.tiempo_id
GROUP BY anio, cuatrimestre, rango_descripcion;

--11
CREATE VIEW promedio_cuota_x_edad AS
SELECT 
    rango_descripcion, 
    AVG(importe_pago / número_cuotas) AS promedio_importe_cuota
FROM LOS_REZAGADOS.hechos_pagos
JOIN BI_hechos_ventas ON hechos_pagos.id_venta = BI_hechos_ventas.id_venta
JOIN BI_dimension_rangos ON BI_hechos_ventas.rango_cliente = BI_dimension_rangos.id_rango_etario
GROUP BY rango_descripcion;