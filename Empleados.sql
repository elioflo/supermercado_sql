-- EMPLEADOS - BEGIN

USE [GD1C2024]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- SE CREA LA TABLA

CREATE TABLE [LOS_REZAGADOS].[Empleados](
	[empleado_id] INT IDENTITY(1,1) PRIMARY KEY,
	[empleado_nombre] [nvarchar](255) NULL,
    [empleado_apellido] [nvarchar](255) NULL,
    [empleado_dni] decimal(18,0) NULL,
    [empleado_fecha_registro] datetime NULL,
    [empleado_telefono] decimal(18,0) NULL,
    [empleado_mail] [nvarchar](255) NULL,
    [empleado_fecha_nacimiento] datetime NULL,
) ON [PRIMARY]
GO

-- SE MIGRAN LOS DATOS

-- INSERT INTO [LOS_REZAGADOS].[Empleados] ([empleado_nombre],[empleado_apellido],[empleado_dni],[empleado_fecha_registro],[empleado_telefono],[empleado_mail],[empleado_fecha_nacimiento])
-- select distinct
-- 	dato.EMPLEADO_NOMBRE,
-- 	dato.EMPLEADO_APELLIDO,
-- 	dato.EMPLEADO_DNI,
-- 	dato.EMPLEADO_FECHA_REGISTRO,
-- 	dato.EMPLEADO_TELEFONO,
-- 	dato.EMPLEADO_MAIL,
-- 	dato.EMPLEADO_FECHA_NACIMIENTO
-- from gd_esquema.Maestra dato
-- where dato.EMPLEADO_DNI is not null;

-- EMPLEADOS - END