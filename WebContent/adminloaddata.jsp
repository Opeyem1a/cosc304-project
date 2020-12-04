<%@ page import="java.sql.*" %>
<%@ page import="java.util.Scanner" %>
<%@ page import="java.io.File" %>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>

<!DOCTYPE html>
<html>
<head>
<title>Your Shopping Cart</title>
<%@ include file="global-jsp/header.jsp" %>
</head>
<body>
<%@ include file="auth.jsp"%>


<%

out.println("<div class='container mt-5'><table class='table table-light'>");
out.println("<h1>Connecting to database.</h1><br><br>");

String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";
        
String fileName = "/usr/local/tomcat/webapps/shop/orderdb_sql.ddl";

try(Connection con = DriverManager.getConnection(url, uid, pw);)
{
    // Create statement
    Statement stmt = con.createStatement();
    
    Scanner scanner = new Scanner(new File(fileName));
    // Read commands separated by ;
    scanner.useDelimiter(";");
    while (scanner.hasNext())
    {
        String command = scanner.next();
        if (command.trim().equals(""))
            continue;
        //out.print(command);        // Uncomment if want to see commands executed
        try
        {
            stmt.execute(command);
        }
        catch (Exception e)
        {	// Keep running on exception.  This is mostly for DROP TABLE if table does not exist.
            out.print(e);
        }
    }	 
    scanner.close();
    
    out.println("<br><br><h1>Database loaded.</h1>");
    out.println("<h3><a href='admin.jsp'>Back</a></h3>");
    out.println("</div>");
}
catch (Exception e)
{
    out.print(e);
}  
%>
<%@ include file="global-jsp/footer.jsp" %>
</body>
</html> 
