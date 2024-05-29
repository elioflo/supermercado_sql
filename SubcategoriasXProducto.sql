-- SubcategoriasXProducto - BEGIN
USE [GD1C2024]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- SE CREA LA TABLA

CREATE TABLE [LOS_REZAGADOS].[SubcategoriasXProducto](
	[subcategoria_id] INT IDENTITY(1,1) PRIMARY KEY,
    [producto_id] INT IDENTITY(1,1) PRIMARY KEY
) ON [PRIMARY]
GO

-- DEFINIMOS SUBCATEGORIA_ID COMO FK y PRODUCTO_ID COMO FK

ALTER TABLE [LOS_REZAGADOS].[SubcategoriasXProducto]
ADD CONSTRAINT FK_SubcategoriasXProducto_Subcategorias
FOREIGN KEY (subcategoria_id)
REFERENCES [LOS_REZAGADOS].[Subcategorias] (subcategoria_id);

ALTER TABLE [LOS_REZAGADOS].[SubcategoriasXProducto]
ADD CONSTRAINT FK_SubcategoriasXProducto_Productos
FOREIGN KEY (producto_id)
REFERENCES [LOS_REZAGADOS].[Productos] (producto_id);
GO

-- SE MIGRAN LOS DATOS

-- TODO

-- SubcategoriasXProducto - END