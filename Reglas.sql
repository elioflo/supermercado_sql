USE [GD1C2024]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Reglas')
CREATE TABLE [LOS_REZAGADOS].[Reglas]
(
	regla_id DECIMAL(18, 0) PRIMARY KEY,
	regla_descripcion NVARCHAR(255),
	regla_descuento_aplicable_prod DECIMAL (18, 2),
	regla_cant_aplica_regla DECIMAL (18, 0),
	regla_cant_aplica_descuento DECIMAL (18, 0),
	regla_cant_max_prod DECIMAL (18, 0),
	regla_aplica_misma_marca DECIMAL (18, 0),
	regla_aplica_mismo_prod DECIMAL (18, 0),
)
GO

INSERT INTO [LOS_REZAGADOS].[Reglas]
	(
	regla_descripcion,
	regla_descuento_aplicable_prod,
	regla_cant_aplica_regla,
	regla_cant_aplica_descuento,
	regla_cant_max_prod,
	regla_aplica_misma_marca,
	regla_aplica_mismo_prod,
	)

SELECT DISTINCT REGLA_DESCRIPCION, REGLA_DESCUENTO_APLICABLE_PROD, REGLA_CANT_APLICABLE_REGLA, REGLA_CANT_APLICA_DESCUENTO, REGLA_CANT_MAX_PROD, REGLA_APLICA_MISMA_MARCA, REGLA_APLICA_MISMO_PROD
FROM gd_esquema.Maestra
WHERE REGLA_DESCRIPCION IS NOT NULL
	AND REGLA_DESCUENTO_APLICABLE_PROD IS NOT NULL
	AND REGLA_CANT_APLICABLE_REGLA IS NOT NULL
	AND REGLA_CANT_APLICA_DESCUENTO IS NOT NULL
	AND REGLA_CANT_MAX_PROD IS NOT NULL
	AND REGLA_APLICA_MISMA_MARCA IS NOT NULL
	AND REGLA_APLICA_MISMO_PROD IS NOT NULL
GO;
