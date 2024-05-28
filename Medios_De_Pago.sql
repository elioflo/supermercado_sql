-- Medios_De_Pago - BEGIN
USE [GD1C2024]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- SE CREA LA TABLA

CREATE TABLE Medios_De_Pago(
	[medio_de_pago_id] INT IDENTITY(1,1) PRIMARY KEY,
	[descripcion] NVARCHAR(255) NULL,
	[tipo_id] INT
) ON [PRIMARY]
GO

-- DEFINIMOS PAGO_MEDIO_PAGO COMO FK

ALTER TABLE [Medios_De_Pago]
ADD CONSTRAINT FK_Tipos_Medio_Pago
FOREIGN KEY (tipo_id)
REFERENCES [Tipos_Medio_pago] (tipo_id);
GO

-- SE MIGRAN LOS DATOS

INSERT INTO [Medios_De_Pago]([descripcion], [tipo_id])
SELECT dato.[PAGO_MEDIO_PAGO],
	(SELECT tipo_id FROM Tipos_Medio_Pago tmp WHERE tmp.tipo_descripcion = dato.[PAGO_TIPO_MEDIO_PAGO]) AS medio_pago_id
FROM [gd_esquema].[Maestra] dato
WHERE [PAGO_TIPO_MEDIO_PAGO] IS NOT NULL

-- Medios_De_Pago - END