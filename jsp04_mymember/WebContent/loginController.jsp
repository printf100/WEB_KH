<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONValue"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.util.List"%>
<%@page import="com.my.DTO.MyMemberDTO"%>
<%@page import="com.my.BIZ.MyMemberBizImpl"%>
<%@page import="com.my.BIZ.MyMemberBiz"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8"); %>

<%
	String command = request.getParameter("command");
	System.out.println("[ " + command + " ]");
	
	MyMemberBiz biz = new MyMemberBizImpl();
	
	// 로그인
	if(command.equals("login")) {
		String ID = request.getParameter("ID");
		String PW = request.getParameter("PW");
		
		MyMemberDTO dto = biz.login(ID, PW);
		
		if(dto != null) {
			// session : 만료되기 전까지 어플리케이션 전체에서 사용 가능
			session.setAttribute("dto", dto);
			
			//setMaxInactiveInterval(second) : 해당 초만큼 활동이 없으면 session을 invalidate한다. (default:30분 / 음수:무제한)
			session.setMaxInactiveInterval(10*60);
			
			if(dto.getMyRole().equals("ADMIN")) {
				response.sendRedirect("adminMain.jsp");
			} else if(dto.getMyRole().equals("USER")) {
				response.sendRedirect("userMain.jsp");
			}
			
		} else {	// 로그인 실패했을 때
%>
			<script type="text/javascript">
				alert("ID와 PW를 다시 한 번 확인해주세요!");
				location.href="index.jsp";
			</script>
<%
		}
	}
	
	// 로그아웃
	else if(command.equals("logout")) {
		session.invalidate();	// 만료
		
		response.sendRedirect("index.jsp");
	}
	
	// 전체 회원정보
	else if(command.equals("selectList")) {
		List<MyMemberDTO> list = biz.selectList();
		request.setAttribute("userList", list);
		
		pageContext.forward("userList.jsp");
	}
	
	// enabled=Y 인 회원정보
	else if(command.equals("selectEnabled")) {
		List<MyMemberDTO> list = biz.selecteEnabled();
		request.setAttribute("enabledUserList", list);
		
		pageContext.forward("userEnabledList.jsp");
	}
	
	// 등급 변경하는 화면으로
	else if(command.equals("updateRoleForm")) {
		int MYNO = Integer.parseInt(request.getParameter("MYNO"));
		
		MyMemberDTO dto = biz.selectOneUser(MYNO);
		request.setAttribute("selectOneUser", dto);
		
		pageContext.forward("updateRole.jsp");
	}
	
	// 등급 변경 완료
	else if(command.equals("updateRoleRes")) {
		
		int MYNO = Integer.parseInt(request.getParameter("MYNO"));
		String MYROLE = request.getParameter("MYROLE");
		
		int res = biz.updateRole(MYNO, MYROLE);
		
		if(res > 0) {
%>
		<script type="text/javascript">
			alert("등급 변경 완료");
			location.href="loginController.jsp?command=selectEnabled";
		</script>
<%
		} else {
%>
		<script type="text/javascript">
			alert("등급 변경 실패");
			location.href="loginController.jsp?command=updateRoleForm&MYNO=" + MYNO;
		</script>
<%
		}
	}
	
	
	
	// 내 정보 조회하기
	else if(command.equals("myInfo")) {
		int MYNO = Integer.parseInt(request.getParameter("MYNO"));
		
		MyMemberDTO dto = biz.selectOneUser(MYNO);
		request.setAttribute("myInfo", dto);
		
		pageContext.forward("userInfo.jsp");
	}
	
	// 내 정보 수정하는 화면으로
	else if(command.equals("updateMyInfoForm")) {
		int MYNO = Integer.parseInt(request.getParameter("MYNO"));
		
		MyMemberDTO dto = biz.selectOneUser(MYNO);
		request.setAttribute("myInfo", dto);
		
		pageContext.forward("userUpdate.jsp");
	}
	
	// 내 정보 수정 완료
	else if(command.equals("updateMyInfoRes")) {
		int MYNO = Integer.parseInt(request.getParameter("MYNO"));
		
		MyMemberDTO dto = new MyMemberDTO();
		dto.setPw(request.getParameter("PW"));
		dto.setName(request.getParameter("NAME"));
		dto.setAddr(request.getParameter("ADDR"));
		dto.setPhone(request.getParameter("PHONE"));
		dto.setEmail(request.getParameter("EMAIL"));
		dto.setMyNo(MYNO);
		
		int res = biz.updateUser(dto);
		
		if(res > 0) {
%>
		<script type="text/javascript">
			alert("내 정보 수정 완료!");
			location.href="loginController.jsp?command=myInfo&MYNO=" + MYNO;
		</script>
<%
		} else {
%>
		<script type="text/javascript">
			alert("내 정보 수정 실패");
			location.href="loginController.jsp?command=updateMyInfoForm&MYNO=" + MYNO;
		</script>
<%
		}
	}
	
	// 탈퇴하기
	else if(command.equals("deleteUser")) {
		int MYNO = Integer.parseInt(request.getParameter("MYNO"));
		
		int res = biz.deleteUser(MYNO);
		
		if(res > 0) {
%>
		<script type="text/javascript">
			alert("탈퇴 완료!");
			location.href="index.jsp";
		</script>
<%
		} else {
%>
		<script type="text/javascript">
			alert("탈퇴 실패");
			location.href="loginController.jsp?command=myInfo&MYNO=" + MYNO;
		</script>
<%
	}
	}
	
	// 회원가입 화면으로
	else if(command.equals("joinForm")) {
		response.sendRedirect("insertUser.jsp");
	}
	
	// 아이디 중복체크 (js)
	else if (command.equals("idChk")) {
		String ID = request.getParameter("ID");
		MyMemberDTO dto = biz.idChk(ID);

		boolean idNotUsed = true; // 존재하지 않음

		if (dto != null) { // 이미 존재하는 계정
			idNotUsed = false;
		}
		
		//response.sendRedirect("idChk.jsp?idNotUsed=" + idNotUsed);
	}

	// 아이디 중복체크 (ajax)
	else if (command.equals("ajaxIdChk")) {
		String ID = request.getParameter("ID");
		MyMemberDTO dto = biz.idChk(ID);

		System.out.println(ID);
		
		JSONObject json = new JSONObject();

		boolean idNotUsed = true;
		if (dto != null) { // 이미 존재하는 계정
			idNotUsed = false;
		}
		
		json.put("idNotUsed", idNotUsed);

		PrintWriter pout = response.getWriter();
		pout.print(json.toString());
		pout.flush();
	}

	// 회원가입 완료
	else if (command.equals("joinRes")) {
		MyMemberDTO dto = new MyMemberDTO();
		dto.setId(request.getParameter("ID"));
		dto.setPw(request.getParameter("PW"));
		dto.setName(request.getParameter("NAME"));
		dto.setAddr(request.getParameter("ADDR"));
		dto.setPhone(request.getParameter("PHONE"));
		dto.setEmail(request.getParameter("EMAIL"));
		dto.setEnabled("Y");
		dto.setMyRole(request.getParameter("MYROLE"));

		int res = biz.insertUser(dto);

		if (res > 0) {
%>
		<script type="text/javascript">
			alert("회원가입 완료!");
			location.href="index.jsp";
		</script>
<%
		} else {
%>
		<script type="text/javascript">
			alert("회원가입 실패");
			location.href="insertUser.jsp";
		</script>
<%
		}
	}
%>