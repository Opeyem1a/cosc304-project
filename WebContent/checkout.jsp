<!DOCTYPE html>
<html>
<head>
<title>Ray's Grocery CheckOut Line</title>
<%@ include file="global-jsp/header.jsp" %>
</head>
<body>

<h1>Enter your customer id to complete the transaction:</h1>

<form method="get" action="order.jsp">
<input type="text" name="customerId" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset">
</form>

<%@ include file="global-jsp/footer.jsp" %>
</body>
</html>

