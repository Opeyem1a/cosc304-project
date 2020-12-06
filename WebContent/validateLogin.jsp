<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="jdbc.jsp" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);

	try
	{
		authenticatedUser = validateLogin(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }

	if(authenticatedUser != null) { // Successful login
		try {
			getConnection();
			String sqlCart = "SELECT * FROM incart WHERE customerId = ?";
			int authId = (Integer) session.getAttribute("authenticatedId");
			ResultSet rstCart = executePreparedQueryWithId(sqlCart, authId);
			boolean isProductList = false;
			HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

			if(!isProductList) {
				productList = new HashMap<String, ArrayList<Object>>();
				isProductList = true;
			};

			while(rstCart.next()) {
				ArrayList<Object> product = new ArrayList<Object>();
				product.add("" + rstCart.getInt("productId"));

				String sqlProductName = "SELECT productName FROM product WHERE productId = ?";
				ResultSet rstProductName = executePreparedQueryWithId(sqlProductName, rstCart.getInt("productId"));
				if(rstProductName.next())
					product.add(rstProductName.getString("productName"));
				
				product.add(rstCart.getDouble("price"));
				product.add(rstCart.getInt("quantity"));

				productList.put("" + rstCart.getInt("productId"), product);
			}

			session.setAttribute("productList", productList);
		} catch(SQLException e) {
			out.print(e);
		} finally {
			closeConnection();
		}
		response.sendRedirect("index.jsp");	
	} else
		response.sendRedirect("login.jsp");		// Failed login - redirect back to login page with a message 
%>


<%!
	String validateLogin(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String retStr = null;
		int authId = 0;

		if(username == null || password == null)
				return null;
		if((username.length() == 0) || (password.length() == 0))
				return null;

		try 
		{
			getConnection();
			// TODO: Check if userId and password match some customer account. If so, set retStr to be the username.
			String query = "SELECT customerId, userid, password " +
							"FROM customer " +
							"WHERE userid = ? AND password = ?";
			
			PreparedStatement pstmt = prepareStatement(query);
			pstmt.setString(1, username);
			pstmt.setString(2, password);
			
			// ResultSet rst = executeQuery(query);
			ResultSet rst = pstmt.executeQuery();

			if(rst.next()) {
					retStr = username;
					authId = rst.getInt("customerId");
			}
					
		} 
		catch (SQLException ex) {
			out.println(ex);
		}
		finally
		{
			closeConnection();
		}	
		
		if(retStr != null)
		{	session.removeAttribute("loginMessage");
			session.setAttribute("authenticatedUser",username);
			if(authId > 0)
				session.setAttribute("authenticatedId", authId);
		}
		else
			session.setAttribute("loginMessage","Could not connect to the system using that username/password.");

		return retStr;
	}
%>

