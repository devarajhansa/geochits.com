<%

  Set rs = con.Execute("Select Max(vouchid) As vouchid From Payments " & _
    "Where Payments.enrollid = '" & Request("enrollid") & "' " & _
    "And Not Payments.deleted ")

  maxvouch = rs("vouchid")

  cmdstr = "Select " & _
    "Receipts.rcptdate As trandate, Instrcpt.insnum, '000000' As vouchid, Receipts.rcptnum As refnum, " & _
    "Receipts.rcptid, Install.auctdate, Install.insamount, Install.dividend, " & _
    "Enroll.nshare, Instrcpt.sub, Instrcpt.divi, " & _
    "Receipts.penalty, Receipts.other As other, " & _
    "0.00 As pamount, 0.00 As tamount, 0.00 As pdivi, 0.00 As commission, 1 As type, " & _
    "Business.*, " & _
    "Groups.gname, Groups.regdat, Groups.groupnum, Groups.groupdate, Groups.gamount, Groups.numins, " & _
    "Enroll.slnum, Enroll.partnum, Enroll.nshare, " & _
    "Customer.sal, Customer.last, Customer.first, Customer.address1, Customer.address2, Customer.address3, Customer.city, Customer.state " & _
    "From Enroll, Receipts, Instrcpt, Install, Groups, Customer, Business " & _
    "Where Instrcpt.rcptid = Receipts.rcptid " & _
    "And Instrcpt.enrollid = Receipts.enrollid " & _
    "And Enroll.enrollid = Receipts.enrollid " & _
    "And Install.insnum = Instrcpt.insnum " & _
    "And Install.groupid = Groups.groupid " & _
    "And Groups.groupid = Enroll.groupid " & _
    "And Customer.custid = Enroll.custid " & _
    "And Receipts.enrollid = '" & Request("enrollid") & "' " & _
    "And Not Receipts.deleted " & _
    "Union " & _
    "Select Payments.vouchdate As trandate,  Enroll.prizedins As insnum, Payments.vouchid, Payments.vouchnum As refnum, " & _
    "'000000' As rcptid, Install.auctdate, 0.00 As insamount, 0.00 As dividend, " & _
    "Enroll.nshare, 0.00 As sub, 0.00 As divi, " & _
    "0.00 As penalty, 0.00 As other, " & _
    "Payments.amount As pamount, " & _
    "Payments.taxamt + Payments.cess1amt + Payments.cess2amt As tamount, " & _
    "IIf(Payments.vouchid = '" & maxvouch & "', Groups.gamount - Install.bidamount - Install.commission, 0.00) As pdivi, " & _
    "IIf(Payments.vouchid = '" & maxvouch & "', Install.commission, 0.00) As commission, " & _
    "2 As type, " & _
    "Business.*, " & _
    "Groups.gname, Groups.regdat, Groups.groupnum, Groups.groupdate, Groups.gamount, Groups.numins, " & _
    "Enroll.slnum, Enroll.partnum, Enroll.nshare, " & _
    "Customer.sal, Customer.last, Customer.first, Customer.address1, Customer.address2, Customer.address3, Customer.city, Customer.state " & _
    "From Enroll, Install, Groups, Payments, Customer, Business " & _
    "Where Enroll.groupid = Groups.groupid " & _
    "And Enroll.enrollid = '" & Request("enrollid") & "' " & _
    "And Enroll.prizedins = Install.insnum " & _
    "And Install.groupid = Groups.groupid " & _
    "And Payments.enrollid = Enroll.enrollid " & _
    "And Customer.custid = Enroll.custid " & _
    "And Not Payments.deleted " & _
    "Order By 1, 2, 3"
    
    'Response.Write cmdstr

   
    Set rs = con.Execute(cmdstr)
    
    
%>

<Div align=center>
<Div class=noprint>

<Style type=text/css>
  table.ledger {border-collapse: collapse; }
  th.led {border: 1px solid black; }
  td.led {border: 1px solid black; }
</Style>
<Table>
<Tr>
	<Td><Form name="ledgerinput" method=post action=listcust.asp> 
    <Input name=choice type=hidden value=ledger>
    <Input name=enrollid type=hidden value=<%=Request("enrollid")%> >
    <Input name=custfilt type=hidden value=<%=custfilt%> > 
    </Td>
  </Tr>
  <Tr>
  <Td align=left> From </Td> <Td>
  <input type="text" name="datefrom" value=<%=dmy(datefrom)%> >
<script language="JavaScript">
	new tcal ({
		// form name
		'formname': 'ledgerinput',
		// input name
		'controlname': 'datefrom'
	});

	</script>
</Td>
  </Tr>
  <Tr>
  <Td align=left> To </Td> 
  <Td>
<input type="text" name="dateto" value=<%=dmy(dateto)%> >
<script language="JavaScript">
	new tcal ({
		// form name
		'formname': 'ledgerinput',
		// input name
		'controlname': 'dateto'
	});

	</script>
  </Td>
  </Tr>
  <Tr>
  <Td></Td>
  <Td>
    <Input type=submit value=Submit>
    <!--
<%=FormatDatetime(datefrom, vbLongdate)%> - 
<%=FormatDatetime(dateto, vbLongdate)%>
    -->
  </Td>
    </Form>
</Tr>
</Table>
<Hr>

</Div>

<Table>
<Tr><Td align=center colspan=2><b><%=rs("bizline1")%></b></Td></Tr>
<Tr><Td align=center colspan=2>FORM XIV (Section 23 & Rules 25)</Td></Tr>
<Tr><Td>SUBSCRIBER'S LEDGER</Td><Td><b><%=dmy(datefrom)%>- <%=dmy(dateto)%></b></Td></Tr>
<Tr><Td align=left>CHIT GROUP</Td><Td> <%=RS("gname")%></Td></Tr>
<Tr><Td>SECTION-1: Receipts and Payments in respect of subscruber</Td><Td> <%=rs("sal") & " " & rs("first") & " " & rs("last")%> 
</Td></Tr>
<Tr><Td>Address</Td><Td><%=rs("address1")%></Td></Tr>
<Tr><td></td><Td><%=rs("address2")%></Td></Tr>
<Tr><td></td><Td><%=rs("address3")%></Td></Tr>
<Tr><td></td><Td><%=rs("city")%></Td></Tr>
<Tr><td></td><Td><%=rs("state")%></Td></Tr>
<Tr>
<Td>Office where the chit agreement is registered at</Td> <Td><%=rs("regdat")%></Td>
<Td>
</Tr>
<Tr>
<Td>Registration Number and Date</Td> <Td><%=rs("groupnum")%>, <%=rs("groupdate")%></Td>
</Tr>
<Tr>
<Td>Ticket No. of Subscriber</Td> <Td><%=rs("slnum")%><%=rs("partnum")%></Td>
</Tr>
<Tr>
<Td>Number of Tickets taken</Td> <Td>One</Td>
</Tr>
<Tr>
<Td>Chit Amount</Td> <Td><%=rs("gamount")/ rs("nshare")%></Td>
</Tr>
<Tr>
<Td>Duration of Chit</Td> <Td><%=rs("numins")%></Td>
</Tr>
</Table>




<Table class=ledger cellpadding=2>
<Thead valign=top >
<Th class=led>Date</Th>
<Th class=led>Receipt No</Th>

<Th class=led>Inst</Th>
<Th class=led>Month</Th>
<Th class=led>Subscription</Th>
<Th class=led>Dividend</Th>
<Th class=led>Share</Th>
<Th class=led>Charges</Th>
<Th class=led>Discount</Th>
<Th class=led>Prize</Th>
<Th class=led>Balance</Th>
</Thead>
<%

Dim rnum, lastrnum, inum, lastinum, lastrid
Dim subtot, divitot, chgtot
Dim pamttot, pdivitot
rnum = 0
lastrnum = 0
inum = 0
lastinum = 0
lastrid = "000000"
opbal = 0.00
opline = False
lastbal = 0.00
balance = 0.00
subtot  = 0.00
divitot = 0.00
chgtot  = 0.00
clbalance = 0.000

While Not rs.Eof
  rnum = iif(rs("refnum") > 0, rs("refnum"), rnum)
  inum = iif(rs("refnum") > 0, rs("insnum"), inum) ' refnum is used since only rcpts are considered
  
  lastbal = balance
  balance = balance + rs("nshare") * (rs("pamount") + properamount(rs("tamount")) + rs("pdivi") + rs("commission") - rs("sub") - rs("divi"))
  
  If dtos(rs("trandate")) >= dtos(datefrom) And dtos(rs("trandate")) <= dtos(dateto) Then
    If Not opline Then
      opbal = lastbal 
      opline = True

     If opbal <> 0.00 Then
     %>
     <Tr>
     <Td class=led colspan=10>Opening Balance</td><Td class=led> <%=formatamount(Abs(opbal)) & " " & iif(opbal > 0, "Dr", "Cr")%></Td>
     </Tr>
     <%
     End If

    End If
    subtot = subtot + rs("nshare") * rs("sub")
    divitot= divitot + rs("nshare") * rs("divi")
    If rs("rcptid") <> lastrid Then
      chgtot = chgtot + rs("nshare") * (rs("penalty") + rs("other"))
      lastrid = rs("rcptid")
    End If
    pamttot = pamttot + rs("nshare") * (rs("pamount") + properamount(rs("tamount")))
    pdivitot = pdivitot + rs("nshare") * (rs("pdivi") + rs("commission"))


  %>
  
  <Tr>
  <Td class=led width="1in" align=left><%=dmy(rs("trandate"))%></Td>
  <Td class=led width="0.5in" ><%=iif(rnum = lastrnum, EmptyCol, rs("refnum"))%></Td>
  <Td class=led width="0.1in" ><%=rs("insnum")%> </Td>
  <Td class=led width="0.5in"	><%=iif(rs("type") = 2, "Prize Payment", monthdesc(rs("auctdate")))%></Td>
  <Td class=led width=0.5in  align=right><%=iif(rs("type") = 1, formatamount(rs("nshare") * (rs("insamount") + rs("dividend"))), EmptyCol)%> </Td>
  <Td class=led  align=right><%=formatamount(rs("nshare") * rs("divi"))%> </Td>
  <Td class=led align=right><%=iif(rs("type") = 1, formatamount(rs("nshare") * rs("sub")), EmptyCol)%> </Td>
  <Td class=led align=right><%=iif(rnum = lastrnum, EmptyCol, formatamount(rs("nshare") * (rs("penalty") + rs("other")))) %> </Td>
  <Td class=led width=0.5in align=right><%=formatamount(rs("nshare") * (rs("pdivi") + rs("commission"))) %> </Td>
  <Td class=led width=0.5in align=right><%=formatamount(rs("nshare") * (rs("pamount") + properamount(rs("tamount"))) )%> </Td>
  <Td class=led width=.8in align=right><%=iif(balance <> 0.00, formatamount(Abs(balance)) & " " & iif(balance > 0, "Dr", "Cr"), "0.00") %></Td>
  </Tr>
  
  <%
    clbalance = balance
  End If
  
  lastrnum = rnum
  lastinum = inum
  rs.MoveNext
Wend
%>
<Tr>
<Td class=led><%=EmptyCol%></Td><Td class=led colspan=3><b>Total</b></Td>
<Td class=led align=right><b><%=formatamount(subtot + divitot)%></b></Td>
<Td class=led align=right><b><%=formatamount(divitot)%></b></Td>
<Td class=led align=right><b><%=formatamount(subtot)%></b></Td>
<Td class=led align=right><b><%=formatamount(chgtot)%></b></Td>
<Td class=led align=right><b><%=formatamount(pdivitot)%></b></Td>
<Td class=led align=right><b><%=formatamount(pamttot)%></b></Td>
<Td class=led align=right><b><%=formatamount(Abs(clbalance)) & " " & iif(clbalance > 0, "Dr", iif(clbalance < 0, "Cr", "A/c Closed"))%></b></Td>
</Tr>

<Tr>
<Td class=led colspan=11><i>Please notify the office imediately of any discrepancies in this statement.<br>As this is a computer generated printout, it need not be signed.
</i>
</Td>
</Tr>


</Table>
</Div>

<Div align=center class=noprint>
<form>
<input type="button" value="   Print...   " Onclick="print()" ;>
</form>
</Div>

