-- Promocion_x_venta - BEGIN
USE [GD1C2024]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- SE CREA LA TABLA
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Promocion_x_venta')
CREATE TABLE [LOS_REZAGADOS].[Promocion_x_venta] (
  cod_promocion DECIMAL(18, 0),
  ticket_id DECIMAL (18, 0),
  producto_id DECIMAL (18, 2),
  PRIMARY KEY (cod_promocion, ticket_id, producto_id)
)
GO

-- DEFINIMOS COMO FKS
--ALTER TABLE [LOS_REZAGADOS].[Promocion_x_venta]
--ADD FOREIGN KEY (cod_promocion) REFERENCES [LOS_REZAGADOS].Promocion(pcod_promocion);

--ALTER TABLE [LOS_REZAGADOS].[Promocion_x_venta]
--ADD FOREIGN KEY (ticket_id) REFERENCES [LOS_REZAGADOS].Tickets_Venta_x_Producto(ticket_id);

--ALTER TABLE [LOS_REZAGADOS].[Promocion_x_venta]
--ADD FOREIGN KEY (producto_id) REFERENCES [LOS_REZAGADOS].Tickets_Venta_x_Producto(producto_id);


-- SE MIGRAN LOS DATOS

-- TODO

-- Promocion_x_venta - END

