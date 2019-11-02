

<%
filter   = Trim(Request("custfilt"))
inclfami = Trim(Request("inclfami"))
inclclsd = Trim(Request("inclclsd"))

Dim checkit00, checkit01, checkit02, checkit03, checkit04, checkit05, totalamount
Dim count

If Request("update") <> "" Then
  count = 1
  While Request("enrollid" & count) <> ""

    checkit00 = Iif(Request("en" & Request("enrollid" & count) & "00") <> "", "checked", "")
    checkit01 = Iif(Request("en" & Request("enrollid" & count) & "01") <> "", "checked", "")
    checkit02 = Iif(Request("en" & Request("enrollid" & count) & "02") <> "", "checked", "")
    checkit03 = Iif(Request("en" & Request("enrollid" & count) & "03") <> "", "checked", "")
    checkit04 = Iif(Request("en" & Request("enrollid" & count) & "04") <> "", "checked", "")
    checkit05 = Iif(Request("en" & Request("enrollid" & count) & "05") <> "", "checked", "")

    sqlstring = "Update Dueslist Set " & _
      "paid00 = " & Iif(checkit00 = "", "False", "True") & ", " & _
      "paid01 = " & Iif(checkit01 = "", "False", "True") & ", " & _
      "paid02 = " & Iif(checkit02 = "", "False", "True") & ", " & _
      "paid03 = " & Iif(checkit03 = "", "False", "True") & ", " & _
      "paid04 = " & Iif(checkit04 = "", "False", "True") & ", " & _
      "paid05 = " & Iif(checkit05 = "", "False", "True") & " " & _
	  "Where enrollid = '" & Request("enrollid" & count) & "'"

    'response.write sqlstring & "<Br>"

    con.Execute sqlstring

    count = count + 1
  Wend
End If

count = 0

sqlstring = "Select Dlb.* From Dueslist Dlb " &_
  "Where Dlb.lookupcode = '" & filter & "' "
If inclclsd = "" Then
  sqlstring = sqlstring & " And Iif(Dlb.cinsnum = Dlb.numins, Dlb.xtotals > 0.00, True)" 
End If

If inclfami <> "" Then

  sqlstring = sqlstring & " " &_
    "Union " &_
	"Select Dla.* From Dueslist Dla, Dueslist Dlb " &_
    "Where Not Dla.famid = '' And Dla.famid = Dlb.famid And Dlb.lookupcode = '" & filter & "' "

  If inclclsd = "" Then
    sqlstring = sqlstring & " And Iif(Dla.cinsnum = Dla.numins, Dla.xtotals > 0.00, True)" 
  End If

  ' currently not used
  Dim selefarm
  selefarm = "Select Distinct Dla.last, Dla.first, Dla.lookupcode From Dueslist Dla, Dueslist Dlb " &_
    "Where Dla.famid = Dlb.famid And Dlb.lookupcode = '" & filter & "' " & ""

End If

sqlstring = sqlstring & " " &_
  "Order By 2, 3, 20, 6, 10"

 'response.write sqlstring & "<Br>"

Set rs = con.Execute(sqlstring)

Dim duesexist, statdate, m00, m01, m02, m03, m04, m05, xtotals, chittota, firstdue, lastcust, checkit
Dim m00sub, m01sub, m02sub, m03sub, m04sub, m05sub, xtotsub

duesexist = False
chittota = 0.00
m00 = 0.00
m01 = 0.00
m02 = 0.00
m03 = 0.00
m04 = 0.00
m05 = 0.00
xtotals = 0.00
m00sub = 0.00
m01sub = 0.00
m02sub = 0.00
m03sub = 0.00
m04sub = 0.00
m05sub = 0.00
xtotsub = 0.00

firstdue = 0

If Not rs.Eof Then 
  duesexist = True
  statdate = rs("asondate")
  stattime = rs("asontime")
  lastcust = ""
%>



<head>
<title></title>
</head>

<body>


<Font size=+1>Account Statement</Font> <Br>
<Table bgcolor=orange bordercolor = black cellpadding = 5>
<Tr bgcolor=FFCF6F>
  <Th> No. </Th>
  <Th> Name    </Th>
  <Th> Group/Inst </Th>
  <Th> Ticket </Th>
  <Th> Auction </Th>
  <Th> Auction Time </Th>
  <Th> <%=monthdesc(DateAdd("m",  0, rs("maxdued")) )%> </Th>
  <Th> <%=monthdesc(DateAdd("m", -1, rs("maxdued")) )%> </Th>
  <Th> <%=monthdesc(DateAdd("m", -2, rs("maxdued")) )%> </Th>
  <Th> <%=monthdesc(DateAdd("m", -3, rs("maxdued")) )%> </Th>
  <Th> <%=monthdesc(DateAdd("m", -4, rs("maxdued")) )%> </Th>
  <Th> As On <%=monthdesc(DateAdd("m", -5, rs("maxdued")) )%> </Th>
  <Th> Total </Th>
</Tr>
<% End If %>

<!--  <Form method=post action=listcust.asp> -->

<% 


count = 0
While Not rs.Eof

  If rs("custid") <> lastcust Then
  %>
  <% If False Then %>
  <Tr>
    <Td colspan=6> </Td>
    <Td> <%=formatamount(m00sub)%></Td>
    <Td> <%=formatamount(m01sub)%></Td>
    <Td> <%=formatamount(m02sub)%></Td>
  </Tr>
  <% End If %>
  <%
    m00sub = 0.00
	m01sub = 0.00
	m02sub = 0.00
    lastcust = rs("custid")
  Else
    m00sub = m00sub + properamount(rs("m00"))
    m01sub = m01sub + properamount(rs("m01"))
    m02sub = m02sub + properamount(rs("m02"))
  End If

%>
  <%
  If Iif(CInt(rs("type")) = 3, properamount(rs("xtotals")) > 0.00, True) Then

  %>
  <Tr>

    <%
	If CInt(rs("type")) = 3 Then
	  chittota = chittota + properamount(rs("xtotals"))
	  %>
	  <Td > <Font color=#FFFFFF>. </Font></Td>
      <Td colspan=5 > Late Fee </Td>
	<%
	Else
      count = count + 1
      chittota = properamount(rs("xtotals"))
	  If properamount(rs("m05")) > 0 Then
	    firstdue = 5
	  End If
	  If properamount(rs("m04")) > 0 Then
	    firstdue = 4
	  End If
	  If properamount(rs("m03")) > 0 Then
	    firstdue = 3
	  End If
	  If properamount(rs("m02")) > 0 Then
	    firstdue = 2
	  End If
	  If properamount(rs("m01")) > 0 Then
	    firstdue = 1
	  End If
	  If properamount(rs("m00")) > 0 Then
	    firstdue = 0
	  End If
	%>
	    <Td align=center> <%= count %>
		  <Input name=<%="en" & rs("enrollid")%> type = hidden value=1>
		  <Input name=<%="enrollid" & count%> type=hidden value=<%=rs("enrollid")%> >
		</Td>
            <Td><%= rs("last") & " " & rs("first") %>
	<%=iif(rs("termstat"), "<br><Div style=font-size:xx-small>(Last Receipt at:" & Day(rs("asondate")) & "/" & Month(rs("asondate")) & "/" & Year(rs("asondate")) & " " & FormatDateTime(rs("asondate"), vbLongTime) & ")</Div>", "")%>
<Form method=post action=listcust.asp> 
<Input name=choice type=hidden value=ledger>
<Input name=enrollid type=hidden value=<%=rs("enrollid")%> >
<Input name=custfilt type=hidden value=<%=custfilt%> > 
<Input name=datefrom type=hidden value=<%=dmy(datefrom)%> >
<Input name=dateto   type=hidden value=<%=dmy(dateto)%> >
<Input type=submit value=Ledger id=submit>
</Td> 
</Form>
	    
	  <Td><B><%= rs("gname") %></B> (<%=rs("gamount")%>/<%=rs("numins")%>)</Td>
	  <Td> <%=rs("slnum")%><%=partnum%><%=Iif(rs("prized"), " Prized", "")%>
    
    </Td>
  <Td> <%=rs("cinsnum")%> </Td>
	<Td> <%=FormatDateTime(rs("auctdate"), vbLongDate)%> <Br> <%= rs("aucttime")%> </Td>
	
	<%
	End If


    totalamount = properamount(rs("xtotals"))
	If properamount(rs("xtotals")) = 0.00 Then
	%>
	  <Td colspan=7 align=center> Up-to-date </Td>
	<%
	Else
	%>
	
    <% checkit00 = Iif(rs("paid00"), "checked", "") %>
    <Td	<%=Iif(properamount(rs("m00")) > 0.00, "bgcolor=#40FF40", "")%> align=right class=zero>  
	
	<%=Iif(firstdue <= 0 And CInt(rs("type")) = 1 And properamount(rs("m00")) > 0.00, "(" & CInt(rs("cinsnum")) + firstdue - 0 & ")", "")%> 
	<Br> <%=formatamount(Iif(Not rs("paid00"), rs("m00"), 0.00)) %> 
	<Br>
	<%  If firstdue <= 0 And CInt(rs("type")) = 1 And properamount(rs("m00")) > 0.00 Then %>
	    <!--Paid--> <Input name=<%="en" & rs("enrollid") & "00"%> type = checkbox <%=checkit00%> value=1 onclick="recalc();">
	<%	End If %>
	</Td>
	<% totalamount = totalamount - Iif(checkit00 <> "", properamount(rs("m00")), 0.00) %>

    <% checkit01 = Iif(rs("paid01"), "checked", "") %>
	<Td <%=Iif(properamount(rs("m01")) > 0.00, "bgcolor=#80FF80", "")%> align=right class=one>   
	<%=Iif(firstdue <= 1 And CInt(rs("type")) = 1 And properamount(rs("m01")) > 0.00, "(" & CInt(rs("cinsnum")) + firstdue - 1 & ")", "")%> 
	<Br> <%=formatamount(Iif(Not rs("paid01"), rs("m01"), 0.00)) %> 
	<Br>
	<%  If firstdue <= 1 And CInt(rs("type")) = 1 And properamount(rs("m01")) > 0.00 Then %>
	    <!--Paid--> <Input name=<%="en" & rs("enrollid") & "01"%> type = checkbox <%=checkit01%> value=1>
	<%	End If %>
	</Td>
	<% totalamount = totalamount - Iif(checkit01 <> "", properamount(rs("m01")), 0.00) %>

    <% checkit02 = Iif(rs("paid02"), "checked", "") %>
	<Td <%=Iif(properamount(rs("m02")) > 0.00, "bgcolor=#FFFF40", "")%> align=right class=two>   
	<%=Iif(firstdue <= 2 And CInt(rs("type")) = 1 And properamount(rs("m02")) > 0.00, "(" & CInt(rs("cinsnum")) + firstdue - 2 & ")", "")%> 
	<Br> <%=formatamount(Iif(Not rs("paid02"), rs("m02"), 0.00)) %> 
	<Br>
	<%  If firstdue <= 2 And CInt(rs("type")) = 1 And properamount(rs("m02")) > 0.00 Then %>
	    <!--Paid--> <Input name=<%="en" & rs("enrollid") & "02"%> type = checkbox <%=checkit02%> value=1>
	<%	End If %>
	</Td>
	<% totalamount = totalamount - Iif(checkit02 <> "", properamount(rs("m02")), 0.00) %>

    <% checkit03 = Iif(rs("paid03"), "checked", "") %>
    <Td <%=Iif(properamount(rs("m03")) > 0.00, "bgcolor=#FFC0C0", "")%> align=right class=three> 
	<%=Iif(firstdue <= 3 And CInt(rs("type")) = 1 And properamount(rs("m03")) > 0.00, "(" & CInt(rs("cinsnum")) + firstdue - 3 & ")", "")%> 
	<Br> <%=formatamount(Iif(Not rs("paid03"), rs("m03"), 0.00)) %> 
	<Br>
	<%  If firstdue <= 3 And CInt(rs("type")) = 1 And properamount(rs("m03")) > 0.00 Then %>
	    <!--Paid--> <Input name=<%="en" & rs("enrollid") & "03"%> type = checkbox <%=checkit03%> value=1>
	<%	End If %>
	</Td>
	<% totalamount = totalamount - Iif(checkit03 <> "", properamount(rs("m03")), 0.00) %>
    
    <% checkit04 = Iif(rs("paid04"), "checked", "") %>
	<Td <%=Iif(properamount(rs("m04")) > 0.00, "bgcolor=#FF8080", "")%> align=right class=four>  
	<%=Iif(firstdue <= 4 And CInt(rs("type")) = 1 And properamount(rs("m04")) > 0.00, "(" & CInt(rs("cinsnum")) + firstdue - 4 & ")", "")%> 
	<Br> <%=formatamount(Iif(Not rs("paid04"), rs("m04"), 0.00)) %> 
	<Br>
	<%  If firstdue <= 4 And CInt(rs("type")) = 1 And properamount(rs("m04")) > 0.00 Then %>
	    <!--Paid--> <Input name=<%="en" & rs("enrollid") & "04"%> type = checkbox <%=checkit04%> value=1>
	<%	End If %>
	</Td>
	<% totalamount = totalamount - Iif(checkit04 <> "", properamount(rs("m04")), 0.00) %>
	
    <% checkit05 = Iif(rs("paid05"), "checked", "") %>
	<Td <%=Iif(properamount(rs("m05")) > 0.00, "bgcolor=#FF4040", "")%> align=right class=five>  
	<%=Iif(firstdue <= 5 And CInt(rs("type")) = 1 And properamount(rs("m05")) > 0.00, "(" & CInt(rs("cinsnum")) + firstdue - 5 & ")", "")%> 
	<Br> <%=formatamount(Iif(Not rs("paid05"), rs("m05"), 0.00)) %> 
	<Br>
	<%  If firstdue <= 5 And CInt(rs("type")) = 1 And properamount(rs("m05")) > 0.00 Then %>
	    <!--Paid--> <Input name=<%="en" & rs("enrollid") & "05"%> type = checkbox <%=checkit05%> value=1>
	<%	End If %>
	</Td>
	<% totalamount = totalamount - Iif(checkit05 <> "", properamount(rs("m05")), 0.00) %>
	<Td align=right class=total>  <%=formatamount(totalamount) %></Td>
	<%
	End If
	%>
	
  </Tr>
  <%
  xtotals = xtotals + totalamount
  End If

  m00 = m00 + Iif(checkit00 = "", properamount(rs("m00")), 0.00)
  m01 = m01 + Iif(checkit01 = "", properamount(rs("m01")), 0.00)
  m02 = m02 + Iif(checkit02 = "", properamount(rs("m02")), 0.00)
  m03 = m03 + Iif(checkit03 = "", properamount(rs("m03")), 0.00)
  m04 = m04 + Iif(checkit04 = "", properamount(rs("m04")), 0.00)
  m05 = m05 + Iif(checkit05 = "", properamount(rs("m05")), 0.00)
  rs.MoveNext 
Wend
%>
<% If duesexist Then %>
<Tr> 
  <Td colspan=6 > Total </Td>
  <Td id=tot00 <%=Iif(m00 > 0.00, "bgcolor=#40FF40", "")%> align=right class=zero>  <%=formatamount(m00)%></Td>
  <Td <%=Iif(m01 > 0.00, "bgcolor=#80FF80", "")%> align=right class=one>   <%=formatamount(m01)%></Td>
  <Td <%=Iif(m02 > 0.00, "bgcolor=#FFFF40", "")%> align=right class=two>   <%=formatamount(m02)%></Td>
  <Td <%=Iif(m03 > 0.00, "bgcolor=#FFC0C0", "")%> align=right class=three> <%=formatamount(m03)%></Td>
  <Td <%=Iif(m04 > 0.00, "bgcolor=#FF8080", "")%> align=right class=four>  <%=formatamount(m04)%></Td>
  <Td <%=Iif(m05 > 0.00, "bgcolor=#FF4040", "")%> align=right class=five>  <%=formatamount(m05)%></Td>
  <Td align=right class=total> <%=formatamount(xtotals)%></Td>
</Tr>
<Tr>
  <Td colspan=13>

  <Input name=inclfami type=hidden value=<%=inclfami%> >
  <Input name=inclclsd type=hidden value=<%=inclclsd%> >
  <Input name=custfilt type=hidden value=<%=filter%> >
  <Input name=choice type=hidden value=dues>
  <Input type=submit value="Update">
  <Input name=update type=hidden value=1>
  </Form>
  </Td>
</Tr>
<Tr>
  <Td colspan=13> 
  Statement generated on <%=FormatDateTime(statdate, vbLongDate)%> --- <%=stattime%>. <Br> </Br>
  <B>Please make the payment on or before 10<Sup>th</Sup> of every month. No dividend will be payable after the due date. </B> <Br></Br>
All remittances should be made payable to <B><Font color=red> <%=CompanyName%></Font> at Coimbatore</B>.</Br> 
Cheques should be crossed and accompanied by covering letters containing Subscriber's Name and Group Number of the Chit.
</Br> 
<Br>For Bank Transfer use
  <Table width=70% bgcolor=bisque align=center cellpadding=5>
  <Tr align=center>
  <Th>Bank</Th><Th>IFS Code</Th><Th>A/c Number</Th>
  </Tr>
  <Tr><Td>Corporation Bank  - CBCA</Td><Td>CORP0000113 </Td><Td>510101000160074</Td></Tr>
  </Table>

</Td>
</Tr>
</Table>

<% End If %>