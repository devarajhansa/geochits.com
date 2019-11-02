var customerObj;
var duesObjAll;
var ledgcustObj;
var ledgerObj; 
var statusObj;
var bFamily = false;
var bClosed = false;
var bPrintDues = false;
var bPrintLedger = false;
var bMobile = false;
var sLookupCode = '';

//Function to Format Month Name and Year
function GetMName(x) { 
	var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

	var CurrentDate = new Date();
	CurrentDate.setMonth(CurrentDate.getMonth() + x);

	return monthNames[CurrentDate.getMonth()] + " " + CurrentDate.getFullYear();

};

//Currency Formating
function currencyFormat(num) {
	if(!isNaN(num)){
		var nNum = Number(num);  
		return ' &#x20B9;' + nNum.toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,')
	} else return num;
};

//Formating Format ledgerObj
function FormatledgerObj(){
	var prercptnum = '';
	var ibalance = 0;
	var ishare = 0;
	
	
	for (x in ledgerObj) {

		if(Number(ledgerObj[x].subscription) != 0 && Number(ledgerObj[x].subscription) <= Number(ledgerObj[x].dividend) + Number(ledgerObj[x].share) + ishare){
			ishare = 0;
		} else{
			ishare += Number(ledgerObj[x].share);
			ledgerObj[x].dividend = "0";
			ledgerObj[x].subscription = "0";
			
		}
		
		ibalance +=  Number(ledgerObj[x].share) + Number(ledgerObj[x].dividend) - Number(ledgerObj[x].discount) - Number(ledgerObj[x].prize);
		ledgerObj[x].balance = ibalance;

		
		if(ledgerObj[x].subscription == "0") ledgerObj[x].subscription = "&nbsp;";
		if(ledgerObj[x].dividend == "0") ledgerObj[x].dividend = "&nbsp;";
		if(ledgerObj[x].share == "0") ledgerObj[x].share = "&nbsp;";
		if(ledgerObj[x].charges == "0") ledgerObj[x].charges = "&nbsp;";
		if(ledgerObj[x].discount == "0") ledgerObj[x].discount = "&nbsp;";
		if(ledgerObj[x].prize == "0") ledgerObj[x].prize = "&nbsp;";
		if(ledgerObj[x].rcptnum == prercptnum){
			prercptnum = ledgerObj[x].rcptnum;
			ledgerObj[x].rcptnum = "&nbsp;";
			ledgerObj[x].charges = "&nbsp;";
		} else {prercptnum = ledgerObj[x].rcptnum;}
	}

};


//Code to Display Dueslist.
function DisplayDuesList() {

	//Return if Database Uploading
	if(statusObj[0].uploading == "1") {
		bPrintLedger = false;
		bPrintDues = false;
		txt = "<table align='center'><tr><td><b><font color='red'><br/><br/>Database Updating... <br/> Please try again later in 10 minutes.</b></font></td></tr></table>";
		return txt;
	}

	//Return if Customer Object is Empty
	if((typeof customerObj[0]) != "object") return;

	duesObj = duesObjAll;
	sLookupCode = sLookupCode.toUpperCase();
	sLookupCode = sLookupCode.trim();

	if(!bFamily){
		//Filter Data to be displayed. 
		var duesObj = duesObjAll.filter(x => x.lookupcode == sLookupCode);
	};

	if(!bClosed){
		//Filter Data to be displayed. 
		var duesObj = duesObj.filter(x => x.Closed == false || (x.Closed == true && new Date(x.CloseDate) > new Date()) || x.bal1 > 0 || x.bal2 > 0 || x.bal3 > 0 || x.bal4 > 0 || x.bal5 > 0 || x.bal6 > 0 );
	};


	//Populate Customer Information
	txt = "<br/><p><b>" + customerObj[0].sal.trim() + " " + customerObj[0].first.trim() + " " + customerObj[0].last.trim() + "</b><br/>";
	txt += customerObj[0].address1.trim() + " " + customerObj[0].address2.trim() + " " + customerObj[0].address3.trim() + "<br/>";
	txt += "Phone: <a href='tel:" + customerObj[0].phone1.trim() + "'> " + customerObj[0].phone1.trim() + "</a>";
	txt += (customerObj[0].phone2.trim().length > 0 ? ", <a href='tel:" + customerObj[0].phone2.trim() + "'> " + customerObj[0].phone2.trim() + "</a>" : "&nbsp;") + " </p><p>";
	txt += "<input type='checkbox' id='chkFamily' " + (bFamily ? "checked":"") + " onchange='FamilyChanged()'> <label for='chkFamily'>Include My Family</label> &nbsp;&nbsp;"	
	txt += "<input type='checkbox' id='chkClosed' " + (bClosed ? "checked":"") + " onchange='ClosedChanged()'> <label for='chkClosed'>Include Closed</label> &nbsp;&nbsp;</p>"
	txt += "Account Statement<br/>";

	if(bMobile) {
		//Populate Dues	for Mobile
		txt += "<table border='1' cellpadding='3' id='tblDues'>";
		bal1=0,bal2=0,bal3=0,bal4=0,bal5=0,bal6=0,tot=0;
		for (x in duesObj) {
			txt += "<tr style='background: #eee;'><td><b>No.</td><td colspan='2' align='center'><b>" + (Number(x)+1) + "</td></tr>";  // myObj[0][0]["" + x + ""]
			txt += "<tr><td>Name</td><td colspan='2' align='center'>" + duesObj[x].first + " " + duesObj[x].last + "<br/>&nbsp;&nbsp;<input type='button' id='btnLedger" + duesObj[x].groupid.trim() + duesObj[x].ticket.trim() + "'   value='Ledger' onclick='btnLedger_Clicked(" + duesObj[x].groupid + "," + duesObj[x].ticket + ")' ></td></tr>";
			txt += "<tr><td>Group</td><td colspan='2' align='center'><b>" + duesObj[x].gname + '</b>' + duesObj[x].gdetails + "</td></tr>";
			txt += "<tr><td>Ticket</td><td colspan='2' align='center'>" + duesObj[x].ticket + (duesObj[x].prized.length > 5 ? " - " + duesObj[x].prized : "") + "</td></tr>";
			txt += "<tr><td>Auction</td><td colspan='2' align='center'>" + duesObj[x].auction + "</td></tr>";
			txt += "<tr><td>Auction Time</td><td colspan='2' align='center'>" + duesObj[x].auctdate + " - " + duesObj[x].aucttime + "</td></tr>";
			
			if((Number(duesObj[x].bal1) + Number(duesObj[x].bal2) + Number(duesObj[x].bal3) + Number(duesObj[x].bal4) + Number(duesObj[x].bal5) + Number(duesObj[x].bal6)) > 0) {
				txt += "<tr><td></td><td align='center'> Dues </td><td align='center'>Late Fee</td></tr>";
				txt += (Number(duesObj[x].bal1)>0 ? "<tr><td>" + GetMName(0) + "</td><td align='right' bgcolor=#40FF40>" + currencyFormat(duesObj[x].bal1) + "</td><td></td></tr>" : "");
				txt += (Number(duesObj[x].bal2)>0 ? "<tr><td>" + GetMName(-1) + "</td><td align='right' bgcolor=#80FF80>" + currencyFormat(duesObj[x].bal2) + "</td><td align='right' bgcolor=#80FF80>" + currencyFormat(duesObj[x].late2) + "</td></tr>": "");
				txt += (Number(duesObj[x].bal3)>0 ? "<tr><td>" + GetMName(-2) + "</td><td align='right' bgcolor=#FFFF40>" + currencyFormat(duesObj[x].bal3) + "</td><td align='right' bgcolor=#FFFF40>" + currencyFormat(duesObj[x].late3) + "</td></tr>": "");
				txt += (Number(duesObj[x].bal4)>0 ? "<tr><td>" + GetMName(-3) + "</td><td align='right' bgcolor=#FFC0C0>" + currencyFormat(duesObj[x].bal4) + "</td><td align='right' bgcolor=#FFC0C0>" + currencyFormat(duesObj[x].late4) + "</td></tr>": "");
				txt += (Number(duesObj[x].bal5)>0 ? "<tr><td>" + GetMName(-4) + "</td><td align='right' bgcolor=#FF8080>" + currencyFormat(duesObj[x].bal5) + "</td><td align='right' bgcolor=#FF8080>" + currencyFormat(duesObj[x].late5) + "</td></tr>": "");
				txt += (Number(duesObj[x].bal6)>0 ? "<tr><td>As of " + GetMName(-5) + "</td><td align='right' bgcolor=#FF4040>" + currencyFormat(duesObj[x].bal6) + "</td><td align='right' bgcolor=#FF4040>" + currencyFormat(duesObj[x].late6) + "</td></tr>": "");
				txt += "<tr><td>Total</td><td align='right'>" + currencyFormat(Number(duesObj[x].bal1) + Number(duesObj[x].bal2) + Number(duesObj[x].bal3) + Number(duesObj[x].bal4) + Number(duesObj[x].bal5) + Number(duesObj[x].bal6));
				txt += "</td><td align='right'> " + (Number(duesObj[x].late2) + Number(duesObj[x].late3) + Number(duesObj[x].late4) + Number(duesObj[x].late5) + Number(duesObj[x].late6)>0 ? currencyFormat(Number(duesObj[x].late2) + Number(duesObj[x].late3) + Number(duesObj[x].late4) + Number(duesObj[x].late5) + Number(duesObj[x].late6)) : "" );
			} else { txt += "<tr><td></td><td colspan='2' align='center'>  Up-to-date ";  };
			txt += "</td></tr>";
		
			//Calculate Total of Each Row
			bal1 += Number(duesObj[x].bal1);
			bal2 += Number(duesObj[x].bal2) + Number(duesObj[x].late2);
			bal3 += Number(duesObj[x].bal3) + Number(duesObj[x].late3);
			bal4 += Number(duesObj[x].bal4) + Number(duesObj[x].late4);
			bal5 += Number(duesObj[x].bal5) + Number(duesObj[x].late5);
			bal6 += Number(duesObj[x].bal6) + Number(duesObj[x].late6);
			tot += (Number(duesObj[x].bal1) + Number(duesObj[x].bal2) + Number(duesObj[x].late2) + Number(duesObj[x].bal3) + Number(duesObj[x].late3) + Number(duesObj[x].bal4) + Number(duesObj[x].late4) + Number(duesObj[x].bal5) + Number(duesObj[x].late5) + Number(duesObj[x].bal6) + Number(duesObj[x].late6));
				
		}
		if(tot>0){
			txt += "<tr><td colspan='3'>&nbsp;</td></tr>"
			txt += "<tr style='background: #eee;'><td colspan='3' align='center'><b> Grand Total For Each Month </td></tr>" ;
			txt += (bal1>0 ? "<tr><td>" + GetMName(0) + "</td><td colspan='2' align='right'bgcolor=#40FF40>" + currencyFormat(bal1) + "</td></tr>" : "");
			txt += (bal2>0 ? "<tr><td>" + GetMName(-1) + "</td><td colspan='2' align='right'bgcolor=#80FF80>" + currencyFormat(bal2) + "</td></tr>" : "");
			txt += (bal3>0 ? "<tr><td>" + GetMName(-2) + "</td><td colspan='2' align='right'bgcolor=#FFFF40>" + currencyFormat(bal3) + "</td></tr>" : "");
			txt += (bal4>0 ? "<tr><td>" + GetMName(-3) + "</td><td colspan='2' align='right'bgcolor=#FFC0C0>" + currencyFormat(bal4) + "</td></tr>" : "");
			txt += (bal5>0 ? "<tr><td>" + GetMName(-4) + "</td><td colspan='2' align='right'bgcolor=#FF8080>" + currencyFormat(bal5) + "</td></tr>" : "");
			txt += (bal6>0 ? "<tr><td>As of " + GetMName(-5) + "</td><td colspan='2' align='right'bgcolor=#FF4040>" + currencyFormat(bal6) + "</td></tr>" : "");
			txt += "<tr><td>Total</td><td colspan='2' align='right'>" + currencyFormat(tot) + "</td></tr>";
		}
		txt += "<tr><td  colspan=3'  align='center' style='white-space: normal;' > Statement generated on " + customerObj[0].syncdate + "<br/><br/>";
		txt += "<b>Please make the payment on or before 10th of every month. No dividend will be payable after the due date.</b><br/><br/>";
		txt += "All remittances should be made payable to <b><font color='red'> Geo Chits Private Limited</font> at Coimbatore.</b><br/>";
		txt += "Cheques should be crossed and accompanied by covering letters containing Subscriber's Name and Group Number of the Chit.<br/><br/>";
		txt += "For Bank Transfer use";
		txt += "<table border='1' cellpadding='10' style='margin-left:auto;margin-right:auto;'><thead><tr><th>Bank</th><th>IFS Code</th><th>A/c Number</th></tr></thead>";
		txt += "<tr><tbody><td>Corporation Bank - CBCA</td><td>CORP0000113</td><td>510101000160074</td></tr></tbody></table> &nbsp;<br/>";
		txt += "</td></tr></tbody></table>";

	} else {
		//Populate Dues	for Desktop	
		txt += "<table border='1' cellpadding='3' id='tblDues'>";
		txt += "<thead><tr><th>No.</th><th>Name</th><th>Group</th><th>Ticket</th><th>Auction</th><th>Auction Time</th>"
		txt += "<th>" + GetMName(0) + "</th><th>" + GetMName(-1) + "</th><th>" + GetMName(-2) + "</th><th>" + GetMName(-3) + "</th><th>" + GetMName(-4) + "</th><th>As of " + GetMName(-5) + "</th><th>Total</th></tr></thead>"
		bal1=0,bal2=0,bal3=0,bal4=0,bal5=0,bal6=0,tot=0;
		for (x in duesObj) {
			txt += "<tbody><tr><td align='center'>" + (Number(x)+1) + "</td>";  // myObj[0][0]["" + x + ""]
			txt += "<td align='center'>" + duesObj[x].first + " " + duesObj[x].last + "<br/>&nbsp;&nbsp;<input type=\"button\" id=\"btnLedger" + duesObj[x].groupid.trim() + duesObj[x].ticket.trim() + "\"   value=\"Ledger\" onclick=\"btnLedger_Clicked(" + duesObj[x].groupid + "," + duesObj[x].ticket + ")\" ></td>";
			txt += "<td align='center'><b>" + duesObj[x].gname + '</b><br/>' + duesObj[x].gdetails + "</td>";
			txt += "<td align='center'>" + duesObj[x].ticket + "<br/>" + duesObj[x].prized + "</td>";
			txt += "<td align='center'>" + duesObj[x].auction + "</td>";
			txt += "<td align='center'>" + duesObj[x].auctdate + "<br/>" + duesObj[x].aucttime + "</td>";
			
			if((Number(duesObj[x].bal1) + Number(duesObj[x].bal2) + Number(duesObj[x].bal3) + Number(duesObj[x].bal4) + Number(duesObj[x].bal5) + Number(duesObj[x].bal6)) > 0) {
				txt += "<td align='right' " + (Number(duesObj[x].bal1)>0 ? "bgcolor=#40FF40>" + currencyFormat(duesObj[x].bal1) : ">") + "</td>";
				txt += "<td align='right' " + (Number(duesObj[x].bal2)>0 ? "bgcolor=#80FF80>" + currencyFormat(duesObj[x].bal2) : ">") + "</td>";
				txt += "<td align='right' " + (Number(duesObj[x].bal3)>0 ? "bgcolor=#FFFF40>" + currencyFormat(duesObj[x].bal3) : ">") + "</td>";
				txt += "<td align='right' " + (Number(duesObj[x].bal4)>0 ? "bgcolor=#FFC0C0>" + currencyFormat(duesObj[x].bal4) : ">") + "</td>";
				txt += "<td align='right' " + (Number(duesObj[x].bal5)>0 ? "bgcolor=#FF8080>" + currencyFormat(duesObj[x].bal5) : ">") + "</td>";
				txt += "<td align='right' " + (Number(duesObj[x].bal6)>0 ? "bgcolor=#FF4040>" + currencyFormat(duesObj[x].bal6) : ">") + "</td>";
				txt += "<td align='right'>" + currencyFormat(Number(duesObj[x].bal1) + Number(duesObj[x].bal2) + Number(duesObj[x].bal3) + Number(duesObj[x].bal4) + Number(duesObj[x].bal5) + Number(duesObj[x].bal6));
			} else { txt += "<td colspan='7' align='center'>  Up-to-date";  };
			txt += "</td></tr>";
			
			if((Number(duesObj[x].late2) + Number(duesObj[x].late3) + Number(duesObj[x].late4) + Number(duesObj[x].late5) + Number(duesObj[x].late6))>0){
				txt += "<tr><td colspan='6' align='right'> Late Fee </td><td> &nbsp; </td>";
				txt += "<td align='right' " + (Number(duesObj[x].late2)>0 ? "bgcolor=#80FF80>" + currencyFormat(duesObj[x].late2) : ">") + "</td>";
				txt += "<td align='right' " + (Number(duesObj[x].late3)>0 ? "bgcolor=#FFFF40>" + currencyFormat(duesObj[x].late3) : ">") + "</td>";
				txt += "<td align='right' " + (Number(duesObj[x].late4)>0 ? "bgcolor=#FFC0C0>" + currencyFormat(duesObj[x].late4) : ">") + "</td>";
				txt += "<td align='right' " + (Number(duesObj[x].late5)>0 ? "bgcolor=#FF8080>" + currencyFormat(duesObj[x].late5) : ">") + "</td>";
				txt += "<td align='right' " + (Number(duesObj[x].late6)>0 ? "bgcolor=#FF4040>" + currencyFormat(duesObj[x].late6) : ">") + "</td>";
				txt += "<td align='right'>" + currencyFormat(Number(duesObj[x].late2) + Number(duesObj[x].late3) + Number(duesObj[x].late4) + Number(duesObj[x].late5) + Number(duesObj[x].late6)) + "</td></tr>";
			}
			
			//Calculate Total of Each Row
			bal1 += Number(duesObj[x].bal1);
			bal2 += Number(duesObj[x].bal2) + Number(duesObj[x].late2);
			bal3 += Number(duesObj[x].bal3) + Number(duesObj[x].late3);
			bal4 += Number(duesObj[x].bal4) + Number(duesObj[x].late4);
			bal5 += Number(duesObj[x].bal5) + Number(duesObj[x].late5);
			bal6 += Number(duesObj[x].bal6) + Number(duesObj[x].late6);
			tot += (Number(duesObj[x].bal1) + Number(duesObj[x].bal2) + Number(duesObj[x].late2) + Number(duesObj[x].bal3) + Number(duesObj[x].late3) + Number(duesObj[x].bal4) + Number(duesObj[x].late4) + Number(duesObj[x].bal5) + Number(duesObj[x].late5) + Number(duesObj[x].bal6) + Number(duesObj[x].late6));
				
		}
		txt += "<tr><td  colspan='6'  align='right'> Total </td>" ;
		txt += "<td align='right' " + (bal1>0 ? "bgcolor=#40FF40>" + currencyFormat(bal1) : ">") + "</td>";
		txt += "<td align='right' " + (bal2>0 ? "bgcolor=#80FF80>" + currencyFormat(bal2) : ">") + "</td>";
		txt += "<td align='right' " + (bal3>0 ? "bgcolor=#FFFF40>" + currencyFormat(bal3) : ">") + "</td>";
		txt += "<td align='right' " + (bal4>0 ? "bgcolor=#FFC0C0>" + currencyFormat(bal4) : ">") + "</td>";
		txt += "<td align='right' " + (bal5>0 ? "bgcolor=#FF8080>" + currencyFormat(bal5) : ">") + "</td>";
		txt += "<td align='right' " + (bal6>0 ? "bgcolor=#FF4040>" + currencyFormat(bal6) : ">") + "</td>";
		txt += "<td align='right' " + (tot>0 ? ">" + currencyFormat(tot) : ">") + "</td></tr>";
		txt += "<tr><td  colspan='13'  align='center'> Statement generated on " + customerObj[0].syncdate + "<br/><br/>";
		txt += "<b>Please make the payment on or before 10th of every month. No dividend will be payable after the due date.</b><br/><br/>";
		txt += "All remittances should be made payable to <b><font color='red'> Geo Chits Private Limited</font> at Coimbatore.</b><br/>";
		txt += "Cheques should be crossed and accompanied by covering letters containing Subscriber's Name and Group Number of the Chit.<br/><br/>";
		txt += "For Bank Transfer use";
		txt += "<table border='1' cellpadding='10' style='margin-left:auto;margin-right:auto;'><thead><tr><th>Bank</th><th>IFS Code</th><th>A/c Number</th></tr></thead>";
		txt += "<tr><tbody><td>Corporation Bank - CBCA</td><td>CORP0000113</td><td>510101000160074</td></tr></tbody></table> &nbsp;<br/>";
		txt += "</td></tr></tbody></table>";
	}
	bPrintDues = true;
	bPrintLedger = false;
	return txt;

}; 


//Code to Display Ledger
function DisplayLedger(){

	//Return if Database Uploading
	if(statusObj[0].uploading == "1") {
		bPrintLedger = false;
		bPrintDues = false;
		txt = "<table align='center'><tr><td><b><font color='red'><br/><br/>Database Updating... <br/> Please try again later in 10 minutes.</b></font></td></tr></table>";
		return txt;
	}
	
	//Display Customer Information
	txt = "<br/><Font size=+3><b>" + ledgcustObj[0].sal + ledgcustObj[0].first + " " + ledgcustObj[0].last + "</b></font>";
	txt += "<br/>" + ledgcustObj[0].address1 + " " + ledgcustObj[0].address2 + " " + ledgcustObj[0].address3 + "<br/>";
	txt += "Phone : " + ledgcustObj[0].phone1.trim() ;
	txt += (ledgcustObj[0].phone2.trim().length > 0 ?  ", " + ledgcustObj[0].phone2 : "") + "<br/><br/>";
	txt += "<Table align=center>";
	txt += "<Tr><Td align=center colspan=2><b>GEO CHITS PRIVATE LIMITED</b></Td></Tr>";
	txt += "<Tr><Td align=center colspan=2>FORM XIV (Section 23 & Rules 25)</Td></Tr>";
	txt += "<Tr><Td>SUBSCRIBER'S LEDGER</Td><Td><b>" + (ledgerObj.length > 0 ? ledgerObj[0].trandate + " - " + ledgerObj[ledgerObj.length-1].trandate : "&nbsp;") + "</b></Td></Tr>";
	txt += "<Tr><Td align=left>CHIT GROUP</Td><Td> " +  ledgcustObj[0].gname + "</Td></Tr>";
	txt += "<Tr><Td>SECTION-1: Receipts and Payments in respect of subscriber </Td><Td>" + ledgcustObj[0].sal + " " + ledgcustObj[0].first + " " + ledgcustObj[0].last +  " </Td></Tr>";
	txt += "<Tr><Td>Address</Td><Td>" + ledgcustObj[0].address1.trim() + "</Td></Tr>";
	txt += (ledgcustObj[0].address2.trim().length > 0 ? "<Tr><td></td><Td>" + ledgcustObj[0].address2.trim() + "</Td></Tr>" : "");
	txt += (ledgcustObj[0].address3.trim().length > 0 ? "<Tr><td></td><Td>" + ledgcustObj[0].address3.trim() + "</Td></Tr>" : "");
	txt += "<Tr><td></td><Td>" + ledgcustObj[0].city + "</Td></Tr>";
	txt += "<Tr><td></td><Td>" + ledgcustObj[0].state + (ledgcustObj[0].zip.trim().length > 0 ? " - " : "") + ledgcustObj[0].zip + "</Td></Tr>";
	txt += "<Tr><Td>Office where the chit agreement is registered at</Td> <Td>" + ledgcustObj[0].regdat + "</Td></Tr>";
	txt += "<Tr><Td>Registration Number and Date</Td> <Td>" + ledgcustObj[0].groupnum.trim() + ", " + ledgcustObj[0].groupdate + "</Td></Tr>";
	txt += "<Tr><Td>Ticket No. of Subscriber</Td><Td>" + ledgcustObj[0].slnum + "</Td></Tr>";
	txt += "<Tr><Td>Number of Tickets taken</Td><Td>One</Td></Tr>";
	txt += "<Tr><Td>Chit Amount</Td> <Td> " + currencyFormat(ledgcustObj[0].gamount) + "</Td></Tr>";
	txt += "<Tr><Td>Duration of Chit</Td> <Td>" + ledgcustObj[0].numins + "</Td></Tr></Table>";

	//Display Ledger
	txt += "<br/><table border='1' cellpadding='3' align='center' id='tblDues'>";
	txt += "<thead><tr><th>Date</th><th>Receipt No</th><th>Inst</th><th>Month</th><th>Subscription</th><th>Dividend</th><th>Share</th>";
	txt += "<th>Charges</th><th>Discount</th><th>Prize</th><th>Balance</th></tr></thead>"

	bal1=0,bal2=0,bal3=0,bal4=0,bal5=0,bal6=0,tot=0;
	//rows
	for (j=0;j<ledgerObj.length;j++){
		txt += "<tbody><tr>"	
		txt += "<td style='text-align:center;'>" + ledgerObj[j].trandate + "</td>";
		txt += "<td style='text-align:center;'>" + ledgerObj[j].rcptnum + "</td>";
		txt += "<td style='text-align:center;'>" + ledgerObj[j].insnum	 + "</td>";
		txt += "<td style='text-align:center;'>" + ledgerObj[j].month + "</td>";
		txt += "<td style='text-align:center;'>" + currencyFormat(ledgerObj[j].subscription) + "</td>";
		txt += "<td style='text-align:center;'>" + currencyFormat(ledgerObj[j].dividend) + "</td>";
		txt += "<td style='text-align:center;'>" + currencyFormat(ledgerObj[j].share) + "</td>";
		txt += "<td style='text-align:center;'>" + currencyFormat(ledgerObj[j].charges) + "</td>";
		txt += "<td style='text-align:center;'>" + currencyFormat(ledgerObj[j].discount) + "</td>";
		txt += "<td style='text-align:center;'>" + currencyFormat(ledgerObj[j].prize) + "</td>";
		txt += "<td style='text-align:center;'>" + currencyFormat(Math.abs(ledgerObj[j].balance));
		txt += (ledgerObj[j].balance == 0 ? "" : (Math.sign(ledgerObj[j].balance) < 0 ? " Dr" : " Cr")) + "</td>"

		//Calculate Total of Each Row
		bal1 += (isNaN(ledgerObj[j].subscription) ? 0 : Number(ledgerObj[j].subscription));
		bal2 += (isNaN(ledgerObj[j].dividend) ? 0 : Number(ledgerObj[j].dividend));
		bal3 += (isNaN(ledgerObj[j].share) ? 0 : Number(ledgerObj[j].share));
		bal4 += (isNaN(ledgerObj[j].charges) ? 0 : Number(ledgerObj[j].charges));
		bal5 += (isNaN(ledgerObj[j].discount) ? 0 : Number(ledgerObj[j].discount));
		bal6 += (isNaN(ledgerObj[j].prize) ? 0 : Number(ledgerObj[j].prize));
		tot = ledgerObj[j].balance;
	
	}

	//Total at the bottom
	txt += "</tr><tr><td></td><td colspan='3'><b>Total</td>";
	txt += "<td><b>" + (bal1==0 ? "&nbsp;" : currencyFormat(bal1)) + "</td>";
	txt += "<td><b>" + (bal2==0 ? "&nbsp;" : currencyFormat(bal2)) + "</td>";
	txt += "<td><b>" + (bal3==0 ? "&nbsp;" : currencyFormat(bal3)) + "</td>";
	txt += "<td><b>" + (bal4==0 ? "&nbsp;" : currencyFormat(bal4)) + "</td>";
	txt += "<td><b>" + (bal5==0 ? "&nbsp;" : currencyFormat(bal5)) + "</td>";
	txt += "<td><b>" + (bal6==0 ? "&nbsp;" : currencyFormat(bal6)) + "</td>";
	txt += "<td><b>"  + (tot == 0 ? "A/c Closed" : currencyFormat(Math.abs(tot)) + (Math.sign(tot) < 0 ? " Dr" : " Cr")) + "</td>";
	txt += "</tr><tr><td colspan='11' style='font-style: italic;' >Please notify the office imediately of any discrepancies in this statement. </br>As this is a computer generated printout, it need not be signed.</td>";
	txt += "</tr></tbody></table>";
	bPrintLedger = true;
	bPrintDues = false;
	return txt;

};


function PrintDuesOrLedger()
{
	var sPrintContent = "";
	var sPrintTitle = "";

	bMobile = false;

	if(bPrintDues && !bPrintLedger) {
		sPrintTitle = "Customer Dues List";
		sPrintContent = DisplayDuesList();
	} else if(bPrintLedger && !bPrintDues){
		sPrintTitle = "Customer Ledger Page";
		sPrintContent = DisplayLedger();
	} else {
		sPrintTitle = "NOTHING TO PRINT";
		sPrintContent = "<h1>NOTHING TO PRINT</h1>";
	}

	var mywindow = window.open('', 'PRINT');
	mywindow.document.write('<html><head><title>' + sPrintTitle  + '</title>');
    mywindow.document.write('</head><body >');
	mywindow.document.write(sPrintContent);
    mywindow.document.write('</body></html>');

    mywindow.print();
    mywindow.close();
    return true;
}
