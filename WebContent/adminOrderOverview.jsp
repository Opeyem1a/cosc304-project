<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
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

            NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.CANADA);

			String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
			String uid = "SA";
			String pw = "YourStrong@Passw0rd";

			try ( Connection con = DriverManager.getConnection(url, uid, pw);) {

                PreparedStatement pstmtSel = con.prepareStatement(
                    "SELECT * " +
                    "FROM ordersummary " +
                    "WHERE orderId = ?");

                pstmtSel.setInt(1, orderId);
                ResultSet rstSel = pstmtSel.executeQuery();

                if(rstSel.next()) {
                // Table Header / Table Data //
                out.println("<form method='get' action='adminOrderUpdate.jsp'>" +
                                "<div class='container mt-5'><table class='table table-light'>" +
                                    "<thead class='thead-dark'><tr><th colspan=2>Order Information</th><th>Update Info</th></tr></thead>" +
                                        "<tr><th>orderId</th><td>" + rstSel.getInt(1) + "</td><td><input type='hidden' name='id' value='" + orderId + "'></td></tr>" +
                                        "<tr><th>orderDate</th><td>" + rstSel.getDate(2) + "</td></tr>" +
                                        "<tr><th>totalAmount</th><td>" + currFormat.format(rstSel.getDouble(3)) + "</td></tr>" +
                                        "<tr><th>Shipment Info:</th></tr>" +
                                        "<tr><th>Address</th><td>" + rstSel.getString(4) + "</td><td><input type='text' name='shiptoAddress' size='50' maxLength='50'></td></tr>" +
                                        "<tr><th>City</th><td>" + rstSel.getString(5) + "</td><td><input type='text' name='shiptoCity' size='50' maxLength='40'></td></tr>" +
                                        "<tr><th>State</th><td>" + rstSel.getString(6) + "</td><td><input type='text' name='shiptoState' size='50' maxLength='20'></td></tr>" +
                                        "<tr><th>PostalCode</th><td>" + rstSel.getString(7) + "</td><td><input type='text' name='shiptoPostalCode' size='50' maxLength='20'></td></tr>" +
                                        "<tr><th>Country</th><td>" + rstSel.getString(8) + "</td><td><input type='text' name='shiptoCountry' size='50' maxLength='40'></td></tr>" +
                                        "<tr><th>Customer Id</th><td>" + rstSel.getInt(9) + "</td></tr>" +
                                        "<tr><th>Shipment Id</th><td>" + rstSel.getInt(10) + "</td></tr>" +
                                    "</table>" +
                                    "<tr><td><button class='btn btn-primary ml-2' type='submit' value='Submit'>Submit</button></td>" +
                                    "<td><button class='btn btn-primary ml-2' type='reset' value='Reset'>Reset</button></td></tr>" +
                                    "<h3></h3>" +
                                    "<h3><a href='adminOrderList.jsp'>Back</a></h3>" +
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