<!-- #Include file=adovbs.inc -->
<Link rel=stylesheet type=text/css href=noprint.css media=print>
<script language="JavaScript" src="calendar_eu.js"></script>
<link rel="stylesheet" href="calendar.css">

</head>

<Script language=javascript>
  function recalc()
  {
    alert("hello");
    //document.getElementById("tot00").value="Hello World";
  }

</Script>

<%
Dim custfilt, sqlstring, filter, loggedin, dueslevel, choice
Dim inclfami, inclclsd, checked, checkedc, checkall
Dim datefrom, dateto, s1, s2, balance, maxvouch
Dim DataSource, con, rs
Dim CompanyName
CompanyName ="Geo Chits Private Limited"

custfilt = Ucase(Request("custfilt"))
dueslevel = Trim(Request("dueslevel"))
choice = Trim(Request("choice"))
datefrom = Trim(Request("datefrom"))
dateto   = Trim(Request("dateto"))

If datefrom = "" Then
  datefrom = "1/4/" & Year(Now)
End if
If dateto = "" Then
  dateto = dmy(Now)
End If

If datefrom <> "" Then
  s1 = Instr(datefrom,  "/")
  s2 = Instr(s1+1, datefrom, "/")
  datefrom = datemonth(CInt(Mid(datefrom, s1+1, s2 - s1 - 1))) & " " & Mid(datefrom, 1, s1-1) & ", " & Mid(datefrom, s2+1)
End If

If dateto <> "" Then
  s1 = Instr(dateto,  "/")
  s2 = Instr(s1+1, dateto, "/")
  dateto = datemonth(CInt(Mid(dateto, s1+1, s2 - s1 - 1))) & " " & Mid(dateto, 1, s1-1) & ", " & Mid(dateto, s2+1)
End If

If dueslevel <> "" Then
  inclfami = ""
Else
  inclfami = Trim(Request("inclfami"))
  inclclsd = Trim(Request("inclclsd"))
End If
loggedin = False

If inclfami <> "" Then
  checked = "checked"
Else
  checked = ""
End If

If inclclsd <> "" Then
  checkedc = "checked"
Else
  checkedc = ""
End If

%>
<Html>
<Head>
<Title> <%=CompanyName%> - Subscriber Information System </Title>
<Style type=text/css>
<!--
  TD.zero  {width:150}
  TD.one   {width:150}
  TD.two   {width:150}
  TD.three {width:150}
  TD.four  {width:150}
  TD.five  {width:150}
  TD.total {width:150}
  TR {background-color: #FFFFEF}

-->
</Style>
</Head>

<%

' Open database connection
Set con = Server.CreateObject("ADODB.Connection")

DataSource = "Provider=Microsoft.Jet.OLEDB.4.0;Persist Security Info=False;Data Source=" & Server.MapPath("Dueslist.mdb")

'DataSource = "Driver={Microsoft Visual FoxPro Driver};UID=;PWD=;SourceDB=" & Server.MapPath(".") & ";SourceType=DBF;Exclusive=No;BackgroundFetch=Yes;Collate=Machine;"

con.Open DataSource

%>

<%
If choice = "updatedueslist" Then
  Call updatedueslist
  Response.End 
End If
%>


<Body>
<Center>
<% If custfilt = "" Then %>
<Table width=100%>
<Tr>
<Td><Form method=post action=listcust.asp >
  <Table width=100% bgcolor=white>
  <Tr>
  <Td align=center>  Welcome to our Online Subscriber Information System. </Td>
  </Tr>

  <Tr>
  <Td align=center>
  Please enter your <B>Personal Information Number (PIN)</B> and press Login: <Br>
    <Input name=custfilt type = "password" size=10>
	<Input name=inclfami type=hidden>
	<Input name=inclclsd type=hidden>
	<Input name=checkall type=hidden value=1>
	<Input name=choice type=hidden value=dues> 

    <Input type=submit value=Login>
</Td>
</Tr>
</Table>
</Form></Td>
</Tr>
</Table>

<% End If %>

<%
If custfilt <> "" Then

  sqlstring = "Select Dlb.* From Dueslist Dlb " &_
    "Where Dlb.lookupcode = '" & custfilt & "' "

  Set rs = con.Execute(sqlstring)
  %>
	<Table width=100%>
	<Tr>
	<Td>

<%	
  If rs.Eof Then
    %>
	No subscriber details found.
	<%
  Else
    loggedin = True
	%>
	<Center>
        <Div class=noprint>
	<Table width=100%>
	<Tr>
	<Td bgcolor=white>
           <Font size=+3><B><%=Trim(rs("sal")) & " " & Trim(rs("first")) & " " & Trim(rs("last"))%></B> </Font>
          <Br>
          <%= rs("address1")  %>, <%= rs("address2") %>, <%= rs("address3") %> <Br>

          Phone: <%= rs("phone1") %>
          <%= rs("phone2") %>

    </Td>
    </Tr>
    </Table>
    </Div>
    </Center>
    
    </Td>
    </Tr>

	<%
  End If
End If


If loggedin Then

  %>
  <Tr>
  <Td align=center> 
  <Div class=noprint>
  

  <Form method=post action=custview.asp >
    <Table>
	<Tr>
	<Td rowspan=2>
	<Input type=submit value="Account Information"> 
	</Td>
	<Td align=center>
	<Input name=custfilt type=hidden value=<%=custfilt%> > 
	<Input name=inclfami type=checkbox <%=checked%> value="1"> Include My Family 
	</Td>
	</Tr>
	<Tr>
	<Td align=center>
	<Input name=inclclsd type=checkbox <%=checkedc%> value="1"> Include Closed
	<Input name=choice type=hidden value=dues>
	<Input name=checkall type=hidden value=1>
	</Td>
	</Tr>
	</Table>
  </Form>

  <!--
  <Form method=post action=listcust.asp>
  <Table>
  <Tr>
  <Td>
  <Input name=choice type=hidden value=groups>
  <Input name=custfilt type=hidden value=<%=custfilt%> > 
  <Input type=submit value=Groups>
  </Td>
  </Tr>
  </Table>
  </Form>
  -->
  
  

  </Div>
  
  </Td>
  </Tr>
  <%

End If


Select Case Trim(Request("choice"))
  Case "dues" 
  %>
  <Tr>
  <Td>
   <!-- #include file=listdues.asp -->
  </Td>
  </Tr>
  <%
  
  Case "groups"
  %>
  <Tr>
  <Td>
   <!-- #include file=listgrou.asp -->
  </Td>
  </Tr>
  <%

  Case "install"
  %>
  <Tr>
  <Td>
   <!-- #include file=install.asp -->
  </Td>
  </Tr>
  <%

  Case "ledger"
  %>
  <Tr>
  <Td>
   <!-- #include file=ledger.asp -->
  </Td>
  </Tr>
  <%
  
End Select
%>

<%
 con.Close
%>

</Table>
</CENTER>

</Body>
</Html>

<%
Function monthdesc(date)
  monthdesc = MonthName(Month(date), True) & " " & Cstr(Year(date))
End Function

Function dmy(dDate)
  dmy = iif(dDate <> "", Day(dDate) & "/" & Month(dDate) & "/" & Year(dDate), "")
End Function

Function mdy(dDate)
  mdy = iif(dDate <> "", Month(dDate) & "/" & Day(dDate) & "/" & Year(dDate), "")
End Function

Function dtos(dDate)
  dtos = Year(dDate) & Right("00" & Month(dDate), 2) & Right("00" & Day(dDate), 2)
End Function

Function properamount(amount)
  
  If IsNull(amount) Or IsEmpty(amount) Then
    properamount = 0.00
  Else
    properamount = CSng(amount)
  End If
End Function

Function formatamount(amount)
  amount = properamount(amount)
  If amount = 0.00 Then
    formatamount = emptycol
  Else
    formatamount = FormatNumber(amount)
  End If
End Function

Function EmptyCol
  emptycol = "<Font color=#FFFFFF>.</Font>"
End Function

Function Iif(lExpr, exprT, exprF)
  If lExpr Then
    Iif = exprT
  Else
    Iif = exprF
  End If
End Function

Function bofy(dDate)
  While Month(dDate) <> 4 Or Day(dDate) <> 1
    dDate = dDate - 1
  Wend
  bofy = dDate + 1
End Function

Function datemonth(mon)
  Select Case mon
    Case 1
    datemonth = "Jan"

    Case 2
    datemonth = "Feb"
    
    Case 3
    datemonth = "Mar"
    
    Case 4
    datemonth = "Apr"
    
    Case 5
    datemonth = "May"
    
    Case 6
    datemonth = "Jun"
    
    Case 7
    datemonth = "Jul"
    
    Case 8
    datemonth = "Aug"
    
    Case 9
    datemonth = "Sep"
    
    Case 10
    datemonth = "Oct"
    
    Case 11
    datemonth = "Nov"
    
    Case 12
    datemonth = "Dec"
    
  End Select
End Function

Sub updatedueslist
  Dim cmdstr, enrollid, datetime, introw, [type], m00, m01, m02, m03, m04, m05, xtotals
  enrollid = Trim(Request("enrollid"))
  datetime = Trim(Request("date")) & " " & Trim(Request("time"))
  introw = Trim(Request("introw"))
  [type] = Trim(Request("type"))
  m00 = Trim(Request("m00"))
  m01 = Trim(Request("m01"))
  m02 = Trim(Request("m02"))
  m03 = Trim(Request("m03"))
  m04 = Trim(Request("m04"))
  m05 = Trim(Request("m05"))
  xtotals = Trim(Request("xtotals"))
  If enrollid <> "" Then
    cmdstr = "Update Dueslist Set " & _
    "m00 = " & m00 & ", " & _
    "m01 = " & m01 & ", " & _
    "m02 = " & m02 & ", " & _
    "m03 = " & m03 & ", " & _
    "m04 = " & m05 & ", " & _
    "m05 = " & m05 & ", " & _
    "xtotals = " & xtotals & ", " & _
    "termstat = True, " & _
    "asondate = '" & datetime & "' " & _
    "Where enrollid = '" & enrollid & "' And type = " & [type]
    
    Response.Write cmdstr
    con.Execute(cmdstr)
    If introw = "" Then
      cmdstr = "Delete From Dueslist Where enrollid = '" & enrollid & "' And type = 3"
      Response.Write(cmdstr)
      con.Execute(cmdstr)
    End If
  End If

End Sub

%>