package com.spring.groovy.approval.model;

import java.util.List;
import java.util.Map;

import com.spring.groovy.management.model.MemberVO;

public interface InterApprovalDAO {

	// 팀문서함 전체 글 개수 조회
	int getTeamDraftCnt(Map<String, Object> paraMap);

	// 팀문서함 페이징처리한 리스트 조회
	List<DraftVO> getTeamDraftList(Map<String, Object> paraMap);

	// 개인문서함 - 상신함 전체 글 개수 조회
	int getSentDraftCnt(Map<String, Object> paraMap);

	// 개인문서함 - 상신함 페이징처리한 리스트 조회
	List<DraftVO> getSentDraftList(Map<String, Object> paraMap);

	// 개인문서함 - 결재함 전체 글 개수 조회
	int getProcessedDraftCnt(Map<String, Object> paraMap);

	// 개인문서함 - 결재함 페이징처리한 리스트 조회
	List<DraftVO> getProcessedDraftList(Map<String, Object> paraMap);
	
	// 개인문서함 - 임시저장함 전체 글 개수 조회
	int getSavedDraftCnt(Map<String, Object> paraMap);
	
	// 개인문서함 - 임시저장함 페이징처리한 리스트 조회
	List<DraftVO> getSavedDraftList(Map<String, Object> paraMap);

	// 개인문서함 - 임시저장함 글삭제
	int deleteDraftList(String[] deleteArr);

	// 결재완료된 문서 5개 가져오기
	List<DraftVO> getMyDraftProcessed(String empno);

	// 결재 대기 문서의 문서번호들 조회
	List<Object> getRequestedDraftNo(Map<String, Object> paraMap);

	// 결재대기문서 전체 글 개수 조회
	int getRequestedDraftCnt(Map<String, Object> paraMap);

	// 결재대기문서 페이징처리한 리스트 조회
	List<DraftVO> getRequestedDraftList(Map<String, Object> paraMap);

	// 사원 목록 가져오기
	List<Map<String, String>> getEmpList(Map<String, Object> paraMap);

	// 부문 목록 가져오기
	List<Map<String, String>> getBumunList(Map<String, Object> paraMap);

	// 부서 목록 가져오기
	List<Map<String, String>> getDeptList(Map<String, Object> paraMap);

	// 환경설정 - 결재라인 저장
	int saveApprovalLine(SavedAprvLineVO sapVO);

	// 기안문서 번호 얻어오기
	int getDraftNo();

	// draft 테이블에 insert
	int addDraft(DraftVO dvo);

	// approval 테이블에 insert
	int addApproval(List<ApprovalVO> apvoList);

	// draft_file 테이블에 insert
	int addFiles(List<DraftFileVO> fileList);

	// 저장된 결재라인 불러오기
	List<SavedAprvLineVO> getSavedAprvLine(Map<String, String> paraMap);

	// 저장된 결재라인 결재자 정보 가져오기
	List<MemberVO> getSavedAprvEmpInfo(List<String> empnoList);

	// 공통결재라인 목록 불러오기
	List<Map<String, String>> getOfficialAprvList();

	// 환경설정-공통결재라인 한개 불러오기
	List<MemberVO> getOneOfficialAprvLine(String official_aprv_line_no);

	// 임시저장 번호 얻어오기
	int getTempDraftNo();

	// 기안 임시저장하기
	int saveDraft(DraftVO dvo);

	// 결재정보 임시저장하기
	int saveApproval(List<ApprovalVO> apvoList);

	// 30일 지난 임시저장 글 삭제하기
	void autoDeleteSavedDraft();

	// draft에서 select
	DraftVO getDraftInfo(DraftVO dvo);

	// approval에서 select
	List<ApprovalVO> getApprovalInfo(DraftVO dvo);

	// file에서 select
	List<DraftFileVO> getDraftFileInfo(DraftVO dvo);

	// 자신의 결재 처리하기(승인 or 반려)
	int updateMyApproval(ApprovalVO avo);

	// 대결 처리하기
	int updateApprovalProxy(ApprovalVO avo);

}
