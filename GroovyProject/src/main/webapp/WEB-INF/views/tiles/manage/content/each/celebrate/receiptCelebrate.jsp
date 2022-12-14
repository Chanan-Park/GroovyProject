<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<% String ctxPath = request.getContextPath(); %>   
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
	
	button{
		border: none;
		wid
	}

	th {
	font-weight: bold;
	background-color: #e3f2fd; 
	width: 20%;
	text-align: center;
	}
	
	input,select {
		width:80%;
		border: solid 1px #cccccc;
	}
	
	input[type="date"] {
		cursor: pointer;
	}
	
	input[type="date"]::before {
		content: attr(data-placeholder);
		width: 100%;
	}
	
	input[type="date"]:valid::before {
		display: none;
	}
	input[data-placeholder]::before {
		color: red;
	}
	
	#celebmenu1 {
		color: #086BDE;
	}

</style>


<script type="text/javascript">
	
	
	$(document).ready(function(){
		
		 $('.eachmenu1').show();
		 
		 $("button#btn_submit").click(function(){
			 
			const clbtype = $("select#clbtype").val();
		 
			 if(clbtype == ''){
				 alert('gfg');
				 return;
			 }
			 
			 func_submit();
		 });
			 
			
			 
			 
		 
		 
		 
		 
		
	}); // end of $(document).ready(function(){-----------------------

	// >>> 부문선택값에 따라 하위 셀렉트 팀옵션 다르게 하기 <<< // 
	function func_clbtype(value){
		
		var clbpay_1 = ["500000"]; 
		var clbpay_2 = ["200000"]; 
		var clbpay_3 =  ["200000"]; 
		var target = document.getElementById("clbpay");
		
		if(value == "1") {
			var clbpay = clbpay_1;
		}
		else if(value == "2") {
			var clbpay = clbpay_2;
		}
		else if(value == "3") {
			var clbpay = clbpay_3;
		}
		
		target.options.length = 0;

		for (i in clbpay) {
			var opt = document.createElement("option");
			opt.value = clbpay[i];
			opt.innerHTML = clbpay[i];
			target.appendChild(opt);
		}
		
		
	} //function bumunchange(){ -------------------------
		
	function func_submit() {
		 

		
		const frm = document.frm_celebApply
		frm.action = "<%= ctxPath%>/manage/celebrate/receiptCelebrate.on";
		frm.method = "POST";
		frm.submit();
	}
		
		
		

</script>


<form name="frm_celebApply" id="frm_celebApply">
<div style='margin: 1% 0 5% 1%; width: 95%;' >
	<h4>경조비관리 </h4>
</div>

	<div id='list' class='m-4' style="width: 95%;">
	<h5>경조비신청</h5>
	
	<%-- 경조구분만 선택가능. 옵션을 누르면 금액은 자동으로 들어오게 해야함.--%>
	
	<table class="table table-bordered m-4 my-3" >
	<c:if test="${ not empty sessionScope.loginuser }">
		<tr>
			<th>신청번호</th>
			<td><input type="text" id="" name="clbno" placeholder="신청번호는 자동으로 입력됩니다."/></td>
			<th>사원번호</th>
			<td><input type="text" id="fk_empno" name="fk_empno" value="${loginuser.empno}" readonly/></td>
		</tr>
		<tr>
			<th>부서명</th>
			<td><input type="text" id="department" name="department" value="${loginuser.department}" readonly/></td>
			<th>사원명</th>
			<td><input type="text" id="name" name="name" value="${loginuser.name}" readonly/></td>
		</tr>
		<tr>
			<th><span style="color:red;">*</span>경조구분</th>
			<td><select id="clbtype" name="clbtype" onchange="func_clbtype(value)">
				<option value="">=== 종류를 선택해주세요 ===</option>
				<option value="1">명절상여금</option>
				<option value="2">생일상여금</option>
				<option value="3">휴가상여금</option>
				</select>
			</td>
			<th><span style="color:red;">*</span>신청금액</th>
			<td>
				<select type="text" id="clbpay" name="clbpay" readonly >
					<option value=""></option>
				</select>
			</td>
		</tr>
		<tr>
			<th><span style="color:red;">*</span>예금주</th>
			<td><input type="text" id="name" name="name" value="${loginuser.name}" readonly/></td>
			<th>계좌번호</th>
			<td><input type="text" id="account" name="account" value="${loginuser.account}" readonly/></td>
		</tr>
		<tr>
			<th>은행</th>
			<td><input type="text" id="bank" name="bank" value="${loginuser.bank}" readonly/></td>
			<th></th>
			<td></td>
		</tr>
	</c:if>
	</table>
	<div align="right">
		<button style="color: white; background-color:#086BDE" class="btn" id="btn_submit">신청</button> <%-- 상여금을 받을 수 있을때만 저장이 가능하다 --%>
	</div>
	</div>


</form>







