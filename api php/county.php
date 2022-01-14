<?php
function convertcounty($cc){
	switch ($cc) {
		case 1:
			return 'AB'; //Stockholms län
			break;
		case 3:
			return 'C'; //Uppsala län
			break;
		case 4:
			return 'D'; //Södermanlands län
			break;
		case 5:
			return 'E'; //Östergötlands län
			break;
		case 6:
			return 'F'; //Jönköpings län
			break;
		case 7:
			return 'G'; //Kronobergs län
			break;
		case 8:
			return 'H'; //Kalmar län
			break;
		case 9:
			return 'I'; //Gotlands län
			break;
		case 10:
			return 'K'; //Blekinge län
			break;
		case 12:
			return 'M'; //Skåne län
			break;
		case 13:
			return 'N'; //Hallands län
			break;
		case 14:
			return 'O'; //Västra Götalands län
			break;
		case 17:
			return 'S'; //Värmlands län
			break;
		case 18:
			return 'T'; //Örebro län
			break;
		case 19:
			return 'U'; //Västmanlands län
			break;
		case 20:
			return 'W'; //Dalarnas län
			break;
		case 21:
			return 'X'; //Gävleborgs län
			break;
		case 22:
			return 'Y'; //Västernorrlands län
			break;
		case 23:
			return 'Z'; //Jämtlands län
			break;
		case 24:
			return 'AC'; //Västerbottens län
			break;
		case 25:
			return 'BD'; //Norrbottens län
			break;
		default:
			return 'error';
	}
}
?>