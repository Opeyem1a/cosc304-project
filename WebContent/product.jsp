<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
    <head>
        <title>R*mone’s Black Market Course Resources - Product Information</title>
		<%@ include file="global-jsp/header.jsp" %>
    </head>
    <body>
        <%
        // Get product name to search for
        // TODO: Retrieve and display info for the product
        String productId = request.getParameter("id");

        try {
            getConnection();
            // Useful code for formatting currency values:
            NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.CANADA);
            String sql = "SELECT * " +
                            "FROM product " +
                            "WHERE productId = ?";

            ResultSet rst = executePreparedQueryWithId(sql, Integer.parseInt(productId));

            if(rst.next()) {
                out.println("<div class='container'><h1>"+rst.getString("productName")+"</h1>");
                %>
                <table class="table table-bordered">
                    <tr>
                    <% if(rst.getString("productImageURL") != null) { 
                        %>
                        <img src="<%= rst.getString("productImageURL")%>" alt="Image of <%= rst.getString(1) %>">
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
                    <tr>
                        <td>Description:    </td>
                        <td><%= rst.getString("productDesc") %></td>
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

            String sqlReview = "SELECT reviewId, reviewRating, reviewDate, reviewComment " +
                            "FROM review " +
                            "WHERE productId = ? " +
                            "ORDER BY reviewDate DESC";
            
            ResultSet rstReviews = executePreparedQueryWithId(sqlReview, Integer.parseInt(productId));
            %>
            <table class="table table-striped table-bordered">
                <thead>
                    <tr>
                        <th>Rating</th>
                        <th>Date</th>
                        <th>Comment</th>
                    </tr>
                </thead>
                <tbody>
            <%
            while(rstReviews.next()) {
                %>
                <tr>
                    <td id="<%= rstReviews.getInt(1) %>"><%= rstReviews.getInt(2) %></td>
                    <td><%= rstReviews.getDate(3) + " " + rstReviews.getTime(3)%></td>
                    <td><%= rstReviews.getString(4) %></td>
                </tr>                        
                <%
            }
            %>
                </tbody>
            </table>
            <button class="btn btn-primary makeNewReviewBtn" onClick="makeReview(<%= productId %>)">Add your Review</button>

            <%
            } catch (SQLException ex) {
                out.println(ex);
            } finally {
                closeConnection();
            }
        %>
        <%@ include file="global-jsp/footer.jsp" %>
        <script>
            function makeReview(pid) {
                event.preventDefault();
                window.location = "review.jsp?productId="+pid;
            }
        </script>
    </body>
</html>

