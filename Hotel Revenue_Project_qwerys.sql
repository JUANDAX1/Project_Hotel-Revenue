
Jpierre Data Analist -> https://juandax1.github.io/


  -- --- 
  -- crearemos primero una única tabla temporal
  -- que combina todos los datos utilizando el siguiente código para facilitar el acceso y el análisis.

  with hotels as (
  select * from dbo.['2018$']
  union all
  select * from dbo.['2019$']
  union all
  select * from dbo.['2020$'])

  select * from hotels


  -- 1 --
  -- consulta para crear el campo Revenue (ingresos) a traves de un calculo
  -- agregando otra columna para sumar el revenue y luego agrupar por año.
  -- alternativa mas eficiente que usar CTE-with--

  SELECT
    arrival_date_year,
    ROUND(SUM((stays_in_week_nights + stays_in_weekend_nights) * adr),0) AS revenue
  FROM
    (
      SELECT * FROM [Project_hotel].[dbo].['2018$']
      UNION ALL
      SELECT * FROM [Project_hotel].[dbo].['2019$']
      UNION ALL
      SELECT * FROM [Project_hotel].[dbo].['2020$']
    ) AS hotels
  GROUP BY
    arrival_date_year
  ORDER BY
    arrival_date_year;


  -- 2 --
  --Respondiendo sobre los espacios de aparcamiento
  --Para obtener el nivel de ingresos multipllicamos la suma de las estancias por el costo 
  --promediodiario de ocupación y se llama a esta columna con el nombre de “revenue”. 
  --Por otro lado, la suma de las estancias se distribuye entre los espacios de aparcamiento 
  --requeridos para obtener en relativo el nivel de ocupación por año y por hotel.

  SELECT
    arrival_date_year, hotel,
    ROUND(SUM((stays_in_week_nights + stays_in_weekend_nights) * adr),0) AS revenue,
    CONCAT( ROUND((SUM(required_car_parking_spaces)/SUM(stays_in_week_nights +
    stays_in_weekend_nights)) * 100, 2), '%') AS parking_percentage
  FROM
    (
      SELECT * FROM [Project_hotel].[dbo].['2018$']
      UNION ALL
      SELECT * FROM [Project_hotel].[dbo].['2019$']
      UNION ALL
      SELECT * FROM [Project_hotel].[dbo].['2020$']
    ) AS hotels 
  GROUP BY
    arrival_date_year, hotel
  ORDER BY
    hotel;



  -- 3 --
  -- consulta que para la conexión a powerBI
  --Aplicaremos dos procedimientos de Joins, uno para generar la columna con los descuentos de 
  --cada segmento y otro para traer el consto de los desayunos. 

  SELECT * FROM
      (
        SELECT * FROM [Project_hotel].[dbo].['2018$']
        UNION ALL
        SELECT * FROM [Project_hotel].[dbo].['2019$']
        UNION ALL
        SELECT * FROM [Project_hotel].[dbo].['2020$']
      ) AS hotels 
  LEFT JOIN dbo.market_segment$
  ON hotels.market_segment = market_segment$.market_segment
  LEFT JOIN dbo.meal_cost$
  ON hotels.meal = meal_cost$.meal


