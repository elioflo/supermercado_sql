USE [GD1C2024]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS(SELECT [name]
FROM sys.tables
WHERE [name] = 'Detalles_pagos')
CREATE TABLE [LOS_REZAGADOS].[Detalles_pagos]
(
	detalle_id DECIMAL (18, 0) PRIMARY KEY,
	cliente DECIMAL (18, 0),-- FK
	detalle_nro_tarjeta DECIMAL (18, 0),
	detalle_vencimiento DECIMAL (18, 0),
	detalle_cuotas DECIMAL (18, 0),
)
GO

ALTER TABLE [LOS_REZAGADOS].[Pagos_Ventas]
ADD FOREIGN KEY (detalle) REFERENCES [LOS_REZAGADOS].Detalles_pagos(detalle_id);
GO

ALTER TABLE [LOS_REZAGADOS].[Detalles_pagos]
ADD FOREIGN KEY (cliente) REFERENCES [LOS_REZAGADOS].Clientes(cliente_id);
GO

INSERT INTO [LOS_REZAGADOS].[Detalles_pagos]
	(
	cliente,
	detalle_nro_tarjeta,
	detalle_vencimiento,
	detalle_cuotas
	)
SELECT DISTINCT C.client_id, M.PAGO_TARJETA_NRO, M.PAGO_TARJETA_FECHA_VENC, M.PAGO_TARJETA_CUOTAS
FROM gd_esquema.Maestra M
LEFT JOIN LOS_REZAGADOS.Clients C
	ON C.cliente_nombre = M.CLIENTE_NOMBRE
	AND C.cliente_apellido = M.CLIENTE_APELLIDO
	AND C.cliente_dni = M.CLIENTE_DNI
WHERE M.PAGO_TARJETA_NRO IS NOT NULL
	AND M.PAGO_TARJETA_FECHA_VENC IS NOT NULL
	AND M.PAGO_TARJETA_CUOTAS IS NOT NULL
