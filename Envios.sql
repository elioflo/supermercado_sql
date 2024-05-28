-- ENVIOS - BEGIN
USE [GD1C2024]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- SE CREA LA TABLA
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Envios')
CREATE TABLE [LOS_REZAGADOS].[Envios] (
  envio_id DECIMAL (18, 0) PRIMARY KEY,
  ticket_id DECIMAL (18, 0), -- FK
  estado_id DECIMAL (18, 0), -- FK
  cliente_id DECIMAL (18, 0), -- FK
  envio_fecha_programada DATETIME,
  envio_hora_inicio DECIMAL (18, 0),
  envio_hora_fin DECIMAL (18, 0),
  envio_costo DECIMAL (18, 2),
  envio_fecha_entrega DATETIME,
)
GO

-- DEFINIMOS COMO FKS
--ALTER TABLE [LOS_REZAGADOS].[Envios]
--ADD FOREIGN KEY (ticket_id) REFERENCES [LOS_REZAGADOS].Tickets_VentaEmpleados(ticket_numero);

--ALTER TABLE [LOS_REZAGADOS].[Envios]
--ADD FOREIGN KEY (estado_id) REFERENCES [LOS_REZAGADOS].Estados_envios(estado_id);

--ALTER TABLE [LOS_REZAGADOS].[Envios]
--ADD FOREIGN KEY (cliente_id) REFERENCES [LOS_REZAGADOS].Clientes(cliente_id);


-- SE MIGRAN LOS DATOS

-- INSERT INTO [LOS_REZAGADOS].[Envios] ([envio_fecha_programada],[envio_hora_inicio],[envio_hora_fin],[envio_costo],[envio_fecha_entrega])
-- select distinct
-- 	dato.ENVIO_FECHA_PROGRAMADA,
-- 	dato.ENVIO_HORA_INICIO,
-- 	dato.ENVIO_HORA_FIN,
-- 	dato.ENVIO_COSTO,
-- 	dato.ENVIO_FECHA_ENTREGA
-- from gd_esquema.Maestra dato;
-- GO

-- ENVIOS - END

