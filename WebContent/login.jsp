<!DOCTYPE html>
<html>
	<head>
		<title>Login Screen</title>
		<%@ include file="global-jsp/header.jsp" %>
	</head>
	<body>
		<div class="container d-flex justify-content-center" style="margin:0 auto;text-align:center;display:inline">
			<div>
				<h3>Please Login to System</h3>

				<%
				// Print prior error login message if present
				if (session.getAttribute("loginMessage") != null)
					out.println("<p>"+session.getAttribute("loginMessage").toString()+"</p>");
				%>

				<br>
				<form name="MyForm" method=post action="validateLogin.jsp">
					<table style="display:inline">
					<tr>
						<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Username:</font></div></td>
						<td><input type="text" name="username"  size=10 maxlength=20></td>
					</tr>
					<tr>
						<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Password:</font></div></td>
						<td><input type="password" name="password" size=10 maxlength="20"></td>
					</tr>
					</table>
					<br/>
					<input class="submit" type="submit" name="Submit2" value="Log In">
				</form>

					<a href="registerUser.jsp">Don't have an account?</a>
			</div>
		</div>
		<%@ include file="global-jsp/footer.jsp" %>
	</body>
</html>

