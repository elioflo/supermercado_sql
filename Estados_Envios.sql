-- Estados_Envios - BEGIN
USE [GD1C2024]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- SE CREA LA TABLA

CREATE TABLE Estados_Envios(
	[tipo_id] INT IDENTITY(1,1) PRIMARY KEY,
	[estado_descripcion] NVARCHAR(255) NULL
) ON [PRIMARY]
GO

-- SE MIGRAN LOS DATOS

INSERT INTO [Estados_Envios]([estado_descripcion])
SELECT DISTINCT
	dato.[ENVIO_ESTADO]
FROM [gd_esquema].[Maestra] dato
WHERE ENVIO_ESTADO IS NOT NULL --REvisar si el estado null es necesario tenerlo

-- Estados_envios - END