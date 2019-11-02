<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<html xmlns="http://www.w3.org/1999/xhtml">


<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">





<title>GEO CHITS PRIVATE LIMITED</title>


<link rel="stylesheet" href="css/style.css" type="text/css" />


<link href="css/skitter.styles.css" type="text/css" media="all" rel="stylesheet" />


<link href="css/menu.css" type="text/css" media="all" rel="stylesheet" />

	



<script src="js/jquery-1.6.3.min.js"></script>


<script src="js/jquery.easing.1.3.js"></script>


<script src="js/jquery.animate-colors-min.js"></script>


<script src="js/jquery.skitter.js"></script>




<script>

$(document).ready(function() {

	

	var options = {};



	if (document.location.search) {

		var array = document.location.search.split('=');

		var param = array[0].replace('?', '');

		var value = array[1];

		

		if (param == 'animation') {

			options.animation = value;

		}

		else if (param == 'type_navigation') {

			if (value == 'dots_preview') {

				$('.border_box').css({'marginBottom': '40px'});

				options['dots'] = true;

				options['preview'] = true;

			}

			else {

				options[value] = true;

				if (value == 'dots') $('.border_box').css({'marginBottom': '40px'});

			}

		}

	}

	

	$('.box_skitter_large').skitter(options);

	

	$(".prev_button").css({ opacity: 0.8 });

	$(".next_button").css({ opacity: 0.8 });

	

});

</script>
</head>




<body>


<div id="wrapper">


<div class="wrapper-box">


<div class="inner-wrapper">


<div class="header">


<div class="logo">
<a href="index.html"><img src="images/logo1.png" /></a></div>

<div class="enq"><a href="contact.html"><img src="images/send1.png"></a></div>
				

			
</div>


<div class="menu">


<ul id="nav">

					
<li><a href="index.html">Home</a></li>

					
<li><a href="about-us.html">About Us</a></li>

<li><a href="services.html">Service</a></li>
					
                   
<li><a href="subscriber.html">Subscriber</a></li>

					
<li><a href="contact.html">Contact Us</a></li>
					

				
</ul>

			
</div>

			

<div class="container">

				
<div class="col1">
		



<%
Dim custfilt, sqlstring, filter, loggedin
Dim inclfami, checked
Dim DataSource, con, rs

custfilt = Ucase(Request("custfilt"))
inclfami = Trim(Request("inclfami"))
loggedin = False

If inclfami <> "" Then
  checked = "checked"
Else
  checked = ""
End If

%>
<Html>
<Head>
<Title> Subscriber List </Title>
<Style type=text/css>
<!--
  TD.azero  {background-color: #40FF40}
  TD.aone   {background-color: #80FF80}
  TD.atwo   {background-color: #FFFF40}
  TD.athree {background-color: #FFC0C0}
  TD.afour  {background-color: #FF8080}
  TD.afive  {background-color: #FF4040}
  TD.atotal {font-weight: bold }
-->
</Style>
</Head>

<Body bgcolor=#FFEFDF>



<Center>
<Table>
<Tr>
<%

Dim letter, scriptname

scriptname = Request.ServerVariables("SCRIPT_NAME")
letter = Request("letter")
Dim i, recnum
For i = 0 To 25
%>
<Td width=10> <A href=<%=scriptname%>?letter=<%=Chr(65+ i) %>> <Font size=+3><%=Chr(65+ i) %> </Font></Td>
<%
Next 
%>
</Tr>
</Table>

<P>
<%
' Open database connection
Set con = Server.CreateObject("ADODB.Connection")


DataSource = "Provider=Microsoft.Jet.OLEDB.4.0;Persist Security Info=False;Data Source=" & Server.MapPath("Dueslist.mdb")

'DataSource = "Driver={Microsoft Visual FoxPro Driver};UID=;PWD=;SourceDB=" & Server.MapPath(".") & ";SourceType=DBF;Exclusive=No;BackgroundFetch=Yes;Collate=Machine;"


con.Open DataSource

sqlstring = "Select Distinct Dlb.last, Dlb.first, Dlb.lookupcode From Dueslist Dlb "
If letter <> "" Then
  sqlstring = sqlstring & " Where UCase(Left(Dlb.last, 1)) = '" & letter & "'"
Else
  sqlstring = sqlstring & " Where False "
End If


Set rs = con.Execute(sqlstring)
If rs.Eof Then
   %>
  	<%
Else
    %>
	<Table>
	  <Tr>
	<%
	recnum = 0
    While Not rs.Eof
	  %>
	  <Td><small>
	  <A href=listcust.asp?custfilt=<%=rs("lookupcode")%>&inclfami=1&checkall=1 > <%=rs("last") & " " & rs("first")%> </A>
          </small></Td>       
          <Td> <%=rs("lookupcode")%> </Td>
		  <%
	  recnum = recnum + 1
	  If recnum mod 1 = 0 Then
	  %>
  	    </Tr>
	    <Tr>
	  <%
	  End If
	  rs.MoveNext
	Wend
	%>
	  </Tr>
	</Table>
<%
End If

%>

</Center>
</Body>
</Html>

<% con.Close %>

<div class="footer">

			
<div class="footer-left">

				
<div class="ftr-social">

Social Links 

<a href="#"><img src="images/facebook.png" align="absmiddle" /></a>

					
<a href="#"><img src="images/twitter.png" align="absmiddle" /></a>

					
<a href="#"><img src="images/linkedin.png" align="absmiddle" /></a>

				
</div>

				
<p><a href="http://geochits.com">GEO CHITS PRIVATE LIMITED</a>&nbsp; Copyright 2015. All rights reserved.</a></p><br />

				
		</div>

			
<div class="footer-right">

				
			
</div>

		
</div>

	
</div><!--wrapper-box end-->

</div><!--wrapper end-->

</body>

</html>
