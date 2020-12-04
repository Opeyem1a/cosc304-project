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

        <h1 class="main-title">Register a Customer</h1>
			<form method="get" action="adminCustomerAdd.jsp">
				<div class="container mt-5"><table class='table table-light'>
                    <thead class='thead-dark'><tr><th colspan=2>Customer Information</th></tr></thead>
                        <tr><td><label for="firstName"><b>First Name</b></label></td>
                            <td><input type="text" name="firstName" id="firstName" size="50" maxLength="40" required></td></tr>
                        <tr><td><label for="lastName"><b>Last Name</b></label></td>
                            <td><input type="text" name="lastName" id="lastName" size="50" maxLength="40" required></td></tr>
                        <tr><td><label for="email"><b>Email</b></label></td>
                            <td><input type="email" name="email" id="email" size="50" maxLength="50" pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$" placeholder="rlawrence@cosc304.com" required></td></tr>
                        <tr><td><label for="phonenum"><b>Phone Number</b></label></td>
                            <td><input type="tel" name="phonenum" id="phonenum" size="50" maxLength="20" pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}" placeholder="123-456-7890"></td></tr>
                        <tr><td><label for="address"><b>Address</b></label></td>
                            <td><input type="text" name="address" id="address" size="50" maxLength="50" required></td></tr>
                        <tr><td><label for="city"><b>City</b></label></td>
                            <td><input type="text" name="city" id="city" size="50" maxLength="40" required></td></tr>
                        <tr><td><label for="state"><b>State</b></label></td>
                            <td><input type="text" name="state" id="state" size="50" maxLength="20" required></td></tr>
                        <tr><td><label for="postalCode"><b>Postal Code</b></label></td></td>
                            <td><input type="text" name="postalCode" id="postalCode" size="50" maxLength="20" required></td></tr>
                        <tr><td><label for="country"><b>Country</b></label></td>
                            <td><input type="text" name="country" id="country" size="50" maxLength="40" required></td></tr>
                        <tr><td><label for="userid"><b>Username</b></label></td>
                            <td><input type="text" name="userid" id="userid" size="50" maxLength="20" required></td></tr>
                        <tr><td><label for="password"><b>Password</b></label></td>
                            <td><input type="password" name="password" id="password" size="50" maxLength="30" required></td></tr>
                    </table>
                    <button class="btn btn-primary ml-2" type="submit" onClick="resetVals()" value="Submit">Submit</button>
                    <button class="btn btn-primary ml-2" type="reset" value="Reset">Reset</button>
                    <h3></h3>
                    <h3><a href="adminCustomerList.jsp">Back</a></h3>
				</div>
			</form>

		<%
			String firstName = request.getParameter("firstName").trim().toLowerCase();
            String lastName = request.getParameter("lastName").trim().toLowerCase();
            String email = request.getParameter("email").trim();
            String phonenum = request.getParameter("phonenum").trim();
            String address = request.getParameter("address").trim().toLowerCase();
            String city = request.getParameter("city").trim().toLowerCase();
            String state = request.getParameter("state").trim().toLowerCase();
            String postalCode = request.getParameter("postalCode").trim().toLowerCase();
            String country = request.getParameter("country").trim().toLowerCase();
            String userid = request.getParameter("userid").trim();
            String password = request.getParameter("password");

			String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
			String uid = "SA";
			String pw = "YourStrong@Passw0rd";

			try ( Connection con = DriverManager.getConnection(url, uid, pw);) {
                
                if(firstName != null){
                    PreparedStatement pstmt = con.prepareStatement(
                    "INSERT INTO customer (" +
                        "firstName, " +
                        "lastName, " +
                        "email, " +
                        "phonenum, " +
                        "address, " +
                        "city, " +
                        "state, " +
                        "postalCode, " +
                        "country, " +
                        "userid, " +
                        "password) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                    Statement.RETURN_GENERATED_KEYS);
                
                    pstmt.setString(1, firstName);
                    pstmt.setString(2, lastName);
                    pstmt.setString(3, email);
                    pstmt.setString(4, phonenum);
                    pstmt.setString(5, address);
                    pstmt.setString(6, city);
                    pstmt.setString(7, state);
                    pstmt.setString(8, postalCode);
                    pstmt.setString(9, country);
                    pstmt.setString(10, userid);
                    pstmt.setString(11, password);

                    pstmt.executeUpdate();

                    ResultSet keys = pstmt.getGeneratedKeys();
                    keys.next();
                    int customerId = keys.getInt(1);

                    out.println("<div class='container mt-5'><h4>Customer with id: " + customerId + " was added to the database</h4></div>");
                }

                
            
            } catch (SQLException ex) {
				System.err.println("SQLException: " + ex);
                out.print("<div class='container mt-5'><h4>Error, that user ID is taken.</h4></div>");
			}
		%>

		<%@ include file="global-jsp/footer.jsp" %>
	</body>
</html>