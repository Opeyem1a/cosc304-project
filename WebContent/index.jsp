<!DOCTYPE html>
<html>
        <head>
                <title>R*mone’s Black Market Course Resources</title>
                <%@ include file="global-jsp/header.jsp" %>
        </head>
        <body>
                <h1 align="center">Welcome to Ray's Grocery</h1>

                <h2 align="center"><a href="login.jsp">Login</a></h2>

                <h2 align="center"><a href="listprod.jsp">Begin Shopping</a></h2>

                <h2 align="center"><a href="listorder.jsp">List All Orders</a></h2>

                <h2 align="center"><a href="customer.jsp">Customer Info</a></h2>

                <h2 align="center"><a href="admin.jsp">Administrators</a></h2>

                <h2 align="center"><a href="logout.jsp">Log out</a></h2>

                <%
                // Display user name that is logged in (or nothing if not logged in)
                boolean authenticated = session.getAttribute("authenticatedUser") == null ? false : true;

                if(authenticated) {
                        String userName = (String) session.getAttribute("authenticatedUser");
                        out.println("<h3 align=\"center\">Signed in as: " + userName + "</h3>");
                }

                %>
                <%@ include file="global-jsp/footer.jsp" %>
        </body>
</html>


