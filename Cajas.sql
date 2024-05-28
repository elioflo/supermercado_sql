-- Cajas - BEGIN
USE [GD1C2024]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- SE CREA LA TABLA

CREATE TABLE [LOS_REZAGADOS].[Cajas](
	[caja_id] INT IDENTITY(1,1) PRIMARY KEY,
    [caja_numero] decimal(18,0) NULL,
    [caja_tipo] [nvarchar](255) NULL,
    [sucursal_id] INT
) ON [PRIMARY]
GO

-- DEFINIMOS SUCURSAL_ID COMO FK

ALTER TABLE [LOS_REZAGADOS].[Cajas]
ADD CONSTRAINT FK_Cajas_Sucursales
FOREIGN KEY (sucursal_id)
REFERENCES [LOS_REZAGADOS].[Sucursales] (sucursal_id);

GO

-- SE MIGRAN LOS DATOS

INSERT INTO [LOS_REZAGADOS].[Cajas] ([caja_numero],[caja_tipo],[sucursal_id])
select 
	dato.CAJA_NUMERO,
	dato.CAJA_TIPO,
	sucursal.sucursal_id
from gd_esquema.Maestra dato
left join LOS_REZAGADOS.Sucursales sucursal on localidad.localidad_descripcion = dato.CLIENTE_LOCALIDAD
where dato.CLIENTE_DNI IS NOT NULL;

-- Cajas - END