USE [GD1C2024]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Tipos_comprobantes')
CREATE TABLE [LOS_REZAGADOS].[Tipos_comprobantes] (
  tipos_comprobante_id DECIMAL (18, 0) PRIMARY KEY,
  tipos_comprobantes_descripcion NVARCHAR(255),
)
GO

INSERT INTO [LOS_REZAGADOS].[Tipos_comprobantes] (
	tipos_comprobantes_descripcion
)
SELECT DISTINCT TICKET_TIPO_COMPROBANTE
FROM gd_esquema.Maestra
WHERE TICKET_TIPO_COMPROBANTE IS NOT NULL
ORDER BY 1