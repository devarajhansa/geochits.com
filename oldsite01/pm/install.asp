<%
  Set rs = con.Execute("Select Groups.gamount, Install.* " & _
    "From Groups, Install " & _
    "Where Install.groupid = Groups.groupid " & _
    "And Groups.groupid = '" & Request("groupid") & "' " & _
    "Order By Install.insnum Desc")
%>

<Table border=1>
<Thead>
<Th>Installment</Th><Th>Amount</Th><Th>Dividend</Th>
<Th>Auction Date</Th><Th>Due Date</Th><Th>Bid Amount</Th>
<Th>Discount</Th>
</Thead>
<%
While Not rs.Eof
  %>
  <Tr>
  <Td><%=rs("insnum")%> </Td>
  <Td> <%=rs("insamount")%> </Td>
  <Td> <%=rs("dividend")%> </Td>
  <Td align=right> <%=dmy(rs("auctdate"))%> </Td>
  <Td align=right> <%=dmy(rs("duedate"))%> </Td>
  <Td> <%=rs("bidamount")%> </Td>
  <Td> <%=rs("gamount") - rs("bidamount") - rs("commission")%> </Td>
  <Td><Form method=post action=clients.asp>
    <Input name=choice type=hidden value=install>
    <Input name=groupid type=hidden value=<%=rs("groupid")%> >
    </Td>
    </Form>
  </Tr>
  <%
  rs.MoveNext
Wend
%>
</Table>
