-- Categorias - BEGIN
USE [GD1C2024]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- SE CREA LA TABLA

CREATE TABLE [LOS_REZAGADOS].[Categorias](
	[categoria_id] INT IDENTITY(1,1) PRIMARY KEY,
    [categoria_descripcion] [nvarchar](255) NULL
) ON [PRIMARY]
GO

-- SE MIGRAN LOS DATOS

INSERT INTO [LOS_REZAGADOS].[Categorias] ([categoria_descripcion])
SELECT DISTINCT 
	dato.PRODUCTO_CATEGORIA
from gd_esquema.Maestra dato
where dato.PRODUCTO_CATEGORIA IS NOT NULL;

-- Categorias - END