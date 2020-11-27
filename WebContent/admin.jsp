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

            // Table Headers //
            out.println("<table><tr>" +
                        "<th>Order Date</th>" +
                        "<th>Total Order Amount</th>" +
                        "</tr>");

            // Table Data //
            while(rst.next()) {
                out.println("<tr>" +
                            "<td>" + rst.getDate("date") + "</td>" +
                            "<td>" + currFormat.format(rst.getDouble("totalOrderAmount")) + "</td>" +
                            "</tr>");
            }
            out.println("</table>");		
                            
        } catch (SQLException ex) {
            out.println(ex);
        } finally {
            closeConnection();
        }

        %>

    <%@ include file="global-jsp/footer.jsp" %>
    </body>
</html>

