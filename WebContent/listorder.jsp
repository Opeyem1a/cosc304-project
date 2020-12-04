<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
	<head>
		<title>R*mone’s Black Market Course Resources</title>
		<%@ include file="global-jsp/header.jsp" %>
	</head>
	<body>
		<h1 class="main-title">Order List</h1>
		<%
		String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
		String uid = "SA";
		String pw = "YourStrong@Passw0rd";
		//Note: Forces loading of SQL Server driver
		try {	// Load driver class
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		} catch (java.lang.ClassNotFoundException e) {
			out.println("ClassNotFoundException: " +e);
		}

		try ( Connection con = DriverManager.getConnection(url, uid, pw);
			Statement stmt = con.createStatement();) {		
			// Useful code for formatting currency values:
			NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.CANADA);
			String sql1 = "SELECT OS.orderId, orderDate, C.customerId, firstName, lastName, totalAmount" +
							" FROM ordersummary OS" +
							" JOIN customer C ON OS.customerId = C.customerId";

			String sql2 = "SELECT productId, quantity, price" +
							" FROM orderproduct OP" +
							" WHERE orderId = ?";

			PreparedStatement pstmt = con.prepareStatement(sql2);
				
			out.println("<table class='table listorder-table table-striped table-bordered table-hover'>" +
						"	<thead class='thead-dark'>" +
						"		<tr>" +
						"			<th>Order Id</th>" +
						"			<th>Order Date</th>" +
						"			<th>Customer Id</th>" +
						"			<th>Customer Name</th>" +
						"			<th>Total Amount</th>" +
						"		</tr>"+
						"	</thead>");
			ResultSet rst1 = stmt.executeQuery(sql1);
			while (rst1.next()) {
				%>	
					<tr>
						<td><%= rst1.getInt(1) %></td>
						<td><%= rst1.getDate(2) %> <%= rst1.getTime(2) %></td>
						<td><%= rst1.getInt(3) %></td>
						<td><%= rst1.getString(4) %> <%=rst1.getString(5) %></td>
						<td><%= currFormat.format(rst1.getDouble(6)) %></td>
					</tr>
				<%
				pstmt.setInt(1, rst1.getInt(1));
				ResultSet rst2 = pstmt.executeQuery();
				out.println("<tr align='left'>" +
							"	<td colspan=5>" +
							"		<table class='table'>" +
							"			<thead class='table-warning'>" +
							"				<th>Product ID</th>" +
							"				<th>Quantity</th>" +
							"				<th>Price</th>" +
							"			</thead>" +
							"			<tbody>");
				while (rst2.next()) {
					out.println("<tr>" +
								"	<td>"+rst2.getInt(1)+"</td>" +
								"	<td>"+rst2.getInt(2)+"</td>" +
								"	<td>"+currFormat.format(rst2.getDouble(3))+"</td>" +
								"</tr>");
				}

				out.println("</tbody>" +
							"	</table>" +
							"		</td>" +
							"			</tr>");
			}
			out.println("</table>");
		}
		catch (SQLException ex) {
			out.println(ex); 
		}

		// Make connection

		// Write query to retrieve all order summary records

		// For each order in the ResultSet

			// Print out the order summary information
			// Write a query to retrieve the products in the order
			//   - Use a PreparedStatement as will repeat this query many times
			// For each product in the order
				// Write out product information 

		// Close connection
		%>
		<%@ include file="global-jsp/footer.jsp" %>
	</body>
</html>

