package com.spring.groovy.mail.service;

import java.util.List;
import java.util.Map;

import com.spring.chatting.websockethandler.MessageVO;
import com.spring.groovy.mail.model.MailVO;
import com.spring.groovy.mail.model.TagVO;

public interface InterMailService {
	/** 특정 유저의 받은메일 총 갯수를 알아오는 식*/
	int getTotalCount(Map<String, Object> paraMap);

	/** 페이징한 메일 정보만 가져오기 */
	List<MailVO> mailListSearchWithPaging(Map<String, Object> paraMap);

	/** 로그인한 유저의 메일 주소를 넣어 그 유저의 태그를 가져오기 */
	List<TagVO> getTagList(String mail_address);

	/** 메일 추가하기 */
	int addMail(Map<String, Object> paraMap);

	/** 메일 하나 불러오기 */
	MailVO getOneMail(Map<String, String> paraMap);

	/** 메일리스트(자동완성용) 가져오기 */
	List<String> getMailList();

	/** 메일번호에 맞는 태그 정보를 가져오면서 조회수 처리도 해주기  */
	List<TagVO> getTagListByMailNo(Map<String, String> paraMap);

	/** 사이드 전용 태그리스트 가져오기 */
	List<TagVO> getTagListSide(String mail_address);

	/** 중요 체크 or 해제 */
	int importantCheck(String mail_recipient_no);
	int importantCheckM(String mail_no);

	/** 메일 삭제  */
	int deleteCheck(String mail_recipient_no);
	int deleteCheckM(String mail_no);

	/** 태그 추가 or 해제 */

	int tagCheckM(Map<String, String> paraMap);

	/** ,로 구분되는 메일 주소로 추가될 태그 만들어서 반환*/
	List<String> getreplyList(String getfK_recipient_address);

	// 채팅방 개설하기
	int goAddChatroom(Map<String, String> paraMap);

	// 채팅방 리스트 가져오기
	List<Map<String, String>> getChatroomList(String empno);

	// 메시지 내용 저장
	int addMessage(MessageVO messageVO);

	// 메시지 내용 가져오기
	List<MessageVO> getMessageList(String parameter);

	// 조직도 중요체크
	int orgImportantCheck(Map<String, String> paraMap);

	// 채팅방 멤버 가져오기
	List<String> getMember(String roomNo);
	
	// 채팅방 변경하기
	int goChangeChatroom(Map<String, String> paraMap);
	// 채팅방 나가기
	int deleteMember(Map<String, String> paraMap);

	int read(Map<String, String> paraMap);
	// 태그 추가
	int tagAdd(Map<String, String> paraMap);
	// 태그 삭제
	int tagDelete(Map<String, String> paraMap);
	
	// 태그메일리스트 훔쳐오기
	List<String> getTotalCountTag(Map<String, Object> paraMap);
	// 비번 구해오기
	String getPwd(String mail_no);
	

	

}
