<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>R*mone’s Black Market Course Resources Order Processing</title>
<%@ include file="global-jsp/header.jsp" %>
</head>
<body>

<div class="container mt-5">
<% 
// Get customer id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");


// Determine if valid customer id was entered
// Determine if there are products in the shopping cart
// If either are not true, display an error message

// Make connection
String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";

NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.CANADA);

try ( Connection con = DriverManager.getConnection(url, uid, pw);) {
	PreparedStatement pstmt = con.prepareStatement(
		"SELECT customerId" +
		" FROM customer" +
		" WHERE customerId = ?",
		ResultSet.TYPE_SCROLL_INSENSITIVE,
		ResultSet.CONCUR_READ_ONLY);

	// Checks whether customerId is a valid integer
	int custIdInt = 0;
	try
	{
		custIdInt = Integer.parseInt(custId.toString());
	}
	catch (Exception e)
	{
		out.println("<h1>Invalid customer id. Go back to the previous page and try again.</h1>");
		return;
	}

	if (custId != null && !custId.isEmpty()) 
	{	// Checks id is valid before inserting
		pstmt.setString(1, custId);
	} else
	{	// If invalid id, insert 0 for customer id
		pstmt.setInt(1, 0);
	}
	
	ResultSet rst = pstmt.executeQuery();
	
	if (rst.first() == false) 
	{	// No valid id in customer list
		out.println("<h1>Invalid customer id. Go back to the previous page and try again.</h1>");
		return;
	}

	if (productList == null)
	{	// No products currently in list.
		out.println("<h1>Shoppping cart is empty</h1>");
		%>
		<h2><a href="listprod.jsp">Return to Products</a></h2>
		<%
		return;
	}

	
	// Save order information to database
	PreparedStatement pstmt2 = con.prepareStatement(
		"INSERT INTO ordersummary (customerId, orderDate) "
		+ "VALUES (?, ?)",
		Statement.RETURN_GENERATED_KEYS);
	
	pstmt2.setString(1, custId);
	pstmt2.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
	pstmt2.executeUpdate();

	ResultSet keys = pstmt2.getGeneratedKeys();
	keys.next();
	int orderId = keys.getInt(1);


	// Insert each item into OrderProduct table using OrderId from previous INSERT
	PreparedStatement pstmt3 = con.prepareStatement(
		"INSERT INTO orderproduct (orderId, productId, quantity, price) "
		+ "VALUES (?, ?, ?, ?)");
	
	double totalAmount = 0;
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext())
	{ 
		Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		String productId = (String) product.get(0);
		String price = (String) product.get(2);
		double pr = Double.parseDouble(price);
		int qty = ( (Integer)product.get(3)).intValue();
		
		pstmt3.setInt(1, orderId);
		pstmt3.setString(2, productId);
		pstmt3.setInt(3, qty);
		pstmt3.setDouble(4, pr);
		pstmt3.executeUpdate();

		totalAmount += pr*qty;
	}
	
	// Update total amount for order record
	PreparedStatement pstmt4 = con.prepareStatement(
		"UPDATE ordersummary "
		+ "SET totalAmount = ? "
		+ "WHERE orderId = ?");
	
	pstmt4.setDouble(1, totalAmount);
	pstmt4.setInt(2, orderId);
	pstmt4.executeUpdate();
	

	// Print out order summary
	PreparedStatement pstmt5 = con.prepareStatement(
		"SELECT orderproduct.productId, productName, quantity, price "
		+ "FROM orderproduct, product "
		+ "WHERE orderproduct.productId = product.productId AND orderId = ?");

	pstmt5.setInt(1, orderId);
	ResultSet rst1 = pstmt5.executeQuery();

	double subtotal = 0;
	double orderTotal = 0;
	%>

	<table id="order-table" class="table table-dark table-bordered mt-5">
		<tr>
			<th>Product Id</th>
			<th>Product Name</th>
			<th>Quantity</th>
			<th>Price</th>
			<th>Subtotal</th>
		</tr>

	<%
	while (rst1.next())
	{	subtotal = rst1.getInt("quantity") * rst1.getDouble("price");
		orderTotal += subtotal;
		
		out.println("<tr>"
		+ "<td>" + rst1.getInt("productId") + "</td>"
		+ "<td>" + rst1.getString("productName") + "</td>"
		+ "<td>" + rst1.getInt("quantity") + "</td>"
		+ "<td>" + currFormat.format(rst1.getDouble("price")) + "</td>"
		+ "<td>" + currFormat.format(subtotal) + "</td></tr>");
	}

	out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
		+ "<td align=\"right\">" + currFormat.format(orderTotal) + "</td></tr>");

	out.println("</table>");

	
	// Clear cart if order placed successfully
	productList = null;
	session.setAttribute("productList", productList);

	
	// Extras in order summary
	PreparedStatement pstmt6 = con.prepareStatement(
		"SELECT firstName, lastName "
		+ "FROM customer "
		+ "WHERE customerId = ?");

	pstmt6.setString(1, custId);
	ResultSet rst2 = pstmt6.executeQuery();
	rst2.next();

	out.println("<p>Order completeed. Will be shipped soon...</p>");
	out.println("<p>Your order reference number is: " + orderId + "</p>");
	out.println("<p>Shipping to customer: " + custId + "         Name: " + rst2.getString("firstName") + " " + rst2.getString("lastName") + "</p>");
	%>
	<h2><a href="index.jsp">Return to Shopping</a></h2>
	<%
} catch (SQLException ex) {
	out.println(ex); 
}

%>
</div>
<%@ include file="global-jsp/footer.jsp" %>
</body>
</html>

