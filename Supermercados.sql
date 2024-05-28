-- Supermercados - BEGIN
USE [GD1C2024]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- SE CREA LA TABLA

CREATE TABLE [LOS_REZAGADOS].[Supermercados](
	[supermercado_id] INT IDENTITY(1,1) PRIMARY KEY,
	[supermercado_nombre] [nvarchar](255) NULL,
    [supermercado_cuit] [nvarchar](255) NULL,
    [supermercado_razon_social] [nvarchar](255) NULL,
    [supermercado_iibb] [nvarchar](255) NULL,
    [supermercado_domicilio] [nvarchar](255) NULL,
    [supermercado_fecha_inicio_act] datetime NULL,
    [super_condicion_fiscal] [nvarchar](255) NULL,
    [supermercado_localidad] INT,
) ON [PRIMARY]
GO

-- DEFINIMOS LOCALIDAD_ID COMO FK

ALTER TABLE [LOS_REZAGADOS].[Supermercados]
ADD CONSTRAINT FK_Supermercados_Localidades
FOREIGN KEY (supermercado_localidad)
REFERENCES [LOS_REZAGADOS].[Localidades] (localidad_id);
GO

-- SE MIGRAN LOS DATOS

INSERT INTO [LOS_REZAGADOS].[Supermercados] ([supermercado_nombre],[supermercado_cuit],[supermercado_razon_social],[supermercado_iibb],[supermercado_domicilio],[supermercado_fecha_inicio_act],[super_condicion_fiscal],[supermercado_localidad])
select 
	dato.SUPER_NOMBRE,
	dato.SUPER_CUIT,
	dato.SUPER_RAZON_SOC,
	dato.SUPER_IIBB,
	dato.SUPER_DOMICILIO,
	dato.SUPER_FECHA_INI_ACTIVIDAD,
	dato.SUPER_CONDICION_FISCAL,
	localidad.localidad_id
from gd_esquema.Maestra dato
left join LOS_REZAGADOS.Localidades localidad on localidad.localidad_descripcion = dato.SUPER_LOCALIDAD
where dato.SUPER_NOMBRE IS NOT NULL
	AND dato.SUPER_CUIT IS NOT NULL
	AND dato.SUPER_RAZON_SOC IS NOT NULL
	AND dato.SUPER_IIBB IS NOT NULL
	AND dato.SUPER_CUIT IS NOT NULL
	AND dato.SUPER_DOMICILIO IS NOT NULL;

-- Supermercados - END