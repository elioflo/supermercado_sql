-- Marcas - BEGIN
USE [GD1C2024]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- SE CREA LA TABLA

CREATE TABLE [Marcas](
	[marca_id] INT IDENTITY(1,1) PRIMARY KEY,
	[marca_descripcion] NVARCHAR(255) NULL
) ON [PRIMARY]
GO

-- SE MIGRAN LOS DATOS

INSERT INTO [Marcas]([marca_descripcion])
SELECT 
	dato.[PRODUCTO_MARCA]
FROM [gd_esquema].[Maestra] dato
GO

-- Marcas - END
