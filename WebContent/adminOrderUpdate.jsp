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

        <h1 class="main-title">Update Order Information</h1>

		<%
            // get customer id
            String orderIdString = request.getParameter("id");
            
            // check if id is empty
            if(orderIdString == null || orderIdString.length() == 0) {
                out.println("<h1>No specified order id.</h1>");
                return;
            }

            // Check if id is actually an int
            int orderId = 0;
            try{
                orderId = Integer.parseInt(orderIdString.toString());
            }
            catch (Exception e) {
                out.println("<h1>Invalid order id.</h1>");
                return;
            }

			String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
			String uid = "SA";
			String pw = "YourStrong@Passw0rd";

			try ( Connection con = DriverManager.getConnection(url, uid, pw);) {

                PreparedStatement pstmtSel = con.prepareStatement(
                    "SELECT shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCountry " +
                    "FROM ordersummary " +
                    "WHERE orderId = ?");
                
                pstmtSel.setInt(1, orderId);
                ResultSet rstSel = pstmtSel.executeQuery();
                rstSel.next();
                
                String shiptoAddress = request.getParameter("shiptoAddress");
                String shiptoCity = request.getParameter("shiptoCity");
                String shiptoState = request.getParameter("shiptoState");
                String shiptoPostalCode = request.getParameter("shiptoPostalCode");
                String shiptoCountry = request.getParameter("shiptoCountry");
                
                if(shiptoAddress == null || shiptoAddress.length() == 0)
                    shiptoAddress = rstSel.getString(1);
                
                if(shiptoCity == null || shiptoCity.length() == 0)
                    shiptoCity = rstSel.getString(2);
                
                if(shiptoState == null || shiptoState.length() == 0)
                    shiptoState = rstSel.getString(3);
                
                if(shiptoPostalCode == null || shiptoPostalCode.length() == 0)
                    shiptoPostalCode = rstSel.getString(4);
                
                if(shiptoCountry == null || shiptoCountry.length() == 0)
                    shiptoCountry = rstSel.getString(5);

                PreparedStatement pstmt = con.prepareStatement(
                "UPDATE ordersummary SET " +
                    "shiptoAddress = ?, " +
                    "shiptoCity = ?, " +
                    "shiptoState = ?, " +
                    "shiptoPostalCode = ?, " +
                    "shiptoCountry = ? " +
                    "WHERE orderId = ?");

                pstmt.setString(1, shiptoAddress);
                pstmt.setString(2, shiptoCity);
                pstmt.setString(3, shiptoState);
                pstmt.setString(4, shiptoPostalCode);
                pstmt.setString(5, shiptoCountry);
                pstmt.setInt(6, orderId);
                pstmt.executeUpdate();
                
                
            } catch (SQLException ex) {
				System.err.println("SQLException: " + ex); 
			}
            
            //
		%>
        <jsp:forward page="adminOrderOverview.jsp?id=<%= orderId %>"/>

		<%@ include file="global-jsp/footer.jsp" %>
	</body>
</html>