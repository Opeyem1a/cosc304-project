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

        <h1 class="main-title">Delete Customer Failed</h1>

		<%
            // get customer id
            String customerIdString = request.getParameter("id");
            
            // check if id is empty
            if(customerIdString == null || customerIdString.length() == 0) {
                out.println("<h1>No specified customer id.</h1>");
                return;
            }

            // Check if id is actually an int
            int customerId = 0;
            try{
                customerId = Integer.parseInt(customerIdString.toString());
            }
            catch (Exception e) {
                out.println("<h1>Invalid customer id.</h1>");
                return;
            }

			String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
			String uid = "SA";
			String pw = "YourStrong@Passw0rd";

			try ( Connection con = DriverManager.getConnection(url, uid, pw);) {

                PreparedStatement pstmtSel = con.prepareStatement(
                    "DELETE FROM customer " +
                    "WHERE customerId = ?");

                pstmtSel.setInt(1, customerId);
                pstmtSel.executeUpdate();        
            
            } catch (SQLException ex) {
				out.println("<div class='container mt-5'>" +
                            "<h4 align='center'>Customer " + customerId + " already has order(s) and therefore can't be deleted</h4>" + 
                            "<h3 align='center'><a href='adminCustomerList.jsp'>Back</a></h3>" +
                            "</div>");
                return;
			}
		%>
        <jsp:forward page="adminCustomerList.jsp"/>

		<%@ include file="global-jsp/footer.jsp" %>
	</body>
</html>