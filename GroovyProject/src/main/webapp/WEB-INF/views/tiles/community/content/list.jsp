<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<% String ctxPath=request.getContextPath(); %>

<style>
#list {
	font-size: small;
	margin-bottom: 50px !important;
}

#pageList a{
	font-size: small;
	color: black;
}

#pageList .active a{
	color: white;
	background-color: #086BDE;
}

</style>
<script>
</script>


<div style='margin: 1% 0 5% 1%'>
	<h4>팀 문서함</h4>
</div>

<div id='list' class='m-4'>

	<form name="searchFrm">
		<div class="text-right mb-3">
				<%-- 검색 구분 --%>
				<select id="searchType" name="searchType" class="mr-1" style="padding: 3px">
					<option value="draft_no">문서번호</option>
					<option value="draft_type">종류</option>
					<option value="draft_subject">제목</option>
					<option value="draft_emp_name">기안자</option>
				</select>
				<%-- 검색어 입력창 --%>
				<input type="text" style="display: none;" /> 
				<input type="text" id="searchWord" name="searchWord" placeholder="검색어를 입력하세요" />&nbsp;
				<button type="button" style="border: none; background-color: transparent;" onclick="goSearch()">
					<i class="fas fa-search fa-1x"></i>
				</button>
		</div>
	
		<div class="row mb-3">
			<div class='col'>
				<c:if test="${not empty draftList}">
				<button type="button" id="excelButton" onclick="excelDownLoad()"><i class="fas fa-download"></i>&nbsp;목록 다운로드</button>
				</c:if>
			</div>
			<div class='col text-right'>
				<select id="pageSize" name="pageSize" onchange="goSearch()">
					<option value="10">10</option>
					<option value="30">30</option>
					<option value="50">50</option>
				</select> 
				<select id="sortType" name="sortType" onchange="goSearch()">
					<option value="draft_date">기안일</option>
					<option value="approval_date">결재완료일</option>
				</select>
				<select id="sortOrder" name="sortOrder" onchange="goSearch()">
					<option value="desc">최신순</option>
					<option value="asc">오래된순</option>
				</select>
			</div>
		</div>
	</form>
	
	<table class="table" id="teamDraftTable">
		<thead>
			<tr class='row'>
				<th class='col'>결재완료일</th>
				<th class='col'>기안일</th>
				<th class='col'>종류</th>
				<th class='col'>문서번호</th>
				<th class='col col-4'>제목</th>
				<th class='col'>기안자</th>
				<th class='col col-1'>결재상태</th>
			</tr>
		</thead>
		<tbody>
			<c:choose>
                <c:when test="${not empty draftList}">
                    <c:forEach items="${draftList}" var="draft" >
                        <tr class='row'>
							<td class='col'>${fn:substring(draft.approval_date, 0, 10)}</td>
							<td class='col'>${fn:substring(draft.draft_date, 0, 10)}</td>
                            <td class='col'>${draft.draft_type}</td>
                            <td class='col'>${draft.draft_no}</td>
                            <td class='col col-4'>
                            <a href='<%=ctxPath%>/approval/draftDetail.on?draft_no=${draft.draft_no}&fk_draft_type_no=${draft.fk_draft_type_no}'>
                       		<c:if test="${draft.urgent_status == 1}">
							<span class="badge badge-pill badge-danger">긴급</span>
                            </c:if>
                            ${draft.draft_subject}</a></td>
                            <td class='col'>${draft.draft_emp_name}</td>
                            <td class='col col-1'>
                            	<c:if test="${draft.draft_status == '완료'}">
	                            	<span class="badge badge-secondary">${draft.draft_status}</span>
                            	</c:if>
                            	<c:if test="${draft.draft_status == '반려'}">
                            		<span class="badge badge-danger">${draft.draft_status}</span>
                            	</c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan='7' class='text-center'>게시물이 존재하지 않습니다.</td>
                    </tr>
                </c:otherwise>            
            </c:choose>
		</tbody>
	</table>
</div>

<div id="pageList">
	${pagebar}
</div>