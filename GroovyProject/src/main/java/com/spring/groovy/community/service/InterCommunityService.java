package com.spring.groovy.community.service;

import java.util.List;
import java.util.Map;

import com.spring.groovy.community.model.CommunityCommentVO;
import com.spring.groovy.community.model.CommunityLikeVO;
import com.spring.groovy.community.model.CommunityPostFileVO;
import com.spring.groovy.community.model.CommunityPostVO;

public interface InterCommunityService {

	// 글 작성하기
	boolean addPost(Map<String, Object> paraMap);

	// 전체 글 개수 구하기
	int getPostCnt(Map<String, String> paraMap);

	// 한 페이지에 표시할 글 목록
	List<CommunityPostVO> getPostList(Map<String, String> paraMap);

	// 글 내용 조회 + 조회수 증가
	CommunityPostVO getPostDetailWithCnt(Map<String, String> paraMap);
	
	// 조회수 증가 없는 글 조회
	CommunityPostVO getPostDetail(Map<String, String> paraMap);
	
	// 첨부파일 조회
	List<CommunityPostFileVO> getPostFiles(String post_no);

	// 댓글 목록 조회
	List<CommunityCommentVO> getComment(String post_no);
	
	// 글 삭제하기
	boolean deletePost(Map<String, String> paraMap);

	// 파일 삭제하기
	boolean deleteFile(String post_file_no, String path);

	// 글 수정하기
	boolean editPost(Map<String, Object> paraMap);

	// 댓글 작성하기
	boolean addComment(CommunityCommentVO comment);

	// 댓글 수정하기
	boolean editComment(CommunityCommentVO comment);

	// 댓글 삭제하기
	boolean delComment(CommunityCommentVO comment);

	// 첨부파일 1개 조회
	CommunityPostFileVO getAttachedFile(String post_file_no);

	// 답댓글 작성
	boolean addReComment(CommunityCommentVO comment);
	
	// 임시저장하기
	String savePost(Map<String, Object> paraMap);

	// 임시저장 목록 가져오기
	List<Map<String, String>> getSavedPostList(String fk_empno);

	// 30일 지난 임시저장 글 삭제하기
	void autoDeleteTempPost();
	
	// 좋아요 목록 조회
	List<CommunityLikeVO> getLikeList(String post_no);

	// 좋아요 누르기/취소하기
	boolean updateLike(CommunityLikeVO like);

	// 모든 첨부파일 삭제하기
	boolean deleteAttachedFiles(Map<String, String> paraMap);

	// 임시저장글 조회하기
	CommunityPostVO getTempPost(String temp_post_no);

	// 임시저장글 삭제하기
	boolean delTempPost(String temp_post_no);

}
