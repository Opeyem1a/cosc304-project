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
            
            String sql = "SELECT orderId, customerId, totalAmount, shiptoAddress, shiptoCity, shiptoCountry, shipmentId " +
                        "FROM ordersummary";

            ResultSet rst = executeQuery(sql);
            NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.CANADA);
            %>
                <div class="container mt-5">
                <h2>List of Orders:</h2>
            <%

            // Table Headers //
            out.println("<table class='table table-striped table-hover'><thead class='thead-dark'><tr>" +
                        "<th>Order Id</th>" +
                        "<th>Customer Id</th>" +
                        "<th>Total Amount</th>" +
                        "<th>Shimpment:</th>" +
                        "<th>Address</th>" +
                        "<th>City</th>" +
                        "<th>Country</th>" +
                        "<th>Shipment Id</th>" +
                        "<th></th>" +
                        "</tr></thead><tbody>");

            // Table Data //
            while(rst.next()) {
                String shipmentId;
                if(rst.getInt("shipmentId") == 0) {
                    shipmentId = "<a href='ship.jsp?orderId=" + rst.getInt("orderId") + "'>Push shipment";
                }else {
                    shipmentId = "" + rst.getInt("shipmentId");
                }

                out.println("<tr>" +
                            "   <td>" + rst.getInt("orderId") + "</td>" +
                            "   <td>" + rst.getInt("customerId") + "</td>" +
                            "   <td>" + currFormat.format(rst.getDouble("totalAmount")) + "</td>" +
                            "   <td></td>" +
                            "   <td>" + rst.getString("shiptoAddress") + "</td>" +
                            "   <td>" + rst.getString("shiptoCity") + "</td>" +
                            "   <td>" + rst.getString("shiptoCountry") + "</td>" +
                            "   <td>" + shipmentId + "</td>" +
                            "   <td><a href='adminOrderOverview.jsp?id=" + rst.getInt("orderId") + "'>Edit Info</a></td>" +
                            "</tr>");
            }
            out.println("   </tbody>" + 
                        "</table>");

            %>
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