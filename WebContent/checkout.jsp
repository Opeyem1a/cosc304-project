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
        <div class="container mt-5 mb-3">

        <form id="chooseOldOrNewPM" class="form">
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="oldOrNewPM" id="oldOrNewPM1" value="old" checked>
                <label class="form-che  ck-label" for="oldOrNewPM1" style="cursor: pointer;">
                    Use existing payment method
                </label>
            </div>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="oldOrNewPM" id="oldOrNewPM2" value="new">
                <label class="form-check-label" for="oldOrNewPM2" style="cursor: pointer;">
                    Input payment method
                </label>
            </div>
        </form>
        <hr style="background-color: white;">

        <form id="choosePaymentMethodForm" class="form needs-validation" novalidate>
                    <div class="form-group ml-auto">
                        <label class="form-label" for="paymentMethodId">Payment Method</label>
                        <select class="custom-select mr-sm-2" id="paymentMethodId" name="category" required>
                            <option style="color: #c4c4c4;" disabled selected>Select Payment Method...</option>
        <%
        try {
            int customerId = (Integer) session.getAttribute("authenticatedId");
            getConnection();
            String sqlPaymentMethods = "SELECT * " +
                                        "FROM paymentmethod " +
                                        "WHERE customerId = ? ";
            ResultSet rstPaymentMethods = executePreparedQueryWithId(sqlPaymentMethods, customerId);
            while(rstPaymentMethods.next()) {
                String pmNum = rstPaymentMethods.getString("paymentNumber");
                String displayedNumber = "**** **** **** " + pmNum.substring(pmNum.length() - 4);
                displayedNumber = rstPaymentMethods.getString("paymentType") + " " + displayedNumber;
                %>
                   <option value="<%= rstPaymentMethods.getInt("paymentMethodId") %>"><%= displayedNumber %></option>                     
                <%
            }
        %>
                </select>
            </div>
        </form>

        <form id="useNewPaymentMethodForm" class="form needs-validation" style="display: none;" novalidate>
            <div class="form-group ml-auto">
                <label class="form-label" for="paymentMethodId">Payment Type</label>
                <select class="custom-select mr-sm-2" id="paymentMethodId" name="category" required>
                    <option style="color: #c4c4c4;" disabled selected>Select Payment Type...</option>
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
                <input class="form-control p-2" type="text" name="paymentNumber" size="50" pattern="[0-9]{4} [0-9]{4} [0-9]{4} [0-9]{4}" placeholder="1234 5678 9012 3456" required>
            </div>
            <div class="form-group">
                <label class="form-label">Card Expiry Date:</label>
                <input class="form-control p-2" type="text" name="paymentExpiryDate" size="50" pattern="[0-9]{2}/[0-9]{2}" placeholder="00/00" required>
            </div>

            <button class="btn btn-warning mr-auto" type="reset" value="Reset">Reset</button>
        </form>
        <%
            String sqlAddress = "SELECT * " +
                                "FROM customer " +
                                "WHERE customerId = ?";
            ResultSet rstAddress = executePreparedQueryWithId(sqlAddress, customerId);
            if(rstAddress.next()) {
        %>
            <%-- form for address --%>
            <form id="addressForm" class="form needs-validation mt-5" novalidate>
                <div class="form-group">
                    <label for="inputAddress">Address</label>
                    <input type="text" class="form-control" id="inputAddress" maxLength=50 value="<%= rstAddress.getString("address") %>" placeholder="1234 Main St">
                </div>
                <div class="form-group">
                    <label for="inputCountry">Country</label>
                    <input type="text" class="form-control" id="inputCountry" maxLength=40 value="<%= rstAddress.getString("country") %>">
                </div>
                <div class="form-row">
                    <div class="form-group col-md-6">
                        <label for="inputCity">City</label>
                        <input type="text" class="form-control" id="inputCity" maxLength=40 value="<%= rstAddress.getString("city") %>">
                    </div>
                    <div class="form-group col-md-4">
                        <label for="inputState">State</label>
                        <input type="text" class="form-control" id="inputState" maxLength=20 value="<%= rstAddress.getString("state") %>">
                    </div>
                    <div class="form-group col-md-2">
                        <label for="inputZip">Zip</label>
                        <input type="text" class="form-control" id="inputZip" maxLength=20 pattern="[A-Za-z0-9]{3} [A-Za-z0-9]{3}" value="<%= rstAddress.getString("postalCode") %>">
                    </div>
                </div>
    
                <button class="btn btn-warning mr-auto" type="reset" value="Reset">Reset</button>
            </form>
        <%
            }
        %>
        <button id="submitCheckout" class="btn btn-primary mt-3" onClick="onSubmit(<%= customerId %>)" type="submit" value="Submit">Check Out</button>
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
                $("#chooseOldOrNewPM").on("change", function(event) {
                    if($(event.target).val() == "new") {
                        $("#useNewPaymentMethodForm").show();
                        $("#choosePaymentMethodForm").hide();
                    } else {
                        $("#useNewPaymentMethodForm").hide();
                        $("#choosePaymentMethodForm").show();
                    };
                });
            });

            function onSubmit(cid) {
                event.preventDefault();
                console.log("Checking out...");
                
                let address, country, city, state, pc;
                address = $("#inputAddress").val().replaceAll(" ", "+");
                country = $("#inputCountry").val().replaceAll(" ", "+");
                city = $("#inputCity").val().replaceAll(" ", "+");
                state = $("#inputState").val().replaceAll(" ", "+");
                pc = $("#inputZip").val().replaceAll(" ", "+");
                
                let allFormsValid = true;
                $("form:visible").each(function() {
                    if($(this).hasClass("needs-validation")){
                        if($(this).get(0).checkValidity() === true) {
                            $(this).get(0).classList.add('was-validated');
                        } else {
                            event.stopPropagation();
                            allFormsValid = false;
                        }
                    }
                });

                if (allFormsValid)
                    window.location = "order.jsp?customerId="+cid+"&address="+address+"&country="+country+"&city="+city+"&state="+state+"&postalCode="+pc;
                else {
                    let element =  `<p id="invalidFields">Please fill in all required form fields.</p>`
                    if($("#invalidFields").length == 0)
                        $("#submitCheckout").after(element);
                }
            }
        </script>
    </body>
</html>

