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
                rstSel.next();
                
                ArrayList<String> customerData = new ArrayList<String>();

                customerData.add(request.getParameter("firstName").trim().toLowerCase());
                customerData.add(request.getParameter("lastName").trim().toLowerCase());
                customerData.add(request.getParameter("email").trim());
                customerData.add(request.getParameter("phonenum").trim());
                customerData.add(request.getParameter("address").trim().toLowerCase());
                customerData.add(request.getParameter("city").trim().toLowerCase());
                customerData.add(request.getParameter("state").trim().toLowerCase());
                customerData.add(request.getParameter("postalCode").trim().toLowerCase());
                customerData.add(request.getParameter("country").trim().toLowerCase());
                customerData.add(request.getParameter("userid").trim());
                customerData.add(request.getParameter("password").trim());
                
                for(int i = 0; i < customerData.size(); i++) {
                    if(customerData.get(i) == null || customerData.get(i).length() == 0){
                        customerData.set(i, rstSel.getString(i+2));
                    }
                }

                PreparedStatement pstmt = con.prepareStatement(
                "UPDATE customer SET " +
                    "firstName = ?, " +
                    "lastName = ?, " +
                    "email = ?, " +
                    "phonenum = ?, " +
                    "address = ?, " +
                    "city = ?, " +
                    "state = ?, " +
                    "postalCode = ?, " +
                    "country = ?, " +
                    "userid = ?, " +
                    "password = ? " +
                    "WHERE customerId = ?");

                for(int i = 0; i < customerData.size(); i++) {
                    pstmt.setString(i+1, customerData.get(i));
                }
                pstmt.setInt(12, customerId);
                pstmt.executeUpdate();

                
                
            
            } catch (SQLException ex) {
				System.err.println("SQLException: " + ex); 
			}

            //
		%>
        <jsp:forward page="adminCustomerOverview.jsp?id=<%= customerId %>"/>

		<%@ include file="global-jsp/footer.jsp" %>
	</body>
</html>