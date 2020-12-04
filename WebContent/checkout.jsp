<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>

<!DOCTYPE html>
<html>
    <head>
        <title>R*mone’s Black Market Course Resources</title>
        <%@ include file="global-jsp/header.jsp" %>
    </head>
    <body>
        <%
        try {
            int customerId = (Integer) session.getAttribute("authenticatedId");
            getConnection();
        %>
        <form class="container my-3" method="get" action="listprod.jsp">
            <div class="form-group ml-auto">
                <label class="form-label">Payment Method</label>
                <select class="custom-select mr-sm-2" id="paymentMethodId" name="category">
                    <option style="color: #c4c4c4;" disabled selected>Select Category...</option>
                    <%
                        String sqlPayTypes = "SELECT paymentMethodId, paymentType " +
                                                "FROM paymentmethod " +
                                                "WHERE customerId = ?";
 
                        ResultSet rstPayTypes = executePreparedQueryWithId(sqlPayTypes, customerId);
                        while(rstPayTypes.next()) {
                            %>
                            <option value="<%= rstPayTypes.getInt(1) %>"><%= rstPayTypes.getString(2) %></option>
                            <%
                        }
                    %>
                </select>
            </div>
            <div class="form-group">
                <label class="form-label">Card Number:</label>
                <input class="form-control p-2" type="text" name="paymentNumber" size="50" placeholder="Insert credit card number...">
            </div>
            <div class="form-group">
                <label class="form-label">Card Expiry Date:</label>
                <input class="form-control p-2" type="text" name="paymentExpiryDate" size="50" placeholder="Insert card expiry date">
            </div>
            <button class="btn btn-primary ml-2" type="submit" value="Submit">Submit</button>
            <button class="btn btn-primary ml-2 mr-auto" type="reset" value="Reset">Reset</button>
        </form>

        <%
        } catch (SQLException e) {
            out.print(e);
        } finally {
            closeConnection();
        }
        %>

        <%@ include file="global-jsp/footer.jsp" %>
    </body>
</html>

