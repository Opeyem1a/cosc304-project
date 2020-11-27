<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
    <head>
        <title>Ray's Grocery - Product Information</title>
		<%@ include file="global-jsp/header.jsp" %>
    </head>
    <body>
        <%
        // Get product name to search for
        // TODO: Retrieve and display info for the product
        String productId = request.getParameter("id");

        //Note: Forces loading of SQL Server driver
        String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
        String uid = "SA";
        String pw = "YourStrong@Passw0rd";

        try {	// Load driver class
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (java.lang.ClassNotFoundException e) {
            out.println("ClassNotFoundException: " +e);
        } try ( Connection con = DriverManager.getConnection(url, uid, pw);
                Statement stmt = con.createStatement();) {		
                // Useful code for formatting currency values:
                NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.CANADA);
                String sql = "SELECT productId, productName, productPrice, productImageURL, productImage " +
                                "FROM product " +
                                "WHERE productId = ?";
                PreparedStatement pstmt = con.prepareStatement(sql);

                pstmt.setInt(1, Integer.parseInt(productId));
                ResultSet rst = pstmt.executeQuery();
                if(rst.next()) {
                    out.println("<div class='container'><h1>"+rst.getString("productName")+"</h1>");

                    %>
                    <table>
                        <tr>
                        <% if(rst.getString("productImageURL") != null) { 
                            %>
                            <img src="<%= rst.getString("productImageURL")%>" alt="Image of <%= rst.getString(1) %>");
                            <%
                        }
                        if(rst.getBinaryStream("productImage") != null) { 
                            %>
                            <img src="displayImage.jsp?id=<%= rst.getInt("productId") %>">
                            <%
                        }
                        %>
                        </tr>
                        <tr>
                            <td>Id       </td>
                            <td><%= rst.getInt("productId") %></td>
                        </tr>
                        <tr>
                            <td>Price    </td>
                            <td><%= currFormat.format(rst.getDouble("productPrice")) %></td>
                        </tr>
                    </table>
                    
                    <h3>
                        <a href="addcart.jsp?id=<%= rst.getInt("productId") %>&name=<%= rst.getString("productName") %>&price=<%= rst.getDouble("productPrice") %>">
                            Add to Cart
                        </a>
                    </h3>
                    <h3>
                        <a href="listprod.jsp">Continue Shopping</a>
                    </h3>
                    <%
                }
            } catch (SQLException ex) {
            out.println(ex); 
            }

        // TODO: If there is a productImageURL, display using IMG tag
                
        // TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
                
        // TODO: Add links to Add to Cart and Continue Shopping
        %>
        <%@ include file="global-jsp/footer.jsp" %>
    </body>
</html>

