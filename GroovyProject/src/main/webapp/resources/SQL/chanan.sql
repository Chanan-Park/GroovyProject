-- 기안 종류 테이블 --
CREATE TABLE TBL_DRAFT_TYPE
(DRAFT_TYPE_NO NUMBER -- 기안 종류 번호(기본키)
,DRAFT_TYPE NVARCHAR2(10) NOT NULL -- 기안 종류 이름
,OUTGOING NUMBER(1) DEFAULT 0 NOT NULL -- 수신 여부(0:내부결재, 1:수신처있음)
,constraint PK_TBL_DRAFT_TYPE_DRAFT_TYPE_NO primary key(DRAFT_TYPE_NO)
,constraint CK_TBL_DRAFT_TYPE_DRAFT_RECEIVE CHECK (DRAFT_RECEIVE IN (0, 1))
);

INSERT INTO TBL_DRAFT_TYPE VALUES(1, '업무품의',0);
INSERT INTO TBL_DRAFT_TYPE VALUES(2, '지출결의서', 1);
INSERT INTO TBL_DRAFT_TYPE VALUES(3, '출장보고서', 1);
COMMIT;

-- 기안 문서 테이블 --
CREATE TABLE TBL_DRAFT
(DRAFT_NO NUMBER -- 문서번호(기본키)
,FK_DRAFT_TYPE_NO NOT NULL -- 기안 종류 번호(외래키)
,FK_DRAFT_EMPNO NOT NULL -- 기안자 사원번호(외래키)
,DRAFT_SUBJECT NVARCHAR2(100) NOT NULL -- 문서 제목
,DRAFT_CONTENT CLOB NOT NULL -- 문서 내용
,DRAFT_COMMENT NVARCHAR2(400) -- 기안 의견
,DRAFT_DATE DATE DEFAULT SYSDATE NOT NULL -- 작성일자
,CONSTRAINT PK_TBL_DRAFT_DRAFT_NO PRIMARY KEY(DRAFT_NO)
,CONSTRAINT FK_TBL_DRAFT_FK_DRAFT_TYPE_NO FOREIGN KEY(FK_DRAFT_TYPE_NO) REFERENCES TBL_DRAFT_TYPE(DRAFT_TYPE_NO)
,CONSTRAINT FK_TBL_DRAFT_FK_DRAFT_EMPNO FOREIGN KEY(FK_DRAFT_EMPNO) REFERENCES TBL_EMPLOYEE(EMPNO)
,CONSTRAINT CK_TBL_DRAFT_TEMP CHECK( TEMP IN (0,1))
);

-- 기안 임시저장 테이블 --
CREATE TABLE TBL_TEMP_DRAFT (
TEMP_DRAFT_NO    NUMBER NOT NULL, -- 임시저장번호(기본키)
FK_DRAFT_EMPNO   NUMBER NOT NULL, -- 작성자 사원번호
DRAFT_SUBJECT    NVARCHAR2(100),
DRAFT_CONTENT    CLOB,  
DRAFT_DATE       DATE,  
DRAFT_TYPE       VARCHAR2(20),
FK_DRAFT_TYPE_NO NUMBER
,CONSTRAINT PK_TBL_TEMP_DRAFT_TEMP_DRAFT_NO PRIMARY KEY(TEMP_DRAFT_NO)
,CONSTRAINT FK_TBL_TEMP_DRAFT_FK_DRAFT_TYPE_NO FOREIGN KEY(FK_DRAFT_TYPE_NO) REFERENCES TBL_DRAFT_TYPE(DRAFT_TYPE_NO)
,CONSTRAINT FK_TBL_TEMP_DRAFT_FK_DRAFT_EMPNO FOREIGN KEY(FK_DRAFT_EMPNO) REFERENCES TBL_EMPLOYEE(EMPNO)
);

-- 기안문서 번호 시퀀스 --
CREATE SEQUENCE SEQ_DRAFT_NO
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

-- 기안문서 임시저장 번호 시퀀스 --
CREATE SEQUENCE SEQ_TEMP_DRAFT_NO
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

-- 기안 첨부파일 테이블 --
CREATE TABLE TBL_DRAFT_FILE
(DRAFT_FILE_NO NUMBER NOT NULL -- 첨부파일번호(기본키)
,FK_DRAFT_NO NUMBER NOT NULL -- 문서번호(외래키)
,ORG_FILENAME VARCHAR2(50) NOT NULL -- 원본 파일명
,FILENAME VARCHAR2(50) NOT NULL -- 저장된 파일명
,FILESIZE NUMBER NOT NULL -- 파일크기
,CONSTRAINT PK_TBL_DRAFT_FILE_DRAFT_FILE_NO  PRIMARY KEY(DRAFT_FILE_NO)
,CONSTRAINT FK_TBL_DRAFT_FILE_FK_DRAFT_NO FOREIGN KEY(FK_DRAFT_NO) REFERENCES TBL_TEMP_DRAFT(DRAFT_SEQ)
);

-- 기안 첨부파일 번호 시퀀스 --
CREATE SEQUENCE SEQ_DRAFT_FILE_NO
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

-- 기안 결재 테이블 --
CREATE TABLE TBL_APPROVAL
(APPROVAL_NO NUMBER -- 결재 일련번호(기본키)
,FK_DRAFT_NO NUMBER NOT NULL -- 문서번호(외래키)
,FK_APPROVAL_EMPNO NOT NULL -- 결재할 사원번호(외래키)
,LEVELNO NUMBER NOT NULL -- 결재 단계
,APPROVAL_STATUS NUMBER(1) DEFAULT 0 NOT NULL -- 결재 상태 (0:미결, 1:결재, 2:반려, -1: 처리불가(아래에서 반려함))
,APPROVAL_COMMENT NVARCHAR2(200) -- 결재 의견
,APPROVAL_DATE DATE -- 결재 일자
,CONSTRAINT PK_TBL_APPROVAL_APPROVAL_NO  PRIMARY KEY(APPROVAL_NO)
,CONSTRAINT FK_TBL_APPROVAL_FK_DRAFT_NO FOREIGN KEY(FK_DRAFT_NO) REFERENCES TBL_DRAFT(DRAFT_NO)
,CONSTRAINT FK_TBL_APPROVAL_FK_APPROVAL_EMPNO FOREIGN KEY(FK_APPROVAL_EMPNO) REFERENCES TBL_EMPLOYEE(EMPNO)
,CONSTRAINT CK_TBL_APPROVAL_APPROVAL_STATUS CHECK( APPROVAL_STATUS IN (0,1,2,-1))
);

-- 기안 결재 번호 시퀀스 --
CREATE SEQUENCE SEQ_APPROVAL_NO
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

-- 기안 임시저장 결재라인 테이블 --
CREATE TABLE TBL_TEMP_APPROVAL
(TEMP_APPROVAL_NO NUMBER -- 결재 일련번호(기본키)
,FK_TEMP_DRAFT_NO NUMBER NOT NULL -- 문서번호(외래키)
,FK_APPROVAL_EMPNO NOT NULL -- 결재할 사원번호(외래키)
,LEVELNO NUMBER NOT NULL -- 결재 단계
,CONSTRAINT PK_TBL_TEMP_APPROVAL_TEMP_APPROVAL_NO PRIMARY KEY(TEMP_APPROVAL_NO)
,CONSTRAINT FK_TBL_TEMP_APPROVAL_FK_TEMP_DRAFT_NO FOREIGN KEY(FK_TEMP_DRAFT_NO) REFERENCES TBL_TEMP_DRAFT(TEMP_DRAFT_NO)
,CONSTRAINT FK_TBL_TEMP_APPROVAL_FK_APPROVAL_EMPNO FOREIGN KEY(FK_APPROVAL_EMPNO) REFERENCES TBL_EMPLOYEE(EMPNO)
);

-- 임시저장 결재 번호 시퀀스 --
CREATE SEQUENCE SEQ_TEMP_APPROVAL_NO
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

INSERT INTO TBL_APPROVAL
(APPROVAL_NO, FK_DRAFT_NO, FK_APPROVAL_EMPNO, LEVELNO)
VALUES(SEQ_APPROVAL_NO.NEXTVAL, 1, 3, 2);

INSERT INTO TBL_APPROVAL
(APPROVAL_NO, FK_DRAFT_NO, FK_APPROVAL_EMPNO, LEVELNO)
VALUES(SEQ_APPROVAL_NO.NEXTVAL, 1, 2, 3);
COMMIT;

-- 지출 내역 테이블 --
CREATE TABLE TBL_EXPENSE_LIST
(EXPENSE_LIST_NO NUMBER -- 지출 내역번호(기본키)
,FK_DRAFT_NO NOT NULL -- 기안 문서 번호(외래키)
,EXPENSE_DATE DATE DEFAULT SYSDATE NOT NULL -- 지출일자
,EXPENSE_TYPE NVARCHAR2(10) NOT NULL -- 지출분류
,EXPENSE_DETAIL NVARCHAR2(50) NOT NULL -- 지출내역
,EXPENSE_AMOUNT NUMBER NOT NULL -- 금액
,EXPENSE_REMARK NVARCHAR2(100) -- 비고
,CONSTRAINT PK_TBL_EXPENSE_LIST_EXPENSE_LIST_NO PRIMARY KEY(EXPENSE_LIST_NO)
,CONSTRAINT FK_TBL_EXPENSE_LIST_FK_DRAFT_NO FOREIGN KEY(FK_DRAFT_NO) REFERENCES TBL_DRAFT(DRAFT_NO)
);

-- 지출 내역 시퀀스 --
CREATE SEQUENCE SEQ_EXPENSE_LIST_NO
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

-- 임시 지출 내역 시퀀스 --
CREATE SEQUENCE SEQ_TEMP_EXPENSE_LIST_NO
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

-- 출장 보고 테이블 --
CREATE TABLE TBL_BIZTRIP_REPORT
(BIZTRIP_REPORT_NO NUMBER -- 출장 보고 번호(기본키)
,FK_DRAFT_NO NOT NULL -- 기안 문서 번호(외래키)
,TRIP_PURPOSE NVARCHAR2(300) NOT NULL -- 출장 목적
,TRIP_START_DATE DATE NOT NULL -- 출장 시작일
,TRIP_END_DATE DATE NOT NULL -- 출장 종료일
,TRIP_LOCATION NVARCHAR2(200) -- 출장 지역
,CONSTRAINT PK_TBL_BIZTRIP_REPORT_BIZTRIP_REPORT_NO PRIMARY KEY(BIZTRIP_REPORT_NO)
,CONSTRAINT FK_TBL_BIZTRIP_REPORT_FK_DRAFT_NO FOREIGN KEY(FK_DRAFT_NO) REFERENCES TBL_DRAFT(DRAFT_NO)
);

-- 출장 보고 시퀀스 --
CREATE SEQUENCE SEQ_BIZTRIP_REPORT_NO
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

-- 임시 출장 보고 시퀀스 --
CREATE SEQUENCE SEQ_TEMP_BIZTRIP_REPORT_NO
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

-- 저장된 결재라인 테이블 --
CREATE TABLE TBL_MY_APRV_LINE
(APRV_LINE_NO NUMBER -- 결재라인 번호(기본키)
,APRV_LINE_NAME NVARCHAR2(50) NOT NULL -- 결재라인 이름
,FK_EMPNO NOT NULL -- 결재라인 소유자 사원번호(외래키)
,FK_APPROVAL_EMPNO1 NOT NULL -- 첫번째 결재자 사원번호(외래키)
,FK_APPROVAL_EMPNO2 -- 두번째 결재자 사원번호(외래키)
,FK_APPROVAL_EMPNO3 -- 세번째 결재자 사원번호(외래키)
,CONSTRAINT PK_TBL_MY_APRV_LINE_APRV_LINE_NO PRIMARY KEY(APRV_LINE_NO)
,CONSTRAINT FK_TBL_MY_APRV_LINE_FK_EMPNO FOREIGN KEY(FK_EMPNO) REFERENCES TBL_EMPLOYEE(EMPNO)
,CONSTRAINT FK_TBL_MY_APRV_LINE_FK_APPROVAL_EMPNO1 FOREIGN KEY(FK_APPROVAL_EMPNO1) REFERENCES TBL_EMPLOYEE(EMPNO)
,CONSTRAINT FK_TBL_MY_APRV_LINE_FK_APPROVAL_EMPNO2 FOREIGN KEY(FK_APPROVAL_EMPNO2) REFERENCES TBL_EMPLOYEE(EMPNO)
,CONSTRAINT FK_TBL_MY_APRV_LINE_FK_APPROVAL_EMPNO3 FOREIGN KEY(FK_APPROVAL_EMPNO3) REFERENCES TBL_EMPLOYEE(EMPNO)
);

-- 결재라인 번호 시퀀스 --
CREATE SEQUENCE SEQ_APRV_LINE_NO
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

-- 공통 결재라인 테이블 --
CREATE TABLE TBL_OFFICIAL_APRV_LINE
(OFFICIAL_APRV_LINE_NO NUMBER -- 결재라인 번호(기본키)
,FK_DRAFT_TYPE_NO NUMBER -- 기안종류번호(외래키)
,FK_APPROVAL_EMPNO1 NOT NULL -- 첫번째 결재자 사원번호(외래키)
,FK_APPROVAL_EMPNO2 -- 두번째 결재자 사원번호(외래키)
,FK_APPROVAL_EMPNO3 -- 세번째 결재자 사원번호(외래키)
,FK_APPROVAL_EMPNO4 -- 세번째 결재자 사원번호(외래키)
,CONSTRAINT PK_TBL_OFFICIAL_APRV_LINE_OFFICIAL_APRV_LINE_NO PRIMARY KEY(OFFICIAL_APRV_LINE_NO)
,CONSTRAINT FK_TBL_OFFICIAL_APRV_LINE_FK_DRAFT_TYPE_NO FOREIGN KEY(FK_DRAFT_TYPE_NO) REFERENCES TBL_DRAFT_TYPE(DRAFT_TYPE_NO)
,CONSTRAINT FK_TBL_OFFICIAL_APRV_LINE_FK_APPROVAL_EMPNO1 FOREIGN KEY(FK_APPROVAL_EMPNO1) REFERENCES TBL_EMPLOYEE(EMPNO)
,CONSTRAINT FK_TBL_OFFICIAL_APRV_LINE_FK_APPROVAL_EMPNO2 FOREIGN KEY(FK_APPROVAL_EMPNO2) REFERENCES TBL_EMPLOYEE(EMPNO)
,CONSTRAINT FK_TBL_OFFICIAL_APRV_LINE_FK_APPROVAL_EMPNO3 FOREIGN KEY(FK_APPROVAL_EMPNO3) REFERENCES TBL_EMPLOYEE(EMPNO)
,CONSTRAINT FK_TBL_OFFICIAL_APRV_LINE_FK_APPROVAL_EMPNO4 FOREIGN KEY(FK_APPROVAL_EMPNO4) REFERENCES TBL_EMPLOYEE(EMPNO)
);

-- 공통결재라인 번호 시퀀스 --
CREATE SEQUENCE SEQ_OFFICIAL_APRV_LINE_NO
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

select SEQ_OFFICIAL_APRV_LINE_NO.nextval from dual;

-- 명언 테이블 --
CREATE TABLE TBL_TODAY_PROVERB
(PROVERB_NO NUMBER -- 명언번호(기본키)
,PROVERB NVARCHAR2(500) NOT NULL -- 명언
,CONSTRAINT PK_TBL_TODAY_PROVERB_PROVERB_NO PRIMARY KEY(PROVERB_NO)
);

-- 부문 테이블 --
CREATE TABLE TBL_BUMUN
(BUMUN_NO NUMBER -- 부문번호(기본키)
,BUMUN VARCHAR2(100) NOT NULL -- 부문명
,CONSTRAINT PK_TBL_BUMUN_BUMUN_NO PRIMARY KEY(BUMUN_NO)
);

-- 부서 테이블 --
CREATE TABLE TBL_DEPARTMENT
(DEPARTMENT_NO NUMBER -- 부서번호(기본키)
,FK_BUMUN_NO NUMBER -- 부문번호(외래키)
,DEPARTMENT VARCHAR2(100) NOT NULL -- 부서명
,CONSTRAINT PK_TBL_DEPARTMENT_DEPARTMENT_NO PRIMARY KEY(DEPARTMENT_NO)
,CONSTRAINT FK_TBL_DEPARTMENT_FK_BUMUN_NO FOREIGN KEY(FK_BUMUN_NO) REFERENCES TBL_BUMUN(BUMUN_NO)
);
        
-- 커뮤니티 게시판 테이블 --
CREATE TABLE TBL_COMMUNITY_POST
(POST_NO NUMBER -- 글번호(기본키)
,FK_EMPNO NOT NULL -- 작성자 사원번호(외래키)
,POST_SUBJECT NVARCHAR2(100) NOT NULL -- 글 제목
,POST_CONTENT CLOB NOT NULL -- 글 내용
,POST_DATE DATE DEFAULT SYSDATE NOT NULL -- 작성일자
,POST_HIT NUMBER DEFAULT 0 NOT NULL -- 조회수
,POST_STATUS NUMBER(1) DEFAULT 1 NOT NULL -- 삭제여부(1: 사용가능, 0: 삭제)
,CONSTRAINT PK_TBL_COMMUNITY_POST_NO PRIMARY KEY(POST_NO)
,CONSTRAINT FK_TBL_COMMUNITY_FK_EMPNO FOREIGN KEY(FK_EMPNO) REFERENCES TBL_EMPLOYEE(EMPNO)
,CONSTRAINT CK_TBL_COMMUNITY_POST_STATUS CHECK( POST_STATUS IN (0,1))
);

-- 커뮤니티 게시판 번호 시퀀스 --
CREATE SEQUENCE SEQ_POST_NO
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;
        
-- 커뮤니티 게시판 임시저장 테이블 --
CREATE TABLE TBL_COMMUNITY_POST_TEMP
(TEMP_POST_NO NUMBER -- 글번호(기본키)
,FK_EMPNO NOT NULL -- 작성자 사원번호(외래키)
,POST_SUBJECT NVARCHAR2(100) -- 글 제목
,POST_CONTENT CLOB NOT NULL -- 글 내용
,POST_DATE DATE DEFAULT SYSDATE NOT NULL -- 작성일자
,CONSTRAINT PK_TBL_COMMUNITY_POST_TEMP_TEMP_POST_NO PRIMARY KEY(TEMP_POST_NO)
,CONSTRAINT FK_TBL_COMMUNITY_POST_FK_EMPNO FOREIGN KEY(FK_EMPNO) REFERENCES TBL_EMPLOYEE(EMPNO)
);

-- 커뮤니티 게시판 번호 시퀀스 --
CREATE SEQUENCE SEQ_TEMP_POST_NO
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

-- 커뮤니티 댓글 테이블 --
CREATE TABLE TBL_COMMUNITY_COMMENT
(COMMENT_NO NUMBER -- 댓글번호(기본키)
,FK_EMPNO NOT NULL -- 작성자 사원번호(외래키)
,FK_POST_NO NOT NULL -- 게시글번호(외래키)
,COMMENT_CONTENT NVARCHAR2(500) NOT NULL -- 댓글 내용
,COMMENT_DATE DATE DEFAULT SYSDATE NOT NULL -- 작성일자
,GROUP_NO NUMBER NOT NULL -- 댓글 그룹번호
,PARENT_COMMENT_NO NUMBER NOT NULL -- 원댓글 번호
,DEPTH NUMBER DEFAULT 0 NOT NULL -- 댓글계층
,CONSTRAINT PK_TBL_COMMUNITY_COMMENT_COMMENT_NO PRIMARY KEY(COMMENT_NO)
,CONSTRAINT FK_TBL_COMMUNITY_COMMENT_FK_EMPNO FOREIGN KEY(FK_EMPNO) REFERENCES TBL_EMPLOYEE(EMPNO)
,CONSTRAINT FK_TBL_COMMUNITY_COMMENT_FK_POST_NO FOREIGN KEY(FK_POST_NO) REFERENCES TBL_COMMUNITY(POST_NO)
);

-- 커뮤니티 댓글 번호 시퀀스 --
CREATE SEQUENCE SEQ_COMMENT_NO
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

-- 커뮤니티 게시판 첨부파일 테이블 --
CREATE TABLE TBL_COMMUNITY_POST_FILE
(POST_FILE_NO NUMBER NOT NULL -- 첨부파일번호(기본키)
,FK_POST_NO NUMBER NOT NULL -- 문서번호(외래키)
,ORG_FILENAME VARCHAR2(50) NOT NULL -- 원본 파일명
,FILENAME VARCHAR2(50) NOT NULL -- 저장된 파일명
,FILESIZE NUMBER NOT NULL -- 파일크기
,CONSTRAINT PK_TBL_COMMUNITY_POST_FILE_POST_FILE_NO  PRIMARY KEY(POST_FILE_NO)
,CONSTRAINT FK_TBL_COMMUNITY_POST_FILE_FK_POST_NO FOREIGN KEY(FK_POST_NO) REFERENCES TBL_COMMUNITY(POST_NO)
);

-- 커뮤니티 게시판 첨부파일 시퀀스 --
CREATE SEQUENCE SEQ_POST_FILE_NO
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

-- 커뮤니티 댓글 첨부파일 테이블 --
CREATE TABLE TBL_COMMUNITY_COMMENT_FILE
(COMMENT_FILE_NO NUMBER NOT NULL -- 첨부파일번호(기본키)
,FK_COMMENT_NO NUMBER NOT NULL -- 문서번호(외래키)
,ORG_FILENAME VARCHAR2(50) NOT NULL -- 원본 파일명
,FILENAME VARCHAR2(50) NOT NULL -- 저장된 파일명
,FILESIZE NUMBER NOT NULL -- 파일크기
,CONSTRAINT PK_TBL_COMMUNITY_COMMENT_FILE_COMMENT_FILE_NO  PRIMARY KEY(COMMENT_FILE_NO)
,CONSTRAINT FK_TBL_COMMUNITY_COMMENT_FILE_FK_COMMENT_NO FOREIGN KEY(FK_COMMENT_NO) REFERENCES TBL_COMMUNITY_COMMENT(COMMENT_NO)
);

-- 커뮤니티 댓글 첨부파일 시퀀스 --
CREATE SEQUENCE SEQ_COMMENT_FILE_NO
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

-- 커뮤니티 좋아요 테이블 --
CREATE TABLE TBL_COMMUNITY_LIKE
(LIKE_NO NUMBER -- 댓글번호(기본키)
,FK_EMPNO NOT NULL -- 누른 사람 사원번호(외래키)
,FK_POST_NO NOT NULL -- 게시글번호(외래키)
,CONSTRAINT PK_TBL_COMMUNITY_LIKE_LIKE_NO PRIMARY KEY(LIKE_NO)
,CONSTRAINT FK_TBL_COMMUNITY_LIKE_FK_EMPNO FOREIGN KEY(FK_EMPNO) REFERENCES TBL_EMPLOYEE(EMPNO)
,CONSTRAINT FK_TBL_COMMUNITY_LIKE_FK_POST_NO FOREIGN KEY(FK_POST_NO) REFERENCES TBL_COMMUNITY(POST_NO)
);

-- 커뮤니티 좋아요 시퀀스 --
CREATE SEQUENCE SEQ_LIKE_NO
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

--------------------------------------------------------------------------------

-- 결재정보를 join하여 가져오는 뷰 --
create or replace view view_draft_approval
as
SELECT case when DRAFT_status = 0 then null else APPROVAL_DATE end as APPROVAL_DATE, 
DRAFT_DATE, FK_DRAFT_TYPE_NO, draft_type, draft_no, FK_DRAFT_EMPNO, urgent_status, FK_APPROVAL_EMPNO,
name as DRAFT_EMP_NAME, REPLACE(REPLACE(REPLACE(REPLACE(DRAFT_SUBJECT,'&'||'lt;','<' ),'&'||'gt;','>'),'&amp;', '&'),'&nbsp;',' ') AS DRAFT_SUBJECT,
REGEXP_REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(DRAFT_CONTENT, '&'||'lt;','<' ),'&'||'gt;','>'),'&amp;', '&'),'&nbsp;',' ') , '<[^>]*>' ,'' ) AS DRAFT_CONTENT,
DRAFT_status, department as draft_DEPARTMENT
FROM TBL_APPROVAL JOIN TBL_DRAFT
ON FK_DRAFT_NO = DRAFT_NO
JOIN TBL_EMPLOYEE
ON EMPNO = FK_DRAFT_EMPNO
;

-- 팀 결재함 문서 전체 목록 뷰 --
create or replace view view_team_draft
as
select case when DRAFT_status = 0 then null else APPROVAL_DATE end as APPROVAL_DATE, 
DRAFT_DATE, FK_DRAFT_TYPE_NO, draft_type, draft_no, FK_DRAFT_EMPNO, urgent_status,
name as DRAFT_EMP_NAME, REPLACE(REPLACE(REPLACE(REPLACE(DRAFT_SUBJECT,'&'||'lt;','<' ),'&'||'gt;','>'),'&amp;', '&'),'&nbsp;',' ') AS DRAFT_SUBJECT,
REGEXP_REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(DRAFT_CONTENT, '&'||'lt;','<' ),'&'||'gt;','>'),'&amp;', '&'),'&nbsp;',' ') , '<[^>]*>' ,'' ) AS DRAFT_CONTENT,
DRAFT_status, department as draft_DEPARTMENT, fk_department_no
FROM
(select DRAFT_DATE, FK_DRAFT_TYPE_NO, draft_type, draft_no, FK_DRAFT_EMPNO, DRAFT_SUBJECT, DRAFT_CONTENT, DRAFT_status, APPROVAL_DATE, urgent_status
from tbl_draft join 
(select max(APPROVAL_DATE) as APPROVAL_DATE, FK_DRAFT_NO from tbl_approval group by FK_DRAFT_NO)
on draft_no = FK_DRAFT_NO
where DRAFT_status != 0) join
tbl_employee
on empno = fk_draft_empno
;

-- 개인문서함 상신함 목록 뷰 --
create or replace view view_draft_sent
as
select case when DRAFT_status = 0 then null else APPROVAL_DATE end as APPROVAL_DATE, DRAFT_DATE, FK_DRAFT_TYPE_NO, draft_type, draft_no,
FK_DRAFT_EMPNO, NAME as DRAFT_EMP_NAME, REPLACE(REPLACE(REPLACE(REPLACE(DRAFT_SUBJECT,'&'||'lt;','<' ),'&'||'gt;','>'),'&amp;', '&'),'&nbsp;',' ') AS DRAFT_SUBJECT, 
DRAFT_status, urgent_status,
REGEXP_REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(DRAFT_CONTENT, '&'||'lt;','<' ),'&'||'gt;','>'),'&amp;', '&'),'&nbsp;',' ') , '<[^>]*>' ,'' ) AS DRAFT_CONTENT
from tbl_draft join
(select max(APPROVAL_DATE) as APPROVAL_DATE, FK_DRAFT_NO from tbl_approval group by FK_DRAFT_NO)
on draft_no = FK_DRAFT_NO
join
tbl_employee
on empno = fk_draft_empno
;

-- 개인문서함 결재함 목록 뷰 --
create or replace view view_draft_processed
as
SELECT case when DRAFT_status = 0 then null else APPROVAL_DATE end as APPROVAL_DATE, 
DRAFT_DATE, FK_DRAFT_TYPE_NO, DRAFT_TYPE, DRAFT_NO,
FK_DRAFT_EMPNO, NAME as DRAFT_EMP_NAME, fk_approval_empno, REPLACE(REPLACE(REPLACE(REPLACE(DRAFT_SUBJECT,'&'||'lt;','<' ),'&'||'gt;','>'),'&amp;', '&'),'&nbsp;',' ') AS DRAFT_SUBJECT, 
department as draft_DEPARTMENT, urgent_status, DRAFT_status,
REGEXP_REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(DRAFT_CONTENT, '&'||'lt;','<' ),'&'||'gt;','>'),'&amp;', '&'),'&nbsp;',' ') , '<[^>]*>' ,'' ) AS DRAFT_CONTENT
FROM TBL_DRAFT JOIN (select APPROVAL_DATE, approval_STATUS, fk_approval_empno, FK_DRAFT_NO from tbl_approval)
ON DRAFT_NO = FK_DRAFT_NO
and approval_STATUS IN (1,2) join
tbl_employee
on empno = fk_draft_empno
;	

-- 개인문서함 임시저장함 목록 뷰 --
create or replace view view_temp_draft
as
SELECT DRAFT_TYPE, TEMP_DRAFT_NO AS DRAFT_NO, FK_DRAFT_EMPNO, DRAFT_DATE,
					REPLACE(REPLACE(REPLACE(REPLACE(DRAFT_SUBJECT,'&'||'lt;','<' ),'&'||'gt;','>'),'&amp;', '&'),'&nbsp;',' ') AS DRAFT_SUBJECT, 
                    FK_DRAFT_TYPE_NO, NAME AS DRAFT_EMP_NAME,
                    REGEXP_REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(DRAFT_CONTENT, '&'||'lt;','<' ),'&'||'gt;','>'),'&amp;', '&'),'&nbsp;',' ') , '<[^>]*>' ,'' ) AS DRAFT_CONTENT
					FROM TBL_TEMP_DRAFT JOIN
					TBL_EMPLOYEE
					ON EMPNO = FK_DRAFT_EMPNO
;

-- 결재 대기문서 목록 select문 --
SELECT DISTINCT DRAFT_DATE, FK_DRAFT_TYPE_NO, DRAFT_TYPE, DRAFT_NO, FK_DRAFT_EMPNO, 
NAME AS DRAFT_EMP_NAME, REPLACE(REPLACE(REPLACE(REPLACE(DRAFT_SUBJECT,'&'||'lt;','<' ),'&'||'gt;','>'),'&amp;', '&'),'&nbsp;',' ') AS DRAFT_SUBJECT, URGENT_STATUS
FROM TBL_DRAFT JOIN TBL_APPROVAL
ON DRAFT_NO = FK_DRAFT_NO
AND DRAFT_NO IN (
   	SELECT FK_DRAFT_NO
	FROM TBL_APPROVAL A
	WHERE FK_APPROVAL_EMPNO = 4 AND APPROVAL_STATUS = 0
	AND FK_DRAFT_NO IN (SELECT FK_DRAFT_NO
	                    FROM TBL_APPROVAL
	                    WHERE (LEVELNO = (A.LEVELNO - 1) AND APPROVAL_STATUS = 1)
                        OR A.LEVELNO = 1)
    )
JOIN TBL_EMPLOYEE
ON EMPNO = FK_DRAFT_EMPNO
;

-- 사원 목록 불러오기 --
select EMPNO, DEPARTMENT, name, e.position, position_no
from tbl_employee e  join tbl_position p 
on e.position = p.position
where empno != 2
and department = '개발팀'
and position_no > 내포지션;

select name, position
from tbl_employee;

-- 저장된 결재라인 불러오기 --
SELECT APRV_LINE_NO, APRV_LINE_NAME, FK_APPROVAL_EMPNO1, FK_APPROVAL_EMPNO2,
FK_APPROVAL_EMPNO3, FK_APPROVAL_EMPNO4
FROM TBL_SAVED_APRV_LINE
WHERE FK_EMPNO = 5;

-- 결재 처리 프로시저
create or replace procedure pcd_tbl_approval_update
(p_FK_DRAFT_NO IN tbl_approval.FK_DRAFT_NO%type
,p_LEVELNO in tbl_approval.LEVELNO%type
,p_APPROVAL_STATUS in tbl_approval.APPROVAL_STATUS%type
,p_APPROVAL_COMMENT in tbl_approval.APPROVAL_COMMENT%type
,o_updateCnt out number
)
is
    v_maxLevel number(1); -- 최고 결재단계
begin
    -- 최고 결재단계 알아오기
    SELECT MAX(LEVELNO) into v_maxLevel FROM TBL_APPROVAL WHERE FK_DRAFT_NO = p_FK_DRAFT_NO;

    -- 결재 처리하기
        update tbl_approval set approval_status = p_APPROVAL_STATUS, APPROVAL_DATE = sysdate, APPROVAL_COMMENT = p_APPROVAL_COMMENT
        where FK_DRAFT_NO = p_FK_DRAFT_NO and LEVELNO = p_LEVELNO;
    -- 만약 마지막 결재자라면 기안 테이블 완료처리
    if(p_LEVELNO = v_maxLevel) then
        update tbl_draft set DRAFT_STATUS = 1
        where DRAFT_NO = p_FK_DRAFT_NO;
    end if;
    
    if(p_approval_status = 2) then
        -- 윗 결재자들의 결재상태를 모두 -1로 update
        update tbl_approval set approval_status = -1 
        where FK_DRAFT_NO = p_FK_DRAFT_NO and LEVELNO in
        (select LEVELNO from tbl_approval where LEVELNO > p_LEVELNO);
        -- 기안 테이블 반려처리
        update tbl_draft set DRAFT_STATUS = 2
        where DRAFT_NO = p_FK_DRAFT_NO;
   end if;

   o_updateCnt := SQL%rowcount;
   
end pcd_tbl_approval_update;

-- 오늘의 명언 프로시저 --
create or replace procedure pcd_get_TODAY_PROVERB
(o_proverb out TBL_TODAY_PROVERB.proverb%type
)
is
    v_proverb_no TBL_TODAY_PROVERB.proverb_no%type;
    v_today_used_count number;
    v_unused_count number;
begin

    -- 오늘 이미 사용된 명언이 있는지 조회
    SELECT count(*) into v_today_used_count FROM TBL_TODAY_PROVERB
    WHERE TO_CHAR(USED_DATE, 'YYYY-MM-DD') = TO_CHAR(SYSDATE, 'YYYY-MM-DD');
    
    -- 오늘 사용된 명언이 있다면 out변수에 담기
    if (v_today_used_count = 1) then
    SELECT proverb into o_proverb FROM TBL_TODAY_PROVERB
    WHERE TO_CHAR(USED_DATE, 'YYYY-MM-DD') = TO_CHAR(SYSDATE, 'YYYY-MM-DD');

    -- 오늘 사용된 명언이 없다면
    else
        -- 사용하지 않은 명언 개수 조회
        SELECT COUNT(*) into v_unused_count FROM TBL_TODAY_PROVERB
        WHERE USED_STATUS = 0;
    
        -- 모든 명언이 사용되었으면 초기화하기
        if (v_unused_count = 0) then
            UPDATE TBL_TODAY_PROVERB
            SET USED_STATUS = 0, USED_DATE = null;
            
        -- 사용되지 않은 명언이 있다면
        else
            -- 랜덤 조회하기
            select proverb, proverb_no into o_proverb, v_proverb_no 
            from(
                SELECT proverb, proverb_no FROM TBL_TODAY_PROVERB
                WHERE USED_STATUS = 0
                order by DBMS_RANDOM.RANDOM)
            where rownum = 1;
            
            -- 상태 업데이트하기
            UPDATE TBL_TODAY_PROVERB
            SET USED_STATUS = 1, USED_DATE = TO_CHAR(SYSDATE, 'YYYY-MM-DD')
            WHERE PROVERB_NO = v_proverb_no;
        end if;
    end if;
    
end pcd_get_TODAY_PROVERB;
-------------------------------------------------------------------------------
SET DEFINE OFF;
-- 커뮤니티 글 목록 조회하기 뷰 --
create or replace view view_post_list
as
select POST_NO, FK_EMPNO, 
REPLACE(REPLACE(REPLACE(REPLACE(POST_SUBJECT, '&'||'lt;','<' ),'&'||'gt;','>'),'&amp;', '&'),'&nbsp;',' ') AS POST_SUBJECT,
REGEXP_REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(POST_CONTENT, '&'||'lt;','<' ),'&'||'gt;','>'),'&amp;', '&'),'&nbsp;',' ') , '<[^>]*>' ,'' ) AS POST_CONTENT,
POST_DATE, POST_HIT, POST_STATUS, nvl(commentCnt,0) commentCnt, name, empimg, nvl(likeCnt,0) likeCnt, nvl(fileCnt,0) fileCnt
from TBL_COMMUNITY_POST P
left join 
    (select count(*) commentCnt, fk_post_no 
    from tbl_community_comment
    where comment_status = 1
    group by fk_post_no) C
on post_no = C.fk_post_no
left join
    (select count(*) likeCnt, fk_post_no 
    from tbl_community_like
    group by fk_post_no) L
on post_no = L.fk_post_no
left join
    (select count(*) fileCnt, fk_post_no 
    from tbl_community_post_file
    group by fk_post_no) F
on post_no = F.fk_post_no
join tbl_employee E
on P.fk_empno = empno
and POST_STATUS = 1
;

-- 커뮤니티 글 내용 조회하기 뷰 --
create or replace view view_post_detail
as
select P.*, nvl(commentCnt,0) commentCnt, name, empimg, nvl(likeCnt,0) likeCnt,
lag(post_no, 1) over(order by post_no) as pre_no,
lag(post_subject, 1) over(order by post_no) as pre_subject,
lead(post_no) over(order by post_no) as next_no,
lead(post_subject) over(order by post_no) as next_subject
from TBL_COMMUNITY_POST P
left join 
    (select count(*) commentCnt, fk_post_no 
    from tbl_community_comment
    group by fk_post_no) C
on post_no = C.fk_post_no
left join
    (select count(*) likeCnt, fk_post_no 
    from tbl_community_like
    group by fk_post_no) L
on post_no = L.fk_post_no
join tbl_employee E
on P.fk_empno = empno
and POST_STATUS = 1
;

-- 임시저장 글 조회 뷰 --
create or replace view view_temp_post_list
as
SELECT T.*,
REGEXP_REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(POST_CONTENT, '&'||'lt;','<' ),'&'||'gt;','>'),'&amp;', '&'),'&nbsp;',' ') , '<[^>]*>' ,'' ) AS PLAIN_POST_CONTENT
FROM TBL_COMMUNITY_POST_TEMP T;

-- 좋아요 목록 조회 뷰 --
create or replace view view_like_list
as
select L.*, name, empimg
from TBL_COMMUNITY_LIKE L
join tbl_employee E
on L.fk_empno = empno
;
