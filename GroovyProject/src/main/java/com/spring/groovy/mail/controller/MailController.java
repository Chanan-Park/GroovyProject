package com.spring.groovy.mail.controller;


import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.net.URL;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.collections4.map.HashedMap;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.ResourceUtils;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;


import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.spring.groovy.common.Pagination;
import com.spring.chatting.websockethandler.MessageVO;
import com.spring.groovy.common.FileManager;
import com.spring.groovy.mail.model.MailVO;
import com.spring.groovy.mail.model.TagVO;

import com.spring.groovy.mail.service.InterMailService;
import com.spring.groovy.management.model.MemberVO;



@Controller
public class MailController {

	@Autowired   // Type 에 따라 알아서 Bean 을 주입해준다.
	private InterMailService service;
	
	
	
	@Autowired   // Type 에 따라 알아서 Bean 을 주입해준다.
	private FileManagerMail fileManager;
	
	@Autowired
	private FileManager fm;
	
	
	@RequestMapping(value = "/mail/receiveMailBox.on")
	public ModelAndView receiveMailBox(ModelAndView mav, Pagination pagination, HttpServletRequest request) {
		
		 Map<String, String> paraMap2 = new HashMap<>();
		 HttpSession session = request.getSession();

		 MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");

		 String mail_address = loginuser.getCpemail();
		 paraMap2.put("FK_MAIL_ADDRESS", mail_address);
		 List<TagVO> tagList = null;
		 tagList=service.getTagListByMailNo(paraMap2);
		 List<TagVO>tagListSide = service.getTagListSide(mail_address);
		 mav.addObject("tagList", tagList);
		 mav.addObject("tagListSide", tagListSide);
		 mav.setViewName("mail/mailbox/receieve_mailbox.tiles");
		// ==> views/tiles/mail/content/mailBox/receieve_mailbox.jsp
		
		return mav;		
	}
	
	@RequestMapping(value = "/mail/sendMailBox.on")
	public ModelAndView sendMailBox(ModelAndView mav, Pagination pagination, HttpServletRequest request) {

		 Map<String, String> paraMap2 = new HashMap<>();
		 HttpSession session = request.getSession();

		 MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");

		 String mail_address = loginuser.getCpemail();
		 paraMap2.put("FK_MAIL_ADDRESS", mail_address);
		 List<TagVO> tagList = null;
		 tagList=service.getTagListByMailNo(paraMap2);
		 List<TagVO>tagListSide = service.getTagListSide(mail_address);
		 mav.addObject("tagList", tagList);
		 mav.addObject("tagListSide", tagListSide);
		 mav.setViewName("mail/mailbox/send_mailbox.tiles");
		
		return mav;		
		// ==> views/tiles/mail/content/mailBox/send_mailbox.jsp
	}
	@RequestMapping(value = "/mail/importantMailBox.on")
	public ModelAndView importantMailBox(ModelAndView mav, Pagination pagination, HttpServletRequest request) {
		 Map<String, String> paraMap2 = new HashMap<>();
		 HttpSession session = request.getSession();

		 MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");

		 String mail_address = loginuser.getCpemail();
		 paraMap2.put("FK_MAIL_ADDRESS", mail_address);
		 List<TagVO> tagList = null;
		 tagList=service.getTagListByMailNo(paraMap2);
		 List<TagVO>tagListSide = service.getTagListSide(mail_address);
		 mav.addObject("tagList", tagList);
		 mav.addObject("tagListSide", tagListSide);
		 mav.setViewName("mail/mailbox/important_mailbox.tiles");
	
		return mav;	
		// ==> views/tiles/mail/content/mailBox/important_mailbox.jsp
	}
	
	@RequestMapping(value = "/mail/tagMailBox.on")
	public ModelAndView tagMailBox(ModelAndView mav, Pagination pagination, HttpServletRequest request) {
		 Map<String, String> paraMap2 = new HashMap<>();
		 HttpSession session = request.getSession();

		 MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");

		 String mail_address = loginuser.getCpemail();
		 paraMap2.put("FK_MAIL_ADDRESS", mail_address);
		 List<TagVO> tagList = null;
		 tagList=service.getTagListByMailNo(paraMap2);
		 List<TagVO>tagListSide = service.getTagListSide(mail_address);
		 mav.addObject("tagList", tagList);
		 mav.addObject("tagListSide", tagListSide);

		 mav.setViewName("mail/mailbox/tag_mailbox.tiles");
		
		return mav;		
		// ==> views/tiles/mail/content/mailBox/send_mailbox.jsp
	}
	
	@ResponseBody
	@RequestMapping(value = "/mail/getPwd.on", method= {RequestMethod.POST},produces="text/plain;charset=UTF-8")
	public String getPwd(Pagination pagination,HttpServletRequest request) {
		
		JSONObject jsonObj = new JSONObject();
		Map<String, Object> htmlMap = new HashMap<String, Object>();
		
		String mail_no = request.getParameter("mail_no");
		String pwd = service.getPwd(mail_no);
		return pwd;
		
	}
	
	@ResponseBody
	@RequestMapping(value = "/mail/sendMailBoxAjax.on", method= {RequestMethod.GET},produces="text/plain;charset=UTF-8")
	public String sendMailBoxAjax(Pagination pagination,HttpServletRequest request) {
		
		JSONObject jsonObj = new JSONObject();
		Map<String, Object> htmlMap = new HashMap<String, Object>();
		
		// html 맵에 mailList tagList 넣어줌
		htmlMap = mailpaginglist(htmlMap, pagination, "FK_Sender_address",request);

		htmlMap.put("type", "send");
		String html = "";
		String taghtml = "";
		try {
			html = mailPagingToString(htmlMap);
			taghtml = getTagHtml(htmlMap);
		} catch (ParseException e) {
			
			e.printStackTrace();
		}
		
		jsonObj.put("html", html);
		jsonObj.put("taghtml", taghtml);
		jsonObj.put("pagebar", pagination.getPagebar("/groovy/mail/sendMailBox.on"));
		
		return jsonObj.toString();
		
	}
	
	private String getTagHtml(Map<String, Object> htmlMap){
		
		List<TagVO>tagListSide = (List<TagVO>)htmlMap.get("tagListSide");
		StringBuilder htmlSB = new StringBuilder();
		
		for(TagVO tagVO:tagListSide) {
			htmlSB.append("<a class=\"dropdown-item\" href=\"#\" onclick=\"tagCheckSelect('"+tagVO.getTag_color()+"','"+tagVO.getTag_name()+"')\">");
			htmlSB.append("<i class=\"fas fa-tag\" style=\"color:#"+tagVO.getTag_color()+"\" ></i> \r\n" + 
					"     	  	&nbsp"+tagVO.getTag_name()+"\r\n" + 
					"     	    <i style=\"float:right\" class=\"fas fa-minus-circle\" onclick=\"deleteTag('"+tagVO.getTag_color()+"','"+tagVO.getTag_name()+"');\"></i></a>");
		}
		htmlSB.append("<a class=\"dropdown-item\" href=\"#\" data-toggle=\"modal\" data-target=\"#modal_addTag\"><i class=\"fas fa-tag\"></i>&nbsp태그 추가</a>");
		return htmlSB.toString();
	}
	
	@ResponseBody
	@RequestMapping(value = "/mail/importantMailBoxAjax.on", method= {RequestMethod.GET},produces="text/plain;charset=UTF-8")
	public String importantMailBoxAjax(Pagination pagination,HttpServletRequest request) {

		JSONObject jsonObj = new JSONObject();
		Map<String, Object> htmlMap = new HashMap<String, Object>();
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		htmlMap.put("cpemail", loginuser.getCpemail());
		// html 맵에 mailList tagList 넣어줌
		htmlMap = mailpaginglist(htmlMap, pagination, "important",request);
		htmlMap.put("type", "important");
		String html = "";
		String taghtml = "";
		try {
			html = mailPagingToString(htmlMap);
			taghtml = getTagHtml(htmlMap);
		} catch (ParseException e) {
			
			e.printStackTrace();
		}

		jsonObj.put("taghtml", taghtml);
		jsonObj.put("html", html);
		jsonObj.put("pagebar", pagination.getPagebar("/groovy/mail/importantMailBox.on"));
		
		return jsonObj.toString();
		
	}
	
	// 태그게시판
	@ResponseBody
	@RequestMapping(value = "/mail/tagMailBoxAjax.on", method= {RequestMethod.GET},produces="text/plain;charset=UTF-8")
	public String tagMailBoxAjax(Pagination pagination,HttpServletRequest request) {
		JSONObject jsonObj = new JSONObject();
		Map<String, Object> htmlMap = new HashMap<String, Object>();
		HttpSession session = request.getSession();

		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		htmlMap.put("cpemail", loginuser.getCpemail());
		// html 맵에 mailList tagList 넣어줌
		htmlMap = mailpaginglist(htmlMap, pagination, "Tag",request);
		htmlMap.put("type", "important");
		String html = "";
		String taghtml = "";
		try {
			html = mailPagingToString(htmlMap);
			taghtml = getTagHtml(htmlMap);
		} catch (ParseException e) {
			
			e.printStackTrace();
		}
		
		jsonObj.put("html", html);
		jsonObj.put("taghtml", taghtml);
		jsonObj.put("pagebar", pagination.getPagebar("/groovy/mail/tagMailBox.on"));
		
		return jsonObj.toString();
		
	}
	// 받은메일
	@ResponseBody
	@RequestMapping(value = "/mail/receieveMailBoxAjax.on", method= {RequestMethod.GET},produces="text/plain;charset=UTF-8")
	public String receieveMailBoxAjax(Pagination pagination,HttpServletRequest request) {

		JSONObject jsonObj = new JSONObject();
		Map<String, Object> htmlMap = new HashMap<String, Object>();
		
		// html 맵에 mailList tagList 넣어줌
		htmlMap = mailpaginglist(htmlMap, pagination, "FK_Recipient_address",request);
		htmlMap.put("type", "receieve");
		String html = "";
		String taghtml = "";
		try {
			html = mailPagingToString(htmlMap);
			taghtml = getTagHtml(htmlMap);
		} catch (ParseException e) {
			
			e.printStackTrace();
		}
		
		jsonObj.put("html", html);
		jsonObj.put("taghtml", taghtml);
		jsonObj.put("pagebar", pagination.getPagebar("/groovy/mail/receieveMailBox.on"));
		
		return jsonObj.toString();
		
	}
	
	

	



	@SuppressWarnings("unchecked") // 노란줄 안뜨게
	private String mailPagingToString(Map<String, Object> htmlMap) throws ParseException {
		StringBuilder sbHtml = new StringBuilder();

		List<MailVO> mailList = (List<MailVO>)htmlMap.get("mailList");
		List<TagVO> tagList = (List<TagVO>)htmlMap.get("tagList");
		String cpemail = (String)htmlMap.get("cpemail");
		String type = (String)htmlMap.get("type");

		Date now = new Date();
        SimpleDateFormat formatToday= new SimpleDateFormat("yyyy-MM-dd");
        String today = formatToday.format(now);
		
		sbHtml.append("<table class=\"table\">");
		int mailListIdx = 0;
		for(MailVO mailVO :mailList) {
			Date sendTimeDate = mailVO.getSend_time_date();
	        SimpleDateFormat formatSendTimeDD = new SimpleDateFormat("yyyy-MM-dd");
	        String sendTimeDD = formatSendTimeDD.format(sendTimeDate);
			
	        SimpleDateFormat formatSendTimeToday = new SimpleDateFormat("HH:mm:ss");
	        String sendTimeToday = formatSendTimeToday.format(sendTimeDate);
	        
	        SimpleDateFormat formatSendTimeNotToday = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	        String sendTimeNotToday = formatSendTimeNotToday.format(sendTimeDate);
	        
	        
	        
	        
	        
			if(mailListIdx > 0) {
				Date SendTimeBf = mailList.get(mailListIdx-1).getSend_time_date();
				SimpleDateFormat formatSendTimeBefore = new SimpleDateFormat("yyyy-MM-dd");
		        String sendTimeBefore = formatSendTimeBefore.format(SendTimeBf);
		        
		        if(!sendTimeBefore.equals(sendTimeDD) ) {
		        	SimpleDateFormat formatSendTimeDDT = new SimpleDateFormat("yyyy년 MM월dd일");
			        String sendTimeDDT = formatSendTimeDDT.format(sendTimeDate);
			        // 날짜 다르면 경계선
			        sbHtml.append("<tr>\r\n" + 
			        			  "		<td colspan=\"4\" style=\"background-color:#F9F9F9; font-size: small;padding: 0.3rem 0.75rem;\">"+sendTimeDDT+"</td>\r\n" + 
			        		      "</tr>");
		        }
			}
			sbHtml.append("<tr onclick = 'goMail("+mailVO.getMail_no()+","+mailVO.getMail_recipient_no()+")'>"
						+ "<td class=\"mail_list_option\" onclick=\"event.stopPropagation()\">");
			if(type.equalsIgnoreCase("send")) {
				sbHtml.append("<input type=\"checkbox\" id=\"mailCheck\" name=\"mailCheck\" onclick=\"clickCheck()\"     value=\""+mailVO.getMail_no()+"\" style=\"vertical-align:middle\">");
				// 보낸 메일함 기준
				if(mailVO.getSender_important().equals("0")) {
					sbHtml.append("<i class=\"fas fa-flag\" style=\"color:darkgray;\" onclick=\"importantCheck('"+mailVO.getMail_no()+"')\"></i>");
				}
				else if(mailVO.getSender_important().equals("1")){
					sbHtml.append("<i class=\"fas fa-flag\" onclick=\"importantCheck('"+mailVO.getMail_no()+"')\"></i>");
				}
			}
			else if(type.equalsIgnoreCase("receieve")) {
				// 받은 메일함 기준
				sbHtml.append("<input type=\"checkbox\" id=\"mailCheck\" name=\"mailCheck\"  onclick=\"clickCheck()\"     value=\""+mailVO.getMail_recipient_no()+"\" mailNo=\""+mailVO.getMail_no()+"\"style=\"vertical-align:middle\">");
				
				if(mailVO.getRecipient_important().equals("0")) {
					sbHtml.append("<i class=\"fas fa-flag\" style=\"color:darkgray;\" onclick=\"importantCheck('"+mailVO.getMail_recipient_no()+"')\"></i>");
				}
				else if(mailVO.getRecipient_important().equals("1")){
					sbHtml.append("<i class=\"fas fa-flag\" onclick=\"importantCheck('"+mailVO.getMail_recipient_no()+"')\"></i>");
				}
				
				if(mailVO.getRead_check().equals("0")) {
					sbHtml.append("<i class=\"fas fa-envelope\"></i>");
				}
				else if(mailVO.getRead_check().equals("1")){
					sbHtml.append("<i class=\"fas fa-envelope-open\" style=\"color: darkgray;\">");
				}
			}
			
			else if(type.equalsIgnoreCase("important")) {
				if(cpemail.equalsIgnoreCase(mailVO.getfK_sender_address())) {
					sbHtml.append("<input type=\"checkbox\" id=\"mailCheck\" name=\"mailCheck\" onclick=\"clickCheck()\" mailNo=\""+mailVO.getMail_no()+"\"style=\"vertical-align:middle\">");
					sbHtml.append("<i class=\"fas fa-flag\" onclick=\"importantCheck('"+mailVO.getMail_no()+"','mail_no')\"></i>");
					sbHtml.append("<i class=\"fas fa-envelope-open\" style=\"color: darkgray;\">");
				}
				else {
					sbHtml.append("<input type=\"checkbox\" id=\"mailCheck\" name=\"mailCheck\" onclick=\"clickCheck()\" mNo=\""+mailVO.getMail_no()+"\" mailRecipientNo=\""+mailVO.getMail_recipient_no()+"\"style=\"vertical-align:middle\">");
					sbHtml.append("<i class=\"fas fa-flag\" onclick=\"importantCheck('"+mailVO.getMail_recipient_no()+"','mail_recipient_no')\"></i>");
					if(mailVO.getRead_check().equals("0")) {
						sbHtml.append("<i class=\"fas fa-envelope\"></i>");
					}
					else if(mailVO.getRead_check().equals("1")){
						sbHtml.append("<i class=\"fas fa-envelope-open\" style=\"color: darkgray;\">");
					}
				}
				
			}
			
			
			
			
			sbHtml.append("</td>\r\n" + 
					      "<td class = \"mail_list_sender\" >");
			if(type.equalsIgnoreCase("send")) {
				if(mailVO.getfK_recipient_address().length() > 25) {
					sbHtml.append(mailVO.getfK_recipient_address().substring(0,23)+"...");
				}
				else {
					sbHtml.append(mailVO.getfK_recipient_address());
				}
			}
			else if(type.equalsIgnoreCase("receieve") || type.equalsIgnoreCase("important")) {
				sbHtml.append(mailVO.getfK_sender_address());
			}

			
			sbHtml.append("</td>\r\n" + 
						  "<td class = \"mail_list_subject\">");
			for(TagVO tag : tagList) {
				if(tag.getFk_mail_no().equalsIgnoreCase(mailVO.getMail_no())) {
					sbHtml.append("<a href=\"#\"><i class=\"fas fa-tag\" style=\"color:#"+tag.getTag_color()+";\"></i> &nbsp</a>");
				}
			}
			if(type.equalsIgnoreCase("important")) {
				if(cpemail.equalsIgnoreCase(mailVO.getfK_sender_address()) ) {
					if(cpemail.equalsIgnoreCase(mailVO.getfK_recipient_address_individual())) {
						sbHtml.append("[내게쓴메일]");
					}
					else {
						sbHtml.append("[보낸메일함]");
					}
				}
				else {
					sbHtml.append("[받은메일함]");
				}
				
			}
			sbHtml.append(mailVO.getSubject()
					//+"[임시노출 번호"+mailVO.getMail_no() +"]"+"[임시노출 수신메일번호"+mailVO.getMail_recipient_no() +"]"
					    + "</td>");
			
			if(sendTimeDD.equalsIgnoreCase(today)) {
				sbHtml.append("<td class = \"mail_list_time\">오늘 "+sendTimeToday+"</td>");
			}
			else {
				sbHtml.append("<td class = \"mail_list_time\">"+sendTimeNotToday+"</td>");
			}
			sbHtml.append("</tr>");

			mailListIdx++;	
		}
		sbHtml.append("</table>");

		return sbHtml.toString();
	}


	
	
	
	@RequestMapping(value = "/mail/writeMail.on")
	public String writeMail(HttpServletRequest request) {
		
		// 자동완성용 메일리스트 가져오기 
		List<String> mailList = service.getMailList();
		
		// 만약 mailno 받아왔다면 그 메일VO 가져옴
		String mailNo = request.getParameter("mailNo");
		if(mailNo != null && !(mailNo.trim().isEmpty())) {
			Map<String,String> paraMap = new HashMap<>();
			paraMap.put("mailNo", mailNo);
			MailVO mailVO = service.getOneMail(paraMap);
			String type = request.getParameter("type");
			if(type.equalsIgnoreCase("reply")) {
			List<String> replyList = service.getreplyList(mailVO.getfK_sender_address());
			request.setAttribute("replyList", replyList);
			}
			request.setAttribute("type", type);
			request.setAttribute("mailVO", mailVO);
		}
		String cpemail = request.getParameter("cpemail");
		if(cpemail!= null && !(cpemail.trim().isEmpty())) {
			List<String> replyList = service.getreplyList(cpemail);
			request.setAttribute("replyList", replyList);
			
		}
		
	
		
		request.setAttribute("mailList", mailList);
		

		return "mail/mailbox/write_mail.tiles";
		// ==> views/tiles/mail/content/mailBox/receieve_mailbox.jsp
	}
	
	@RequestMapping(value = "/mail/viewMail.on")
	public String viewMail(HttpServletRequest request) {
		String mailNo = request.getParameter("mailNo");
		HttpSession session = request.getSession();

		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		
		Map<String, String> paraMap = new HashedMap<>();
		paraMap.put("mailNo", mailNo);
		paraMap.put("FK_MAIL_ADDRESS", loginuser.getCpemail());
		
		MailVO mailVO = service.getOneMail(paraMap);
		List<TagVO> tagList = null;
		tagList = service.getTagListByMailNo(paraMap);

		request.setAttribute("mailVO", mailVO);
		request.setAttribute("tagList", tagList);
		if(request.getParameter("mailRecipientNo") != null && !! request.getParameter("mailRecipientNo").equals("")) {
			request.setAttribute("mailRecipientNo", request.getParameter("mailRecipientNo"));
		}
		
		return "mail/mailbox/view_mail.tiles";
		// ==> views/tiles/mail/content/mailBox/receieve_mailbox.jsp
	}
	
	@ResponseBody
	@RequestMapping(value = "/mail/getTagListSide.on", method= {RequestMethod.POST},produces="text/plain;charset=UTF-8")
	public String getTagListSide(HttpServletRequest request, HttpServletResponse response) {
		
		HttpSession session = request.getSession();

		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		String mail_address =  loginuser.getCpemail();
		
		List<TagVO> tagList = null;
		tagList = service.getTagListSide(mail_address);
		
		JsonArray jsonArr = new JsonArray();  // []
		
		if(tagList != null) {
			for(TagVO tvo : tagList) {
				JsonObject jsonObj = new JsonObject(); // {}
				jsonObj.addProperty("tag_color", tvo.getTag_color()); 
				jsonObj.addProperty("tag_name", tvo.getTag_name()); 
				jsonArr.add(jsonObj);
			}// end of for---------------------------
		}
				
		return jsonArr.toString();
		
	}

	@RequestMapping(value="/mail/download.on")
	public void requiredLogin_download(HttpServletRequest request, HttpServletResponse response) {
		
		String mailNo = request.getParameter("mailNo");
		int index = Integer.parseInt(request.getParameter("index"));
		// 첨부파일이 있는 글번호 
		
		/*
		     첨부파일이 있는 글번호를 가지고
		   tbl_board 테이블에서 filename 컬럼의 값과 orgfilename 컬럼의 값을 가져와야 한다.
		   filename 컬럼의 값은 202210281630581204316300601400.jpg 와 같은 것이고
		   orgfilename 컬럼의 값은  berkelekle심플라운드01.jpg 와 같은 것이다.    
		*/
		

		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("mailNo", mailNo);

		
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = null;
		// out 은 웹브라우저에 기술하는 대상체라고 생각하자.
				
		try {
		     Integer.parseInt(mailNo);
		     MailVO mailvo = service.getOneMail(paraMap);
		
		     if(mailvo == null || (mailvo != null && mailvo.getFilename() == null ) ) {
		    	 out = response.getWriter();
				 // out 은 웹브라우저에 기술하는 대상체라고 생각하자.
					
				 out.println("<script type='text/javascript'>alert('존재하지 않는 글번호 이거나 첨부파일 없으므로 파일다운로드가 불가합니다.'); history.back();</script>"); 
				 return; // 종료
		     }
		     else {
		    	 // 정상적으로 다운로드를 할 경우 
		    	 String fileName = mailvo.getFilename_array().get(index);

			     String orgFilename = mailvo.getOrgfilename_array().get(index);

 
				 String path = "C:\\Users\\sist\\git\\GroovyProject\\GroovyProject\\src\\main\\webapp\\resources\\files\\mail";

				 
				 // **** file 다운로드 하기 **** //
				 boolean flag = false;  // file 다운로드 성공, 실패를 알려주는 용도
				 flag = fileManager.doFileDownload(fileName, orgFilename, path, response);
				 // file 다운로드 성공시 flag 는 true,
				 // file 다운로드 실패시 flag 는 false 를 가진다.
				 
				 if(!flag) {
					 // 다운로드가 실패할 경우 메시지를 띄워준다.
					 out = response.getWriter();
					 // out 은 웹브라우저에 기술하는 대상체라고 생각하자.
						
					 out.println("<script type='text/javascript'>alert('파일다운로드가 실패되었습니다.'); history.back();</script>"); 
				 }
		     }
		     
		} catch(NumberFormatException | IOException e) {
			try {
				out = response.getWriter();
				// out 은 웹브라우저에 기술하는 대상체라고 생각하자.
				
				out.println("<script type='text/javascript'>alert('파일다운로드가 불가합니다.'); history.back();</script>");
			} catch (IOException e1) {
				e1.printStackTrace();
			}
			
		}
		
	}

	@ResponseBody
	@RequestMapping(value = "/addMail.on", method= {RequestMethod.POST},produces="text/plain;charset=UTF-8")
	public String addMail(MultipartHttpServletRequest mrequest) {
		
		List<MultipartFile> fileList = mrequest.getFiles("fileList");

		StringBuilder originalFilenamesb =new StringBuilder();
		StringBuilder newFileNamesb =new StringBuilder();
		StringBuilder fileSizesb =new StringBuilder();
		
		String originalFilename ="";
		String newFileName ="";
		String fileSize ="";
		
		JSONObject jsonObj = new JSONObject();
		int n =0;
		
		
		
		
		boolean fileUploadCK = true;
		// 파일 저장
		if( !fileList.isEmpty() ) {
			for(MultipartFile file : fileList) {

				HttpSession session = mrequest.getSession();
				String root = session.getServletContext().getRealPath("/");
				
		//		System.out.println("~~~~ 확인용 webapp 의 절대경로 => " + root);
		//		~~~~ 확인용 webapp 의 절대경로 => > C:\NCS\workspace(spring)\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\GroovyProject\
				String path = root+"resources"+ File.separator +"files";

		//			System.out.println("~~~~ 확인용 path => " + path);		
				byte[] bytes = null;
				// 첨부파일의 내용물을 담는 것	
				try {
					bytes = file.getBytes();
					// 첨부파일의 내용물을 읽어오는 것
					String ogfilename = file.getOriginalFilename();
					originalFilenamesb.append(ogfilename+",");
					newFileNamesb.append(fileManager.doFileUpload(bytes, ogfilename, path)+",");					
					fileSizesb.append(String.valueOf(file.getSize())+","); // 첨부파일의 크기(단위는 byte임)
			
					
				} catch (Exception e) {
					fileUploadCK = false;
					e.printStackTrace();
					
					
				}
			}// end of for
			originalFilename = originalFilenamesb.toString();
			newFileName = newFileNamesb.toString();
			fileSize = fileSizesb.toString();

			originalFilename = 	removeComma(originalFilename);
			newFileName = 	removeComma(newFileName);
			fileSize = 	removeComma(fileSize);

		}// 파일 업로드 끝
		
		if(fileUploadCK) {// 업로드 잘 됐으면 메일 보내기 실행
			
			
			Map<String, Object> paraMap = new HashMap<>();
			
			HttpSession session = mrequest.getSession();

			MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
			 
			String FK_Sender_address = loginuser.getCpemail();
			paraMap.put("FK_Sender_address",FK_Sender_address);
			paraMap.put("FK_Recipient_address",mrequest.getParameter("recipient_address"));
			
			
			paraMap.put("originalFilename",originalFilename);
			paraMap.put("newFileName",newFileName);
			paraMap.put("fileSize",mrequest.getParameter("fileSize"));
	
			paraMap.put("subject",mrequest.getParameter("subject"));
			paraMap.put("contents", secureCode(mrequest.getParameter("contents")));

			if(mrequest.getParameter("send_time") != "" && mrequest.getParameter("send_time") != null) {
				paraMap.put("send_time",mrequest.getParameter("send_time"));
			}
			else {
				paraMap.put("send_time","");
			}
			
			
			if(mrequest.getParameter("password") != null) {
				String mail_pwd = mrequest.getParameter("password");
				paraMap.put("mail_pwd",mail_pwd);
			}
			else {
				paraMap.put("mail_pwd","");
			}

			n = service.addMail(paraMap); 


		}
		else {// 업로드중 문제 발생
			
			n=-1;
			
		}

		jsonObj.put("n", n);

		return jsonObj.toString(); 
		

	}
	
	
	@ResponseBody
	@RequestMapping(value = "/mail/importantCheck.on", method= {RequestMethod.POST},produces="text/plain;charset=UTF-8")
	public String importantCheck(HttpServletRequest request) {
		JSONObject jsonObj = new JSONObject();
		int n=0;
		int m=0;
		String mail_recipient_no = request.getParameter("mail_recipient_no");
		if(mail_recipient_no != null) {
			n = service.importantCheck(mail_recipient_no);
		}
		
		String mail_no = request.getParameter("mail_no");
		
		if(mail_no != null) {
			m = service.importantCheckM(mail_no);
		}
		

		jsonObj.put("n", n+m);
		
		return jsonObj.toString(); 
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/mail/deleteCheck.on", method= {RequestMethod.POST},produces="text/plain;charset=UTF-8")
	public String deleteCheck(HttpServletRequest request) {
		JSONObject jsonObj = new JSONObject();
		int n = 0;
		int m = 0;
		String mail_recipient_no = request.getParameter("mail_recipient_no");
		if(mail_recipient_no != null) {
			n = service.deleteCheck(mail_recipient_no);
		}
		
		String mail_no = request.getParameter("mail_no");
		if(mail_no != null) {
			m = service.deleteCheckM(mail_no);
		}
		

		jsonObj.put("n", n+m);
		
		return jsonObj.toString(); 
	}
	
	@ResponseBody
	@RequestMapping(value = "/mail/tagCheck.on", method= {RequestMethod.POST},produces="text/plain;charset=UTF-8")
	public String tagCheck(HttpServletRequest request) {
		JSONObject jsonObj = new JSONObject();
		int n = 0;
		
		String tagColor = request.getParameter("tagColor");
		String tagName = request.getParameter("tagName");
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		String mail_address = loginuser.getCpemail();
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("tag_color",tagColor);
		paraMap.put("tag_name",tagName);
		paraMap.put("FK_MAIL_ADDRESS",mail_address);
		

		String mail_no_List = request.getParameter("mail_no");
		if(mail_no_List != null) {
			paraMap.put("mail_no_List",mail_no_List);
			n = service.tagCheckM(paraMap);
		}
		

		jsonObj.put("n", n);
		
		return jsonObj.toString(); 
	}
	
	// 태그 추가
	@ResponseBody
	@RequestMapping(value = "/mail/tagAdd.on", method= {RequestMethod.POST},produces="text/plain;charset=UTF-8")
	public String tagAdd(HttpServletRequest request) {
		JSONObject jsonObj = new JSONObject();
		int n = 0;
		
		String tag_color = request.getParameter("tag_color");
		String tag_name = request.getParameter("tag_name");
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		String mail_address = loginuser.getCpemail();
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("tag_color",tag_color);
		paraMap.put("tag_name",tag_name);
		paraMap.put("FK_MAIL_ADDRESS",mail_address);
		

		String fk_mail_no_List = request.getParameter("fk_mail_no");
		if(fk_mail_no_List != null) {
			paraMap.put("fk_mail_no_List",fk_mail_no_List);
			n = service.tagAdd(paraMap);
		}
		

		jsonObj.put("n", n);
		
		return jsonObj.toString(); 
	}
	
	// 태그  삭제
	@ResponseBody
	@RequestMapping(value = "/mail/tagDelete.on", method= {RequestMethod.POST},produces="text/plain;charset=UTF-8")
	public String tagDelete(HttpServletRequest request) {
		JSONObject jsonObj = new JSONObject();
		int n = 0;
		
		String tag_color = request.getParameter("tag_color");
		String tag_name = request.getParameter("tag_name");
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		String mail_address = loginuser.getCpemail();
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("tag_color",tag_color);
		paraMap.put("tag_name",tag_name);
		paraMap.put("FK_MAIL_ADDRESS",mail_address);

		n = service.tagDelete(paraMap);
		

		jsonObj.put("n", n);
		
		return jsonObj.toString(); 
	}
	
	// 메일 읽음 처리
	@ResponseBody
	@RequestMapping(value = "/mail/readCheck.on", method= {RequestMethod.POST},produces="text/plain;charset=UTF-8")
	public String readCheck(HttpServletRequest request) {
		JSONObject jsonObj = new JSONObject();
		int n = 0;


		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		String mail_address = loginuser.getCpemail();
		
		// Map 에 내 이메일과 읽음처리할 메일번호 두가지 넣고 돌림
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("FK_MAIL_ADDRESS",mail_address);
		String mailno_List = request.getParameter("mailno");
		if(mailno_List != null) {
			paraMap.put("mailno_List",mailno_List);
			n = service.read(paraMap);
		}
		
		

		jsonObj.put("n", n);
		
		return jsonObj.toString(); 
	}
	
	
	// 조직도 중요체크
	@ResponseBody
	@RequestMapping(value = "/organization/importantCheck.on", method= {RequestMethod.POST},produces="text/plain;charset=UTF-8")
	public String orgImportantCheck(HttpServletRequest request) {
		JSONObject jsonObj = new JSONObject();
		int n = 0;
		
		String emp_no = request.getParameter("emp_no");
		if(emp_no != null) {
			
			HttpSession session = request.getSession();
			MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
			
			Map<String,String> paraMap = new HashMap<>();
			paraMap.put("loginuserNo",loginuser.getEmpno());
			paraMap.put("emp_no",emp_no);
			
			n = service.orgImportantCheck(paraMap);
		}


		jsonObj.put("n", n);
		
		return jsonObj.toString(); 
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	// 채팅
	@RequestMapping(value = "/chat.on")
	public String chat(HttpServletRequest request) {
		
		// 내가 참가 가능한 채팅방리스트 가져오기
		List<Map<String, String>> chatroomList = null;
		
		HttpSession session = request.getSession();
		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		chatroomList = service.getChatroomList(loginuser.getEmpno()); 
		request.setAttribute("chatroomList", chatroomList);
		
		// 자동완성용 메일리스트 가져오기 
		List<String> mailList = service.getMailList();
		request.setAttribute("mailList", mailList);

		return "chat/chatMain.tiles";
		// ==> views/tiles/chat/content/chatMain.jsp
	}
	
	// 채팅방 추가하기
	@RequestMapping(value = "/chat/goAddChatroom.on")
	public ModelAndView goAddChatroom(ModelAndView mav, HttpServletRequest request) {
		
		String subject = request.getParameter("subject");
		String recipient_address = request.getParameter("recipient_address");
		
		Map<String,String> paraMap = new HashMap<>();
		paraMap.put("subject", subject);
		paraMap.put("recipient_address", recipient_address);
		
		int n = service.goAddChatroom(paraMap);
		if (n == 0) {
			mav.addObject("message", "채팅방 개설에 실패하였습니다.");
			mav.addObject("loc", "javascript:history.back()");
		} else {
			mav.addObject("message", "채팅방이 개설되었습니다.");
			mav.addObject("loc", request.getContextPath() + "/chat.on");
		}

		mav.setViewName("msg");

		return mav;
		

	}
	
	
	// 채팅방 변경하기
		@RequestMapping(value = "/chat/goChangeChatroom.on")
		public ModelAndView goChangeChatroom(ModelAndView mav, HttpServletRequest request) {
			String no = request.getParameter("no");
			String subject = request.getParameter("subject");
			String recipient_address = request.getParameter("recipient_address");
			
			Map<String,String> paraMap = new HashMap<>();
			paraMap.put("room_no", no);
			paraMap.put("subject", subject);
			paraMap.put("recipient_address", recipient_address);
			

			
			int n = service.goChangeChatroom(paraMap);
			if (n == 0) {
				mav.addObject("message", "채팅방 변경에 실패하였습니다.");
				mav.addObject("loc", "javascript:history.back()");
			} else {
				mav.addObject("message", "채팅방이 변경되었습니다.");
				mav.addObject("loc", request.getContextPath() + "/chat.on");
			}

			mav.setViewName("msg");

			return mav;
			

		}

	// 채팅방 띄우기
	@RequestMapping(value = "/chat/chatroom.on")
	public String chatroom(HttpServletRequest request) {
		// 자기 채팅방 맞는지 확인작업 한번 필요함
		request.setAttribute("no", request.getParameter("no"));
		// 채팅방 채팅내역 가져오기
		List<MessageVO> messageList = service.getMessageList(request.getParameter("no"));
		request.setAttribute("messageList", messageList);
		return "chat/chatroom";
		// ==> views/tiles/chat/content/chatMain.jsp
	}
	
	// 채팅방 멤버 가져오기
	@ResponseBody
	@RequestMapping(value = "/chat/getMember.on", method= {RequestMethod.GET},produces="text/plain;charset=UTF-8")
	public String getMember(HttpServletRequest request) {
		String roomNo = request.getParameter("roomNo");

		List<String> memberList = service.getMember(roomNo);


		JSONArray arr_strJson = new JSONArray(Arrays.asList(memberList));
		
		return arr_strJson.toString();
	}
	
	
	
	@ResponseBody
	@RequestMapping(value = "/chat/exit.on", method= {RequestMethod.POST},produces="text/plain;charset=UTF-8")
	public String exit(HttpServletRequest request) {
		Map<String, String> paraMap = new HashMap<>();
		HttpSession session = request.getSession();

		MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");
		String empNo = loginuser.getEmpno();
		String room_no = request.getParameter("room_no");
		paraMap.put("empNo",empNo);
		paraMap.put("room_no",room_no);
		
		int n = service.deleteMember(paraMap);

		
		return Integer.toString(n);
	}
	
	
	
	
	
	
	/////////////////////////////
	// 1. `**Controller**`에 아래와 같이 에러 처리 메소드를 생성한다.
	// 만약 사용자가 **`pageSize`**나 **`currentPage`**에 문자 or 정수형 범위 이상을 입력했다면 에러페이지를 띄우는 것임
	
	@ExceptionHandler(org.springframework.validation.BindException.class)
	public String error(Exception e) {
	    return "error";
	}
	
	
	
	
	
	
	
	
	
	/////////////////////
	

	private Map<String,Object> mailpaginglist(Map<String,Object> htmlMap, Pagination pagination, String listType,HttpServletRequest request) {
		
		 Map<String, Object> paraMap = new HashMap<>();
		 HttpSession session = request.getSession();
		 
		 MemberVO loginuser = (MemberVO)session.getAttribute("loginuser");

		 String mail_address = loginuser.getCpemail();

		 paraMap.put("mail_address", mail_address);
		 paraMap.put("listType", listType);

		 
		 // 내 태그 가져오기
		 List<TagVO> tagList = null;
		 Map<String, String> paraMap2 = new HashMap<>();
		 paraMap2.put("FK_MAIL_ADDRESS", mail_address);
		 
		 tagList=service.getTagListByMailNo(paraMap2);
 
		 List<MailVO> mailList = null;
		 
		 String searchType = pagination.getSearchType(); 
		 String searchWord = pagination.getSearchWord();

		 // 둘다 없다면 "" 처리
		 if(searchType == null || (!"subject".equals(searchType) && !"FK_Sender_address".equals(searchType)) ) {
			searchType = "";
		 }
		
		 if(searchWord == null || "".equals(searchWord) || searchWord.trim().isEmpty() ) {
		 	searchWord = "";
		 }
		 paraMap.put("searchType",searchType);
		 paraMap.put("searchWord",searchWord);	
		 
		 // 총 게시물 건수(totalCount)
		 if(listType.equalsIgnoreCase("Tag")) {
			 paraMap.put("tag_name", request.getParameter("tagName"));
			 paraMap.put("tag_color", request.getParameter("tagColor"));

			 List<String> TagMailList = service.getTotalCountTag(paraMap);
			 paraMap.put("TagMailList", TagMailList);
			 
		 }

		 int listCnt  = service.getTotalCount(paraMap);
		 System.out.println("listCnt"+listCnt);
		 Map<String, Object> resultMap = pagination.getPageRange(listCnt);

		 paraMap.put("startRno",resultMap.get("startRno"));
		 paraMap.put("endRno",(resultMap.get("endRno")));
		 
		 mailList = service.mailListSearchWithPaging(paraMap);
		 // 페이징 처리한 글목록 가져오기(검색이 있든지, 검색이 없든지 모두 다 포함한 것)
		 List<TagVO>tagListSide = service.getTagListSide(mail_address);
		 htmlMap.put("tagListSide", tagListSide);
		 htmlMap.put("mailList", mailList);
		 htmlMap.put("tagList", tagList);

		return htmlMap;
	}
	
	
	
	static String removeComma(String str) {
        if (str.endsWith(",")) {
            return str.substring(0, str.length() - 1);
        }
 
        return str;
    }
	
	static String secureCode(String str) {
		
		/*	
			=== 스마트에디터를 사용 안 할 경우 ===
			str = str.replaceAll("<", "&lt;");
			str = str.replaceAll(">", "&gt;");
		*/	
			// 스마트에디터를 사용할 경우
			str = str.replaceAll("<script", "&lt;script");
			return str;
	}
	
	
	
	


}
