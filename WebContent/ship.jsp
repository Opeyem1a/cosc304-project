<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
	<head>
		<title>YOUR NAME Grocery Shipment Processing</title>
		<%@ include file="global-jsp/header.jsp" %>
	</head>
	<body>

		<%
			// TODO: Get order id
			// The href=ship.jsp?orderId is on the list orders page as the order numbers
			String orderIdString = request.getParameter("orderId");
			
			String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
			String uid = "SA";
			String pw = "YourStrong@Passw0rd";

			try ( Connection con = DriverManager.getConnection(url, uid, pw);) {	
				
				// TODO: Check if valid order id
				// Check if null or nothing
				if(orderIdString == null || orderIdString.length() == 0) {
					out.println("<h1>Invalid order id.</h1>");
					return;
				}

				// Check if it is actually an int
				int orderId = 0;
				try{
					orderId = Integer.parseInt(orderIdString.toString());
				}
				catch (Exception e) {
					out.println("<h1>Invalid order id.</h1>");
					return;
				}

				// Check if order id is in database	
				PreparedStatement pstmt = con.prepareStatement(
					"SELECT orderId " +
					"FROM orderproduct " +
					"WHERE orderId = ?",
					ResultSet.TYPE_SCROLL_INSENSITIVE,
					ResultSet.CONCUR_READ_ONLY);
				
				pstmt.setInt(1, orderId);
				ResultSet rst = pstmt.executeQuery();

				if(rst.first() == false) {
					out.println("<h1>Invalid order id or no items in order.</h1>");
					return;
				}
				
				// TODO: Start a transaction (turn-off auto-commit)
				con.setAutoCommit(false);			

				// TODO: Retrieve all items in order with given id
				PreparedStatement pstmtOrder = con.prepareStatement(
					"SELECT productId, quantity " +
					"FROM orderproduct " +
					"WHERE orderId = ?");

				pstmtOrder.setInt(1, orderId);
				ResultSet rstOrder = pstmtOrder.executeQuery();

				// TODO: Create a new shipment record.
				PreparedStatement pstmtShip = con.prepareStatement(
				"INSERT INTO shipment (shipmentDate, warehouseId) " +
				"VALUES (?, 1)");
			
				pstmtShip.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
				pstmtShip.executeUpdate();

				// READY "Get warehouse quantities" and "Update warehouse quantities"
				PreparedStatement pstmtStock = con.prepareStatement(
					"SELECT quantity " +
					"FROM productinventory " +
					"WHERE productId = ?");
				
				PreparedStatement pstmtUpdateStock = con.prepareStatement(
					"UPDATE productinventory " +
					"SET quantity = ? " +
					"WHERE productId = ?");

				// TODO: For each item verify sufficient quantity available in warehouse 1.
				// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
				boolean sufficientInventory = true;
				while(rstOrder.next()) {
					int productId = rstOrder.getInt("productId");
					int quantity = rstOrder.getInt("quantity");

					pstmtStock.setInt(1, productId);
					ResultSet rstStock = pstmtStock.executeQuery();
					rstStock.next();

					int warehouseQuantity = rstStock.getInt("quantity");

					int newWarehouseQuantity = warehouseQuantity - quantity; 
					if (newWarehouseQuantity >= 0) {
						pstmtUpdateStock.setInt(1, newWarehouseQuantity);
						pstmtUpdateStock.setInt(2, productId);
						pstmtUpdateStock.executeUpdate();

						out.println("<h2>" +
							"Ordered product: " + productId +
							" Qty: " + quantity +
							" Previous inventory: " + warehouseQuantity +
							" New inventory " + newWarehouseQuantity);
					} else {
						sufficientInventory = false;
						out.println("<h1>Shipment not done. Insufficient inventory for product id: " + productId + "</h1>");
						break;
					}
				}

				if(sufficientInventory == true) {
					con.commit();
					out.println("<h1>Shipment successfully processed</h1>");
				} else {
					con.rollback();
				}
				
				// TODO: Auto-commit should be turned back on
				con.setAutoCommit(true);
				
			} catch (SQLException ex) {
				System.err.println("SQLException: " + ex); 
				//con.rollback();
			}
			
		%>                       				

		<h2><a href="index.jsp">Back to Main Page</a></h2>
		<%@ include file="global-jsp/footer.jsp" %>
	</body>
</html>
