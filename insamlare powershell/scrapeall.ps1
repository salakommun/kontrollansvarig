Get-Variable -Exclude PWD,*Preference | Remove-Variable -EA 0
Add-Type -AssemblyName System.Web

$logfile = 'C:\scheduledservice\scrapekontrollansvarig\scrapelog.txt'
$sleeptime = 5

function sql($sqlText, $database = "dbnamn", $server = "dbserver", $sqluser = "dbanvändare", $sqlpwd = "dblösenord"){
    $connection = new-object System.Data.SqlClient.SQLConnection("Data Source=$server;Integrated Security=False;User ID=$sqluser;Password=$sqlpwd;Initial Catalog=$database");
    $cmd = new-object System.Data.SqlClient.SqlCommand($sqlText, $connection);
    $connection.Open();
    $reader = $cmd.ExecuteReader()
    $results = @()
    while ($reader.Read()){
        $row = @{}
        for ($i = 0; $i -lt $reader.FieldCount; $i++){
            $row[$reader.GetName($i)] = $reader.GetValue($i)
        }
        $results += new-object psobject -property $row
    }
    $connection.Close();
    $results
}

Clear-Content -Path $logfile

$timer = [system.diagnostics.stopwatch]::StartNew()

$lan = @{
    'AB' = 'Stockholms län';
    'AC' = 'Västerbottens län';
    'BD' = 'Norrbottens län';
    'C' = 'Uppsala län';
    'D' = 'Södermanlands län';
    'E' = 'Östergötlands län';
    'F' = 'Jönköpings län';
    'G' = 'Kronobergs län';
    'H' = 'Kalmar län';
    'I' = 'Gotlands län';
    'K' = 'Blekinge län';
    'M' = 'Skåne län';
    'N' = 'Hallands län';
    'O' = 'Västra Götalands län';
    'S' = 'Värmlands län';
    'T' = 'Örebro län';
    'U' = 'Västmanlands län';
    'W' = 'Dalarnas län';
    'X' = 'Gävleborgs län';
    'Y' = 'Västernorrlands län';
    'Z' = 'Jämtlands län';
}

foreach ($key in $lan.Keys) {
    $timer.Restart()
    Add-Content -Path $logfile -Value "$(Get-Date -Format "yyyy/MM/dd HH:mm:ss") Started scrape for '$($lan.$key)'" -Encoding UTF8
    $county=$lan.$key
    $countycode=$key

    $page2scrape = 'https://www.boverket.se/sv/om-boverket/tjanster/hitta-certifierade/'
    $currentpage = 1
    $alldata = @()
    do {
        $html = Invoke-WebRequest ($page2scrape+'?page='+$currentpage+'&type=2&county='+$countycode+'&name=&sname=&company=&qlvl=&city=&qnr=#certificate-results')
        $pagination = $html.ParsedHtml.getElementsByTagName('ul') | Where-Object {$_.getAttributeNode('class').Value -eq 'pagination'}
        $pages = $pagination.getElementsByTagName('li') | Select-Object innerText
        $table = $html.ParsedHtml.getElementById('results')
        $rows = $table.getElementsByTagName('tr')

        foreach ($row in $rows){
            $columns=$row.getElementsByTagName('td')
            if($columns.length -eq 0){
                continue
            }
            if ($columns[0].innerText -inotmatch 'Dold på begäran'){
                $link = [uri]$columns[0].getElementsByTagName('a')[0].href.Replace("about:blank",$page2scrape)
                $ParsedQueryString = [System.Web.HttpUtility]::ParseQueryString($link.Query)
                $i = 0
                $uid = 0
                foreach($QueryStringObject in $ParsedQueryString){
                    if($QueryStringObject -eq 'uid'){
                        $uid = $ParsedQueryString[$i]
                        break
                    }
                    $i++
                }
                $rowscrape = [pscustomobject]@{
                    link = [string]$link
                    uid = $uid
                    name = $columns[0].innerText
                    company = $columns[1].innerHTML -replace "<span(.*)</span>", "" -replace "&amp;", "&"
                    city = $columns[2].innerText
                }
                $alldata+=$rowscrape
            }
        }
        #write-host "scraped on page $currentpage"
        $currentpage++
    } While ($pages.innerText.Contains(($currentpage).ToString()))

    Add-Content -Path $logfile -Value "$(Get-Date -Format "yyyy/MM/dd HH:mm:ss") Found $currentpage pages to scrape for '$($lan.$key)'" -Encoding UTF8

    foreach ($entry in $alldata){
        #write-host "scraping:"$entry.link
        $html = Invoke-WebRequest $entry.link
        $userinfo = $html.ParsedHtml.getElementsByTagName('ul') | Where-Object {$_.getAttributeNode('class').Value -eq 'userinfo'}
        $li = $userinfo.getElementsByTagName('li')

        foreach($l in $li){
            switch($l.getElementsByTagName('strong')[0].innerText){
                "Typ av certifiering:" {
                    $entry | Add-Member -type NoteProperty -Name certtype -Value $l.getElementsByTagName('span')[0].innerText
                    break
                }
                "Certifierad av:" {
                    $entry | Add-Member -type NoteProperty -Name certby -Value $l.getElementsByTagName('span')[0].innerText
                    break
                }
                "Certifierad till:" {
                    $entry | Add-Member -type NoteProperty -Name certtodate -Value $l.getElementsByTagName('span')[0].innerText
                    break
                }
                "Behörighetsnr:" {
                    $entry | Add-Member -type NoteProperty -Name accessnumber -Value $l.getElementsByTagName('span')[0].innerText
                    break
                }
                "Behörighetsnivå:" {
                    $entry | Add-Member -type NoteProperty -Name accesslevel -Value $l.getElementsByTagName('span')[0].innerText
                    break
                }
                "Telefon:" {
                    $entry | Add-Member -type NoteProperty -Name tel -Value $l.getElementsByTagName('span')[0].innerText
                    break
                }
                "Adress:" {
                    [string]$adr=$l.getElementsByTagName('span') | ForEach-Object { $_.OuterHTML }
                    $entry | Add-Member -type NoteProperty -Name adr -Value $adr
                    break
                }
                "E-Post:" {
                    $entry | Add-Member -type NoteProperty -Name mail -Value $l.getElementsByTagName('a')[0].href.replace("mailto:","")
                    break
                }
                Default {
                    break
                }
            }
        }
        $entry | Add-Member -type NoteProperty -Name county -Value $county
        $entry | Add-Member -type NoteProperty -Name countycode -Value $countycode
    }

    sql ("UPDATE kontrollansvarig SET enabled = 0 WHERE countycode='"+$countycode+"'")

    foreach($data in $alldata){
        $data.company=$data.company -replace "'", "''" #fix for '
        $data.adr=$data.adr -replace "'", "''" #fix for '
        sql ("update kontrollansvarig set updated = getdate(), enabled='1', name ='"+$data.name+"', company ='"+$data.company+"', city ='"+$data.city+"', certtype ='"+$data.certtype+"', certby ='"+$data.certby+"', certtodate ='"+$data.certtodate+"', accessnumber ='"+$data.accessnumber+"', accesslevel ='"+$data.accesslevel+"', tel = '"+$data.tel+"', adr = '"+$data.adr+"', mail = '"+$data.mail+"', county ='"+$data.county+"', countycode ='"+$data.countycode+"' where id="+$data.uid+"
            IF @@ROWCOUNT=0
            insert into kontrollansvarig(id,updated,enabled,name,company,city,certtype,certby,certtodate,accessnumber,accesslevel,tel,adr,mail,county,countycode) values('"+$data.uid+"',getdate(),'1','"+$data.name+"','"+$data.company+"', '"+$data.city+"', '"+$data.certtype+"', '"+$data.certby+"', '"+$data.certtodate+"', '"+$data.accessnumber+"', '"+$data.accesslevel+"', '"+$data.tel+"', '"+$data.adr+"', '"+$data.mail+"', '"+$data.county+"', '"+$data.countycode+"');")
    }

    #write-host $lan.$key " done" $timer.Elapsed.Seconds
    Add-Content -Path $logfile -Value "$(Get-Date -Format "yyyy/MM/dd HH:mm:ss") Done scraping '$($lan.$key)' it took $($([string]::Format("{0:d2} hours {1:d2} minutes {2:d2} seconds", $timer.Elapsed.hours, $timer.Elapsed.minutes, $timer.Elapsed.seconds)))" -Encoding UTF8
    Start-Sleep -Seconds $sleeptime
}