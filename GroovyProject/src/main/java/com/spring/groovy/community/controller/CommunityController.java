package com.spring.groovy.community.controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.InvocationTargetException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.beanutils.BeanUtils;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.nhncorp.lucy.security.xss.XssPreventer;
import com.spring.groovy.common.FileManager;
import com.spring.groovy.common.Myutil;
import com.spring.groovy.common.Pagination;
import com.spring.groovy.community.model.CommunityCommentVO;
import com.spring.groovy.community.model.CommunityLikeVO;
import com.spring.groovy.community.model.CommunityPostFileVO;
import com.spring.groovy.community.model.CommunityPostVO;
import com.spring.groovy.community.service.InterCommunityService;
import com.spring.groovy.management.model.MemberVO;

@Controller
@RequestMapping(value = "/community/*")
public class CommunityController {
	
	private InterCommunityService service;
	private FileManager fileManager;

	@Autowired
	public CommunityController(InterCommunityService service, FileManager fileManager) {
		this.service = service;
		this.fileManager = fileManager;
	}

	// ??? ?????? ???????????????
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/list.on")
	public ModelAndView getCommunityList(ModelAndView mav, Pagination pagination, HttpServletRequest request) throws IllegalAccessException, InvocationTargetException, NoSuchMethodException {

		String unescaped = XssPreventer.unescape(pagination.getSearchWord());
		pagination.setSearchWord(unescaped);
		Map<String, String> paraMap = BeanUtils.describe(pagination); // pagination??? Map??????

		// ?????? ??? ?????? ?????????
		int listCnt = service.getPostCnt(paraMap);
		pagination.setPageInfo(listCnt); // ??? ?????????, ?????????, ???????????? ??????
		paraMap.putAll(BeanUtils.describe(pagination)); // pagination??? Map??????
		
		// ?????? ??????
		setSorting(request, paraMap);

		// ??? ???????????? ????????? ??? ??????
		mav.addObject("postList", service.getPostList(paraMap));
		
		// ????????????
		String url = request.getContextPath() + "/community/list.on";
		pagination.setQueryString("&sortType="+paraMap.get("sortType")+"&sortOrder="+paraMap.get("sortOrder"));
		mav.addObject("pagebar", pagination.getPagebar(url));
		mav.addObject("paraMap", paraMap);
		
		// ?????? url ??????
		String communityBackUrl = Myutil.getCurrentURL(request);
		request.setAttribute("communityBackUrl", request.getContextPath() + communityBackUrl);
		
		mav.setViewName("community/post_list.tiles2");
		return mav;
		
	}
	
	// ????????? ?????? ???????????????
	@RequestMapping(value = "/detail.on")
	public ModelAndView getCommunityDetail(ModelAndView mav, HttpServletRequest request, @RequestParam("post_no") String post_no) {
		
		MemberVO loginuser = Myutil.getLoginUser(request);
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("empno", loginuser.getEmpno());
		paraMap.put("post_no", post_no);
		
		// ??? ?????? ?????? + ????????? ??????
		CommunityPostVO post = service.getPostDetailWithCnt(paraMap);
		
		// ???????????? ??????
		List<CommunityPostFileVO> postFileList = service.getPostFiles(post_no);

		mav.addObject("post", post);
		mav.addObject("postFileList", postFileList);
		
		mav.setViewName("community/post_detail.tiles2");
		return mav;
		
	}
	
	// ?????? ??????
	@ResponseBody
	@RequestMapping(value = "/getComment.on")
	public String getComment(HttpServletRequest request, @RequestParam("post_no") String post_no) {
		
		// ?????? ??????
		List<CommunityCommentVO> cmtList = service.getComment(post_no);
		
		JSONArray cmtArr = new JSONArray(cmtList);
		return String.valueOf(cmtArr);
	
	}
	
	// ??? ?????? ???????????????
	@RequestMapping(value = "/write.on")
	public ModelAndView getWriteForm(ModelAndView mav, HttpServletRequest request) {
		
		mav.setViewName("community/post_form.tiles2");
		return mav;
		
	}
	
	// ??? ????????????
	@ResponseBody
	@PostMapping(value = "/addPost.on", produces = "text/plain;charset=UTF-8")
	public String addPost(MultipartHttpServletRequest mtfRequest, CommunityPostVO post) {
		
		MemberVO loginuser = Myutil.getLoginUser(mtfRequest);
		post.setFk_empno(loginuser.getEmpno());
		
		Map<String, Object> paraMap = new HashMap<>();
		
		paraMap.put("post", post);
		paraMap.put("temp_post_no", mtfRequest.getParameter("temp_post_no"));
		
		// service??? ?????? ??????????????? ?????? ?????????
		List<CommunityPostFileVO> fileList = new ArrayList<CommunityPostFileVO>();
		
		// ??????????????? ?????? ???
		if (mtfRequest.getFiles("fileList").size() > 0) {
			
			// ?????? ????????? ?????? ??????
			String path = Myutil.setFilePath(mtfRequest, "files");
			
			// view?????? ????????? ?????????
			List<MultipartFile> multiFileList = mtfRequest.getFiles("fileList");
			
			// ?????? ???????????????
			for (MultipartFile attach : multiFileList) {
				
				String filename = ""; // ????????? ?????????
				String originalFilename = ""; // ?????? ?????????
				byte[] bytes = null; // ?????? ?????????
				long filesize = 0; // ?????? ??????
				
				try {
					// ??????????????? ???????????? ????????????.
					bytes = attach.getBytes();
					
					// originalFilename??? ????????????.
					originalFilename = attach.getOriginalFilename();
					
					// ????????? ??????????????? ???????????? ????????????.
					filename = fileManager.doFileUpload(bytes, originalFilename, path);
					
				} catch (Exception e) {
					e.printStackTrace();
				}
				
				CommunityPostFileVO cfvo = new CommunityPostFileVO();
				
				// cfvo set
				cfvo.setFilename(filename);
				cfvo.setOriginalFilename(originalFilename);
				filesize = attach.getSize(); // ??????????????? ?????? (??????: byte)
				cfvo.setFilesize(String.valueOf(filesize));
				
				fileList.add(cfvo);
			}
		}
		paraMap.put("fileList", fileList);
		
		boolean result = service.addPost(paraMap);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("result", result);

		return jsonObj.toString();
		
	}
	
	// ??? ??????????????????
	@ResponseBody
	@PostMapping(value = "/savePost.on", produces = "text/plain;charset=UTF-8")
	public String savePost(MultipartHttpServletRequest mtfRequest, CommunityPostVO post) {
		
		MemberVO loginuser = Myutil.getLoginUser(mtfRequest);
		post.setFk_empno(loginuser.getEmpno());
		
		// ????????? ???????????????
		if (post.getPost_subject() == null || "".equals(post.getPost_subject())) {
			Calendar currentDate = Calendar.getInstance(); // ??????????????? ??????
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy.MM.dd HH:mm:ss");
			String currentTime = dateFormat.format(currentDate.getTime());
			
			post.setPost_subject(currentTime + "??? ??????????????? ???");
		}
		
		Map<String, Object> paraMap = new HashMap<>();
		paraMap.put("post", post);
		paraMap.put("temp_post_no", mtfRequest.getParameter("temp_post_no"));
		
		// ??????????????????
		String temp_post_no = service.savePost(paraMap);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("temp_post_no", temp_post_no);
		
		return jsonObj.toString();
		
	}
	
	// ??????????????? ????????????
	@ResponseBody
	@PostMapping(value = "/deleteTempPost.on", produces = "text/plain;charset=UTF-8")
	public String deleteSavePost(HttpServletRequest request, @RequestParam("temp_post_no") String temp_post_no) {
		
		MemberVO loginuser = Myutil.getLoginUser(request);
		String empno =  loginuser.getEmpno();
		
		// ??????????????? ????????????
		CommunityPostVO post = service.getTempPost(temp_post_no);
		
		boolean result = false;
		JSONObject jsonObj = new JSONObject();
		
		if (post.getFk_empno().equals(empno)) {
			// ???????????? ????????????
			result = service.delTempPost(temp_post_no);
		} else {
			jsonObj.put("msg", "?????? ????????? ???????????? ?????? ????????? ??? ????????????!");
		}
		
		jsonObj.put("result", result);
		
		return jsonObj.toString();
		
	}
	
	// ???????????? ??? ???????????? ????????? ??????
	@RequestMapping(value = "/getSavedPost.on", produces = "text/plain;charset=UTF-8")
	public ModelAndView getSavedPost(ModelAndView mav, HttpServletRequest request) {
		
		MemberVO loginuser = Myutil.getLoginUser(request);
		String fk_empno = loginuser.getEmpno();
		
		// ???????????? ?????? ????????????
		List<Map<String, String>> savedPostList = service.getSavedPostList(fk_empno);
	
		JSONArray savedPostArray = new JSONArray(savedPostList);
		mav.addObject("savedPostArray", String.valueOf(savedPostArray));

		mav.setViewName("community/select_saved_post");

		return mav;
	}
	
	// ??? ????????????
	@ResponseBody
	@PostMapping(value = "/deletePost.on", produces = "text/plain;charset=UTF-8")
	public String deletePost(HttpServletRequest request, @RequestParam("post_no") String post_no) {
		
		JSONObject json = new JSONObject();

		MemberVO loginuser = Myutil.getLoginUser(request);
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("post_no", post_no); // ??????????????? ?????????
		
		// ????????? ?????? ?????? ??? ??????
		CommunityPostVO post = service.getPostDetail(paraMap);
		
		try {
			// ??? ???????????? ???????????? ???????????? ????????????
			if (!post.getFk_empno().equals(loginuser.getEmpno()))
				json.put("msg", "?????? ???????????? ?????? ????????? ??? ????????????!");
			
			else {
				paraMap.put("filePath", Myutil.setFilePath(request, "files")); // ?????? ?????? ??????
				
				// ????????????
				boolean result = service.deleteAttachedFiles(paraMap);
				
				// ???????????? ?????? ???
				if (result) {
					// ????????? ??????
					result = service.deletePost(paraMap);
				}
				json.put("msg", (result)? "?????? ??????????????? ?????????????????????." : "??? ????????? ?????????????????????.");
			}
			
		} catch (NullPointerException e) {
			// ?????? ?????? ?????????
			json.put("msg", "???????????? ?????? ????????????!");
		}
		
		return String.valueOf(json);
	}
	
	// ??? ???????????? ??? ????????? ??????
	@GetMapping(value = "/editPost.on")
	public ModelAndView editPost(ModelAndView mav, HttpServletRequest request, @RequestParam("post_no") String post_no) {
		
		MemberVO loginuser = Myutil.getLoginUser(request);
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("post_no", post_no); // ??????????????? ?????????
		
		// ????????? ?????? ?????? ??? ??????
		CommunityPostVO post = service.getPostDetail(paraMap);
		
		try {
			// ??? ???????????? ???????????? ???????????? ????????????
			if (!post.getFk_empno().equals(loginuser.getEmpno())) {
				mav.addObject("message", "?????? ???????????? ?????? ????????? ??? ????????????!");
				mav.addObject("loc", "javascript:history.back()");
				mav.setViewName("msg");
			}
			else {
				mav.addObject("post", post);
				mav.setViewName("community/edit_form.tiles2");
			}
			
		} catch (NullPointerException e) {
			// ?????? ?????? ?????????
			mav.addObject("message", "???????????? ?????? ????????????!");
			mav.addObject("loc", "javascript:history.back()");
			mav.setViewName("msg");
		}
		
		return mav;
	}
	
	// ??? ???????????? ??????
	@ResponseBody
	@PostMapping(value = "/editPostEnd.on", produces = "text/plain;charset=UTF-8")
	public String editPost(MultipartHttpServletRequest mtfRequest, CommunityPostVO post) {
		
		Map<String, Object> paraMap = new HashMap<>();
		
		paraMap.put("post", post);
		
		// service??? ?????? ??????????????? ?????? ?????????
		List<CommunityPostFileVO> fileList = new ArrayList<CommunityPostFileVO>();
		
		// ??????????????? ?????? ???
		if (mtfRequest.getFiles("fileList").size() > 0) {
			
			// ?????? ????????? ?????? ??????
			String path = Myutil.setFilePath(mtfRequest, "files");
			
			// view?????? ????????? ?????????
			List<MultipartFile> multiFileList = mtfRequest.getFiles("fileList");
			
			// ?????? ???????????????
			for (MultipartFile attach : multiFileList) {
				
				String filename = ""; // ????????? ?????????
				String originalFilename = ""; // ?????? ?????????
				byte[] bytes = null; // ?????? ?????????
				long filesize = 0; // ?????? ??????
				
				try {
					// ??????????????? ???????????? ????????????.
					bytes = attach.getBytes();
					
					// originalFilename??? ????????????.
					originalFilename = attach.getOriginalFilename();
					
					// ????????? ??????????????? ???????????? ????????????.
					filename = fileManager.doFileUpload(bytes, originalFilename, path);
					
				} catch (Exception e) {
					e.printStackTrace();
				}
				
				CommunityPostFileVO cfvo = new CommunityPostFileVO();
				
				// cfvo set
				cfvo.setFilename(filename);
				cfvo.setOriginalFilename(originalFilename);
				filesize = attach.getSize(); // ??????????????? ?????? (??????: byte)
				cfvo.setFilesize(String.valueOf(filesize));
				
				fileList.add(cfvo);
			}
		}
		paraMap.put("fileList", fileList);
		
		// ??? ????????????
		boolean result = service.editPost(paraMap);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("result", result);

		return jsonObj.toString();
			
	}
	
	// ???????????? ????????????
	@ResponseBody
	@PostMapping(value = "/deleteFile.on", produces = "text/plain;charset=UTF-8")
	public String deleteFile(HttpServletRequest request, @RequestParam("post_file_no") String post_file_no) {
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("post_file_no", post_file_no); // ??????????????? ????????????
		
		// ????????????
		boolean result = service.deleteFile(post_file_no, Myutil.setFilePath(request, "files"));

		JSONObject json = new JSONObject();
		json.put("result", result);
		return String.valueOf(json);
	}
	
	// ajax??? ???????????? ????????????
	@ResponseBody
	@RequestMapping(value = "/getPostFiles.on", produces = "text/plain;charset=UTF-8")
	public String getPostFiles(HttpServletRequest request, @RequestParam("post_no") String post_no) {

		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("post_no", post_no); // ?????????
		
		// ???????????? ??????
		List<CommunityPostFileVO> postFileList = service.getPostFiles(post_no);
		
		JSONArray jsonArr = new JSONArray(postFileList);
		
		return String.valueOf(jsonArr);
	}
	
	// ?????? ??????
	@ResponseBody
	@RequestMapping(value = "/addComment.on", produces = "text/plain;charset=UTF-8")
	public String addComment(HttpServletRequest request, CommunityCommentVO comment) {

		MemberVO loginuser = Myutil.getLoginUser(request);
		comment.setFk_empno(loginuser.getEmpno());
		
		// ?????? ????????????
		boolean result = service.addComment(comment);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("result", result);

		return jsonObj.toString();
	}
	
	// ????????? ??????
	@ResponseBody
	@RequestMapping(value = "/addReComment.on", produces = "text/plain;charset=UTF-8")
	public String addReComment(HttpServletRequest request, CommunityCommentVO comment) {
		MemberVO loginuser = Myutil.getLoginUser(request);
		comment.setFk_empno(loginuser.getEmpno());
		
		// ?????? ????????????
		boolean result = service.addReComment(comment);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("result", result);
		
		return jsonObj.toString();
	}
	
	// ?????? ??????
	@ResponseBody
	@PostMapping(value = "/editComment.on", produces = "text/plain;charset=UTF-8")
	public String editComment(HttpServletRequest request, CommunityCommentVO comment) {

		MemberVO loginuser = Myutil.getLoginUser(request);

		boolean result = false;
		// ?????? ???????????? ???????????? ???????????? ?????????
		if (loginuser.getEmpno().equals(comment.getFk_empno())) {
			// ?????? ????????????
			result = service.editComment(comment);
		}

		JSONObject jsonObj = new JSONObject();
		jsonObj.put("result", result);
		
		return jsonObj.toString();
		
	}
	
	// ?????? ??????
	@ResponseBody
	@PostMapping(value = "/delComment.on", produces = "text/plain;charset=UTF-8")
	public String delComment(HttpServletRequest request, CommunityCommentVO comment) {
		
		MemberVO loginuser = Myutil.getLoginUser(request);

		boolean result = false;
		// ?????? ???????????? ???????????? ???????????? ?????????
		if (loginuser.getEmpno().equals(comment.getFk_empno())) {
			// ?????? ????????????
			result = service.delComment(comment);
		}
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("result", result);
		
		return jsonObj.toString();
		
	}
	
	// ?????? ????????????
	@ResponseBody
	@RequestMapping(value = "/download.on")
	public void fileDownload(HttpServletRequest request, HttpServletResponse response) {
		
		// ???????????? ??????
		String post_file_no = request.getParameter("post_file_no");
		
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = null;

		try {
			CommunityPostFileVO pfvo = service.getAttachedFile(post_file_no); // ?????? ??????
			
			// ???????????? ????????? ?????? ????????? ?????????
			if (pfvo == null || (pfvo != null && pfvo.getFilename() == null)) {
				out = response.getWriter();
				out.println("<script type='text/javascript'>alert('???????????? ?????? ???????????????.'); history.back();</script>");
				return;
			}
			
			String filename = pfvo.getFilename(); // ????????? ?????? ??????
			String originalFilename = pfvo.getOriginalFilename(); // ?????? ?????? ??????
			
			// ??????????????? ???????????? ?????? WAS ????????? ????????? ???????????? ????????????.
			HttpSession session = request.getSession();
			String root = session.getServletContext().getRealPath("/");
			
			String path = root+"resources"+File.separator+"files";
			
			boolean flag = false;// file ???????????? ??????, ????????? ???????????? ??????
			
			// FileManager??? ?????? ???????????? ????????? ??????
			flag = fileManager.doFileDownload(filename, originalFilename, path, response);
			
			if (!flag) { // ?????? ???????????? ?????? ???
				out = response.getWriter();
				out.println("<script type='text/javascript'>alert('?????? ???????????? ??????');</script>");
			}
			
		} catch (IOException e) { // ?????????????????? ????????? ??????
			try {
				e.printStackTrace();
				out = response.getWriter();
				out.println("<script type='text/javascript'>alert('?????? ???????????? ??????');</script>");
			} catch (IOException e1) {
				e1.printStackTrace();
			}
		}
	}
	
	// ????????? ?????? ??????
	@ResponseBody
	@PostMapping(value = "/getLikeList.on", produces = "text/plain;charset=UTF-8")
	public String getLikeList(@RequestParam("post_no") String post_no) {

		// ????????? ?????? ??????
		List<CommunityLikeVO> likeList = service.getLikeList(post_no);
		
		JSONArray jsonArr = new JSONArray(likeList);
		
		return String.valueOf(jsonArr);
	}
	
	// ????????? ?????????/????????????
	@ResponseBody
	@PostMapping(value = "/updateLike.on", produces = "text/plain;charset=UTF-8")
	public String updateLike(HttpServletRequest request, CommunityLikeVO like) {
		
		boolean result = service.updateLike(like);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("result", result);
		
		return jsonObj.toString();
		
	}
	
	// ????????? ?????? ?????? ??? ?????? ????????????
	private void setSorting(HttpServletRequest request, Map<String, String> paraMap) {
		// ????????????
		String sortType = request.getParameter("sortType");
		sortType = sortType == null ? "post_date" : sortType;
		paraMap.put("sortType", sortType);

		// ????????????
		String sortOrder = request.getParameter("sortOrder");
		sortOrder = sortOrder == null ? "desc" : sortOrder;
		paraMap.put("sortOrder", sortOrder);
	}
	
}
