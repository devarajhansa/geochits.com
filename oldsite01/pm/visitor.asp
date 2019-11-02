<HTML>
<HEAD>
<META NAME="GENERATOR" Content="Microsoft Developer Studio">
<META HTTP-EQUIV="Content-Type" content="text/html; charset=iso-8859-1">
<TITLE>Document Title</TITLE>
</HEAD>
<BODY>

<%
Dim DataSource, con, rs
DataSource = "Driver={Microsoft Visual FoxPro Driver};UID=;PWD=;SourceDB=" & Server.MapPath(".") & ";SourceType=DBF;Exclusive=No;BackgroundFetch=Yes;Collate=Machine;"
Set con = Server.CreateObject("ADODB.Connection")
con.Open DataSource

  sqlstring = "Select Distinct Dlb.last, Dlb.first, Vi.day, Vi.month, Vi.year, Vi.time From Dueslist Dlb, Visitor Vi " &_
    "Where Dlb.lookupcode = Vi.lookupcode " &_ 
	"Order By Vi.year, Vi.month, Vi.day "

  Set rs = con.Execute(sqlstring)
  If Not rs.Eof Then
  %>
    <Table border=1>
	<%
    While Not rs.Eof
	%>
	  <Tr>
	   <Td><%=Trim(rs("first")) & " " & Trim(rs("last"))%> </Td>
	   <Td><%=DateSerial(rs("year"), rs("month"), rs("day"))%> </Td>
	   <Td><%=rs("time")%> </Td>
      </Tr>
    <%
	  rs.MoveNext
	Wend
	%>
	</Table>
	<%
  End If

Set rs= Nothing
con.Close
%>

</BODY>
</HTML>
