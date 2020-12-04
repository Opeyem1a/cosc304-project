<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Administrator Page</title>
        <%@ include file="global-jsp/header.jsp" %>
    </head>
    <body>
        <%
        // TODO: Include files auth.jsp and jdbc.jsp
        %>
        <%@ include file="jdbc.jsp" %>
        <%@ include file="auth.jsp" %>
        <%

        // TODO: Write SQL query that prints out total order amount by day
        try {
            getConnection();
            
            String sql = "SELECT customerId, firstName, lastName, userid, email " +
                        "FROM customer";

            ResultSet rst = executeQuery(sql);

            %>
                <div class="container mt-5">
                <h2>List of Customers:</h2>
            <%

            // Table Headers //
            out.println("<table class='table table-striped table-hover'><thead class='thead-dark'><tr>" +
                        "<th>Customer Id</th>" +
                        "<th>Name</th>" +
                        "<th>Username</th>" +
                        "<th>Email</th>" +
                        "<th></th>" +
                        "<th></th>" +
                        "</tr></thead><tbody>");

            // Table Data //
            while(rst.next()) {
                out.println("<tr>" +
                            "   <td>" + rst.getInt("customerId") + "</td>" +
                            "   <td>" + rst.getString("firstName") + " " + rst.getString("lastName") + "</td>" +
                            "   <td>" + rst.getString("userId") + "</td>" +
                            "   <td>" + rst.getString("email") + "</td>" +
                            "   <td><a href='adminCustomerOverview.jsp?id=" + rst.getInt("customerId") + "'>Edit Info</a></td>" +
                            "   <td><a href='adminCustomerDelete.jsp?id=" + rst.getInt("customerId") + "' style='color:red'>Delete</a></td>" +
                            "</tr>");
            }
            out.println("   </tbody>" + 
                        "</table>");

            %>
                <h4><a href="adminCustomerAdd.jsp" style="color:green">Add Customer</a></h4>
                <h3><a href="admin.jsp">Back</a></h3>
                </div>
            <%		
                            
        } catch (SQLException ex) {
            out.println(ex);
        } finally {
            closeConnection();
        }

        %>

        <%@ include file="global-jsp/footer.jsp" %>
    </body>
</html>