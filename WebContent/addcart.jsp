<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>
<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null)
{	// No products currently in list.  Create a list.
	productList = new HashMap<String, ArrayList<Object>>();
}

// Add new product selected
// Get product information
String customerId = "" + (Integer) session.getAttribute("authenticatedId");
String id = request.getParameter("id");
String name = request.getParameter("name");
String price = request.getParameter("price");
Integer quantity = new Integer(1);

// Store product information in an ArrayList
ArrayList<Object> product = new ArrayList<Object>();
product.add(id);
product.add(name);
product.add(price);
product.add(quantity);

/*
	customerId          INT,
	productId           INT,
	quantity            INT,
	price               DECIMAL(10,2),
*/

String sqlAddCart = "INSERT INTO incart " +
					"(customerId, productId, quantity, price) " +
					"VALUES (?, ?, ?, ?)";

String sqlUpdateCart = "UPDATE incart " +
						"SET productId = ?, quantity = ?, price = ? " +
						"WHERE customerId = ?";

// Update quantity if add same item to order again
if (productList.containsKey(id)) {
	product = (ArrayList<Object>) productList.get(id);
	int curAmount = ((Integer) product.get(3)).intValue();
	product.set(3, new Integer(curAmount+1));

	try {
		getConnection();

		PreparedStatement pstmt = prepareStatement(sqlUpdateCart);
		pstmt.setInt(4, Integer.parseInt(customerId));
		pstmt.setInt(1, Integer.parseInt(id));
		pstmt.setInt(2, curAmount+1);
		pstmt.setDouble(3, Double.parseDouble(price));

		pstmt.executeUpdate();

	} catch(SQLException e) {
		out.print(e);
	} finally {
		closeConnection();
	}

} else {
	try {
		getConnection();

		PreparedStatement pstmt = prepareStatement(sqlAddCart);
		pstmt.setInt(1, Integer.parseInt(customerId));
		pstmt.setInt(2, Integer.parseInt(id));
		pstmt.setInt(3, quantity);
		pstmt.setDouble(4, Double.parseDouble(price));

		pstmt.executeUpdate();

	} catch(SQLException e) {
		out.print(e);
	} finally {
		closeConnection();
	}

	productList.put(id, product);
}

session.setAttribute("productList", productList);
%>
<jsp:forward page="showcart.jsp" />