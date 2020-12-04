<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
	<head>
		<title>Add Product Page</title>
		<%@ include file="global-jsp/header.jsp" %>
	</head>
	<body>

		<%@ include file="auth.jsp"%>
		<%@ include file="jdbc.jsp" %>
        
        <%
            int categoryMin = 0;
            int categoryMax = 0;

            String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
			String uid = "SA";
			String pw = "YourStrong@Passw0rd";

			try ( Connection con = DriverManager.getConnection(url, uid, pw);) {

                // min/max category Id
                Statement stmt = con.createStatement(
                    ResultSet.TYPE_SCROLL_INSENSITIVE,
					ResultSet.CONCUR_READ_ONLY);
                ResultSet rst = stmt.executeQuery(
                    "SELECT categoryId " +
                    "FROM category");
                categoryMin = (rst.first() == false)? 0 : rst.getInt(1);
                categoryMax = (rst.last() == false)? 0 : rst.getInt(1);
            
            } catch (SQLException ex) {
				System.err.println("SQLException: " + ex); 
			}
        %>


        <h1 class="main-title">Register a Product</h1>
			<form method="get" action="adminProductAdd.jsp">
				<div class="container mt-5"><table class='table table-light'>
                    <thead class='thead-dark'><tr><th colspan=2>Product Information</th></tr></thead>
                        <tr><td><label for="productName"><b>Product Name</b></label></td>
                            <td><input type="text" name="productName" id="productName" size="50" maxLength="100" required></td></tr>
                        <tr><td><label for="productPrice"><b>Product Price</b></label></td>
                            <td><input type="number" name="productPrice" id="productPrice" size="50" step="0.01" min="0" required></td></tr>
                        <tr><td><label for="productImageURL"><b>Product Image URL</b></label></td>
                            <td><input type="text" name="productImageURL" id="productImageURL" size="50" maxLength="100"></td></tr>
                        <tr><td><label for="productDesc"><b>Product Description</b></label></td>
                            <td><input type="text" name="productDesc" id="productDesc" size="50" maxLength="1000"></td></tr>
                        <tr><td><label for="categoryId"><b>Category Id</b></label></td>
                            <td><input type="number" name="categoryId" id="categoryId" size="50" min="<%= categoryMin %>" max="<%= categoryMax %>" required></td></tr>
                    </table>
                    <button class="btn btn-primary ml-2" type="submit" value="Submit">Submit</button>
                    <button class="btn btn-primary ml-2" type="reset" value="Reset">Reset</button>
                    <h3></h3>
                    <h3><a href="adminProductList.jsp">Back</a></h3>
				</div>
			</form>

		<%
			String productName = request.getParameter("productName");
            String productPriceString = request.getParameter("productPrice");
            double productPrice;
            String productImageURL = request.getParameter("productImageURL");
            String productDesc = request.getParameter("productDesc");
            String categoryIdString = request.getParameter("categoryId");
            int categoryId;

			try ( Connection con = DriverManager.getConnection(url, uid, pw);) {
                
                if(productName != null){

                    PreparedStatement pstmt = con.prepareStatement(
                    "INSERT INTO product (" +
                        "productName, " +
                        "productPrice, " +
                        "productImageURL, " +
                        "productDesc, " +
                        "categoryId) " +
                        "VALUES (?, ?, ?, ?, ?)",
                    Statement.RETURN_GENERATED_KEYS);

                    productPrice = Double.parseDouble(productPriceString.toString());
                    categoryId = Integer.parseInt(categoryIdString.toString());
                
                    pstmt.setString(1, productName);
                    pstmt.setDouble(2, productPrice);
                    pstmt.setString(3, productImageURL);
                    pstmt.setString(4, productDesc);
                    pstmt.setInt(5, categoryId);

                    pstmt.executeUpdate();

                    ResultSet keys = pstmt.getGeneratedKeys();
                    keys.next();
                    int productId = keys.getInt(1);

                    out.println("<div class='container mt-5'><h4>Product with id: " + productId + " was added to the database</h4></div>");
                }

                
            
            } catch (SQLException ex) {
				System.err.println("SQLException: " + ex); 
			}
		%>

		<%@ include file="global-jsp/footer.jsp" %>
	</body>
</html>