# Supermercado

- [x]  Provincias
- [x]  Localidades (necesita provincia antes)
- [x]  Clientes (necesita localidad antes)
- [ ]  Detalles_pagos (necesita cliente antes)
- [ ]  Supermercado (necesita localidades antes)
- [ ]  Sucursales (necesita supermercado y localidades antes)
- [ ]  Cajas (necesita sucursal antes)
- [ ]  Tipos_comprobantes
- [ ]  Promocion
- [ ]  Reglas
- [ ]  PromocionPorRegla (necesita Promocion y Reglas antes)
- [ ]  Empleados
- [ ]  Tickets_Venta (necesita cajas, empleado y tipos_comprobante antes)
- [ ]  Marcas
- [ ]  Productos (necesita marcas antes) (aclaracion subcategoria_id no deberia estar en productos)
- [ ]  PromocionPorProductos (necesita Promocion y Productos antes)
- [ ]  Ticket_VentaPorProducto (necesita Tickets_Venta y productos antes)
- [ ]  PromocionPorVenta (necesita Ticket_VentaPorProducto y Promocion antes) (aclaracion ticket_numero no es necesario)
- [ ]  Categorias
- [ ]  Subcategorias (necesita categorias antes)
- [ ]  SubcategoriaPorProducto (necesita subcategoria y productos antes)
- [ ]  Estados_envios
- [ ]  Envios (necesita Tickets_Venta, Estados_envios y Clientes antes)
- [ ]  Tipos_Medio_Pago
- [ ]  Medios_De_Pago (necesita Tipos_Medio_Pago antes)
- [ ]  Pagos_Venta (necesita Medios_De_Pago, Detalles_pagos y Tickets_Venta antes)
- [ ]  Descuentos

