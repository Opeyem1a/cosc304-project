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

		<%@ include file="auth.jsp" %>
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
                    "SELECT productName, productPrice, productImageURL, productDesc, categoryId " +
                    "FROM product " +
                    "WHERE productId = ?");
                
                pstmtSel.setInt(1, productId);
                ResultSet rstSel = pstmtSel.executeQuery();
                rstSel.next();
                
                String productName = request.getParameter("productName");
                String productPriceString = request.getParameter("productPrice");
                double productPrice;
                String productImageURL = request.getParameter("productImageURL");
                String productDesc = request.getParameter("productDesc");
                String categoryIdString = request.getParameter("categoryId");
                int categoryId;
                
                if(productName == null || productName.length() == 0)
                    productName = rstSel.getString(1);
                
                if(productPriceString == null || productPriceString.length() == 0)
                    productPrice = rstSel.getDouble(2);
                else
                    productPrice = Double.parseDouble(productPriceString.toString());
                
                if(productImageURL == null || productImageURL.length() == 0)
                    productImageURL = rstSel.getString(3);
                
                if(productDesc == null || productDesc.length() == 0)
                    productDesc = rstSel.getString(4);
                
                if(categoryIdString == null || categoryIdString.length() == 0)
                    categoryId = rstSel.getInt(5);
                else 
                    categoryId = Integer.parseInt(categoryIdString.toString());

                PreparedStatement pstmt = con.prepareStatement(
                "UPDATE product SET " +
                    "productName = ?, " +
                    "productPrice = ?, " +
                    "productImageURL = ?, " +
                    "productDesc = ?, " +
                    "categoryId = ? " +
                    "WHERE productId = ?");

                pstmt.setString(1, productName);
                pstmt.setDouble(2, productPrice);
                pstmt.setString(3, productImageURL);
                pstmt.setString(4, productDesc);
                pstmt.setInt(5, categoryId);
                pstmt.setInt(6, productId);
                pstmt.executeUpdate();
                
                
            } catch (SQLException ex) {
				System.err.println("SQLException: " + ex); 
			}
            
            //
		%>
        <jsp:forward page="adminProductOverview.jsp?id=<%= productId %>"/>

		<%@ include file="global-jsp/footer.jsp" %>
	</body>
</html>