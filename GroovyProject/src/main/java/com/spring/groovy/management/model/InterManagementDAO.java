package com.spring.groovy.management.model;

import java.util.Map;

public interface InterManagementDAO {

	
	// 로그인- 이메일입력
	MemberVO getLogin(String cpemail);

	
	// 로그인- 비밀번호 입력
	MemberVO login2(Map<String, String> paraMap);

}