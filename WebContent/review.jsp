<%@ page import="java.util.HashMap" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>

<html>
    <head>
        <title>R*mone’s Black Market Course Resources - Review Product</title>
		<%@ include file="global-jsp/header.jsp" %>
    </head>
    <body>
        <%
            session = request.getSession(true);
            String product = request.getParameter("productId");
            int productId = 0;
            try {
                productId = Integer.parseInt(product);
            } catch (NumberFormatException e) {
                out.print(e);
            }
        %>

        <div id="addReviewForm" class="container review-table my-5">
            <form class="form needs-validation" novalidate>
                <div class="form-group">
                    <label class="mr-sm-2" for="selectReviewRating">Rating</label>
                    <select class="custom-select mr-sm-2" id="selectReviewRating" required>
                        <option style="color: #c4c4c4;" disabled selected>Choose...</option>
                        <option value="5">😁 5 - Amazing!</option>
                        <option value="4">😊 4 - Great!</option>
                        <option value="3">🙂 3 - Satisfactory</option>
                        <option value="2">😕 2 - Poor</option>
                        <option value="1">🙁 1 - Terrible</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="mr-sm-2">Comment</label>
                    <textarea class="form-control" placeholder="What did you think of the product?" rows=10 maxlength=1000 required></textarea>
                </div>
                <button type="submit" id="submitAddReviewForm" class="btn btn-primary" onClick="submitReview(<%= productId %>)">Add Review</button>
            </form>
        </div>

        <%@ include file="global-jsp/footer.jsp" %>
        <script>
            $(function(){
                $("#submitAddReviewForm").on("click", function(event) {
                    event.preventDefault();
                    if ($(event.target).parent().get(0).checkValidity() === false) {
                        event.stopPropagation();
                    };
                    $(event.target).parent().get(0).classList.add('was-validated');
                })
            });

            function submitReview(pid) {
                let rating = $("#addReviewForm").find("option:selected").val();
                let comment = $("#addReviewForm").find("textarea").val().replaceAll(" ", "+");
                if ($(event.target).parent().get(0).checkValidity() === true)
                    window.location = "addReview.jsp?productId="+pid+"&rating="+rating+"&comment="+comment;
            }
        </script>
    </body> 
</html>