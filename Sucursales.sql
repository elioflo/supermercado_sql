-- Sucursales - BEGIN
USE [GD1C2024]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- SE CREA LA TABLA

CREATE TABLE [LOS_REZAGADOS].[Sucursales](
	[sucursal_id] INT IDENTITY(1,1) PRIMARY KEY,
    [supermercado_id] INT,
    [sucursal_nombre] [nvarchar](255) NULL,
    [sucursal_localidad] INT,
    [sucursal_direccion] [nvarchar](255) NULL
) ON [PRIMARY]
GO

-- DEFINIMOS LOCALIDAD_ID COMO FK y SUPERMERCADO_ID COMO FK

ALTER TABLE [LOS_REZAGADOS].[Sucursales]
ADD CONSTRAINT FK_Sucursales_Localidades
FOREIGN KEY (sucursal_localidad)
REFERENCES [LOS_REZAGADOS].[Localidades] (localidad_id);

ALTER TABLE [LOS_REZAGADOS].[Sucursales]
ADD CONSTRAINT FK_Sucursales_Supermercados
FOREIGN KEY (supermercado_id)
REFERENCES [LOS_REZAGADOS].[Supermercados] (supermercado_id);
GO

-- SE MIGRAN LOS DATOS

INSERT INTO [LOS_REZAGADOS].[Sucursales] ([sucursal_nombre],[sucursal_localidad],[sucursal_direccion],[supermercado_id])
select 
	dato.SUCURSAL_NOMBRE_NOMBRE,
	localidad.localidad_id,
	dato.SUCURSAL_DIRECCION,
	supermercado.supermercado_id,
	
from gd_esquema.Maestra dato
left join LOS_REZAGADOS.Localidades localidad on localidad.localidad_descripcion = dato.CLIENTE_LOCALIDAD
where dato.CLIENTE_DNI IS NOT NULL;

-- Sucursales - END