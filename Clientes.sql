-- CLIENTES - BEGIN
USE [GD1C2024]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- SE CREA LA TABLA

CREATE TABLE [LOS_REZAGADOS].[Clientes](
	[cliente_id] INT IDENTITY(1,1) PRIMARY KEY,
	[cliente_nombre] [nvarchar](255) NULL,
    [cliente_apellido] [nvarchar](255) NULL,
    [cliente_dni] decimal(18,0) NULL,
    [cliente_fecha_registro] datetime NULL,
    [cliente_telefono] decimal(18,0) NULL,
    [cliente_mail] [nvarchar](255) NULL,
    [cliente_fecha_nacimiento] datetime NULL,
    [cliente_domicilio] [nvarchar](255) NULL,
    [cliente_localidad] INT,
) ON [PRIMARY]
GO

-- DEFINIMOS PROVINCIA_ID COMO FK

ALTER TABLE [LOS_REZAGADOS].[Clientes]
ADD CONSTRAINT FK_Clientes_Localidades
FOREIGN KEY (cliente_localidad)
REFERENCES [LOS_REZAGADOS].[Localidades] (localidad_id);
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

-- CLIENTES - END