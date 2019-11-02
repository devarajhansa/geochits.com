<%
Set rs = con.Execute("Select * from Groups Order By groupid Desc")
%>
<Table border=1>
<Thead>
<Th>PSO No.</Th><Th>Group</Th><Th>Agmt No.</Th>
<Th>Amount</Th><Th>Commencement</Th><Th>Installments</Th>
<Th>Inst Amount</Th><Th>Current Inst</Th>
</Thead>
<%
While Not rs.Eof
  %>
  <Tr>
  <Td><%=rs("psonum")%> </Td>
  <Td> <%=rs("gname")%> </Td>
  <Td> <%=rs("groupnum")%> </Td>
  <Td> <%=rs("gamount")%> </Td>
  <Td align=right> <%=dmy(rs("startdate"))%> </Td>
  <Td> <%=rs("numins")%> </Td>
  <Td> <%=rs("gamount") / rs("numins") %> </Td>
  <Td> <%=rs("cinsnum")%> </Td>
  <Td><Form method=post action=listcust.asp> 
    <Input name=choice type=hidden value=install>
    <Input name=groupid type=hidden value=<%=rs("groupid")%> >
    <Input name=custfilt type=hidden value=<%=custfilt%> > 
    <Input type=submit value=View>
  </Td>
    </Form>
  </Tr>
  <%
  rs.MoveNext
Wend
%>
</Table>
