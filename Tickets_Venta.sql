-- TICKETS_VENTA - BEGIN
USE [GD1C2024]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- SE CREA LA TABLA
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'Tickets_Venta')
CREATE TABLE [LOS_REZAGADOS].[Tickets_Venta] (
  ticket_id DECIMAL (18, 0) IDENTITY(1,1) PRIMARY KEY,
  ticket_numero DECIMAL (18, 0),
  ticket_fecha_hora DATETIME,
  caja_id DECIMAL(18, 0), -- FK
  empleado_id DECIMAL(18, 0), -- FK
  tipo_comprobante_id DECIMAL(18, 0), --FK
  ticket_sub_total_productos DECIMAL(18, 2),
  ticket_total_descuento DECIMAL(18, 2),
  ticket_total_descuento_aplicado DECIMAL(18, 2),
  ticket_total_descuento_aplicado_mp DECIMAL(18, 2),
  ticket_total_ticket DECIMAL(18, 2),
)
GO

-- DEFINIMOS COMO FKS

--ALTER TABLE [LOS_REZAGADOS].[Tickets_Venta]
--ADD FOREIGN KEY (caja_id) REFERENCES [LOS_REZAGADOS].Cajas(caja_id);

--ALTER TABLE [LOS_REZAGADOS].[Tickets_Venta]
--ADD FOREIGN KEY (empleado_id) REFERENCES [LOS_REZAGADOS].Empleados(empleado_id);

--ALTER TABLE [LOS_REZAGADOS].[Tickets_Venta]
--ADD FOREIGN KEY (tipo_comprobante_id) REFERENCES [LOS_REZAGADOS].Tipos_comprobantes(tipo_comprobante_id);


-- SE MIGRAN LOS DATOS

-- INSERT INTO [LOS_REZAGADOS].[Tickets_Venta] ([ticket_numero],[ticket_fecha_hora],[ticket_sub_total_productos],[ticket_total_descuento_aplicado],[ticket_total_descuento_aplicado_mp],[ticket_total_ticket])
-- select distinct
-- 	dato.TICKET_NUMERO,
-- 	dato.TICKET_FECHA_HORA,
-- 	dato.TICKET_SUBTOTAL_PRODUCTOS,
-- 	dato.TICKET_TOTAL_DESCUENTO_APLICADO,
--   dato.TICKET_TOTAL_DESCUENTO_APLICADO_MP
-- 	dato.TICKET_TOTAL_TICKET
-- from gd_esquema.Maestra dato
-- order by dato.TICKET_NUMERO;
-- GO

-- TICKETS_VENTA - END

