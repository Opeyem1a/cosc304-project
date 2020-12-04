<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>

<%
	String product = request.getParameter("productId");
	int customerId = (Integer) session.getAttribute("authenticatedId");
	String ratingString = request.getParameter("rating");
	String comment = request.getParameter("comment");

	try {
		int productId = Integer.parseInt(product);
		int rating = Integer.parseInt(ratingString);

		if(validateReview(out,request,session)) {
			getConnection();
			String sql = "INSERT INTO review " +
						"(customerId, productId, reviewRating, reviewDate, reviewComment) " +
						"VALUES (?, ?, ?, ?, ?)";
			
			PreparedStatement pstmt = prepareStatement(sql);
			pstmt.setInt(1, customerId);
			pstmt.setInt(2, productId);
			pstmt.setInt(3, rating);
			pstmt.setTimestamp(4, new java.sql.Timestamp(System.currentTimeMillis()));
			pstmt.setString(5, comment);

			pstmt.executeUpdate();
		};
	} catch(IOException e) {
		System.err.println(e);
	} catch (SQLException e) {
		out.print(e);
	} catch (Exception e) {
		System.err.println(e);
		out.print(e);
	} finally {
		closeConnection();
	}
%>

<%!
	boolean validateReview(JspWriter out, HttpServletRequest request, HttpSession session) throws IOException {
		// currently default accepts all forms but extra server validation could be done here
        return true;
    }
%>
<jsp:forward page="product.jsp">
	<jsp:param name="id" value="<%= product %>" ></jsp:param>
</jsp:forward>