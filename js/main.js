

window.onload = function () {

    document.getElementById("btnSendMessage").addEventListener("click", btnSendMessage_Clicked);
    document.getElementById("btnGetDuesList").addEventListener("click", btnGetDuesList_Clicked);

    if(getUrlParameter('pin') != ""){
        document.getElementById('txtpin').value = getUrlParameter('pin');
        btnGetDuesList_Clicked();
        window.scrollTo(0, document.getElementById('portfolio').offsetTop);
    }
    
};

function rdbChit_Selected(sSelectedChit) {
    document.getElementById("txtsubject").value = "Enquiry for New Chit"
    document.getElementById("txtmessage").value = "I am interested in " + sSelectedChit;
};

function btnChitContact_Clicked() {
    window.scrollTo(0, document.getElementById('contact').offsetTop)
};

//Code when btnLedger Button is Clicked
function btnLedger_Clicked(groupid, ticket){
	var divSubscriberDetails = document.getElementById("divSubscriberDetails");
	var btnLedger = document.getElementById("btnLedger" + groupid + ticket);
        btnLedger.value = "Loading...";

        //Build the JSON Data Object to Send to Server
        var data = {};
        data.groupid = groupid;
        data.ticket = ticket;
	    data.pin = sLookupCode;
        var json = JSON.stringify(data);

        //Create the Http Request
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function () {
            if (this.readyState == 4) {
                if (this.status == 200 && this.responseText.length > 10) {
                    //If data Found, Display Information
                    resultObj = JSON.parse(this.responseText);
                    ledgcustObj = resultObj[0];
                    ledgerObj = resultObj[1];
                    statusObj = resultObj[2];
	 	            FormatledgerObj();
                    divSubscriberDetails.innerHTML = DisplayLedger();
                }
                else {
		            divSubscriberDetails.innerHTML = "<br/><br/><b>No ledger details found.</b>";
                    console.log(this.responseText);
                }
                window.scrollTo(0, document.getElementById('portfolio').offsetTop)
            }
        };

        xhttp.open('POST', 'getledger.php', true);
        xhttp.setRequestHeader('Content-type', 'application/json; charset=UTF-8');
        xhttp.send(json);

};

//Code When GetDuesList Button is clicked.
function btnGetDuesList_Clicked() {
    var divSubscriberDetails = document.getElementById("divSubscriberDetails");
    var btnGetDuesList = document.getElementById("btnGetDuesList");
    var btnPrint = document.getElementById("btnPrint");

    if (document.getElementById("divSubscriberDetails").offsetWidth < 700) bMobile = true; 
        else bMobile = false;

	if(document.getElementById('txtpin').value.length == 0 && sLookupCode.length == 7){
		divSubscriberDetails.innerHTML = DisplayDuesList();
        btnGetDuesList.value = "Account Information";
        btnPrint.value= "Print";
        btnPrint.style.visibility = "visible";
		return true;
	}

	if(document.getElementById('txtpin').value.length != 0 && document.getElementById('txtpin').value.length != 7){
		divSubscriberDetails.innerHTML = "<br/><br/><b>No subscriber details found.</b>";
        btnGetDuesList.value = " Login ";
        btnPrint.style.visibility = "hidden";
        sLookupCode = "";
        document.getElementById('txtpin').value = "";
		return true;
	}

    
    if (document.getElementById('txtpin').value.length == 7) {

        btnGetDuesList.value = "Loading..";
	
        //Build the JSON Data Object to Send to Server
        var data = {};
        data.pin = document.getElementById('txtpin').value;
        var json = JSON.stringify(data);

        //Create the Http Request
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function () {
            if (this.readyState == 4) {
                if (this.status == 200 && this.responseText.length > 10) {
                    //If Found Customer Information, Display it.
                    resultObj = JSON.parse(this.responseText);
                    customerObj = resultObj[0];
                    duesObjAll = resultObj[1];
                    statusObj = resultObj[2];
                    sLookupCode = data.pin; 
                    divSubscriberDetails.innerHTML = DisplayDuesList();
                    btnGetDuesList.value = "Account Information";
                    btnPrint.value= "Print";
                    btnPrint.style.visibility = "visible";
                    document.getElementById('txtpin').value = "";
                }
                else {
                    divSubscriberDetails.innerHTML = "<br/><br/><b>No subscriber details found.</b>";
                    console.log(this.responseText);
                    btnGetDuesList.value = " Login ";
                    btnPrint.style.visibility = "hidden";
                    document.getElementById('txtpin').value = "";
			        sLookupCode = "";
                }
            }
        };

        xhttp.open('POST', 'getdueslist.php', true);
        xhttp.setRequestHeader('Content-type', 'application/json; charset=UTF-8');
        xhttp.send(json);

    } else {

        divSubscriberDetails.innerHTML = "<br/><br/><b>Please Enter a Valid PIN.</b>";
        btnGetDuesList.value = " Login ";
        btnPrint.style.visibility = "hidden";
		sLookupCode = "";
		return true;
    }

};



//Code When SendMessage Button is clicked.
function btnSendMessage_Clicked() {
    var contactForm = document.getElementById("frmContact");
    var divResult = document.getElementById("divResult");
    var btnSendMessage = document.getElementById("btnSendMessage");

    
    if (contactForm.reportValidity()) {

        btnSendMessage.value = "Sending...  ";
        
        //Build the JSON Data Object to Send to Server
        var data = {};
        data.name = document.getElementById('txtname').value;
        data.email = document.getElementById('txtemail').value;
        data.phone = document.getElementById('txtphone').value;
        data.subject = document.getElementById('txtsubject').value;
        data.message = document.getElementById('txtmessage').value;
        var json = JSON.stringify(data);

        //Create the Http Request
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function () {
            if (this.readyState == 4) {
                if (this.status == 200) {
                    document.getElementById('txtname').value = "";
                    document.getElementById('txtemail').value = "";
                    document.getElementById('txtphone').value = "";
                    document.getElementById('txtsubject').value = "";
                    document.getElementById('txtmessage').value = "";
                } 
                divResult.innerHTML = this.responseText;
                divResult.style.display = "block";
                btnSendMessage.value = "SEND MESSAGE";
            }
        };

        xhttp.open('POST', 'contact_mail.php', true);
        xhttp.setRequestHeader('Content-type', 'application/json; charset=UTF-8');
        xhttp.send(json);

    }

};

function FamilyChanged(){
	bFamily = document.getElementById("chkFamily").checked;
	document.getElementById("divSubscriberDetails").innerHTML = DisplayDuesList();
	document.getElementById("chkFamily").focus();
};


function ClosedChanged(){
	bClosed = document.getElementById("chkClosed").checked;
	document.getElementById("divSubscriberDetails").innerHTML = DisplayDuesList();
	document.getElementById("chkClosed").focus();
};

//Enter Key Pressed
function txtpin_Changed(event) {
    if (event.keyCode == 13) {
        btnGetDuesList_Clicked();
    }
};

function getUrlParameter(name) {
    name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
    var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
    var results = regex.exec(location.search);
    return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
};

