-- Medios_De_Pago - BEGIN
USE [GD1C2024]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- SE CREA LA TABLA

CREATE TABLE [LOS_REZAGADOS].[Medios_De_Pago](
	[medio_de_pago_id] INT IDENTITY(1,1) PRIMARY KEY,
	[descripcion] NVARCHAR(255) NULL,
	[tipo_id] INT
) ON [PRIMARY]
GO

-- DEFINIMOS PAGO_TIPO_MEDIO_PAGO COMO FK

ALTER TABLE [LOS_REZAGADOS].[Productos]
ADD CONSTRAINT FK_Producto_Marca
FOREIGN KEY (producto_marca)
REFERENCES [LOS_REZAGADOS].[Marcas] (marca_id);
GO

-- SE MIGRAN LOS DATOS

INSERT INTO [LOS_REZAGADOS].[Medios_De_Pago] ([descripcion], [tipo_id])
SELECT
    dato.[PAGO_MEDIO_PAGO],
    tmp.tipo_id
FROM 
    [gd_esquema].[Maestra] dato
    INNER JOIN Tipos_Medio_Pago tmp ON dato.[PAGO_TIPO_MEDIO_PAGO] = tmp.tipo_descripcion
WHERE 
    dato.[PAGO_TIPO_MEDIO_PAGO] IS NOT NULL;

-- Medios_De_Pago - END