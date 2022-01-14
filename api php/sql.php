<?php
mb_internal_encoding("UTF-8");
$sqlconn = array('host' => '127.0.0.1', 'user' => 'användare', 'pass' => 'lösenord', 'db' => 'databas');

class sql {
	var $con;
	function __construct($db=array()){
		$default = array('host' => '127.0.0.1', 'user' => 'sa', 'pass' => '', 'db' => 'test');
		$db = array_merge($default,$db);
		$this->con=sqlsrv_connect($db['host'],array('UID'=>$db['user'],'PWD'=>$db['pass'],'Database'=>$db['db'],'ReturnDatesAsStrings' =>1,'CharacterSet'=>'UTF-8')) or die ('Error connecting to SQL server');
	}
	function __destruct(){
		sqlsrv_close($this->con);
	}
	function execute($s=''){
		if (sqlsrv_query($this->con,$s)) return true;
		return false;
	}
	function query($s=''){
		if (!$q=sqlsrv_query($this->con,$s)) return false;
		return $q;
	}
	function fetch_array($s,$t=true){
		$q=$this->query($s);
		$type = $t ? SQLSRV_FETCH_ASSOC : SQLSRV_FETCH_NUMERIC;
		while($d=sqlsrv_fetch_array($q,$type)){
			$data[]=$d;
		}
		sqlsrv_free_stmt($q);
		return $data;
	}
	function fetch_row($s,$t=true){
		$q=$this->query($s);
		$type = $t ? SQLSRV_FETCH_ASSOC : SQLSRV_FETCH_NUMERIC;
		$d=sqlsrv_fetch_array($q,$type);
		sqlsrv_free_stmt($q);
		return $d;
	}
	function get_field($s,$c=0){
		$q=$this->query($s);
		if( sqlsrv_fetch( $q ) === false) {
			return;
		}
		$d = sqlsrv_get_field($q, $c);
		sqlsrv_free_stmt($q);
		return $d;
	}
	function getallresults($s,$t=true){
		$q=$this->query($s);
		$type = $t ? SQLSRV_FETCH_ASSOC : SQLSRV_FETCH_NUMERIC;
		$data=array();
		do {
			if (sqlsrv_has_rows($q)){
				while($d=sqlsrv_fetch_array($q,$type)){
					$data[]=$d;
				}
			}
		} while (sqlsrv_next_result($q));
		sqlsrv_free_stmt($q);
		return $data;
	}
	function escape($s){
		if(is_numeric($s))
			return $s;
	}
	function begin_tran(){
		if (sqlsrv_begin_transaction($this->con)) return true;
		return false;
	}
	function commit(){
		if (sqlsrv_commit($this->con)) return true;
		return false;
	}
	function rollback(){
		if (sqlsrv_rollback($this->con)) return true;
		return false;
	}
	function tran($s){
		if (sqlsrv_begin_transaction($this->con)){
			if($s){
				if (sqlsrv_commit($this->con)) return true;
			}
		}
		if (sqlsrv_rollback($this->con)) return false; // hm...
		return false;
	}
}
?>