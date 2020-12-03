<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ include file="jdbc.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
	<head>
		<title>R*mone’s Black Market Course Resources</title>
		<%@ include file="global-jsp/header.jsp" %>
	</head>
	<body>
		<%
			try {
				getConnection();
		%>
		<h1 class="main-title mt-5">Search</h1>
		<div class="container mt-5">
			<form class="container form-inline my-3" method="get" action="listprod.jsp">
				<div class="form-group ml-auto">
                    <select class="custom-select mr-sm-2" id="selectCategory" name="category">
                        <option style="color: #c4c4c4;" disabled selected>Select Category...</option>
                        <%
							String sqlCategories = "SELECT * " +
													"FROM category";
							ResultSet rstCategories = executeQuery(sqlCategories);
							while(rstCategories.next()) {
								%>
								<option value="<%= rstCategories.getInt(1) %>"><%= rstCategories.getString(2) %></option>
								<%
							}
						%>
                    </select>
                </div>
				<div class="form-group">
					<input class="form-control p-2" type="text" name="productName" size="50" placeholder="Search for products...">
				</div>
				<button class="btn btn-primary ml-2" type="submit" value="Submit">Submit</button>
				<button class="btn btn-primary ml-2 mr-auto" type="reset" value="Reset">Reset</button>
			</form>

			<% 		
				// Get product name and category to search for
				String name = request.getParameter("productName");
				String categoryString = request.getParameter("category");
				Integer category = categoryString == null ? null : Integer.parseInt(categoryString);
				// Useful code for formatting currency values:
				NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.CANADA);
				String sql1 = "SELECT productId, productName, productPrice, productImageURL" +
								" FROM product P";

				PreparedStatement pstmt = prepareStatement(sql1);
				ResultSet rst1 = null;

				if(name != null) {
					// if a name is given, change the statement, and set up the prepared query with the correct search parameters
					sql1 = sql1 + " WHERE productName LIKE ?";
					name = "%" + name + "%";
					pstmt = prepareStatement(sql1);					
				};

				if(category != null) {
					sql1 = sql1 + " AND categoryId = ?";
					pstmt = prepareStatement(sql1);	
				};

				if (name != null) {
					pstmt.setString(1, name);
				}

				if (category != null) {
					if(name != null) pstmt.setInt(2, category);
					else pstmt.setInt(1, category);
				}
									
				out.println("<table class='table listprod-table table-striped table-hover'>" +
							"	<thead class='thead-dark'>" +
							"		<tr>" +
							"			<th></th>" +
							"			<th></th>" +
							"			<th>Product Name</th>" +
							"			<th>Price</th>" +
							"		</tr>" +
							"	</thead>" +
							"	<tbody>");
							
				rst1 = name != null ? pstmt.executeQuery() :
									category != null ? pstmt.executeQuery() : executeQuery(sql1);

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
					<% 
						if(rst1.getString("productImageURL") != null) {
						%>
						<td><img height=200px src="<%= rst1.getString("productImageURL")%>" alt="Image of <%= rst1.getString("productName") %>"></td>
						<%
						} else 
							out.print("<td></td>");
					%>
						<td><%= addCartLink %></td>
						<td><a href="product.jsp?id=<%= rst1.getInt("productId") %>"><%= rst1.getString("productName") %></a></td>
						<td><%= currFormat.format(rst1.getDouble(3)) %></td>
					</tr>
					<%
				}
				out.println("</tbody>" +
							"	</table>");
			} catch (SQLException ex) {
				out.println(ex); 
			} finally {
				closeConnection();
			}
			%>
		</div>
	<%@ include file="global-jsp/footer.jsp" %>
	</body>
</html>