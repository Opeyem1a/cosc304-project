<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Add Warehouse Page</title>
		<%@ include file="global-jsp/header.jsp" %>
	</head>
	<body>

		<%@ include file="auth.jsp"%>
		<%@ include file="jdbc.jsp" %>
    
        <h1 class="main-title">Register a Warehouse</h1>
			<form method="get" action="adminWarehouseAdd.jsp">
				<div class="container mt-5"><table class='table table-light'>
                    <thead class='thead-dark'><tr><th colspan=2>Warehouse Information</th></tr></thead>
                        <tr><td><label for="warehouseName"><b>Warehouse Name</b></label></td>
                            <td><input type="text" name="warehouseName" id="warehouseName" maxLength="30" size="50" required></td></tr>
                    </table>
                    <button class="btn btn-primary ml-2" type="submit" value="Submit">Submit</button>
                    <button class="btn btn-primary ml-2" type="reset" value="Reset">Reset</button>
                    <h3></h3>
                    <h3><a href="adminWarehouseList.jsp">Back</a></h3>
				</div>
			</form>

		<%
			String warehouseName = request.getParameter("warehouseName");

            String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
			String uid = "SA";
			String pw = "YourStrong@Passw0rd";

			try ( Connection con = DriverManager.getConnection(url, uid, pw);) {
                
                if(warehouseName != null){

                    PreparedStatement pstmt = con.prepareStatement(
                    "INSERT INTO warehouse (" +
                        "warehouseName) " +
                        "VALUES (?)",
                    Statement.RETURN_GENERATED_KEYS);
                
                    pstmt.setString(1, warehouseName);
                    pstmt.executeUpdate();

                    ResultSet keys = pstmt.getGeneratedKeys();
                    keys.next();
                    int warehouseId = keys.getInt(1);

                    out.println("<div class='container mt-5'><h4>Warehouse with id: " + warehouseId + " was added to the database</h4></div>");
                }

                
            
            } catch (SQLException ex) {
				System.err.println("SQLException: " + ex); 
			}
		%>

		<%@ include file="global-jsp/footer.jsp" %>
	</body>
</html>