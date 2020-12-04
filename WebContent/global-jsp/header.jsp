<%
	boolean isLoggedIn= session.getAttribute("authenticatedUser") == null ? false : true;
%>

<link rel="stylesheet" href="css/bootstrap.min.css">
<link rel="stylesheet" href="css/styles.css">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <a class="navbar-brand nav-link" href="index.jsp">R*mone's</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavAltMarkup" aria-controls="navbarNavAltMarkup" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>
  <div class="collapse navbar-collapse" id="navbarNavAltMarkup">
    <div class="navbar-nav mr-auto">
      <a class="nav-item nav-link" href="listprod.jsp">Shop</a>
    </div>
    
    <%
      if(isLoggedIn) {
    %>

    <div class="navbar-nav ml-auto">
      <div class="nav-item dropdown">
        <a class="nav-link dropdown-toggle text-info" type="a" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          <%
            out.print("Hello, " + session.getAttribute("authenticatedUser"));
          %>
        </a>
        <div class="dropdown-menu bg-dark" aria-labelledby="dropdownMenuButton">
          <a class="dropdown-item nav-item nav-link pl-3" href="customer.jsp">My Info</a>
          <a class="dropdown-item nav-item nav-link pl-3" href="admin.jsp">Admin</a>
          <a class="dropdown-item nav-item nav-link pl-3" href="listUserOrders.jsp">My Orders</a>
          <a class="dropdown-item nav-item nav-link pl-3" href="logout.jsp">Logout</a>
        </div>
      </div>
      <a class="nav-item nav-link" href="showcart.jsp">Your Cart</a>
    
    <%
      } else {
    %>
        <a class="nav-item nav-link" href="login.jsp">Login</a>
        <a class="nav-item nav-link" href="registerUser.jsp">Register</a>
    <%
      } 
    %>
    <%-- ending right side of navbar --%>
    </div>
  </div>
</nav>
