<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8"); %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글 작성</title>
</head>
<body>

	<%@ include file="./form/header.jsp" %>

	<h1>MDBOARD :: INSERT</h1>
	
	<form action="boardWriteRes.jsp" method="post">
		<table border="1">
			<tr>
				<th>작성자</th>
				<td><input type="text" name="WRITER">
			</tr>
			<tr>
				<th>제목</th>
				<td><input type="text" name="TITLE">
			</tr>
			<tr>
				<th>내용</th>
				<td><textarea rows="6" cols="60" name="CONTENT"></textarea>
			</tr>
			<tr>
				<td colspan="2">
					<input type="submit" value="작성">
					<input type="button" value="취소">
				</td>
			</tr>
		</table>
	</form>	

	<%@ include file="./form/footer.jsp" %>

</body>
</html>