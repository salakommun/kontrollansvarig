<?php
mb_internal_encoding("UTF-8");
include('sql.php');
include('county.php');

if(isset($_GET['id'])){
	$id=(int) filter_var($_GET['id'], FILTER_SANITIZE_NUMBER_INT);
	header("Content-Type: text/html; charset=UTF-8");
	header("InfoQueryResponse: ".date("Y-m-d"));
	$datainfo = new sql($sqlconn);
	$info = $datainfo->fetch_row("SELECT name, company, city, certtype, certby, certtodate, accessnumber, accesslevel, tel, adr, mail FROM kontrollansvarig WHERE id=$id");
	//var_dump($info);
	//echo "<pre>".PHP_EOL;
	echo "<strong>Namn:</strong> ".$info['name']."<br>".PHP_EOL;
	if(!empty($info['company'])){
		echo "<strong>Företag:</strong> ".htmlentities($info['company'])."<br>".PHP_EOL;
	}
	echo "<strong>Stad:</strong> ".$info['city']."<br>".PHP_EOL;
	echo "<strong>Typ av certifiering:</strong> ".$info['certtype']."<br>".PHP_EOL;
	echo "<strong>Certifierad av:</strong> ".$info['certby']."<br>".PHP_EOL;
	echo "<strong>Certifierad till:</strong> ".$info['certtodate']."<br>".PHP_EOL;
	echo "<strong>Behörighetsnr:</strong> ".$info['accessnumber']."<br>".PHP_EOL;
	echo "<strong>Behörighetsnivå:</strong> ".$info['accesslevel']."<br>".PHP_EOL;
	if(!empty($info['tel'])){
		echo "<strong>Telefon:</strong> ".$info['tel']."<br>".PHP_EOL;
	}
	$adr=str_ireplace("</span>","</span><br>",$info['adr']);
	echo "<strong>Adress:</strong> ".$adr.PHP_EOL;
	if(!empty($info['mail'])){
		echo "<strong>Mail:</strong> <a href=\"mailto:".$info['mail']."\">".$info['mail']."</a><br>".PHP_EOL;
	}
	//echo "</pre>".PHP_EOL;
} else if(!empty($_GET['lan'])){
	$lan=convertcounty($_GET['lan']);
	$optional='';
	if(!empty($_GET['fornamn'])){
		$fornamn=$_GET['fornamn'];
		$optional.="AND name LIKE '%$fornamn%' ";
	}
	if(!empty($_GET['efternamn'])){
		$efternamn=$_GET['efternamn'];
		$optional.="AND name LIKE '%$efternamn%' ";
	}
	if(!empty($_GET['foretag'])){
		$foretag=$_GET['foretag'];
		$optional.="AND company LIKE '%$foretag%' ";
	}
	if(!empty($_GET['postort'])){
		$postort=$_GET['postort'];
		$optional.="AND city LIKE '%$postort%' ";
	}
	//echo $lan;
	$datalist = new sql($sqlconn);
	$list = $datalist->fetch_array("SELECT CONVERT(varchar(10), id) AS 'key', 'value' = 
	name + 
	CASE WHEN company IS NULL OR company = '' THEN '' ELSE ', ' + company END + 
	CASE WHEN city IS NULL OR city = '' THEN '' ELSE ', ' + city END
FROM kontrollansvarig
WHERE enabled='1' AND countycode ='$lan' $optional
ORDER BY name");
	header("Content-Type: application/json; charset=UTF-8");
	echo json_encode($list);
} else {
	$datalist = new sql($sqlconn);
	//$list = $datalist->fetch_array("SELECT CONVERT(varchar(10), [id]) AS 'key',name AS 'value' FROM kontrollansvarig WHERE enabled='1'");
	//$list = $datalist->fetch_array("SELECT DISTINCT countycode AS 'key', county AS 'value' FROM kontrollansvarig WHERE enabled='1'");
	$list = $datalist->fetch_array("SELECT DISTINCT
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
   ORDER BY county");
	//var_dump($list);
	header("Content-Type: application/json; charset=UTF-8");
	echo json_encode($list);
	//echo json_encode($list, JSON_UNESCAPED_UNICODE);
}
?>