<%@ page import="java.sql.*,java.net.URLEncoder" %>
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
                    "SELECT * " +
                    "FROM warehouse " +
                    "WHERE warehouseId = ?");

                pstmtSel.setInt(1, warehouseId);
                ResultSet rstSel = pstmtSel.executeQuery();

                if(rstSel.next()) {
                // Table Header / Table Data //
                out.println("<form method='get' action='adminWarehouseUpdate.jsp'>" +
                                "<div class='container mt-5'><table class='table table-light'>" +
                                    "<thead class='thead-dark'><tr><th colspan=2>Warehouse Information</th><th>Update Info</th></tr></thead>" +
                                        "<tr><th>Id</th><td>" + rstSel.getInt(1) + "</td><td><input type='hidden' name='id' value='" + warehouseId + "'></td></tr>" +
                                        "<tr><th>Name</th><td>" + rstSel.getString(2) + "</td><td><input type='text' name='warehouseName' size='50' maxLength='30'></td></tr>" +
                                    "</table>" +
                                    "<tr><td><button class='btn btn-primary ml-2' type='submit' value='Submit'>Submit</button></td>" +
                                    "<td><button class='btn btn-primary ml-2' type='reset' value='Reset'>Reset</button></td></tr>" +
                                    "<h3></h3>" +
                                    "<h3><a href='adminWarehouseList.jsp'>Back</a></h3>" +
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