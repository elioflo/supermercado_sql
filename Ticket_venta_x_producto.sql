-- Ticket_venta_x_producto - BEGIN
USE [GD1C2024]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- SE CREA LA TABLA
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Ticket_venta_x_producto')
CREATE TABLE [LOS_REZAGADOS].[Ticket_venta_x_producto] (
  ticket_id DECIMAL(18, 0),
  producto_id DECIMAL(18,0),
  ticket_det_cantidad DECIMAL (18, 0),
  ticket_det_precio DECIMAL (18, 2),
  ticket_det_total DECIMAL (18, 2),
  promo_aplicada_descuento DECIMAL (18, 2),
  PRIMARY KEY (ticket_id, producto_id)
)
GO

-- DEFINIMOS COMO FKS
--ALTER TABLE [LOS_REZAGADOS].[Ticket_venta_x_producto]
--ADD FOREIGN KEY (ticket_id) REFERENCES [LOS_REZAGADOS].Tickets_Venta(ticket_id);

--ALTER TABLE [LOS_REZAGADOS].[Ticket_venta_x_producto]
--ADD FOREIGN KEY (producto_id) REFERENCES [LOS_REZAGADOS].Productos(producto_id);


-- SE MIGRAN LOS DATOS

-- INSERT INTO [LOS_REZAGADOS].[Ticket_venta_x_producto] ([ticket_det_cantidad],[ticket_det_precio],[ticket_det_total],[promo_aplicada_descuento])
-- select distinct
-- 	dato.TICKET_DET_CANTIDAD,
-- 	dato.TICKET_DET_PRECIO,
-- 	dato.TICKET_DET_TOTAL,
-- 	ISNULL(dato.PROMO_APLICADA_DESCUENTO, 0)
-- from gd_esquema.Maestra dato;
-- GO

-- Ticket_venta_x_producto - END

