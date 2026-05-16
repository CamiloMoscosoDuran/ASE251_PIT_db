CREATE DATABASE AgroPlan;
GO
USE AgroPlan;
GO

---
--- 1. TABLA: CAMPOS
---
CREATE TABLE campos (
    id_campo INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(200),
    hectareas INT,
    estado VARCHAR(30),
    fecha_creacion DATETIME2 DEFAULT GETDATE()
);
GO

---
--- 2. TABLA: CULTIVOS
---
CREATE TABLE cultivos (
    id_cultivo INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(500),
    temporada_siembra VARCHAR(50),
    dias_cosecha INT,
    estado VARCHAR(30),
    fecha_creacion DATETIME2 DEFAULT GETDATE()
);
GO

---
--- 3. TABLA: PLANIFICACIÓN DE SIEMBRA
---
CREATE TABLE planificacion_siembra (
    id_siembra INT IDENTITY(1,1) PRIMARY KEY,
    id_campo INT FOREIGN KEY REFERENCES campos(id_campo),
    id_cultivo INT FOREIGN KEY REFERENCES cultivos(id_cultivo),
    fecha_siembra DATE NOT NULL,
    hectareas INT NOT NULL,
    estado char(1) NOT NULL DEFAULT 1, 
    created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME2,
    deleted_at DATETIME2,
    restored_at DATETIME2
);
GO

---
--- 4. TABLA: LOTES / SECTORES DE CULTIVO (El estado actual en el Dashboard)
---
CREATE TABLE estado_cultivo (
    id_estado_cultivo INT IDENTITY(1,1) PRIMARY KEY,
    id_campo INT FOREIGN KEY REFERENCES campos(id_campo),
    id_cultivo INT FOREIGN KEY REFERENCES cultivos(id_cultivo),
    hectareas DECIMAL(10,2) NOT NULL,      -- Ej: 33ha, 12ha
    fase_actual VARCHAR(50),               -- Ej: 'Floración', 'Maduración', 'En letargo'
    estado_salud VARCHAR(30),              -- Ej: 'Óptimo', 'Atención', 'Letargo'
    dias_proxima_accion INT                -- Ej: 45, 22, 62 días
);
GO

---
--- 5. TABLA: PLANIFICACIÓN DE COSECHA
---
CREATE TABLE planificacion_cosecha (
    id_cosecha INT IDENTITY(1,1) PRIMARY KEY,
    id_campo INT FOREIGN KEY REFERENCES campos(id_campo),
    id_cultivo INT FOREIGN KEY REFERENCES cultivos(id_cultivo),
    fecha_recomendada DATE NOT NULL,
    hectareas DECIMAL(10,2) NOT NULL,
    estado VARCHAR(30) NOT NULL,           -- Ej: 'En Planificación', 'Pendiente', 'En letargo', 'Proyectando'
    fecha_creacion DATETIME2 DEFAULT GETDATE()
);
GO

---
--- 6. TABLA: CALENDARIO INTELIGENTE (Eventos de la finca)
---
CREATE TABLE eventos_calendario (
    id_evento INT IDENTITY(1,1) PRIMARY KEY,
    id_campo INT FOREIGN KEY REFERENCES campos(id_campo),
    id_cultivo INT FOREIGN KEY REFERENCES cultivos(id_cultivo),
    fecha DATE NOT NULL,
    tipo_evento VARCHAR(30) NOT NULL,      -- Ej: 'Siembra', 'Cosecha', 'Riego', 'Fertilización'
    hectareas DECIMAL(10,2),
    estado VARCHAR(30),
    descripcion NVARCHAR(250)
);
GO

---
--- 7. TABLA: ALERTAS (Historial y alertas activas en pantalla)
---
CREATE TABLE alertas (
    id_alerta INT IDENTITY(1,1) PRIMARY KEY,
    id_campo INT FOREIGN KEY REFERENCES campos(id_campo),
    id_cultivo INT FOREIGN KEY REFERENCES cultivos(id_cultivo), -- Puede ser NULL si es alerta general
    tipo_alerta VARCHAR(30) NOT NULL,      -- Ej: 'Peligro', 'Información', 'Éxito', 'Advertencia'
    titulo VARCHAR(100) NOT NULL,          -- Ej: 'Riesgo de helada leve'
    mensaje NVARCHAR(500) NOT NULL,        -- Ej: 'Temperatura mínima proyectada 8°C...'
    fecha_alerta DATE NOT NULL,
    activa BIT DEFAULT 1                   -- 1 = Activa, 0 = Archivada
);
GO

---
--- 8. TABLA: REPORTES FINANCIEROS Y DE PRODUCCIÓN
---
CREATE TABLE reportes_historicos (
    id_reporte INT IDENTITY(1,1) PRIMARY KEY,
    id_campo INT FOREIGN KEY REFERENCES campos(id_campo),
    id_cultivo INT FOREIGN KEY REFERENCES cultivos(id_cultivo),
    mes INT NOT NULL,                      -- 1 al 12
    anio INT NOT NULL,                     -- Ej: 2026
    produccion_ton DECIMAL(10,2) NOT NULL, -- Toneladas producidas
    ingresos DECIMAL(12,2) NOT NULL,       -- S/. Ingresos
    gastos DECIMAL(12,2) NOT NULL          -- S/. Gastos
);
GO

---
--- 1. INSERTS PARA: campos
---
INSERT INTO campos (nombre, ubicacion, hectareas, estado) VALUES
('Fundo Los Olivos', 'Valle de Ica, Ica', 120, 'Activo'),
('Fundo Santa Rosa', 'Chanchamayo, Junín', 85, 'Activo'),
('Parcela El Mirador', 'Chao, La Libertad', 50, 'Mantenimiento'),
('Fundo Tambo Alto', 'Majes, Arequipa', 200, 'Activo'),
('Fundo La Agraria', 'Huaral, Lima', 65, 'Activo');
GO

---
--- 2. INSERTS PARA: cultivos
---
INSERT INTO cultivos (nombre, descripcion, temporada_siembra, dias_cosecha, estado) VALUES
('Arándano Biloxi', 'Variedad de arándano de alta densidad para exportación', 'Otoño - Invierno', 180, 'Activo'),
('Palto Hass', 'Palta destinada a mercados europeos y americanos', 'Primavera', 365, 'Activo'),
('Café Caturra', 'Café de altura con notas achocolatadas', 'Inicio de lluvias', 270, 'Activo'),
('Espárrago Verde', 'Cultivo permanente de alto rendimiento hídrico', 'Todo el año', 120, 'Activo'),
('Maíz Amarillo', 'Maíz duro destinado a la industria forrajera', 'Verano', 110, 'Activo');
GO

---
--- 3. INSERTS PARA: planificacion_siembra
--- (Usa id_campo del 1 al 5 y id_cultivo del 1 al 5)
---
INSERT INTO planificacion_siembra (id_campo, id_cultivo, fecha_siembra, hectareas, estado) VALUES
(1, 1, '2026-02-15', 30, '1'),
(2, 3, '2026-03-01', 45, '1'),
(4, 5, '2026-04-10', 80, '1'),
(5, 4, '2026-01-20', 25, '1'),
(3, 2, '2026-05-01', 15, '1');
GO

---
--- 4. INSERTS PARA: estado_cultivo
---
INSERT INTO estado_cultivo (id_campo, id_cultivo, hectareas, fase_actual, estado_salud, dias_proxima_accion) VALUES
(1, 1, 30.00, 'Floración', 'Óptimo', 15),
(2, 3, 45.50, 'Maduración', 'Atención', 7),
(4, 5, 80.00, 'Crecimiento Vegetativo', 'Óptimo', 22),
(5, 4, 25.00, 'Cosecha', 'Óptimo', 2),
(3, 2, 15.00, 'En letargo', 'Letargo', 60);
GO
Select * from planificacion_cosecha;
---
--- 5. INSERTS PARA: planificacion_cosecha
---
INSERT INTO planificacion_cosecha (id_campo, id_cultivo, fecha_recomendada, hectareas, estado) VALUES
(5, 4, '2026-05-20', 25.00, '1'),
(1, 1, '2026-08-15', 30.00, '1'),
(4, 5, '2026-07-30', 80.00, '1'),
(2, 3, '2026-11-25', 45.50, '1'),
(3, 2, '2027-05-01', 15.00, '1');
-- NOTA: Corregí el nombre de la columna "fecha_recomendada" a "fecha_recommended" 
-- debido a que en tu script original pusiste "fecha_recommended" en la declaración.
GO

---
--- 6. INSERTS PARA: eventos_calendario
---
INSERT INTO eventos_calendario (id_campo, id_cultivo, fecha, tipo_evento, hectareas, estado, descripcion) VALUES
(1, 1, '2026-05-18', 'Riego', 30.00, 'Programado', 'Aplicación de riego por goteo con nutrientes'),
(2, 3, '2026-05-22', 'Fertilización', 45.50, 'Pendiente', 'Refuerzo de potasio para etapa de maduración'),
(5, 4, '2026-05-20', 'Cosecha', 25.00, 'Programado', 'Corte de espárrago verde primera calidad'),
(4, 5, '2026-06-01', 'Monitoreo', 80.00, 'Planificado', 'Evaluación de control de plagas (cogollero)'),
(3, 2, '2026-05-25', 'Poda', 15.00, 'Pendiente', 'Poda de formación sanitaria');
GO

---
--- 7. INSERTS PARA: alertas
---
INSERT INTO alertas (id_campo, id_cultivo, tipo_alerta, titulo, mensaje, fecha_alerta, activa) VALUES
(4, 5, 'Advertencia', 'Riesgo de helada leve', 'Temperatura mínima proyectada 8°C en Majes. Tomar previsiones.', '2026-05-16', 1),
(2, 3, 'Peligro', 'Presencia de Roya', 'Detectado foco de roya amarilla en el lote este del cafetal.', '2026-05-14', 1),
(1, 1, 'Éxito', 'Riego Completado', 'Ciclo de fertirriego automatizado ejecutado correctamente.', '2026-05-15', 0),
(5, 4, 'Información', 'Disponibilidad de personal', 'Cuadrilla de cosecha confirmada para el día 20/05.', '2026-05-16', 1),
(3, NULL, 'Advertencia', 'Mantenimiento de Canales', 'Corte programado de agua de regadío por la junta de usuarios.', '2026-05-18', 1);
-- NOTA: El quinto insert deja el id_cultivo en NULL como lo especificaste para alertas generales.
GO

---
--- 8. INSERTS PARA: reportes_historicos
---
INSERT INTO reportes_historicos (id_campo, id_cultivo, mes, anio, produccion_ton, ingresos, gastos) VALUES
(1, 1, 4, 2026, 45.20, 180500.00, 65000.00),
(2, 3, 3, 2026, 12.80, 95000.00, 42000.00),
(4, 5, 2, 2026, 120.00, 84000.00, 39000.00),
(5, 4, 4, 2026, 35.00, 140000.00, 55000.00),
(3, 2, 1, 2026, 0.00, 0.00, 12000.00); 
-- NOTA: El último reporte simula un campo en mantenimiento/letargo (solo gastos, sin producción ni ingresos).
GO
Select * from planificacion_siembra;