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
String deleteId = request.getParameter("delete");

if (deleteId != null) {
    if (productList.containsKey(deleteId)) {
        String sqlDeleteProduct = "DELETE FROM incart " +
                              "WHERE customerId = ? AND productId = ?";
        try {
            getConnection();
            PreparedStatement pstmt = prepareStatement(sqlDeleteProduct);
            pstmt.setInt(1, Integer.parseInt(customerId));
            pstmt.setInt(2, Integer.parseInt(deleteId));
            pstmt.executeUpdate();
        } catch(SQLException e) {
            out.print(e);
        } finally {
            closeConnection();
        }
        productList.remove(deleteId);
    }
}

session.setAttribute("productList", productList);
%>
<%@ include file="global-jsp/footer.jsp" %>
<jsp:forward page="showcart.jsp" />