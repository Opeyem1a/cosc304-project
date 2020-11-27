<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
	<head>
		<title>YOUR NAME Grocery Order List</title>
		<%@ include file="global-jsp/header.jsp" %>
	</head>
	<body>
		<h1 class="main-title">Search</h1>
		<div class="container mt-5">
			<form class="container form-inline my-3" method="get" action="listprod.jsp">
				<div class="form-group mx-auto">
					<input class="p-2" type="text" name="productName" size="50" placeholder="Search for products...">
					<button class="btn btn-primary ml-2" type="submit" value="Submit">Submit</button>
					<button class="btn btn-primary ml-2" type="reset" value="Reset">Reset</button>
				</div>
			</form>

			<% // Get product name to search for
			String name = request.getParameter("productName");
					
			//Note: Forces loading of SQL Server driver
			String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
			String uid = "SA";
			String pw = "YourStrong@Passw0rd";

			try
			{	// Load driver class
				Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
			}
			catch (java.lang.ClassNotFoundException e)
			{
				out.println("ClassNotFoundException: " +e);
			}
			try ( Connection con = DriverManager.getConnection(url, uid, pw);
					Statement stmt = con.createStatement();) {		
					// Useful code for formatting currency values:
					NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.CANADA);
					String sql1 = "SELECT productId, productName, productPrice" +
									" FROM product P";

					PreparedStatement pstmt = con.prepareStatement(sql1);

					if(name != null) {
						// if a name is given, change the statement, and set up the prepared query with the correct search parameters
						sql1 = sql1 + " WHERE productName LIKE ?";
						name = "%" + name + "%";
						pstmt = con.prepareStatement(sql1);
						pstmt.setString(1, name);					
					}
				
					out.println("<table class='table listprod-table table-striped table-hover'>" +
								"	<thead class='thead-dark'>" +
								"		<tr>" +
								"			<th></th>" +
								"			<th>Product Name</th>" +
								"			<th>Price</th>" +
								"		</tr>" +
								"	</thead>" +
								"	<tbody>");
					
					ResultSet rst1 = name == null ? stmt.executeQuery(sql1) : pstmt.executeQuery();
					String baseURL = "localhost";
					while (rst1.next()) {
						String cartLink = String.format(
											"addcart.jsp" +
											"?id=%d" +
											"&name=%s" +
											"&price=%f",
											rst1.getInt(1), rst1.getString(2).replaceAll(" ", "+"), rst1.getDouble(3));
						//replaceAll() because spaces in the product names really wreck the process
						String addCartLink = String.format("<a href="+cartLink+">Add to Cart</a>");	
						%>
						<tr>
							<td><%= addCartLink %></td>
							<td><a href="product.jsp?id=<%= rst1.getInt("productId") %>"><%= rst1.getString("productName") %></a></td>
							<td><%= currFormat.format(rst1.getDouble(3)) %></td>
						</tr>
						<%
					}
					out.println("</tbody>" +
								"	</table>");
				}
				catch (SQLException ex) {
					out.println(ex); 
				}
			// Variable name now contains the search string the user entered
			// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!

			// Make the connection

			// Print out the ResultSet

			// For each product create a link of the form
			// addcart.jsp?id=productId&name=productName&price=productPrice
			// Close connection

			// Useful code for formatting currency values:
			// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
			// out.println(currFormat.format(5.0);	// Prints $5.00
			%>
		</div>
	<%@ include file="global-jsp/footer.jsp" %>
	</body>
</html>