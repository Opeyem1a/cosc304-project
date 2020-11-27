
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
        <%@ page import="java.text.NumberFormat" %>
        <%@ page import="java.util.Locale" %>
        <%

        // TODO: Write SQL query that prints out total order amount by day
        try {
            NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.CANADA);

            getConnection();
            
            String sql = "SELECT CAST(orderDate AS DATE) AS date, SUM(totalAmount) AS totalOrderAmount " +
                        "FROM ordersummary " +
                        "GROUP BY CAST(orderDate AS DATE)";

            ResultSet rst = executeQuery(sql);

            %>
                <div class="container mt-5">
                <h2>Your Orders:</h2>
            <%

            // Table Headers //
            out.println("<table class='table table-bordered table-striped table-hover'><thead class='thead-dark'><tr>" +
                        "<th>Order Date</th>" +
                        "<th>Total Order Amount</th>" +
                        "</tr></thead><tbody>");

            // Table Data //
            while(rst.next()) {
                out.println("<tr>" +
                            "   <td>" + rst.getDate("date") + "</td>" +
                            "   <td>" + currFormat.format(rst.getDouble("totalOrderAmount")) + "</td>" +
                            "</tr>");
            }
            out.println("   </tbody>" + 
                        "</table>");

            %>
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

