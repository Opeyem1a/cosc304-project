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

        <h1 class="main-title">Update Warehouse Information</h1>

		<%
            // get customer id
            String warehouseIdString = request.getParameter("id");
            
            // check if id is empty
            if(warehouseIdString == null || warehouseIdString.length() == 0) {
                out.println("<h1>No specified warehouse id.</h1>");
                return;
            }

            // Check if id is actually an int
            int warehouseId = 0;
            try{
                warehouseId = Integer.parseInt(warehouseIdString.toString());
            }
            catch (Exception e) {
                out.println("<h1>Invalid warehouse id.</h1>");
                return;
            }

			String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
			String uid = "SA";
			String pw = "YourStrong@Passw0rd";

			try ( Connection con = DriverManager.getConnection(url, uid, pw);) {

                PreparedStatement pstmtSel = con.prepareStatement(
                    "SELECT warehouseName " +
                    "FROM warehouse " +
                    "WHERE warehouseId = ?");
                
                pstmtSel.setInt(1, warehouseId);
                ResultSet rstSel = pstmtSel.executeQuery();
                rstSel.next();
                
                String warehouseName = request.getParameter("warehouseName");
                
                if(warehouseName == null || warehouseName.length() == 0)
                    warehouseName = rstSel.getString(1);

                PreparedStatement pstmt = con.prepareStatement(
                "UPDATE warehouse SET " +
                    "warehouseName = ? " +
                    "WHERE warehouseId = ?");

                pstmt.setString(1, warehouseName);
                pstmt.setInt(2, warehouseId);
                pstmt.executeUpdate();
                
                
            } catch (SQLException ex) {
				System.err.println("SQLException: " + ex); 
			}
            
            //
		%>
        <jsp:forward page="adminWarehouseOverview.jsp?id=<%= warehouseId %>"/>

		<%@ include file="global-jsp/footer.jsp" %>
	</body>
</html>