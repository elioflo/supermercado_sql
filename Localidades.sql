-- LOCALIDADES - BEGIN
USE [GD1C2024]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- SE CREA LA TABLA

CREATE TABLE [LOS_REZAGADOS].[Localidades](
	[Localidad_id] INT IDENTITY(1,1) PRIMARY KEY,
	[Localidad_descripcion] [nvarchar](255) NULL,
	[provincia_id] INT,
) ON [PRIMARY]
GO

-- DEFINIMOS PROVINCIA_ID COMO FK

-- ALTER TABLE [LOS_REZAGADOS].[Localidades]
-- ADD CONSTRAINT FK_ProvinciaID
-- FOREIGN KEY (provincia_id)
-- REFERENCES [LOS_REZAGADOS].[Provincias] (provincia_id);

-- SE MIGRAN LOS DATOS

-- INSERT INTO [LOS_REZAGADOS].[Localidades] ([Localidad_descripcion], [provincia_id])
-- SELECT DISTINCT Localidad_descripcion, provincia_id FROM (SELECT
-- 	dato.SUPER_LOCALIDAD as Localidad_descripcion,
-- 	provincia.provincia_id as provincia_id
-- from gd_esquema.Maestra dato
-- inner join LOS_REZAGADOS.Provincias provincia on provincia.provincia_descripcion = dato.SUPER_PROVINCIA
-- union
-- select 
-- 	dato.SUCURSAL_LOCALIDAD as Localidad_descripcion,
-- 	provincia.provincia_id as provincia_id
-- from gd_esquema.Maestra dato
-- inner join LOS_REZAGADOS.Provincias provincia on provincia.provincia_descripcion = dato.SUCURSAL_PROVINCIA
-- union
-- select 
-- 	dato.CLIENTE_LOCALIDAD as Localidad_descripcion,
-- 	provincia.provincia_id as provincia_id
-- from gd_esquema.Maestra dato
-- inner join LOS_REZAGADOS.Provincias provincia on provincia.provincia_descripcion = dato.CLIENTE_PROVINCIA) AS LOCALIDADES;
-- GO

-- LOCALIDADES - END