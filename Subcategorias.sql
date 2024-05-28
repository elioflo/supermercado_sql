-- Subcategorias - BEGIN
USE [GD1C2024]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- SE CREA LA TABLA

CREATE TABLE [LOS_REZAGADOS].[Subcategorias](
	[subcategoria_id] INT IDENTITY(1,1) PRIMARY KEY,
    [subcategoria_descripcion] [nvarchar](255) NULL,
    [categoria_id] INT
) ON [PRIMARY]
GO

-- DEFINIMOS CATEGORIA_ID COMO FK

ALTER TABLE [LOS_REZAGADOS].[Subcategorias]
ADD CONSTRAINT FK_Subcategorias_Categorias
FOREIGN KEY (categoria_id)
REFERENCES [LOS_REZAGADOS].[Categorias] (categoria_id);

GO

-- SE MIGRAN LOS DATOS

INSERT INTO [LOS_REZAGADOS].[Subcategorias] ([subcategoria_descripcion],[categoria_id])
select 
	dato.PRODUCTO_SUB_CATEGORIA,
	categoria.categoria_id
from gd_esquema.Maestra dato
left join LOS_REZAGADOS.Categorias categoria on localidad.localidad_descripcion = dato.CLIENTE_LOCALIDAD
where dato.CLIENTE_DNI IS NOT NULL;

-- Subcategorias - END