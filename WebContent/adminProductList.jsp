<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
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
            
            String sql = "SELECT productId, productName, productPrice, categoryId " +
                        "FROM product";

            ResultSet rst = executeQuery(sql);
            NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.CANADA);
            %>
                <div class="container mt-5">
                <h2>List of Products:</h2>
            <%

            // Table Headers //
            out.println("<table class='table table-striped table-hover'><thead class='thead-dark'><tr>" +
                        "<th>Product Id</th>" +
                        "<th>Name</th>" +
                        "<th>Price</th>" +
                        "<th>Category Id</th>" +
                        "<th></th>" +
                        "<th></th>" +
                        "</tr></thead><tbody>");

            // Table Data //
            while(rst.next()) {
                out.println("<tr>" +
                            "   <td>" + rst.getInt("productId") + "</td>" +
                            "   <td>" + rst.getString("productName") + "</td>" +
                            "   <td>" + currFormat.format(rst.getDouble("productPrice")) + "</td>" +
                            "   <td>" + rst.getInt("categoryId") + "</td>" +
                            "   <td><a href='adminProductOverview.jsp?id=" + rst.getInt("productId") + "'>Edit Info</a></td>" +
                            "   <td><a href='adminProductDelete.jsp?id=" + rst.getInt("productId") + "' style='color:red'>Delete</a></td>" +
                            "</tr>");
            }
            out.println("   </tbody>" + 
                        "</table>");

            %>
                <h4><a href="adminProductAdd.jsp" style="color:green">Add Product</a></h4>
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