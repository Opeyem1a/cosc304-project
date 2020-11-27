<!DOCTYPE html>
<html>
	<head>
		<title>Customer Page</title>
		<%@ include file="global-jsp/header.jsp" %>
	</head>
	<body>

		<%@ include file="auth.jsp"%>
		<%@ page import="java.text.NumberFormat" %>
		<%@ page import="java.util.Locale" %>
		<%@ include file="jdbc.jsp" %>

		<%
			int customerId = (int) session.getAttribute("authenticatedId");

			// TODO: Print Customer information
			try {
				getConnection();
				
				String sql = "SELECT * " +
							"FROM customer " +
							"WHERE customerId = ?";

				ResultSet rst = executePreparedQueryWithId(sql, customerId);
				if(rst.next()) {
				// Table Header / Table Data //
				out.println("<div class='container mt-5'><table class='table table-light table-bordered'>" +
							"<thead class='thead-dark'><tr><th colspan=2>Customer Information</th></tr></thead>" +
							"<tr><th>Id</th><td>" + rst.getInt(1) + "</td></tr>" +
							"<tr><th>First Name</th><td>" + rst.getString(2) + "</td></tr>" +
							"<tr><th>Last Name</th><td>" + rst.getString(3) + "</td></tr>" +
							"<tr><th>Email</th><td>" + rst.getString(4) + "</td></tr>" +
							"<tr><th>Phone</th><td>" + rst.getString(5) + "</td></tr>" +
							"<tr><th>Address</th><td>" + rst.getString(6) + "</td></tr>" +
							"<tr><th>City</th><td>" + rst.getString(7) + "</td></tr>" +
							"<tr><th>State</th><td>" + rst.getString(8) + "</td></tr>" +
							"<tr><th>Postal Code</th><td>" + rst.getString(9) + "</td></tr>" +
							"<tr><th>Country</th><td>" + rst.getString(10) + "</td></tr>" +
							"<tr><th>User Id</th><td>" + rst.getString(11) + "</td></tr>" +
							"</table></div>");
			} else {
				out.println("<p>Invalid Customer</p>");
			}
		} 
		catch (SQLException ex) {
			out.println(ex);
		} finally {
			closeConnection();
		}
		// Make sure to close connection
		%>

		<%@ include file="global-jsp/footer.jsp" %>
	</body>
</html>
