<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="global-jsp/header.jsp" %>
<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

String deleteId = request.getParameter("delete");

if (deleteId != null) {
    if (productList.containsKey(deleteId))
        productList.remove(deleteId);
}

session.setAttribute("productList", productList);
%>
<%@ include file="global-jsp/footer.jsp" %>
<jsp:forward page="showcart.jsp" />