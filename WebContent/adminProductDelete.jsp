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

        <h1 class="main-title">Delete Product Failed</h1>

		<%
            // get product id
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
                    "DELETE FROM product " +
                    "WHERE productId = ?");
                
                pstmtSel.setInt(1, productId);
                pstmtSel.executeUpdate();        
                
            } catch (SQLException ex) {
				System.err.println("SQLException: " + ex);
                
                out.println("<div class='container mt-5'>" +
                            "<h4 align='center'>Product " + productId + " already in use in a product order</h4>" + 
                            "<h3 align='center'><a href='adminProductList.jsp'>Back</a></h3>" +
                            "</div>");
                return;
			}
            //
		%>
        <jsp:forward page="adminProductList.jsp"/>

		<%@ include file="global-jsp/footer.jsp" %>
	</body>
</html>