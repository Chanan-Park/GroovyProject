<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
 <% String ctxPath = request.getContextPath(); %>
 
 <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
 <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
 <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>

	button {
		border: none;
		background-color: white;
	}
	
	input {
		border: none;
		background-color: white;
	}
	
	div#situation1 {
		background-color:#086BDE;
		width: 50px;
		border: none;
		color: white;
	}
	
	
	div#situation2{
		background-color: #F9F9F9;
		width: 50px;
		border: none
	}

	div#input_unjoin {
		background-color:#E3F2FD; 
		width: 70px; 
		border: none;
	}
	
	div#input_join {
		background-color:#F9F9F9;
		width: 70px; 
		border: none;"
	}
	

 

</style>

<script type="text/javascript">


	$(document).ready(function(){
		
		// === 설문지제목을 누르면 === //
		$("input#surtitle").click(function(){
			const surno = $("input#surno").val();
			go_survey(surno);
		
			
		}); // end of $("input#surtitle").click(function(){ -------------------------
		
		/* 
		const notjoin = $("input[name='surjoindate']").length();
		console.log(notjoin); */
			
		var notsurvey = $("input[name='surjoindate']").length;
		$("#noCnt").html("("+ length+")").css("background-color","yellow");

		
		// 제목을 누르면
		$("a#nosurtitle").click(function(){
			swal("설문기간이 아닙니다.");
		}); // end of $("a#nosurtitle").click(function(){
			
			
			
		
	}); // end of document.ready(function(){----------------------------

<%-- 
	//>>> 설문지 제목버튼을 누르면 <<<
	function go_survey(surno) {
		
		const frm = document.frm_surveyList;
		frm.action="<%=ctxPath%>/survey/surveyJoin.on";
		frm.method="GET";
		frm.submit();
	} --%>

</script>


<div id="div_surveyList">
<div style='margin: 1% 0 5% 1%'>
	<h4>설문리스트</h4>
</div>
	
	<!-- 제목을 클릭하면 정보를 넘길 수 있도록 hidden으로 값 받아오기 -->
	
	<div align="right">
		<span>
			<select name="searchType" style="width: 100px; border:none;">
				<option value="1">설문제목</option>
				<option value="2">설문기간</option>
			</select>
			<input type="text" name="searchWord" style="width: 120px; border:solid 1px #cccccc;" />
			<button class="btn btn-sm" style="background-color: #086BDE; color:white; width: 60px;font-size:14px;"><i class="fas fa-search"></i>검색</button>
		</span>
	</div>

	<div class="m-4">
		<div  style='margin: 1% 0 3% 1%'>
			<span style="color:#086BDE"><input type="button" name="" value="전체  (${requestScope.listCnt})"/></span>
			<%-- <span><c:if test="${empty survey.surjoindate}">
					<input type="button" onclick="go_NotsurveyList()" value="미참여"/><fn:length(surjoindate)></fn:length()>
					</c:if>
			<span id="noCnt"></span> </span></c:if>  value="${empty requestScope.surjoindate}"
			<span><input type="button"onclick="go_OksurveyList()">참여 (2) &nbsp;</button></span> --%>
		</div>
		
		<div class="table table-sm" style='margin: 1% 0 3% 1%' >
			<table style="width: 100%;">
			  <colgroup align="center">
			  	<col width=10%>
	            <col width=10%>
	            <col width=35%>
	            <col width=25%>
	            <col width=10%>
	            <col width=10%>
	        </colgroup>
	        
				<thead align="center">
					<th>NO</th>
					<th>상태</th>
					<th>설문제목</th>
					<th>설문기간</th>
					<th>참여여부</th>
					<th>설문제출일</th>
				</thead>
				
				<%-- 현재시각을 알아오는 JSTL --%>
				<jsp:useBean id="now" class="java.util.Date" />
				<fmt:formatDate value="${now}" pattern="yyyy-MM-dd" var="today" />
				
				<tbody align="center" class="table ">
				<c:forEach var="survey" items="${requestScope.pageCnt}" varStatus="status"> 
					<input type="hidden" name="surend" value="${survey.surend}"/>
					<tr>
						<td>${status.count}
							<input type="hidden" name="surno" id="surno" value="${survey.surno}"/>
						</td>
						<td>
							<!-- 설문조사가 진행중인경우 -->
							<c:if test="${survey.surstart <= survey.surend && survey.surend >= today}">
							<div id="situation1">진행중</div>
							</c:if>
							
							<!-- 설문조사가 종료된경우-->
							<c:if test="${survey.surend < today}">
								<div id="situation2">종료</div>
							</c:if>
						</td>
						<td>
						<c:if test="${survey.surstart <= survey.surend && survey.surend >= today}">
						<a name="surtitle" id="surtitle" href="<%=ctxPath%>/survey/surveyJoin.on?surno=${survey.surno}"  style="color: black;">${survey.surtitle}</a>
								<!-- onclick="go_survey()" -->
								</c:if>
								<c:if test="${survey.surend < today}">
									<a name="surtitle" id="nosurtitle"  style="color: black;cursor: pointer; ">${survey.surtitle}</a>
								</c:if>
						</td>
						<td>${survey.surstart}~${survey.surend}</td>
						
						<!-- 미참여일 경우 설문조사 페이지로 이동 -->
						<td>
							<!-- 미참여 -->
							<c:if test="${empty survey.surjoindate}">
								<div id="input_unjoin">미참여</div>
							</c:if>
							
							<!-- 참여 -->
							<c:if test="${not empty survey.surjoindate}">
								<div id="input_join">참여</div>
							</c:if>
						</td>  
						<td>${survey.surjoindate}</td>
					</tr>
					</c:forEach>
					
				</tbody>
				
			</table>
		</div>
		
		<div>${pagebar}</div>
	</div>
	
</div>


