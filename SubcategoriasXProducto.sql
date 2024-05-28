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

INSERT INTO [LOS_REZAGADOS].[Clientes] ([cliente_nombre],[cliente_apellido],[cliente_dni],[cliente_fecha_registro],[cliente_telefono],[cliente_mail],[cliente_fecha_nacimiento],[cliente_domicilio],[cliente_localidad])
select 
	dato.CLIENTE_NOMBRE,
	dato.CLIENTE_APELLIDO,
	dato.CLIENTE_DNI,
	dato.CLIENTE_FECHA_REGISTRO,
	dato.CLIENTE_TELEFONO,
	dato.CLIENTE_MAIL,
	dato.CLIENTE_FECHA_NACIMIENTO,
	dato.CLIENTE_DOMICILIO,
	localidad.localidad_id
from gd_esquema.Maestra dato
left join LOS_REZAGADOS.Localidades localidad on localidad.localidad_descripcion = dato.CLIENTE_LOCALIDAD
where dato.CLIENTE_DNI IS NOT NULL;

-- SubcategoriasXProducto - END