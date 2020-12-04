<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>

okay so deafult
<%
    out.print("yo");
    session = request.getSession(true);
    //assume that the url has /validateCustomer.jsp?[all parameters given]
    //could alternatively be stored in session though
    String firstName = request.getParameter("firstName").trim().toLowerCase();
    String lastName = request.getParameter("lastName").trim().toLowerCase();
    String email = request.getParameter("email").trim();
    String phonenum = request.getParameter("phonenum").trim();
    String address = request.getParameter("address").trim().toLowerCase();
    String city = request.getParameter("city").trim().toLowerCase();
    String state = request.getParameter("state").trim().toLowerCase();
    String postalCode = request.getParameter("postalCode").trim().toLowerCase();
    String country = request.getParameter("country").trim().toLowerCase();
    String userid = request.getParameter("userid").trim();
    String password = request.getParameter("password");
        //check if password has whitespace before it gets here
    out.print("oof1");

    try {
        boolean customerIsValid =
                validateCustomerInfo(out, session, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password);
        if(!customerIsValid) {
            out.print("oof");
            //update where this link routes to
            response.sendRedirect("addCustomer.jsp");
            //validateCustomer.jsp?firstName=A&lastName=B&email=opey@gmail.com&phonenum=111-111-1111&address=111+Street&city=citycity&state=astate&postalCode=Y7Y8U8&country=Canada&userid=somespecial&password=test2
        } else {
            out.print("new customer created!");
        }
    } catch (Exception e) {
        out.print(e);
    }

    try {
        getConnection();
        String sql = "INSERT INTO customer " +
                    "(firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) " +
                    "VALUES " +
                    "(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        PreparedStatement pstmt = prepareStatement(sql);
        pstmt.setString(1, firstName);
        pstmt.setString(2, lastName);
        pstmt.setString(3, email);
        pstmt.setString(4, phonenum);
        pstmt.setString(5, address);
        pstmt.setString(6, city);
        pstmt.setString(7, state);
        pstmt.setString(8, postalCode);
        pstmt.setString(9, country);
        pstmt.setString(10, userid);
        pstmt.setString(11, password);

        pstmt.executeUpdate();

    } catch (SQLException e) {
        out.print(e);
    } finally {
        closeConnection();
    }

    //INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password)
        //VALUES ('Arnold', 'Anderson', 'a.anderson@gmail.com', '204-111-2222', 
                //'103 AnyWhere Street', 'Winnipeg', 'MB', 'R3X 45T', 'Canada', 'arnold' , 'test');  
%>

<%!
    boolean validateCustomerInfo(JspWriter out, HttpSession session, String firstName, String lastName, String email,
                            String phonenum, String address, String city, String state, String postalCode, String country,
                            String userid, String password) {
        return true;
        /*boolean validEmail = isValidEmail(email);
        boolean validPhonenum = isValidPhonenum(phonenum);
        boolean uniqueUserId = isUniqueUserid(userid);
        String errMsg = "Invalid parameters for new customer account.";
        boolean result = validEmail && validPhonenum && uniqueUserId;

        if(!result) session.setAttribute("errCreateCustomer", errMsg); else session.removeAttribute("errCreateCustomer");

        return result;*/
    };

    boolean isUniqueUserid(String userid) {
        boolean result = true;
        try {
            getConnection();
            String sql = "SELECT * " +
                        "FROM customer " +
                        "WHERE userid = ?";
            
            PreparedStatement stmt = prepareStatement(sql);
            stmt.setString(1, userid);

            ResultSet rst = stmt.executeQuery();
            if(rst.next()) result = false;
            
        } catch(SQLException e) {
            System.out.println(e);
        } finally {
            closeConnection();
        }

        return result;
    };

    boolean isValidPhonenum(String phonenum) {
        boolean result = true;
        String[] phonenums = phonenum.split("-");
        if(phonenums.length != 3) result = false;
        for(int i = 0; i < phonenums.length; i++) {
            try {
                int temp = Integer.parseInt(phonenums[i]);
            } catch (NumberFormatException e) {
                result = false;
            }
        }
        return result;
    };

    boolean isValidEmail(String email) {
        boolean result = true;
        /*try {
            InternetAddress emailAddr = new InternetAddress(email);
            emailAddr.validate();
        } catch (AddressException ex) {
            result = false;
        }*/
        return result;
    };
%>