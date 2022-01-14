 ![Sala Kommun](https://www.sala.se/resources/images/Logotyper/sakn-logotyp-FS-srgb.png)
# Kontrollansvarig
Lösning för kontrollansvarig e-tjänst. Ett powershell skript hämtar information om kontrollansvarig från Boverkets hemsida som lagras i MSSQL databas och sedan presenteras i API form på egen PHP sida.

### Databas MSSQL

```bash
"databas mssql\skapa tabell.sql"
``` 
Kan användas för att skapa databastabell, kräver Microsoft SQL databas.

### Insamlare powershell
```bash
"insamlare powershell\scrapeall.ps1"
```
Används för att samla in data från boverkets hemsida, kan läggas som shemalagt jobb.
* Databasuppgifter & några inställningar behövs fyllas i på rad 4-7
### API för OpenE
```bash
"api php\index.php"
"api php\sql.php"
"api php\county.php"
```
Används för API till OpenE, kräver webserver med PHP. (Vi har det på Windows Server med IIS och PHP)
* Databasuppgifter & några inställningar behövs fyllas på rad 3 i "sql.php"