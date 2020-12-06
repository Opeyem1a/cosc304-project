<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>
<%@ include file="global-jsp/header.jsp" %>

<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

String customerId = "" + (Integer) session.getAttribute("authenticatedId");
String updateId = request.getParameter("update");
String rawNewqty = request.getParameter("newqty");
int newqty = 0;

try {
    newqty = Integer.parseInt(rawNewqty);
} catch (Exception e) {
    System.err.print(e);
    out.print("<div class='alert alert-danger' role='alert'>New quantity must be numeric.</div>");
    out.print("<a class='btn btn-primary' href='showcart.jsp'>Go back to cart</a>");
    return;
}

if (updateId != null) {
    /*
        customerId          INT,
        productId           INT,
        quantity            INT,
        price               DECIMAL(10,2),
    */
    String sqlUpdateCart = "UPDATE incart " +
						    "SET productId = ?, quantity = ? " +
                            "WHERE customerId = ? ";

    String sqlDeleteProduct = "DELETE FROM incart " +
                              "WHERE customerId = ? AND productId = ?";
    
    if (productList.containsKey(updateId)) {
        ArrayList<Object> product = new ArrayList<Object>();
        product = productList.remove(updateId);

        try {
            getConnection();

            PreparedStatement pstmt = prepareStatement(sqlUpdateCart);

            if(newqty <= 0) {
                pstmt = prepareStatement(sqlDeleteProduct);
                pstmt.setInt(1, Integer.parseInt(customerId));
                pstmt.setInt(2, Integer.parseInt(updateId));
                pstmt.executeUpdate();
            } else {
                pstmt.setInt(3, Integer.parseInt(customerId));
                pstmt.setInt(1, Integer.parseInt(updateId));
                pstmt.setInt(2, newqty);
                pstmt.executeUpdate();
            }
        } catch(SQLException e) {
            out.print(e);
        } finally {
            closeConnection();
        }

        if(newqty <= 0) {
            out.print("<div class='alert alert-danger' role='alert'> New quantity = 0. The product "+product.get(1)+" was removed. </div>");
            out.print("<a class='btn btn-primary' href='showcart.jsp'>Go back to cart</a");
            return;
        }
        
        product.set(3, new Integer(newqty));
        productList.put(updateId, product);
    }
}

session.setAttribute("productList", productList);
%>
<%@ include file="global-jsp/footer.jsp" %>

<jsp:forward page="showcart.jsp" />
