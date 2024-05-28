-- Productos - BEGIN
USE [GD1C2024]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- SE CREA LA TABLA

CREATE TABLE [LOS_REZAGADOS].[Productos](
	[producto_id] INT IDENTITY(1,1) PRIMARY KEY,
	[producto_precio_unitario] DECIMAL(18,2) NULL,
	[subcategoria_id] INT,
	[producto_marca] INT,
	[producto_descripcion] NVARCHAR(255) NULL,
	[producto_nombre] NVARCHAR(255) NULL
) ON [PRIMARY]
GO

-- SE MIGRAN LOS DATOS

INSERT INTO [LOS_REZAGADOS].[Productos] ([producto_precio_unitario], [producto_marca], [producto_descripcion], [producto_nombre])
SELECT DISTINCT
    dato.[PRODUCTO_PRECIO],
	--falta subcategoria
    m.marca_id,
    dato.[PRODUCTO_DESCRIPCION],
    dato.[PRODUCTO_NOMBRE]
FROM 
    [gd_esquema].[Maestra] dato
    INNER JOIN Marcas m ON dato.[PRODUCTO_MARCA] = m.marca_descripcion
WHERE 
    dato.[PRODUCTO_NOMBRE] IS NOT NULL;

-- Productos - END
