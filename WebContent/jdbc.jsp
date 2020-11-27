<%
/**
A JSP file that encapsulates all database access.

Public methods:
- public void getConnection() throws SQLException
- public ResultSet executeQuery(String query) throws SQLException
- public void executeUpdate(String query) throws SQLException
- public void closeConnection() throws SQLException  
**/
%>
<%@ page import="java.sql.*"%>
<%!
	// TODO: Modify database/user connection info
	// User id, password, and server information
	String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
	String uid = "SA";
	String pw = "YourStrong@Passw0rd";

	// Connection
	private Connection con = null;
%>
<%!
	public void getConnection() throws SQLException 
	{
		try
		{	// Load driver class
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		}
		catch (java.lang.ClassNotFoundException e)
		{
			throw new SQLException("ClassNotFoundException: " +e);
		}
	
		con = DriverManager.getConnection(url, uid, pw);
	}

	public ResultSet executeQuery(String query) throws SQLException
	{
		Statement stmt = con.createStatement();
		ResultSet rst = stmt.executeQuery(query);
		return rst;
	}

	public PreparedStatement prepareStatement(String query) throws SQLException
	{
		return con.prepareStatement(query);	
	}

	public ResultSet executePreparedQueryWithId(String query, int id) throws SQLException
	{
		PreparedStatement pstmt = con.prepareStatement(query);
		pstmt.setInt(1, id);
		ResultSet rst = pstmt.executeQuery();
		return rst;
	}
   
	public void closeConnection()
	{
		try {
			if (con != null)
				con.close();
			con = null;	
		}
		catch (SQLException e)
		{ /* Ignore connection close error */ }
	}
%>
