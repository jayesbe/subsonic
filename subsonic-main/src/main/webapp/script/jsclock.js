// Styles
	//  0 Month Date, Year
	//
	//  1 Day, Month Date
	//  2 Day, Month Date Year
	//  3 Day, Month Date Year HH:MM AP
	//  4 Day, Month Date Year HH:MM:SS AP
	//
	//  5 MM-DD-YYYY
	//  6 MM/DD/YYYY
	//  7 MM.DD.YYYY
	//
	//  8 DD-MM-YYYY
	//  9 DD/MM/YYYY
	// 10 DD.MM.YYYY
	//
	// 11 HH:MM (24 Hour)
	// 12 HH:MM AP (12 Hour)
	// 13 HH:MM:SS AP (12 Hour)
	//
	// 14 MM/DD/YYYY HH:MM (24 Hour)
	// 15 MM/DD/YYYY HH:MM AP (12 Hour)
	// 16 MM/DD/YYYY HH:MM:SS AP (12 Hour)

function jsClock(style){
	var fmt = "";
	d = new Date();
	nday   = d.getDay();
	nmonth = d.getMonth();
	ndate  = d.getDate();
	nyear  = d.getYear();
	nhour  = d.getHours();
	nmin   = d.getMinutes();
	nsec   = d.getSeconds();
	tmonth = new Array("January","February","March","April","May","June","July","August","September","October","November","December");
	tday   = new Array("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday");

	if (nyear < 1000) nyear = nyear + 1900;

	if (style === undefined || style == 12 || style == 13 || style == 15 || style == 16) {
			 if(nhour ==  0) {ap = " AM";nhour = 12;} 
		else if(nhour <= 11) {ap = " AM";} 
		else if(nhour == 12) {ap = " PM";} 
		else if(nhour >= 13) {ap = " PM";nhour -= 12;}
	}

	if(nmin <= 9) {nmin = "0" +nmin;}
	if(nsec <= 9) {nsec = "0" +nsec;}
	switch (style) {

		case  1: fmt = ""+tday[nday]+", "+tmonth[nmonth]+" "+ndate+""; break;
		case  2: fmt = ""+tday[nday]+", "+tmonth[nmonth]+" "+ndate+", "+nyear+""; break;
		case  3: fmt = ""+tday[nday]+", "+tmonth[nmonth]+" "+ndate+", "+nyear+" "+nhour+":"+nmin+ap+""; break;
		case  4: fmt = ""+tday[nday]+", "+tmonth[nmonth]+" "+ndate+", "+nyear+" "+nhour+":"+nmin+":"+nsec+ap+""; break;

		case  5: fmt = ""+(nmonth+1)+"-"+ndate+"-"+nyear+""; break;
		case  6: fmt = ""+(nmonth+1)+"/"+ndate+"/"+nyear+""; break;
		case  7: fmt = ""+(nmonth+1)+"."+ndate+"."+nyear+""; break;

		case  8: fmt = ""+ndate+"-"+(nmonth+1)+"-"+nyear+""; break;
		case  9: fmt = ""+ndate+"/"+(nmonth+1)+"/"+nyear+""; break;
		case 10: fmt = ""+ndate+"."+(nmonth+1)+"."+nyear+""; break;

		case 11: fmt = ""+nhour+":"+nmin+""; break;
		case 12: fmt = ""+nhour+":"+nmin+ap+""; break;
		case 13: fmt = ""+nhour+":"+nmin+":"+nsec+ap+""; break;

		case 14: fmt = ""+(nmonth+1)+"/"+ndate+"/"+nyear+" "+nhour+":"+nmin+""; break;
		case 15: fmt = ""+(nmonth+1)+"/"+ndate+"/"+nyear+" "+nhour+":"+nmin+ap+""; break;
		case 16: fmt = ""+(nmonth+1)+"/"+ndate+"/"+nyear+" "+nhour+":"+nmin+":"+nsec+ap+""; break;

		default: fmt = ""+(nmonth+1)+"/"+ndate+"/"+nyear+" "+nhour+":"+nmin+ap+"";
	}

	document.getElementById('clockbox').innerHTML = fmt;
	setTimeout("jsClock("+style+")", 1000);
}