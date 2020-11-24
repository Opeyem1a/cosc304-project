<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Ray's Grocery - Product Information</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="global-jsp/header.jsp" %>

<%
String name = request.getParameter("productName");
					
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
    // Get product name to search for
    // TODO: Retrieve and display info for the product
    String productId = request.getParameter("id");

    String sql = "SELECT productName, productImageURL, productId, productPrice, productImage"
                    + " FROM product"
                    + " WHERE productId = ?";

    // TODO: If there is a productImageURL, display using IMG tag
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setInt(1, Integer.parseInt(productId));

    ResultSet rst = pstmt.executeQuery();
	while (rst.next()) {
        out.println("<div class='container'><h2>"+rst.getString(1)+"</h2>");

        if(rst.getString(2) != null) {
            out.println("<img src="+rst.getString(2)+" alt='Image of "+rst.getString(1)+"'>");
        } 

        if(rst.getBinaryStream(5) != null) {
            out.println("<img src=displayImage.jsp?id="+rst.getInt(3)+" alt='Image of "+rst.getString(1)+"'>");
        }

        out.println("<h5>Id:&nbsp"+rst.getInt(3)+"</h5>");
        out.println("<h5>Price:&nbsp"+currFormat.format(rst.getDouble(4))+"</h5>");

        out.println("<p><a href=addCart.jsp?id="+rst.getInt(3)+"name="+rst.getString(1)+"price="+rst.getDouble(4)+">Add to Cart</a></p>");
        out.println("<p><a href=listprod.jsp>Back to Shopping</a></p></div>");
    }

    // TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
            
    // TODO: Add links to Add to Cart and Continue Shopping
} catch (SQLException ex) {
    out.println(ex); 
}
%>

</body>
</html>

