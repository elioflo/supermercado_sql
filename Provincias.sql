-- PROVINCIA - BEGIN
USE [GD1C2024]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- SE CREA LA TABLA

CREATE TABLE [LOS_REZAGADOS].[Provincias](
	[provincia_id] INT IDENTITY(1,1) PRIMARY KEY,
	[provincia_descripcion] [nvarchar](255) NULL,
) ON [PRIMARY]
GO

-- SE MIGRAN LOS DATOS

INSERT INTO [LOS_REZAGADOS].[Provincias] ([provincia_descripcion])
SELECT DISTINCT(PROVINCIA) FROM (
	SELECT SUPER_PROVINCIA AS PROVINCIA FROM gd_esquema.Maestra
	UNION
	SELECT SUCURSAL_PROVINCIA AS PROVINCIA FROM gd_esquema.Maestra
	UNION
	SELECT CLIENTE_PROVINCIA AS PROVINCIA FROM gd_esquema.Maestra
) AS PROVINCIAS;

-- PROVINCIA - END