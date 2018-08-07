<%@ page import="redis.clients.jedis.Jedis" %>

<html>
<body>
<h2>Hello World!</h2>

<%
String jedis_host = System.getProperty("REDIS_URI", "localhost");
Jedis jedis = new Jedis(jedis_host);
out.print("Server is running: "+jedis.ping() +" on " + jedis_host + " <br>");

String value = jedis.get("hits");
if (value == null) {
	out.print("Welcome new user!<br>");
	jedis.set("hits", "1");
} else {
	int hits = Integer.parseInt(value);
	hits++;
	out.print("Welcome back - " + hits + " <br>");
	jedis.set("hits", "" + hits);
}

%>

</body>
</html>
