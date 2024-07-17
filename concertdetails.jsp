<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%
HttpSession httpSession = request.getSession(false);
if (httpSession == null || httpSession.getAttribute("user") == null) {
    response.sendRedirect("login.jsp");
    return;
}

String concertId = request.getParameter("concert_id");
if (concertId == null || concertId.isEmpty()) {
    response.sendRedirect("userwelcome.jsp");
    return;
}

// Database connection parameters
String url = "jdbc:mysql://192.168.18.245:3306/javadb_168";
String username = "javadb_168";
String password = "Sp3cJa5A2k24";
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
String name = "";
double ticketPrice = 0;
String specification = "";
String imageUrl = "";
String concert_date="";
String concert_time="";
String location="";




try {
    // Load the JDBC driver
    Class.forName("com.mysql.jdbc.Driver");

    // Establish the connection
    conn = DriverManager.getConnection(url, username, password);

    // Create a prepared statement
    String sql = "SELECT * FROM concerts WHERE concert_id = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, Integer.parseInt(concertId));

    // Execute the query
    rs = pstmt.executeQuery();

    // Check if a concert is found
    if (rs.next()) {
        name = rs.getString("concert_name");
        ticketPrice = rs.getDouble("ticket_price");
        specification = rs.getString("spec");
        imageUrl = rs.getString("image_url");
        concert_time=rs.getString("concert_time");
        concert_date=rs.getString("concert_date");
        location=rs.getString("concert_time");


    } else {
        response.sendRedirect("userwelcome.jsp");
        return;
    }
} catch (Exception e) {
    e.printStackTrace();
    response.sendRedirect("error.jsp");
    return;
} finally {
    // Close the resources
    if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
    if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
    if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
}
%>
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<title>Concert Details - Festavalive</title>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
.card-img-container {
    display: flex;
    justify-content: center;
    height: 500px;
    overflow: hidden;
}

.card-img-container img {
    max-width: 100%;
    max-height: 100%;
    object-fit: cover;
}
</style>
</head>
<body class="p-3 m-0 border-0 bd-example" style="text-align: center;">

<nav class="navbar navbar-expand-lg bg-body-tertiary">
    <div class="container-fluid">
        <a class="navbar-brand" href="userwelcome.jsp">Festavalive</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNavDropdown">
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link active" aria-current="page" href="#">Edit Profile</a></li>
                <li class="nav-item"><a class="nav-link" href="#">Your Orders</a></li>
                <li class="nav-item"><a class="nav-link" href="#">Payment</a></li>
                <li class="nav-item dropdown"><a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">Menu</a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="#">Our Products</a></li>
                        <li><a class="dropdown-item" href="#">WishList</a></li>
                        <li><a class="dropdown-item" href="#">Cancel Order</a></li>
                    </ul></li>
            </ul>
        </div>
        <li class="nav-item"><a class="nav-link" href="logout.jsp">Logout</a></li>
    </div>
</nav>

<div class="" style="padding-top: 50px;">
    <div class="card product-card">
        <div class="card-img-container">
            <img alt="<%= name %>" src="<%= imageUrl %>">
        </div>
        <div class="card-body">
            <h5 class="card-title"><%= name %></h5>
            <p class="card-text">
                            <strong>Date:</strong> <%= concert_date %><br>
                                                        <strong>Time:</strong> <%= concert_time %><br>
                                                        <strong>Location:</strong> <%= location %><br>
                            
            
                <strong>Ticket price:</strong> <%= ticketPrice %><br>
               <%= specification %><br>
            </p>
            <div class="d-flex justify-content-between">
                <form action="addToCart.jsp" method="post" style="display: inline;">
                    <input type="hidden" name="concertId" value="<%= concertId %>">
                    <button type="submit" class="btn btn-primary">Add to Cart</button>
                </form>
                <form action="buyNow.jsp" method="post" style="display: inline;">
                    <input type="hidden" name="concertId" value="<%= concertId %>">
                    <button type="submit" class="btn btn-success">Buy Now</button>
                </form>
            </div>
        </div>
    </div>
</div>

</body>
</html>
