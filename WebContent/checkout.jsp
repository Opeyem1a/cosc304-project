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
        <div class="container my-3">
        <form id="checkoutForm" class="form needs-validation" novalidate>
            <div class="form-group ml-auto">
                <label class="form-label" for="paymentMethodId">Payment Method</label>
                <select class="custom-select mr-sm-2" id="paymentMethodId" name="category" required>
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
                <input class="form-control p-2" type="text" name="paymentNumber" size="50" pattern="[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{4}" placeholder="1234-5678-9012-3456" required>
            </div>
            <div class="form-group">
                <label class="form-label">Card Expiry Date:</label>
                <input class="form-control p-2" type="text" name="paymentExpiryDate" size="50" pattern="[0-9]{2}/[0-9]{2}" placeholder="00/00" required>
            </div>
            <button class="btn btn-primary ml-2" onClick="onSubmit(<%= customerId %>)" type="submit" value="Submit">Submit</button>
            <button class="btn btn-primary ml-2 mr-auto" type="reset" value="Reset">Reset</button>
        </form>
        </div>

        <%
        } catch (SQLException e) {
            out.print(e);
        } finally {
            closeConnection();
        }
        %>

        <%@ include file="global-jsp/footer.jsp" %>
        <script>
            $(function(){
                $("#checkoutForm").on("click", function(event) {
                    event.preventDefault();
                    if ($(event.target).parent().get(0).checkValidity() === false) {
                        event.stopPropagation();
                    };
                    $(event.target).parent().get(0).classList.add('was-validated');
                })
            });

            function onSubmit(cid) {
                if ($(event.target).parent().get(0).checkValidity() === true)
                    window.location = "order.jsp?customerId=" + cid;
            }
        </script>
    </body>
</html>

