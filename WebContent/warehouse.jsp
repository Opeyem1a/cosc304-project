<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Current Stock</title>
<%@ include file="global-jsp/header.jsp" %>
</head>
<body>
		<h1 class="main-title">Current Inventory</h1>
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
			String sql1 = "SELECT * " +
							" FROM warehouse";

			String sql2 = "SELECT * " +
							" FROM productinventory " +
							" WHERE warehouseId = ?";

			PreparedStatement pstmt = con.prepareStatement(sql2);
				
			out.println("<table class='table listorder-table table-striped table-bordered table-hover'>" +
						"	<thead class='thead-dark'>" +
						"		<tr>" +
						"			<th>Warehouse Id</th>" +
						"			<th>Warehouse </th>" +
						"		</tr>"+
						"	</thead>");
			ResultSet rst1 = stmt.executeQuery(sql1);
			while (rst1.next()) {
				%>	
					<tr>
						<td><%= rst1.getInt(1) %></td>
						<td><%= rst1.getString(2) %></td>
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
								"	<td>"+rst2.getInt("productId")+"</td>" +
								"	<td>"+rst2.getInt("quantity")+"</td>" +
								"	<td>"+currFormat.format(rst2.getDouble("price"))+"</td>" +
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

		%>
		<%@ include file="global-jsp/footer.jsp" %>
	</body>
</html> 

