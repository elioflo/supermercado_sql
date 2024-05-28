USE [GD1C2024]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Promocion')
CREATE TABLE [LOS_REZAGADOS].[Promocion] (
	promocion_codigo DECIMAL(18, 0) PRIMARY KEY,
	promocion_descripcion NVARCHAR(255),
	promocion_fecha_inicio DATETIME,
	promocion_fecha_fin DATETIME,
)
GO

SET IDENTITY_INSERT [LOS_REZAGADOS].[Promocion] ON;
INSERT INTO [LOS_REZAGADOS].[Promocion] (
	promocion_codigo,
	promocion_descripcion,
	promocion_fecha_inicio,
	promocion_fecha_fin
)

SELECT DISTINCT PROMO_CODIGO, PROMOCION_DESCRIPCION, PROMOCION_FECHA_INICIO, PROMOCION_FECHA_FIN
FROM gd_esquema.Maestra
WHERE PROMO_CODIGO IS NOT NULL
SET IDENTITY_INSERT [LOS_REZAGADOS].[Promocion] OFF;
GO;