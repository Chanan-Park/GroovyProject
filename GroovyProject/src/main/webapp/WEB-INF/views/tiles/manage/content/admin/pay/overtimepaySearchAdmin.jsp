<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<% String ctxPath = request.getContextPath(); %>   


<!-- Font Awesome 5 Icons !!이걸써줘야 아이콘웹에서 아이콘 쓸 수 있다!!-->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    
    
<style>
	
	button{
		border: none;
	}

	th {
	font-weight: bold;
	background-color: #e3f2fd; 
	text-align: center;
	}
	
	div > button {
		width: 7%;
		display: inline-block;
		margin: 1% 0;
	}
	
	input[type="date"] {
	cursor: pointer;
	}
	
	input {
		border: none;
	}
	
	button#btn_excel {
		background-color: #cccccc;
	}
	
	button#btn_pay {
		background-color: #086BDE;
		color: white;
	}

	 /* === 모달 CSS === */
	
    .modal-dialog.modals-fullsize_viewDetailinfo {
	    width: 800px;
	    min-height: 10%;
    }
    
    .modals-fullsize {
    	width:800px;
    	min-height: 1000px;
    }
    
    
    .modal-content.modals-fullsize {
	    height: auto;
	    min-height:50%;
	    border-radius: 0;
    }
    
    #go_payDetail{
	    position: fixed;
	    left: -10%;
		top: 10%;
 	}
</style>

<script>

	$(document).ready(function(){
		
		$('.subadmenu').show();
		$('.eachmenu5').show();
		
		$("div#detailPay").hide();
		
		 $("tr#list> td").click(function(){
			 
			 $("div#detailPay").show();
			 
			 
		 }); // end of  $("tbody.list > tr> td").click(function(){---------------------
		
		
	}); // end of $(document).ready(function(){
		
		
	// >>> Function Declartion<<<	
	// >>> 해당 회원을 클릭하면<<< 
	function go_detailInfo(){
		
	
	
	} // end of function go_detailInfo(){
		

</script>






<form name="frm_celebSearch">

<div style='margin: 1% 0 5% 1%'>
	<h4>급여관리</h4>
</div>
	
	<div style="margin-left: 73%;">
		<span>
			<select style="width: 110px; border:solid 1px #cccccc; border: none;" name="searchType">
				<option value="overtimepay">추가근무수당</option>
				<option value="annualpay">연차근무수당</option>
			</select> 
		</span>
			<input type="text"style="width: 120px; border:solid 1px #cccccc;" name="searchWord"/>
			<button class="btn btn-sm" style="background-color: #086BDE; color:white; width: 60px;"><i class="fas fa-search"></i>검색</button>
	</div>
	
	<div class='m-4' style="margin: 7% 0% 5% 0%; width: 95%;">
		<h5 >기본외수당 목록</h5>
		<table class="table table-bordered table-sm ">
			<thead>
				<tr>
					<th>No</th>
					<th>지급기준일</th>
					<th>부문</th>
					<th>부서</th>
					<th>직급</th>
					<th>사원명</th>
					<th>초과근무수당</th>
					<th>연차수당</th>
					<th>총지급액</th>
				</tr>
			</thead>
			<tbody  onclick="go_detailInfo">
				<c:forEach  var="emp" items="${requestScope.payList}" varStatus="status">
					<tr class="text-center border" id="list">
						<td><c:out value="${status.count}" /></td>
						<td>${emp.paymentdate}</td>
						<td>${emp.bumun}</td>
						<td>${emp.department}</td>
						<td>${emp.position}</td>
						<td>${emp.name}</td>
						<td><fmt:formatNumber value="${emp.overtimepay}" pattern="#,###" /></td>
						<td><fmt:formatNumber value="${emp.annualpay}" pattern="#,###" /></td>
						<td><fmt:formatNumber value="${emp.overpay}" pattern="#,###" /></td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</form>
<!-- 	
	<div class="mt-5" id="detailPay">
		<h5 class='mx-4'>기본외수당 상세목록</h5>
		<table class="table table-bordered table-sm mx-4 ">
			<thead>
				<tr>
				<th>NO</th>
				<th>지급기준일</th>
				<th>수당구분</th>
				<th>지급액</th>
				</tr>
			</thead>
			<tbody>
				<tr class="text-center border" >
					<td>1</td>
					<td>2022.11.12</td>
					<td><input type="text" name=""/>초과근무수당</td>
					<td><input type="text" name=""/>20,000</td>
				</tr>
			</tbody>
			
		</table>
		
	</div>
</div>

 -->
