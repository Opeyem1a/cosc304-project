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

        <h1 class="main-title">Update Customer Information</h1>

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
                    "SELECT * " +
                    "FROM customer " +
                    "WHERE customerId = ?");

                pstmtSel.setInt(1, customerId);
                ResultSet rstSel = pstmtSel.executeQuery();

                if(rstSel.next()) {
                // Table Header / Table Data //
                out.println("<form method='get' action='adminCustomerUpdate.jsp'>" +
                                "<div class='container mt-5'><table class='table table-light'>" +
                                    "<thead class='thead-dark'><tr><th colspan=2>Customer Information</th><th>Update Info</th></tr></thead>" +
                                        "<tr><th>Id</th><td>" + rstSel.getInt(1) + "</td><td><input type='hidden' name='id' value='" + customerId + "'></td></tr>" +
                                        "<tr><th>First Name</th><td>" + rstSel.getString(2) + "</td><td><input type='text' name='firstName' size='50' maxLength='40'></td></tr>" +
                                        "<tr><th>Last Name</th><td>" + rstSel.getString(3) + "</td><td><input type='text' name='lastName' size='50' maxLength='40'></td></tr>" +
                                        "<tr><th>Email</th><td>" + rstSel.getString(4) + "</td><td><input type='email' name='email' size='50' maxLength='50'></td></tr>" +
                                        "<tr><th>Phone</th><td>" + rstSel.getString(5) + "</td><td><input type='tel' name='phonenum' size='50' maxLength='20' pattern='[0-9]{3}-[0-9]{3}-[0-9]{4}' placeholder='123-456-7890'></td></tr>" +
                                        "<tr><th>Address</th><td>" + rstSel.getString(6) + "</td><td><input type='text' name='address' size='50' maxLength='50'></td></tr>" +
                                        "<tr><th>City</th><td>" + rstSel.getString(7) + "</td><td><input type='text' name='city' size='50' maxLength='40'></td></tr>" +
                                        "<tr><th>State</th><td>" + rstSel.getString(8) + "</td><td><input type='text' name='state' size='50' maxLength='20'></td></tr>" +
                                        "<tr><th>Postal Code</th><td>" + rstSel.getString(9) + "</td><td><input type='text' name='postalCode' size='50' maxLength='20'></td></tr>" +
                                        "<tr><th>Country</th><td>" + rstSel.getString(10) + "</td><td><input type='text' name='country' size='50' maxLength='40'></td></tr>" +
                                        "<tr><th>User Id</th><td>" + rstSel.getString(11) + "</td><td><input type='text' name='userid' size='50' maxLength='20'></td></tr>" +
                                        "<tr><th>Password</th><td>" + rstSel.getString(12) + "</td><td><input type='text' name='password' size='50' maxLength='30'></td></tr>" +
                                    "</table>" +
                                    "<tr><td><button class='btn btn-primary ml-2' type='submit' value='Submit'>Submit</button></td>" +
                                    "<td><button class='btn btn-primary ml-2' type='reset' value='Reset'>Reset</button></td></tr>" +
                                    "<h3></h3>" +
                                    "<h3><a href='adminCustomerList.jsp'>Back</a></h3>" +
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