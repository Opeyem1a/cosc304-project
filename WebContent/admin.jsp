
<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Administrator Page</title>
        <%@ include file="global-jsp/header.jsp" %>
    </head>
    <body>

        <%@ include file="jdbc.jsp" %>
        <%@ include file="auth.jsp" %>
        
        <h1 align="center">Admin Page</h1>

            <h2 align="center"><a href="adminSaleList.jsp">Sales List</a></h2>

            <h2 align="center"><a href="adminCustomerList.jsp">Customer List</a></h2>

            <h2 align="center"><a href="adminProductList.jsp">Product List</a></h2>

            <h2 align="center"><a href="adminWarehouseList.jsp">Warehouse List</a></h2>

            <h2 align="center"><a href="warehouse.jsp">Warehouse Inventory</a></h2>

            <h2 align="center"><a href="index.jsp">Back</a></h2>

            <h2 align="center"><a href="adminloaddata.jsp" style="color:red">Restore Database</a></h2>
        
        <%@ include file="global-jsp/footer.jsp" %>
    </body>
</html>

