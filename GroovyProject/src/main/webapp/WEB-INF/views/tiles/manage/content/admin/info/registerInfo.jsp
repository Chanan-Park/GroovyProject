<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<% String ctxPath = request.getContextPath(); %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<style>

	div#info_manageInfo {
		padding: 5% 2%;
		width: 95%;
	}

	
	table{
		width: 95%;
		padding: 2%;
		font-size: 12px;
	}

	td {
		width:18%;
	}

	
	th {
		font-weight: bold;
		background-color: #e3f2fd; 
		width: 10%;
		text-align: center;
	}
	
	.t1 {
		width: 7%;
		background-color: #black; 
	}
	
	input {
		border: solid 1px #cccccc;
	}
	
	button.btn_check, button#btn_adrsearch, .btn_search{
		width:50px; 
		font-size:12px;
		display: inline-block;
		border: none;
		background-color:#F9F9F9;
	}
	
	span#birthday > select {
		width:85px;
		font-size: 12px;
		height: 20px;
		border: solid 1px #cccccc;
	}
	
	
	select.select_3{
		width: 165px;
		height: 25px;
		border: solid 1px #cccccc;
	}
	
	.msg_error {
		color: red;
	}
	
	
	 /* === 모달 CSS === */
	
    .modal-dialog.modals-fullsize_go_searchTel {
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

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript">

$("div.error").hide();
let b_flag_emailDuplicate_click = false;
// "이메일중복확인" 을 클릭했는지 클릭을 안했는지 여부를 알아오기 위한 용도.


	$(document).ready(function(){
	

		$('.subadmenu').show();
		 $('.eachmenu3').show();
		 $("div.msg_error").hide();
		 $("div#msg_probation").hide();
		 
		 // === 주민등록번호=== // 
		 $("input#jubun").blur(function(e){
			 
			 const $target = $(e.target);
			 const regExp = /\d{2}([0]\d|[1][0-2])([0][1-9]|[1-2]\d|[3][0-1])[-]*[1-4]\d{6}/g;
				/*	 \d{2} : 맨앞 정수 2자리(생년)는 어떤 정수값이 와도 상관없다.
		
					 ([0]\d|[1][0-2]) : 첫자리가 0인경우는 뒤에 어떤 정수가 와도 괜찮다. ,, 첫자리가 1인경우 뒷자리는 0,1,2만 올수있다. 
		
					  // (01-12 생월을 표현)
		
					 ([0][1-9]|[1-2]\d|[3][0-1]) : 생일은 첫자리가 0이면 뒷자리가 0이될경우 0일이 되기 때문에 0다음에는 1-9만 올 수있다.
		
					 [-]* : 하이픈은 0개 or 1개다.
		
					 [1-4] : 주민번호 뒷자리 첫번째 숫자는 1~4만 갖는다.
		
					 \d{6} : 주민번호 첫자리를 제외한 숫자는 총 6자리다.
				*/
			 const bool = regExp.test( $target.val() );
			
			 if(!bool) {
				 $("div.msg_error").show();
				 $("input#jubun").val().remove();
			 }
			 else {
				 $("div.msg_error").hide();
			 }
			
		 }); //  end of $("input#jubunbirth").bulr((e) => {--------------------
	
	
	
	
	
	
	
	
		 
		// === 생년월일 === //
	        
		    var dt = new Date();
		    var com_year = dt.getFullYear();
		    var year = "";
		    
		    // 년도 뿌려주기
		    $("#year").append("<option value=''>년도</option>");
		    // 올해 기준으로 -50년부터 +1년을 보여준다.
		    for (var i = (com_year - 50); i <= (com_year); i++) {
		      $("#birthyyyy").append("<option value='" + i+ "'>" + i + " 년" + "</option>");
		    }
		    
		    // 월 뿌려주기(1월부터 12월)
		    var month;
		    $("#month").append("<option value=''>월</option>");
		    for (var i = 1; i <= 12; i++) {
		    	
		    	if(i<10){
		    		month += "<option>0"+i+"</option>";
				}
				else{
					month += "<option>"+i+"</option>";
				}
		    } 
			$("#birthmm").html(month);
		    
		    // 일 뿌려주기(1일부터 31일)
		    var day;
		    $("#day").append("<option value=''>일</option>");
		    for (var i = 1; i <= 31; i++) {
		    	if(i<10){
		    		day += "<option>0"+i+"</option>";
				}
				else{
					day += "<option>"+i+"</option>";
				}
		    }
			$("#birthdd").html(day);
		 
		 
		 
		// === 우편번호 찾기를 클릭했을 때 이벤트 처리하기 === //
		 $("button#btn_adrsearch").click(function() {
		 	b_flag_btn_adrsearch_click = true;
		 });
		 
		 // === 우편번호 입력란에 키보드로 입력할 경우 이벤트 처리하기 === //
		 $("input:text[id='postcode']").keyup( function() {
		 	alert("우편번호 입력은 \"우편번호찾기\"를 클릭하여 입력해야 합니다. ");
		 	$(this).val("");
		 });
		 
		 
		 
		 
		 // === 핸드폰 번호 === //
		 $("input#hp2").blur( function(e) {
				
				const $target = $(e.target);
				
				// const regExp = /^[1-9][0-9]{2,3}$/g;
				// 또는
				const regExp = new RegExp( /^[1-9][0-9]{2,3}$/g);
				// 숫자 3자리 또는 4자리만 들어오도록 검사하는 정규표현식 객체 생성
				const bool = regExp.test( $target.val() );
				
				if(!bool) {
					// 국번이 정규표현식에 위배된 경우
					$("table#tblMemberRegister :input").prop("disabled", true);
					$target.prop("disabled", false);
					
					// $target.next().show();
					// 또는
					$target.parent().find("span.error").show();
					
					$target.focus();
					
				}
				else {
					// 국번이 정규표현식에 맞는 경우
					$("table#tblMemberRegister :input").prop("disabled", false);
					
					// $target.next().hide();
					// 또는
					$target.parent().find("span.error").hide();
					
				}
				
			}); // end of $("input#hp2").blur() ----------------- // 아이디가 hp2 인 것은 포커스를 잃어버렸을 경우(blur) 이벤트를 처리해주는 것이다.
			
			
			
			
			// ------------------------------------------------------------------------
			$("input#hp3").blur( function(e) {
				
				const $target = $(e.target);
				
				// const regExp = /^[0-9]{4}$/g;
				// 또는
				const regExp = new RegExp(/^[0-9]{4}$/g);
				// 숫자 3자리 또는 4자리만 들어오도록 검사하는 정규표현식 객체 생성
				const bool = regExp.test( $target.val() );
				
				if(!bool) {
					// 전화번호 마지막 네자리가 정규표현식에 위배된 경우
					$("table#tblMemberRegister :input").prop("disabled", true);
					$target.prop("disabled", false);
					
					// $target.next().show();
					// 또는
					$target.parent().find("span.error").show();
					
					$target.focus();
					
				}
				else {
					// 전화번호 마지막 네자리가 정규표현식에 맞는 경우
					$("table#tblMemberRegister :input").prop("disabled", false);
					
					// $target.next().hide();
					// 또는
					$target.parent().find("span.error").hide();
					
				}
				
				
			}); // end of $("input#hp3").blur() ----------------- // 아이디가 hp3 인 것은 포커스를 잃어버렸을 경우(blur) 이벤트를 처리해주는 것이다.

			
		/*	
		
		// === 회사이메일 확인버튼 === //
		$("button#checkCpEmail").click(function(e){
			
			$("input#cpemail").bulr(function(e){
				const cpemail = $(e.target).val();
				if(cpemail == ""){
					$("div#empnocheckResult").text("이메일을 입력해주세요.").show();
					$("input#cpemail").focus();
				}
				else {
					$("div#empnocheckResult").text("이메일을 입력해주세요.").hide();
				}
			
			func_checkEmail();
		});// $("button#checkCpEmail").click(function(){ ---------------------
			
		*/ 
	
			
		// === 텍스트넣는법  === // 
	/* 	$( "select[name=empstatus]").change(function(){
			var value = $("option:selected").val();
			var inputText = $("input#emppay");
			
			if (value == '계약직') {
				inputText.text('80%');
			}
			
		}); */
			
			
		
			
		// === 저장버튼을 누르면 === //
		$("button#btn_submit").click(function(){
			 
			btn_register();
		});
		
	
		
	}); // end of $(document).ready(function(){}-----------------------------------------




//>>> Function Declaration <<< //

	
    // >>> select box  생년월일 표시 <<<
	  function setDateBox() {
	    
	  }
	// === 생년월일 끝 === 
		
	// >>> 주소 <<<	
	function openDaumPOST(){
	    new daum.Postcode({
	        oncomplete: function(data) {
	            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
	
	            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
	            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
	            let addr = ''; // 주소 변수
	            let extraAddr = ''; // 참고항목 변수
	
	            //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
	            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
	                addr = data.roadAddress;
	            } else { // 사용자가 지번 주소를 선택했을 경우(J)
	                addr = data.jibunAddress;
	            }
	
	            // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
	            if(data.userSelectedType === 'R'){
	                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
	                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
	                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
	                    extraAddr += data.bname;
	                }
	                // 건물명이 있고, 공동주택일 경우 추가한다.
	                if(data.buildingName !== '' && data.apartment === 'Y'){
	                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                }
	                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
	                if(extraAddr !== ''){
	                    extraAddr = ' (' + extraAddr + ')';
	                }
	                // 조합된 참고항목을 해당 필드에 넣는다.
	                document.getElementById("extraaddress").value = extraAddr;
	            
	            } else {
	                document.getElementById("extraaddress").value = '';
	            }
	
	            // 우편번호와 주소 정보를 해당 필드에 넣는다.
	            document.getElementById('postcode').value = data.zonecode;
	            document.getElementById("address").value = addr;
	            // 커서를 상세주소 필드로 이동한다.
	            document.getElementById("detailaddress").focus();
	        }
	    }).open();
	} // end of openDaumPOST() -------------------------------
	
	
	
	// >>> 부문선택값에 따라 하위 셀렉트 팀옵션 다르게 하기 <<< // 
	function bumunchange(value){
		
		var dept_1 = ["인사총무팀","재경팀"]; 
		var dept_2 = ["개발팀","기획팀"]; 
		var dept_3 = ["영업팀","마케팅팀"]; 
		var target = document.getElementById("department");
		
		if(value == "경영지원부문") {
			var dept = dept_1;
		}
		else if(value == "IT사업부문") {
			var dept = dept_2;
		}
		else if(value == "마케팅영업부문") {
			var dept = dept_3;
		}
		
		target.options.length = 0;

		for (i in dept) {
			var opt = document.createElement("option");
			opt.value = dept[i];
			opt.innerHTML = dept[i];
			target.appendChild(opt);
		}
	
	} //function bumunchange(){ -------------------------
		

		function go_search() {
			$('#go_searchTel').modal({backdrop: 'static'});
		}
	
	
	
	// >>> 회사이메일 확인버튼 누르면 (ajax)<<<
	function func_checkEmail(cpemail) {
	 
		let b_flag_emailDuplicate_click = true;
		
		const $cpemail = $("input#cpemail").val();
		
		if($cpemail == "") {
			$("div#cpemailCheck").text("이메일을 입력해주세요").show();
			$("input#cpemail").focus();
			
		}
		else {
			$("div#cpemailCheck").text("이메일을 입력해주세요").hide();
		
		$.ajax({
		  url:"<%= request.getContextPath()%>/manage/admin/checkCpEmail.on",
		  data:{"cpemail":$("input#cpemail").val()},
		  type:"POST",
		  dataType:"JSON",
		  success:function(json){
			  
			  if(json.n == 1) {
				$("div#empnocheckResult").html($("input#cpemail").val()+" 은(는) 이미 사용중인 사원이메일 입니다.").css("color","red");
	           	$("input#cpemail").val("");
			  }
			  else {
				  $("div#empnocheckResult").html($("input#cpemail").val()+" 은(는) 사용가능한  사원이메일 입니다.").css("color","##086BDE");
			  }
		  },
		  error: function(request, status, error){
			  alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		  }
	  });
		
		}
	} // end of function btn_register() { -----------------------------
	
	

	// >>> 등록버튼을 누르면 <<<
	function btn_register() {
		
		<%--  
		  // 보내야할 데이터를 선정하는 또 다른 방법
		  // jQuery에서 사용하는 것으로써,
		  // form태그의 선택자.serialize(); 을 해주면 form 태그내의 모든 값들을 name값을 키값으로 만들어서 보내준다. 
		  const queryString = $("form[name='addWriteFrm']").serialize();
		--%>
		
		const queryString = $("form[name='frm_manageInfo']").serialize();
		
		$.ajax({
			url:"<%=ctxPath%>/manage/admin/registerEnd.on",
			data:queryString, 
			type:"POST",
			dataType:"text",
		  	success:function(json){
		  		
		  		if(json.n == 1) {
		  			alert("사원정보 등록성공");
		  			location.href="redirect:/manage/admin/registerInfo.on";
		  		}
		  		else{
		  			alert("사원정보 등록실패");
		  			location.href="javascript:history.back()";
		  			console.log(json);
		  		} 
		  	},
			 error: function(request, status, error){
				  alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			  }
		});
	} // end of function btn_register() { ---------------------------
	
	// >>> 삭제버튼을 누르면<<<
	function func_delete() {
		$("input").val("");
		$("select").val("");
	}
	
</script>

<form name="frm_manageInfo">
<div style='margin: 1% 0 5% 1%'>
	<h4>사원정보</h4>
</div>

	<div class='mx-4'>
	<h5>사원등록</h5>
	
	<table class="m-4 mb-3 table table-bordered table-sm" id="first_table" style="width: 95%;">
		<tr>
			<td rowspan='4' style="width: 2%;"><i class="fas fa-user-tie fa-10x mt-2 ml-2" ></i><input type="hidden" name="empimg"/></td>
			<th class="t1"><span class="alert_required" style="color: red;">*</span>사원번호</th>
			<td>	
				<input type="text" id="empno" name="empno" required placeholder="자동입력됩니다." readonly/>
			</td>
			
			<th class="t1"><span class="alert_required" style="color: red;">*</span>성명</th>
			<td><input type="text" id="name" name="name" required /></td>
		</tr>
		<tr >
			<th class="t1"><span class="alert_required" style="color: red;">*</span>주민등록번호</th>
				<td>
				
					<span>
						<input type="text" id="jubun" name="jubun"required style="display: inline;" />
					</span>
					
					 <!-- 
					 <span>
						<input type="text" id="jubun1" name="jubun1"required style="display: inline;" /> - <input type="text" id="jubun2" name="jubun2"required style="display: inline;" /> 
					</span>
					  -->
					 
					<div class="msg_error">형식에 올바르지 않습니다.</div>
				</td>
			<th class="t1">성별</th>
			 <td style="text-align: left;">
	            <input type="radio" id="male" name="gender" value="1" required/><label for="male" style="margin-left: 2%;">남자</label>
	            <input type="radio" id="female" name="gender" value="2" style="margin-left: 10%;" required /><label for="female" style="margin-left: 2%;">여자</label>
	         </td>
		</tr>
		<tr>
			<th class="t1"><span class="alert_required" style="color: red;">*</span>생년월일</th>
			<td>
				<span id="birthday" class="required" >
				    	<select name="birthyyyy" id="birthyyyy" title="년도" class=" requiredInfo" required ></select>
						<select name="birthmm" id="birthmm" title="월" class=" requiredInfo"  required></select>
						<select name="birthdd" id="birthdd" title="일" class=" requiredInfo" required></select>
				</span>
			</td>
			<th></th>
			<td></td>
		</tr>
		<tr>
			<th class="t1"><span class="alert_required" style="color: red;">*</span>자택주소</th>
			<td colspan="3">
			<span>
				<input type="text" id="postcode" name="postcode"required placeholder="우편번호" style="display: inline-block;"/>
				<input type="text" id="address" name="address" class="input_style" required placeholder="예)00동, 00로" readonly/>
				<input type="text" id="detailaddress" name="detailaddress" class="input_style"  placeholder="상세주소" style="display: inline-block;  width: 190px;"/>
				<input type="text" id="extraaddress" name="extraaddress" required placeholder="참고항목" style="display: inline-block;  width: 190px;  margin: 10px 0 10px 8px;"readonly/>
				<button type="button" id="btn_adrsearch" onclick="openDaumPOST();" class="btn btn-sm ml-2">추가</button>
			</span>
			</td>
		</tr>

	</table>
	
	<table  class="m-4 mb-3 table table-bordered" style="width: 95%;">
		<tr>
			<th><span class="alert_required"style="color: red;">*</span>내선번호</th>
			<td>
				<input type="text" id="depttel" class="required" name="depttel" required/>
				<!-- <button class="btn btn-sm ml-5 btn_check" onclick="go_search" data-toggle="modal" data-target="#go_searchTel"><i class="fas fa-search"></i>찾기</button> -->
			</td>
			<th><span class="alert_required" style="color: red;">*</span>핸드폰번호</th>
	         <td style="text-align: left;" id="mobile">
	             <input type="text" id="hp1" name="hp1" size="6" maxlength="3" value="010" class="requiredInfo" required />&nbsp;-&nbsp;
	             <input type="text" id="hp2" name="hp2" size="6" maxlength="4" class="requiredInfo" required/>&nbsp;-&nbsp;
	             <input type="text" id="hp3" name="hp3" size="6" maxlength="4" class="requiredInfo" required/>
	         </td>

		</tr>
		<tr>
			<th><span class="alert_required" style="color: red;">*</span>회사이메일</th>
			<td>
				<input type="email" id="cpemail" class="required" name="cpemail" required />
				<button type="button" class="btn btn-sm ml-5 btn_check" id="checkCpEmail" onclick="func_checkEmail()">확인</button>
				<div id="cpemailCheck"></div>
				<div id="empnocheckResult"></div>
				
				
			</td>
			<th>외부이메일</th>
			<td><input type="email" id="pvemail" readonly name="pvemail"/></td>

		</tr>
	</table>
	
	<table  class=" m-4 mb-3 table table-bordered" style="width: 95%;">
		<tr>
			<th><span class="alert_required" style="color: red;">*</span>부문</th>
			<td>
				<select name="bumun" class="select_3" required onchange="bumunchange(value)">
					<option value="">부문을 선택해주세요</option>
					<option value="경영지원부문">경영지원부문</option>
					<option value="IT사업부문">IT사업부문</option>
					<option value="마케팅영업부문">마케팅영업부문</option>
				</select>
			</td>
			<th><span class="alert_required required" style="color: red;">*</span>부서</th>
			<td>
				<select name="department" id="department" class="select_3" required  >
						<option value="">부서를 선택해주세요</option>
				</select>
			</td>
			
		</tr>
		<tr>
			<th><span class="alert_required" style="color: red;">*</span>직급</th>
			<td>
				<select name="position" class="select_3"  required >
					<option value="">직급을 선택해주세요</option>
					<option value="부문장">부문장</option>
					<option value="팀장">팀장</option>
					<option value="책임">책임</option>
					<option value="선임">선임</option>
				</select>
			</td>
			<th><span class="alert_required" style="color: red;">*</span>급여계약기준</th>
			<td><select name="empstauts" class="select_3" required>
					<option value="">계약기준을 선택해주세요</option>
					<option value="1">정규직</option>
					<option value="2">계약직</option>
				</select>
			</td>
		</tr>
		<tr>
			<th><span class="alert_required" style="color: red;">*</span>은행</th>
			<td>
				<input type="text" class="bank" name="bank" required />
			</td>
			<th><span class="alert_required" style="color: red;">*</span>계좌</th>
			<td><input type="text" name="account" required style="width: 165px;" /></td>
		</tr>
		<tr>
			<th><span class="alert_required" style="color: red;">*</span>연봉</th>
			<td>
				<input type="text" id="salary" class="required" name="salary"/>
			</td>
			<th>입사일자</th>
			<td>
				<input type="text" id="joindate" class="required" name="joindate" readonly placeholder="자동입력 됩니다."/>
				
				<input type="hidden" name="annualcnt" />
			<!-- 	<input type="hidden" name="fk_position_no" />
				<input type="hidden" name="fk_bumun_no" />
				<input type="hidden" name="fk_department_no" /> -->
			</td>
		</tr>
			
	</table>
	
	<%-- 정보수정 페이지에서 보이는 버튼 --%>
	<div align="right" style="margin: 3% 0; width: 95%;">
		<button id="btn_update" style="background-color:#F9F9F9; border: none; width: 80px;" onclick="func_delete()">삭제</button>
		<button style="color: white; background-color:#086BDE; border: none; width: 80px;" id="btn_submit">저장</button>
	</div>
</div>
</form>


