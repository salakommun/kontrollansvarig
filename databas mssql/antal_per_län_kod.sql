SELECT countycode, count(countycode) AS CountOf
FROM kontrollansvarig
WHERE enabled = 1
GROUP BY countycode
ORDER BY CountOf DESC