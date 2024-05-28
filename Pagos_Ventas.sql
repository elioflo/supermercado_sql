-- Pagos_Venta - BEGIN
USE [GD1C2024]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- SE CREA LA TABLA
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Pagos_Ventas')
CREATE TABLE [LOS_REZAGADOS].[Pagos_Ventas] (
  nro_pago DECIMAL (18, 0) PRIMARY KEY,
  pago_fecha_hora DATETIME,
  ticket_id DECIMAL (18, 0), -- FK
  detalle_id DECIMAL (18, 0), -- FK
  medio_de_pago_id DECIMAL (18, 0), -- FK
  cod_descuento_id DECIMAL (18, 0), -- FK
  pago_importe DECIMAL (18, 0),
)
GO

-- DEFINIMOS COMO FKS
--ALTER TABLE [LOS_REZAGADOS].[Pagos_Ventas]
--ADD FOREIGN KEY (ticket_id) REFERENCES [LOS_REZAGADOS].Tickets_VentaClientes(ticket_numero);

--ALTER TABLE [LOS_REZAGADOS].[Pagos_Ventas]
--ADD FOREIGN KEY (detalle_id) REFERENCES [LOS_REZAGADOS].Detalles_pagos(detalle_id);

--ALTER TABLE [LOS_REZAGADOS].[Pagos_Ventas]
--ADD FOREIGN KEY (medio_de_pago_id) REFERENCES [LOS_REZAGADOS].Medios_de_pago(medio_de_pago_id);

--ALTER TABLE [LOS_REZAGADOS].[Pagos_Ventas]
--ADD FOREIGN KEY (cod_descuento_id) REFERENCES [LOS_REZAGADOS].Descuentos(descuento_id);


-- SE MIGRAN LOS DATOS

-- INSERT INTO [LOS_REZAGADOS].[Pagos_Ventas] ([pago_importe],[pago_fecha_hora],[envio_hora_fin],[envio_costo],[envio_fecha_entrega])
-- select distinct
-- 	dato.PAGO_IMPORTE,
-- 	dato.PAGO_FECHA
-- from gd_esquema.Maestra dato;
-- GO

-- Pagos_Venta - END

