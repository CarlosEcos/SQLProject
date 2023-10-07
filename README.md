# Data Analysis Project 1
Proyecto end-to-end de análisis de datos desarrollado en SQL y Power BI.
Este proyecto consistió en la carga y posterior análisis (3 queries) de una base de datos de los empleados artificial creada para MySQL. Se desarrollaron 3 archivos en SQL Server:
1.	Creación del modelo (*database_creation*): En esta query se crearon las tablas y relaciones diseñadas en el modelo de datos. Se crearon 6 tablas y 2 vistas en total. Finalmente, se cargaron los datos de cada tabla desde su respectivo archivo base en CSV haciendo uso del comando BULK INSERT (utilizado para la carga de grandes cantidades de filas).
2.	Obtención de información de puestos de un determinado número de años (*n_years_data*): La información obtenida en esta etapa es un paso intermedio para una de las queries finales (evolución temporal del número de empleados por departamento), pero al ser dependiente del número de años de los que se quiera obtener la información, se decidió encapsularlo en un procedimiento de SQL. En este paso predomina el uso de JOIN y subqueries.
3.	Análisis de la información (*data_analysis*): En este paso final se realizan 3 queries para analizar diferentes tendencias de los datos:
    - Primero se obtiene el número de empleados de los últimos 10 años (se utiliza el procedimiento creado en el paso 2), segmentándolos por género y departamento al que pertenezcan.
    - En la segunda query se analiza el salario promedio en cada año, y de igual forma que en la primera query, se utiliza una segmentación por género y departamento.
    - En la última query se obtiene el número total de empleados en cada año según su puesto y departamento.
    
Los resultados de cada una de las queries fueron plasmados en un reporte interactivo desarrollado en Power BI, al cual se puede acceder mediante [Dashboard](https://app.powerbi.com/view?r=eyJrIjoiZjE1NmIzNDgtMzFjMC00OThkLWE5ZDYtNmFjYjdjYjkzNzlhIiwidCI6IjFlYmE0NDNmLTIzZTUtNDUzNC05MGQxLTA5NzZhYWJlODZhYyIsImMiOjR9) 
