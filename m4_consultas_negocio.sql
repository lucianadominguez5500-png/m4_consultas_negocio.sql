
-- CONSULTA 1: Resumen ejecutivo mensual
-- Total facturado, cantidad de pedidos y ticket promedio por mes.

SELECT 
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    ROUND(AVG(CAST(cantidad * precio_unitario AS DECIMAL(10,2))), 2) AS ticket_promedio
FROM 
    ventas
GROUP BY 
    MONTH(fecha_venta)
ORDER BY 
    mes ASC;

-- CONSULTA 2: Ranking de productos (Top 5)
-- Top 5 de productos que generaron mayores ingresos.

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM 
    ventas
GROUP BY 
    id_producto
ORDER BY 
    total_generado DESC;

-- CONSULTA 3: Clientes recurrentes
-- Clientes con más de un pedido realizado y su gasto acumulado.

SELECT 
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM 
    ventas
GROUP BY 
    id_cliente
HAVING 
    COUNT(*) > 1
ORDER BY 
    total_gastado DESC;

-- CONSULTA 4: Meses por encima/por debajo del promedio
-- Compara el total de cada mes contra el promedio de facturación general.

WITH VentasMensuales AS (
    SELECT 
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_mes
    FROM 
        ventas
    GROUP BY 
        MONTH(fecha_venta)
),
PromedioGeneral AS (
    SELECT 
        AVG(CAST(total_mes AS DECIMAL(10,2))) AS promedio_mensual
    FROM 
        VentasMensuales
)
SELECT 
    vm.mes,
    vm.total_mes,
    ROUND(pg.promedio_mensual, 2) AS promedio_referencia,
    CASE 
        WHEN vm.total_mes > pg.promedio_mensual THEN 'Por encima'
        ELSE 'Por debajo'
    END AS rendimiento_vs_promedio
FROM 
    VentasMensuales vm
CROSS JOIN 
    PromedioGeneral pg
ORDER BY 
    vm.mes ASC;

-- BLOQUE DE CIERRE: HALLAZGOS CLAVE DE NEGOCIO (Ejemplos para completar)

-- Hallazgo 1: Concentración en Top 5
-- Al revisar el ranking de la Consulta 2, se observa que los 5 productos más vendidos 
-- concentran más del 50% de la facturación total.

-- Hallazgo 2: Comportamiento de clientes recurrentes
-- La Consulta 3 refleja que los clientes recurrentes realizan compras con un 
-- ticket promedio más alto que el de clientes esporádicos.

-- Hallazgo 3: Rendimiento mensual vs Promedio
-- La Consulta 4 muestra que durante la segunda mitad del año la mayoría de los meses 
-- quedan etiquetados como 'Por encima' del promedio general.
