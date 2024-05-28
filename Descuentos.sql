-- Descuentos - BEGIN
USE [GD1C2024]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- SE CREA LA TABLA

CREATE TABLE [LOS_REZAGADOS].[Descuentos](
	[descuento_id] INT IDENTITY(1,1) PRIMARY KEY,
	[descuento_codigo] DECIMAL(18,0) NULL,
    [descuento_descripcion] NVARCHAR(255) NULL,
    [descuento_fecha_inicio] DATETIME NULL,
    [descuento_fecha_fin] DATETIME NULL,
    [descuento_porcentaje] DECIMAL(18,2) NULL,
    [descuento_tope] DECIMAL(18,2) NULL
) ON [PRIMARY]
GO

-- SE MIGRAN LOS DATOS

INSERT INTO [LOS_REZAGADOS].[Descuentos] ([descuento_codigo],[descuento_descripcion],[descuento_fecha_inicio],[descuento_fecha_fin],[descuento_porcentaje],[descuento_tope])
SELECT 
	dato.[DESCUENTO_CODIGO],
	dato.[DESCUENTO_DESCRIPCION],
	dato.[DESCUENTO_FECHA_INICIO],
	dato.[DESCUENTO_FECHA_FIN],
	dato.[DESCUENTO_PORCENTAJE_DESC],
	dato.[DESCUENTO_TOPE]
FROM [gd_esquema].[Maestra] dato
WHERE dato.[DESCUENTO_CODIGO] IS NOT NULL
GO

-- Descuentos - END