<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>

<html>
    <head>
        <title>R*mone’s Black Market Course Resources - List Customers</title>
		<%@ include file="global-jsp/header.jsp" %>
    </head>
    <body>
        <%
            try {
                getConnection();
                String sql = "SELECT * " +
                            "FROM customer ";

                ResultSet rst = executeQuery(sql);
                %>
                <table class="table table-striped table-bordered">
                    <thead>
                        <tr>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                <%
                while(rst.next()) {
                %>
                    <tr>
                        <td><%= rst.getInt(1) %></td>
                        <td><%= rst.getString(2) %></td>
                        <td><%= rst.getString(3) %></td>
                        <td><%= rst.getString(4) %></td>
                        <td><%= rst.getString(5) %></td>
                        <td><%= rst.getString(6) %></td>
                        <td><%= rst.getString(7) %></td>
                        <td><%= rst.getString(8) %></td>
                        <td><%= rst.getString(9) %></td>
                        <td><%= rst.getString(10) %></td>
                        <td><%= rst.getString(11) %></td>
                        <td><%= rst.getString(12) %></td>
                    </tr>
                <%
                }
                %>
                    </tbody>
                </table>
                <%
            } catch(SQLException e) {
                out.print(e);
            } finally {
                closeConnection();
            }
        %>
        <%@ include file="global-jsp/footer.jsp" %>
    </body>
</html>