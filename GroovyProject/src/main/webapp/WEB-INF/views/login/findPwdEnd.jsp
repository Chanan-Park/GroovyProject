<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<% String ctxPath = request.getContextPath(); %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">


<title>Groovy :: The Best Groupware</title>
<!-- Required meta tags -->
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">

<!-- Bootstrap CSS -->
<link rel="stylesheet" type="text/css"
	href="<%=ctxPath%>/resources/bootstrap-4.6.0-dist/css/bootstrap.min.css">

<!-- Font Awesome 5 Icons -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

<!-- Optional JavaScript -->
<script type="text/javascript"
	src="<%=ctxPath%>/resources/js/jquery-3.6.0.min.js"></script>
<script type="text/javascript"
	src="<%=ctxPath%>/resources/bootstrap-4.6.0-dist/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript"
	src="<%=ctxPath%>/resources/smarteditor/js/HuskyEZCreator.js"
	charset="utf-8"></script>

<%--  jquery-ui --%>
<link rel="stylesheet" type="text/css"
	href="<%=ctxPath%>/resources/jquery-ui-1.13.1.custom/jquery-ui.css" />
<script type="text/javascript"
	src="<%=ctxPath%>/resources/jquery-ui-1.13.1.custom/jquery-ui.js"></script>

<%-- ajaxForm --%>
<script type="text/javascript"
	src="<%=ctxPath%>/resources/js/jquery.form.min.js"></script>
	
<style>


	div#container {
	
	}
	
	input {
		width:60%;
		border: solid 1px #d9d9d9;
		margin-left: 2%;
	}
	
	div.error_msg, div#pwdSame{
		font-size: 10px;
		margin: 1% 0 2% 0;
	}
	
	div#section {
		margin: 2% 0 3% 0;
	}
	
	
	#btn_next{
		background-color:  #086BDE; 
		color: white; 
		width: 55px; 
		padding: 1%;
		border-radius: 10%;
		border: none;
	}
	
	
	
	
</style>    
</head>
<body>


<script type="text/javascript">

	$(document).ready(function(){
		
		$(".error_msg").hide();
		$("#pwdSame").hide();
		
		let chk_bool = false;
		let same_bool = false;
	
		$("input#pwd").on("propertychange change keyon paste input", function() {
			
			const pwd = $(this).val();
			$(".chk").css({"color":"red"});
			
			const num = /[0-9]/g;  
			const lower = /[a-z]/g;
			const spe = /[`~!@@#$%^&*|?????????'???";:???/?]/gi;
			
			let size_bool = false;
			let num_bool = false;
			let lower_bool = false;
			let spe_bool = false;
			
			
			if(pwd.length > 7 && pwd.length < 16){
				$("div#size").css({"color":"green"});
				size_bool = true;
			}
			else {
				size_bool = false;
			}
			
			if( num.test(pwd) ){
				$("div#num").css({"color":"green"});
				num_bool = true;
			}
			else {
				num_bool = false;
			}
			
			if( lower.test(pwd) ){
				$("div#lower").css({"color":"green"});
				lower_bool = true;
			}
			else{
				lower_bool = false;
			}
			
			if( spe.test(pwd) ){
				$("div#special").css({"color":"green"});
				spe_bool = true;
			}
			else{
				spe_bool = false;
			}
			
			if(size_bool && num_bool && lower_bool && spe_bool){
				chk_bool = true;
			}
			else{
				chk_bool = false;
			}
			$(".error_msg").show();
			
		}); // end of $("#pwd1").on() ----------------------------------------
	
		
		
		$("#pwdCheck").blur(function(e){
			const pwd = $("input#pwd").val();
			const pwdCheck = $("input#pwdCheck").val();
			
			if(pwd != pwdCheck){ // ????????? ???????????? ?????? ?????? ?????? ??????
				$("#pwdSame").show();
				same_bool = false;
			}
			else{
				$("#pwdSame").hide();
				same_bool = true;
			}
			
			$("#pwdSame").css({"color": "", "font-weight": ""});
			
			func_update();
			
		}); // end of $("#pwd2").on() ----------------------------------------
		

		// ????????? ???????????? ????????? //
		$("input#pwdCheck").keydown(function(e){
			     
			if(e.keyCode == 13) {
				func_update();
			}
		}); // end of $("input[name='pwd2']").keyup(function(e)
				
	}); // end of 
		
	// >>> Function Declartion <<<

	// >>> ???????????? ???????????? ?????? ???????????? <<< 
	function func_update() {
		const frm = document.frm_changePwd
		frm.action = "<%=ctxPath%>/findPwdChange.on";
		frm.method="POST";
		frm.submit();
	}

	

</script>

<div id="myContainer">
<div id="body" align="center" class="flex-content join-content">

<form name="frm_changePwd">
	<div id="container"  class="card card-body" >
		<h3 style="font-weight: bold;" >???????????? ??????</h3>
		<p style="color:#b3b3b3">????????? ??????????????? ??????????????????</p>
		
			<div id="section">
				<input type="hidden" name="cpemail" value="${employee.cpemail}"/>
				<span>???????????? </span><input type="password" name="pwd" id="pwd" required/>
			</div>
	       	<div class="error_msg">
					<div id="notPassed">??????????????? ?????? ????????? ?????? ???????????? ?????????.</div>
		        	<span class="chk" id="size">???</span>&nbsp;?????? 8??? ?????? 15?????? ??????<br>
		        	<span class="chk" id="lower">???</span>&nbsp;?????? 1?????? ????????? ??????<br>
		        	<span class="chk" id="num">???</span>&nbsp;?????? 1?????? ?????? ??????<br>
		        	<span class="chk" id="special">???</span>&nbsp;?????? 1?????? ???????????? ??????
	       	</div>
	       	
	       	<div>
				<span>???????????? ?????? </span><input type="password" id="pwdCheck"required />
			</div>
			<div id="pwdSame" style="color: red;">??????????????? ???????????? ??????????????????.</div>
		<div align="center" class="mt-3">
			<button type="button" id="btn_next" >??????</button>
		</div>
	</div>
</form>	
</div>
</div>

</body>
</html>