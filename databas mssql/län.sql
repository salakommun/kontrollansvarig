SELECT DISTINCT
   CASE countycode
      WHEN 'AB' THEN '01' --Stockholms l�n
	  WHEN 'C' THEN '03' -- Uppsala l�n
	  WHEN 'D' THEN '04' -- S�dermanlands l�n
	  WHEN 'E' THEN '05' -- �sterg�tlands l�n
	  WHEN 'F' THEN '06' -- J�nk�pings l�n
	  WHEN 'G' THEN '07' -- Kronobergs l�n
	  WHEN 'H' THEN '08' -- Kalmar l�n
	  WHEN 'I' THEN '09' -- Gotlands l�n
	  WHEN 'K' THEN '10' -- Blekinge l�n
	  WHEN 'M' THEN '12' -- Sk�ne l�n
	  WHEN 'N' THEN '13' -- Hallands l�n
	  WHEN 'O' THEN '14' -- V�stra G�talands l�n
	  WHEN 'S' THEN '17' -- V�rmlands l�n
	  WHEN 'T' THEN '18' -- �rebro l�n
	  WHEN 'U' THEN '19' -- V�stmanlands l�n
	  WHEN 'W' THEN '20' -- Dalarnas l�n
	  WHEN 'X' THEN '21' -- G�vleborgs l�n
	  WHEN 'Y' THEN '22' -- V�sternorrlands l�n
	  WHEN 'Z' THEN '23' -- J�mtlands l�n
	  WHEN 'AC' THEN '24' -- V�sterbottens l�n
	  WHEN 'BD' THEN '25' -- Norrbottens l�n
      ELSE 'error'
   END AS 'key', county AS 'value'
   FROM kontrollansvarig
   WHERE enabled = 1
   ORDER BY county