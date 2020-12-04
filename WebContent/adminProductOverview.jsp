<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Add Customer Page</title>
		<%@ include file="global-jsp/header.jsp" %>
	</head>
	<body>

		<%@ include file="auth.jsp"%>
		<%@ include file="jdbc.jsp" %>

        <h1 class="main-title">Update Product Information</h1>

		<%
            // get customer id
            String productIdString = request.getParameter("id");
            
            // check if id is empty
            if(productIdString == null || productIdString.length() == 0) {
                out.println("<h1>No specified product id.</h1>");
                return;
            }

            // Check if id is actually an int
            int productId = 0;
            try{
                productId = Integer.parseInt(productIdString.toString());
            }
            catch (Exception e) {
                out.println("<h1>Invalid product id.</h1>");
                return;
            }

			String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
			String uid = "SA";
			String pw = "YourStrong@Passw0rd";

			try ( Connection con = DriverManager.getConnection(url, uid, pw);) {

                PreparedStatement pstmtSel = con.prepareStatement(
                    "SELECT * " +
                    "FROM product " +
                    "WHERE productId = ?");

                pstmtSel.setInt(1, productId);
                ResultSet rstSel = pstmtSel.executeQuery();

                // min/max category Id
                Statement stmt = con.createStatement(
                    ResultSet.TYPE_SCROLL_INSENSITIVE,
					ResultSet.CONCUR_READ_ONLY);
                ResultSet rst = stmt.executeQuery(
                    "SELECT categoryId " +
                    "FROM category");
                int categoryMin = (rst.first() == false)? 0 : rst.getInt(1);
                int categoryMax = (rst.last() == false)? 0 : rst.getInt(1);

                if(rstSel.next()) {
                // Table Header / Table Data //
                out.println("<form method='get' action='adminProductUpdate.jsp'>" +
                                "<div class='container mt-5'><table class='table table-light'>" +
                                    "<thead class='thead-dark'><tr><th colspan=2>Product Information</th><th>Update Info</th></tr></thead>" +
                                        "<tr><th>Id</th><td>" + rstSel.getInt(1) + "</td><td><input type='hidden' name='id' value='" + productId + "'></td></tr>" +
                                        "<tr><th>Name</th><td>" + rstSel.getString(2) + "</td><td><input type='text' name='productName' size='50' maxLength='100'></td></tr>" +
                                        "<tr><th>Price</th><td>" + rstSel.getDouble(3) + "</td><td><input type='number' name='productPrice' size='50' min='0' step='0.01'></td></tr>" +
                                        "<tr><th>Image URL</th><td>" + rstSel.getString(4) + "</td><td><input type='text' name='productImageURL' size='50' maxLength='100'></td></tr>" +
                                        "<tr><th>Image</th><td><img src='" + rstSel.getString(4) + "'></td></tr>" +
                                        "<tr><th>Description</th><td>" + rstSel.getString(6) + "</td><td><input type='text' name='productDesc' size='50' maxLength='1000'></td></tr>" +
                                        "<tr><th>Category Id</th><td>" + rstSel.getString(7) + "</td><td><input type='number' name='categoryId' size='50' min='" + categoryMin +"' max='" + categoryMax + "'></td></tr>" +
                                    "</table>" +
                                    "<tr><td><button class='btn btn-primary ml-2' type='submit' value='Submit'>Submit</button></td>" +
                                    "<td><button class='btn btn-primary ml-2' type='reset' value='Reset'>Reset</button></td></tr>" +
                                    "<h3></h3>" +
                                    "<h3><a href='adminProductList.jsp'>Back</a></h3>" +
                                "</div>" +
                            "</form>");
                }          
            
            } catch (SQLException ex) {
				System.err.println("SQLException: " + ex); 
			}
		%>

		<%@ include file="global-jsp/footer.jsp" %>
	</body>
</html>