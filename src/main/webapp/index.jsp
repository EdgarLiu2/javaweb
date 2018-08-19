<%@ page import="redis.clients.jedis.Jedis" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="org.apache.logging.log4j.LogManager" %>

<html>
<body>
<h2>Hello World! - <%= System.getenv("ENV") %> </h2>

<%

String ip = request.getRemoteAddr();
String actor = (String)request.getParameter("actor");
if (actor ==null) {
	actor ="anonymous";
}
out.print("ip=" + ip + ", actor=" + actor + " <br>");


Logger logger = LogManager.getRootLogger();
String jedis_host = System.getenv("REDIS_HOST");
if (jedis_host == null) {
	jedis_host = System.getProperty("REDIS_HOST", "localhost");
}
String jedis_port = System.getenv("REDIS_PORT");
if (jedis_port == null) {
	jedis_port = System.getProperty("REDIS_PORT", "6379");
}

try {
	Jedis jedis = (Jedis)session.getAttribute("jedis");
	if (jedis == null) {
		jedis = new Jedis(jedis_host, Integer.parseInt(jedis_port));
		session.setAttribute("jedis", jedis);
		out.print("Open Redis server: " + jedis_host + ":" + jedis_port + " <br>");
		logger.info("({}) [{}] - Open Redis server={}", actor, ip, jedis_host + ":" + jedis_port);
	} else {
		out.print("Reuse cached Redis connection: " + jedis_host + ":" + jedis_port + " <br>");
		logger.info("({}) [{}] - Reuse cached Redis connection={}", actor, ip, jedis_host + ":" + jedis_port);
	}

	String value = jedis.get(ip);
	if (value == null) {
		out.print("Welcome new user!<br>");
		jedis.set(ip, "1");
	} else {
		int hits = Integer.parseInt(value);
		hits++;
		out.print("Welcome back " + ip + " - " + hits + " <br>");
		jedis.set(ip, "" + hits);
		// 2018-08-20 00:16:12.035 INFO  [http-nio-8080-exec-5]  - (user@abc.com) [192.168.1.14] - hits=6
		logger.info("({}) [{}] - hits={}", actor, ip, hits);
	}
	
	//jedis.close();
} catch (Exception e) {
	logger.error("({}) [{}] - Can't connect to Redis server", actor, ip);
	logger.error(e.getMessage(), e);
	
	if (session.getAttribute("jedis") != null) {
		session.removeAttribute("jedis");
	}
}

%>

</body>
</html>
