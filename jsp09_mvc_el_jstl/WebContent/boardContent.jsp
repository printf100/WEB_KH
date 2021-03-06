<%@page import="com.mvc.DTO.MVCBoardDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8"); %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글 내용</title>
</head>

<body>

	<jsp:useBean id="boardContent" class="com.mvc.DTO.MVCBoardDTO" scope="request"></jsp:useBean>
	
	<h1>MVCBOARD :: 글 내용</h1>
		<table border="1">
			<tr>
				<th>작성자</th>
				<td><jsp:getProperty property="writer" name="boardContent"/></td>
			</tr>
			<tr>
				<th>제목</th>
				<td><jsp:getProperty property="title" name="boardContent"/></td>
			</tr>
			<tr>
				<th>내용</th>
				<td>
					<textarea rows="10" cols="60" readonly="readonly"><jsp:getProperty property="content" name="boardContent"/></textarea>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<input type="button" value="수정" onclick="location.href='con.do?command=updateForm&SEQ=<jsp:getProperty property="seq" name="boardContent"/>'">
					<input type="button" value="삭제" onclick="location.href='con.do?command=boardDelete&SEQ=<jsp:getProperty property="seq" name="boardContent"/>'">
					<input type="button" value="목록" onclick="location.href='con.do?command=boardList'">
				</td>
			</tr>
		</table>
</body>
</html>