SELECT DISTINCT
   CASE countycode
      WHEN 'AB' THEN '01' --Stockholms län
	  WHEN 'C' THEN '03' -- Uppsala län
	  WHEN 'D' THEN '04' -- Södermanlands län
	  WHEN 'E' THEN '05' -- Östergötlands län
	  WHEN 'F' THEN '06' -- Jönköpings län
	  WHEN 'G' THEN '07' -- Kronobergs län
	  WHEN 'H' THEN '08' -- Kalmar län
	  WHEN 'I' THEN '09' -- Gotlands län
	  WHEN 'K' THEN '10' -- Blekinge län
	  WHEN 'M' THEN '12' -- Skåne län
	  WHEN 'N' THEN '13' -- Hallands län
	  WHEN 'O' THEN '14' -- Västra Götalands län
	  WHEN 'S' THEN '17' -- Värmlands län
	  WHEN 'T' THEN '18' -- Örebro län
	  WHEN 'U' THEN '19' -- Västmanlands län
	  WHEN 'W' THEN '20' -- Dalarnas län
	  WHEN 'X' THEN '21' -- Gävleborgs län
	  WHEN 'Y' THEN '22' -- Västernorrlands län
	  WHEN 'Z' THEN '23' -- Jämtlands län
	  WHEN 'AC' THEN '24' -- Västerbottens län
	  WHEN 'BD' THEN '25' -- Norrbottens län
      ELSE 'error'
   END AS 'key', county AS 'value'
   FROM kontrollansvarig
   WHERE enabled = 1
   ORDER BY county