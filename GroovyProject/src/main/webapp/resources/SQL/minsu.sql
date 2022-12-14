
-- 사원테이블
create table tbl_employee
(empno              varchar2(15)   not null   -- 사원번호
,cpemail            varchar2(200)  not null  -- 회사이메일 (AES-256 암호화/복호화 대상)
,name               varchar2(30)   not null  -- 회원명
,pwd                varchar2(200)  not null  -- 비밀번호 (SHA-256 암호화 대상)
,position           Nvarchar2(20)            -- 직급
,jubun              varchar2(15)   not null  -- 주민번호
,postcode           varchar2(5)              -- 우편번호
,address            varchar2(200)            -- 주소
,detailaddress      varchar2(200)            -- 상세주소
,extraaddress       varchar2(200)            -- 참고항목
,empimg             varchar2(200)            -- 사원이미지파일
,birthday           varchar2(10)             -- 생년월일   
,bumun              varchar2(100)    not null  -- 부문 
,department         varchar2(100)    not null  -- 부서(팀)
,pvemail            varchar2(200)  not null  -- 개인이메일 (AES-256 암호화/복호화 대상)
,mobile             varchar2(200)  not null  -- 연락처 (AES-256 암호화/복호화 대상)
,depttel            varchar2(30)   not null  -- 내선번호
,joindate           date   default sysdate   -- 입사일자
,empstauts          varchar2(1)    not null  -- 재직구분 (3개월이후 정직원 1정규직, 2비정규직)
,bank               Nvarchar2(20)  not null  -- 은행
,account            number(20)     not null  -- 계좌번호
,annualcnt          varchar2(5) default 15 not null;  -- 연차갯수
,salary             NUMBER(30)    not null;   -- 연봉
,constraint PK_tbl_employee_empno primary key(empno)
,constraint CK_tbl_employee_empstauts check( empstauts in('1','2') )
,constraint UK_tbl_employee_cpemail unique(cpemail)
,constraint UK_tbl_employee_pvemail unique(pvemail)
);
-- Table TBL_EMPLOYEE이(가) 생성되었습니다.

-- 사원테이블 시퀀스
create sequence seq_tbl_employee
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;
-- Sequence SEQ_TBL_EMPLOYEE이(가) 생성되었습니다.

-- 급여테이블
create table tbl_pay
(payno              number        not null       -- 급여번호
,fk_empno           number        not null       -- 사원번호
,pay                number(30)   default 10000   -- 기본급
,annualpay          number(30)                  -- 연차수당
,overtimepay        number(30)                  -- 초과근무수당
,incomtax		    number        default 0.07   -- 소득세
,pension		    number        default 0.05 	-- 국민연금
,insurance	        number        default 0.008 	-- 건강보험
,paymentdate        date  default sysdate       -- 지급일자(특정일자)
,constraint PK_tbl_pay_payno primary key(payno)
,constraint FK_tbl_pay_fk_empno foreign key(fk_empno) references tbl_employee(empno)
);
-- Table TBL_PAY이(가) 생성되었습니다.

insert into tbl_pay(payno,fk_empno,pay,incomtax,pension,insurance,paymentdate )
values(seq_tbl_pay.nextval,10,default,default,default,default,default)

commit
select *
from tbl_pay

-- 지급항목
초과근무수당 :  pay * 1.5*근무시간
연차수당 : 연차수당 일급(시간*8)*연차휴가 미사용갯수

-- 공제항목
소득세 : 0.07
국민연금 : 0.05
고용보험 : 0.008

alter table 
PENSION


-- 급여테이블 시퀀스
create sequence seq_tbl_pay
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;
-- Sequence SEQ_TBL_PAY이(가) 생성되었습니다.

-- 경조비테이블
create table tbl_celebrate
(clbno               number(30)                 not null   -- 경조비신청번호
,fk_empno            number (30)                 not null   -- 사원번호
,clbdate             date default sysdate    not null   -- 신청일자
,clbpay              number(30)              not null   -- 신청금액  (1- 50, 2-20, 3-30 )
,clbtype             Nvarchar2(20)           not null  -- 경조구분 (1명절상여금, 2생일상여금, 3휴가상여금)
,clbstatus           varchar2(1)    default 0    not null  -- 승인여부  (0 미승인, 1 승인)
,constraint PK_tbl_celebrate_clbno primary key(clbno)
,constraint FK_tbl_celebrate_fk_empno foreign key(fk_empno) references tbl_employee(empno)
,constraint CK_tbl_celebrate_clbtype check( clbtype in('1','2','3') )
,constraint CK_tbl_celebrate_clbstatus check( clbstatus in('0','1') )
);
-- Table TBL_CELEBRATE이(가) 생성되었습니다.

drop table tbl_celebrate
commit

insert into tbl_celebrate (clbno, fk_empno, clbdate, clbpay, clbtype, clbstatus)
values(seq_tbl_celebrate.nextval, 13, sysdate, 1, 1, default)

select *
from tbl_celebrate

rollback

-- 경조비테이블시퀀스
create sequence seq_tbl_celebrate
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;
-- Sequence SEQ_TBL_CELEBRATE이(가) 생성되었습니다.

--증명서테이블
create table tbl_certificate
(proofno              number             not null   -- 증명서번호
,fk_empno             number             not null   -- 사원번호
,issuedate            date default sysdate          -- 발급일자(sysdate)
,issueuse             varchar2(1)                   -- 발급용도
,constraint PK_tbl_certificate_proofno primary key(proofno)
,constraint FK_tbl_certificate_fk_empno foreign key(fk_empno) references tbl_employee(empno)
,constraint CK_tbl_certificate_issueuse check( issueuse in('1','2') )  -- 1 은행제출용, 2 공공기관용
);
-- Table TBL_CERTIFICATE이(가) 생성되었습니다.


-- 증명서테이블시퀀스
create sequence seq_tbl_certificate
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;
-- Sequence SEQ_TBL_CERTIFICATE이(가) 생성되었습니다.



-- 근태 테이블
tbl_attendance
( fk_empno       number  not null                -- 사원번호
, workdate        date default sysdate not null  -- 날짜(매일 1am 마다 insert 됨)
, workstart      date                            -- 출근시간
, workend        date                            -- 퇴근시간
, trip           Nvarchar2(1) default 'N'        -- 출장여부
, tripstart      date                            -- 출장시작 (ex. 2022-10-10 11:00)
, tripend        date                            -- 출장종료 (ex. 2022-10-10 11:00)
, dayoff         Nvarchar2(1) default 'N'        -- 연차여부
, extendstart    date                            -- 연장근무시작시간 
, constraint FK_tbl_attendance_fk_empno Foreign key(fk_empno) references tbl_employee(empno)
, constraint PK_tbl_attendance_fk_empno_workdate primary key(fk_empno, workdate)
);

select (extendstart-workend)*24 AS overhour, fk_empno
from tbl_attendance

-- 연장근무시간과 퇴근시간 차이시간을 알아오기(시간단위로)
select (extendstart-workend)*24 AS overhour, fk_empno
from tbl_attendance
where fk_empno = 10 and to_char(workdate, 'yyyy-mm-dd') = '2022-12-05'

-- 연차가 n으로 남아있다면(일급주기)
select fk_empno,dayoff
from tbl_attendance
where dayoff = 'Y'

-- 급여테이블과 join
insert all
into tbl_pay(payno,fk_empno,pay,overtimepay,annualpay,incomtax,pension,insurance,paymentdate)
values(seq_tbl_pay.nextval, B.fk_empno, pay, overhour*pay as overtimepay, anuualcnt*pay*8 AS anuualpay,default,default,default,sysdate)
select payno, B.fk_empno, pay, overhour*pay as overtimepay, anuualcnt*pay*8 AS anuualpay,incomtax,pension,insurance,paymentdate
from 
    (
    select fk_empno, nvl((extendstart-workend)*24,0) AS overhour --, nvl2(dayoff,1,0) AS dayoff 
         , case when dayoff ='N' then 1 else 0 end as anuualcnt-- 만약에 연차가 n이면 급여테이블에서 돈지급, y라면 미지급
            -- ,nvl2(dayoff,1,0)
    from tbl_attendance
    where fk_empno = 10 and to_char(workdate, 'yyyy-mm-dd') = '2022-12-05'
    ) A
    join 
    ( 
    select fk_empno,pay,annualpay,overtimepay,incomtax,pension,insurance,paymentdate
    from tbl_pay
    where fk_empno = 10
    )B
    on A.fk_empno = B.fk_empno
where fk_empno = 10


-- 급여테이블에서 연장근무수당이랑 연차수당 컬럼이 있음
-- 근테테이블에서 연장근무수당은 퇴근시간 - 연장근무시작시간 을 알아와서 급여테이블의 PAY(시급)*알아온시간으로 추가근무수당지급
-- 근테테이블의 연차수당은 만약 연차를 사용했다면 Y로 나오고 연차를 사용하지 않은 경우라면 N으로 나온다. 연차를 사용하지 않은 N인경우 PAY(시급)*8로 계산해서 연차수당지급
-- 마지막에 TBL_PAY테이블에 수당을 스케줄러를 사용해서 급여INSERT하기 


select overtimepay, annualpay
from tbl_pay;

select *
from tbl_pay;

insert into tbl_pay(......) values(  ? , ? ,b  )

select to_char(workend, 'yyyy-mm-dd hh24:mi:ss') , to_char(extendstart, 'yyyy-mm-dd hh24:mi:ss') , workend - extendstart, 
       (extendstart - workend), (extendstart - workend)*24, (extendstart - workend)*24*20000 as b
from tbl_attendance
where extendstart is not null;

select workend - extendstart   AS '연장근무수당'
from tbl_attendance


-- 퇴근시간 - 추가근무시간 알아오기
select to_date(workdate, 'yyyy-mm-dd hh24-mi-ss') AS workdate, to_date(extendstart,'yyyy-mm-dd hh24-mi-ss')AS extendstart, to_date(workend,'yyyy-mm-dd hh24-mi-ss')workend 
from tbl_attendance
where fk_empno = 43

delete from tbl_attendance
where fk_empno = 43

UPDATE tbl_attendance SET EXTENDSTART = null
where fk_empno = 43; 


commit

select EXTENDSTART
from tbl_attendance
where fk_empno = 43 and workdate = TO_char(workdate, 'YYYY/MM/DD HH:MI:SS'  )

select to_char(extendstart,'yyyy-mm-dd hh24-mi-ss')AS extendstart, to_char(workend,'yyyy-mm-dd hh24-mi-ss')workend, workstart
from tbl_attendance
where  to_char(workend,'yyyy-mm-dd hh24-mi-ss') = '2022/12/05'

select to_date(workend,'hh24:mi:ss')- to_date(EXTENDSTART,'hh24:mi:ss')
from tbl_attendance
where fk_empno = 43; 

rollback

select *
from tbl_attendance
order by fk_empno desc



-- 이미지 칼럼 추가
alter table tbl_employee
   add joindate  VARCHAR2(15)    not null; 
   
-- 연봉컬럼추가
alter table tbl_employee
   add salary  NUMBER(30)    not null; 
   
update tbl_employee set salary = 50000000

commit
   
   update tbl_employee set joindate = '2022-12-02'
insert into tbl_employee (joindate) values ('2022-12-02')
   
-- 컬럼삭제
alter table tbl_employee drop column pay

ALTER TABLE tbl_employee
ADD [CONSTRAINT UK_tbl_employee_pay]
unique(pay);

-- 제약추가하기
ALTER TABLE tbl_employee add constraint  UK_tbl_employee_pay  unique(pay);
alter table tbl_employee constraint UK_tbl_employee_pay unique(pay) ;

select joindate
from tbl_employee

commit

desc TBL_EMPLOYEE

-- 성별칼럼추가
alter table tbl_employee add gender varchar2(2);

-- 연차칼럼추가
alter table tbl_employee add ANNUALCNT varchar2(5) default 15 not null;

-- 급여 디폴트값걸기
alter table tbl_pay add pay  number(30)  default 10000 not null;


-- 칼럼 변경
alter table tbl_pay modify pay NUMBER(30) default 10000   not null;



alter table tbl_employee modify salary NUMBER(30)    not null;
-- pvemail 칼럼변경
alter table tbl_employee modify pvemail varchar2(200) null;

select joindate
from tbl_employee

rollback
alter table tbl_employee MODIFY annualcnt varchar2(5);

update tbl_employee set pay = '1'
where account 

update tbl_employee set pay = 'n'
where annualcnt is null 

select *
from tbl_employee
where department = '인사총무팀'
order by empno 

update tbl_employee set depttel = '102'
where name ='김민수' 

commit

rollback

delete from tbl_employee
where empno = 7

INSERT INTO tbl_employee 
(empno,cpemail,name,pwd,position,jubun,postcode,bumun,department,pvemail
,mobile,depttel,joindate,empstauts,bank,account,annualcnt)
VALUES(SEQ_TBL_EMPLOYEE.NEXTVAL, 'minsu@groovy.com', '김민수', 'qwer1234$',
'책임자', '981210-2222222', '12345', 'IT사업부문','개발팀','alstn8109@naver.com',
'010-1111-2222','201','2022/11/18','1','국민은행','21520204188',15);

INSERT INTO tbl_employee 
(empno,cpemail,name,pwd,position,jubun,postcode,bumun,department,pvemail
,mobile,depttel,joindate,empstauts,bank,account,annualcnt)
VALUES(SEQ_TBL_EMPLOYEE.NEXTVAL, 'mangdb@groovy.com', '맹단비', 'qwer1234$',
'선임', '990102-2222222', '12345', '경영지원본부','인사총무팀','mangdb@naver.com',
'010-1111-2222','106','2022/11/18','1','국민은행','123456789',15);

commit

-- 로그인 조회
select empno, cpemail, name, pwd, position, jubun, postcode, address, detailaddress
     , extraaddress,empimg,birthday, bumun,department,pvemail,mobile,depttel,joindate
     ,empstauts,bank, account,annualcnt, empimg
from tbl_employee
where cpemail = minsu@groovy.com and  pwd = 'qwer1234$'


select *
from tbl_employee

-- 사원테이블에 정보넣기
INSERT INTO tbl_employee 
(empno,cpemail,name,position,jubun,postcode,ADDRESS,DETAILADDRESS, EXTRAADDRESS
,EMPIMG,birthday, bumun,department,pvemail
,mobile,depttel,joindate,empstauts,bank,account,annualcnt,gender)
VALUES


select *
from tbl_certificate


-- 증명서테이블에 insert
insert into tbl_certificate 
values(seq_tbl_certificate.nextval, 13, sysdate, '1')

-- 증명서 테이블신청내역 조회
select proofno,fk_empno, issuedate, issueuse
from tbl_certificate
where fk_empno = '13' 
commit

select proofno,fk_empno, to_char(issuedate, 'yyyy-mm-dd') issuedate , issueuse
from tbl_certificate

select cpemail
from tbl_employee

select position, bumun,department,
		    fk_position_no, fk_bumun_no, fk_department_no
		from tbl_employee




insert into tbl_employee (empimg)
values ('dog.png')
where 




select *
from tbl_employee
where empno = 13

-- 칼럼 값변경
ALTER TABLE tbl_employee MODIFY pwd varchar2(200) DEFAULT 1111;
ALTER TABLE tbl_employee MODIFY joindate varchar2(10) DEFAULT SYSDATE;

-- 국민연급 값변경
ALTER TABLE tbl_pay MODIFY pension number default 0.05  

-- 경조비 목록 조회
select clbno, fk_empno, to_char(clbdate, 'yyyy-mm-dd') AS clbdate, clbpay, clbtype, clbstatus
from tbl_celebrate
where fk_empno = 13


drop table tbl_celebrate
drop sequence tbl_celebrate

ALTER TABLE tbl_employee MODIFY EMPSTAUTS varchar2(1)  DEFAULT 1;

update tbl_employee set postcode = '48060' , address = '부산 해운대구 APEC로 17' , DETAILADDRESS='108동', EXTRAADDRESS='우동', EMPIMG= 'null', PVEMAIL='alstn8109@naver.com'
where empno = 13

rollback

commit


select count(*)
		from tbl_employee
		where pvemail = 'alstn8109@naver.com'
        
        


select payno, fk_empno,pay,annualpay,overtimepay,paymentdate
from tbl_pay

insert tbl_pay into payno='seq_tbl_pay.nextval', fk_empno='13', pay= 3000000, annualpay=100000, overtimepay=100000, paymentdate = sysdate
where empno = 13

insert into tbl_pay  
values(seq_tbl_pay.nextval, 10, 5000000, 100000, 100000,sysdate)


select payno, fk_empno, pay, annualpay, overtimepay, paymentdate
from tbl_pay 


-- 급여 테이블 목록 조회
select name, payno, fk_empno, pay, annualpay, overtimepay, paymentdate
from tbl_pay P join tbl_employee e
on p.fk_empno = e.empno


select name, clbno, fk_empno, to_char(clbdate, 'yyyy-mm-dd') AS clbdate, clbpay, clbtype, clbstatus
from tbl_celebrate C join tbl_employee E
on C.fk_empno = E.empno
order by clbno desc


select 
from tbl_celebrate

select name, clbno, fk_empno, to_char(clbdate, 'yyyy-mm-dd') AS clbdate, clbpay, clbtype, clbstatus
from tbl_celebrate C join tbl_employee E
on C.fk_empno = E.empno
where clbstatus = '0'
order by clbno desc

update tbl_celebrate set clbstatus = '1'
where fk_empno = 13

select *
from tbl_celebrate

insert into tbl_celebrate values(seq_tbl_celebrate.nextval, 14,sysdate, 200000, 3,0)
commit


-- 재직증명서 모두 조회
select name, proofno, fk_empno, to_char(issuedate, 'yyyy-mm-dd') AS issuedate, issueuse
		from tbl_certificate C join tbl_employee E
		on C.fk_empno = E.empno
		order by proofno desc
        
        
        
      create table tbl_certificate
(proofno              number             not null   -- 증명서번호
,fk_empno             number             not null   -- 사원번호
,issuedate            date default sysdate          -- 발급일자(sysdate)
,issueuse   

insert into tbl_employee 
select *
from tbl_pay P right join tbl_employee e
on p.fk_empno = e.empno


select *
from tbl_employee
where name = '아이유'

update tbl_employee
set mobile = '010-1234-5678';
commit;

update tbl_employee set pwd = 'qwer1234$'
where name = '아이유'

commit

insert into TBL_PAY(PAYNO, FK_EMPNO, PAY, ANNUALPAY, OVERTIMEPAY, PAYMENTDATE)
values(seq_tbl_pay.nextval, 10,5000000, 100000, 200000,sysdate)

commit

SELECT PAYNO, FK_EMPNO, PAY, ANNUALPAY, OVERTIMEPAY, PAYMENTDATE
FROM TBL_PAY


-- 급여정보 조회
select E.empno, name, bumun, department, position, ceil(salary/12) as salary,
        PAYNO, FK_EMPNO, PAY, ANNUALPAY, OVERTIMEPAY, to_char(paymentdate, 'yyyy-mm-dd') AS paymentdate
from tbl_employee E right join TBL_PAY P
on E.empno = P.fk_empno
where name = '김민수'



(payno               number        not null       -- 급여번호
,fk_empno            number        not null       -- 사원번호
,pay                 number(30)   default 10000   -- 기본급
,annualpay           number(30)                  -- 연차수당
,overtimepay         number(30)                  -- 초과근무수당
,paymentdate   

select payno, fk_empno,money,annualpay, overtimepay, paymentdate, money*3.3 as tax
from V
(select payno, fk_empno, ceil(salary/12) as money, annualpay, overtimepay, paymentdate
from tbl_pay P join tbl_employee E
on P.fk_empno = E.empno)

-- 급여테이블에 넣는 방법
select payno, fk_empno, money, annualpay, overtimepay, paymentdate, round(money*0.07) as incomtax, round(money*0.55) as pension, round(money*0.07) as insurance
from 
(
    select empno, ceil(salary/12) as money
    from tbl_employee
)A
join
(
    select payno,annualpay, overtimepay, paymentdate ,fk_empno
    from tbl_pay
)B
on  A.empno = B.fk_empno


-- 지급항목
초과근무수당 :  pay * 1.5*근무시간
연차수당 : 연차수당 일급(시간*8)*연차휴가 미사용갯수

-- 공제항목
소득세 : 0.07
국민연금 : 0.55
건강보험 : 0.07

insert into tbl_pay set 

insert into tbl_pay (salary,payno, fk_empno,annualpay, overtimepay, paymentdate)
select salary
from tbl_employee





insert into TBL_PAY (payno,fk_empno,pay,overtimepay,incomtax,pension,insurance,paymentdate)
values(seq_tbl_pay.nextval,13,default, 100000,default, default, default,sysdate)
where fk_empno = 13
commit
select *
from TBL_PAY

-- 급여테이블 조회
select PAYNO, FK_EMPNO, NAME, BUMUN, DEPARTMENT, POSITION, SALARY,PAY ,ANNUALPAY,OVERTIMEPAY,PAYMENTDATE,OVERPAY,
        INCOMTAX,PENSION,INSURANCE, ALLPAY, tax,
        (ALLPAY - tax) AS monthpay
from 
    (
        select PAYNO, FK_EMPNO, NAME, BUMUN, DEPARTMENT, POSITION, SALARY,PAY ,ANNUALPAY,OVERTIMEPAY,PAYMENTDATE,OVERPAY,
                    INCOMTAX,PENSION,INSURANCE, 
                    (SALARY+ANNUALPAY+OVERTIMEPAY) AS ALLPAY,
                    (INCOMTAX+PENSION+INSURANCE) AS tax
                    
        from 
        (
            SELECT PAYNO, FK_EMPNO, NAME, BUMUN, DEPARTMENT, POSITION, SALARY,PAY ,ANNUALPAY,OVERTIMEPAY,PAYMENTDATE, (ANNUALPAY+OVERTIMEPAY) AS OVERPAY,
                    CEIL(SALARY*INCOMTAX) AS INCOMTAX, CEIL(SALARY*PENSION)AS PENSION, CEIL(SALARY*INSURANCE)AS INSURANCE
            FROM
                (SELECT E.EMPNO, NAME, BUMUN, DEPARTMENT, POSITION, ROUND(SALARY/12)AS SALARY,
                        PAYNO, FK_EMPNO, PAY, NVL(ANNUALPAY,0) AS ANNUALPAY, NVL(OVERTIMEPAY,0)  AS OVERTIMEPAY, TO_CHAR(PAYMENTDATE, 'YYYY-MM-DD') AS PAYMENTDATE
                        ,INCOMTAX,PENSION,INSURANCE
                FROM TBL_EMPLOYEE E RIGHT JOIN TBL_PAY P
                ON E.EMPNO = P.FK_EMPNO
            )V
        )A
    )P

-- ====================================================================================================================================== --

-- 설문조사테이블
create table  tbl_survey 
(surno		    number(20)        		not null   -- 설문번호
,fk_empno	    number   		        not null   -- 사원번호
,surtitle  	   	Nvarchar2(30)  		    not null   -- 설문제목
,surexplain    	Nvarchar2(200)        		       -- 설문설명
,surcreatedate 	date  default sysdate   not null   -- 설문생성일
,surstart 	    date  			        not null   -- 설문시작일
,surend	   	    date  			        not null   -- 설문종료일
,surstatus    	number(1)   default 1  	not null   -- 상태(0 임시저장, 1 저장)
,suropenstatus  number(1)   default 1   not null   -- 설문결과공개여부(0비공개, 1공개)
,fk_surtarget   number(1)   default 1              -- 설문대상(1전직원, 0직접선택)
,constraint PK_tbl_survey_surno primary key(surno)
,constraint FK_tbl_survey_fk_empno foreign key(fk_empno) references tbl_employee(empno)
,constraint CK_tbl_survey_surstatus check( surstatus in('0','1') )
,constraint CK_tbl_survey_suropenstatus check(suropenstatus in('0','1') )
);


-- 설문조사테이블 시퀀스
create sequence seq_tbl_survey
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

   
-- 설문조사대상테이블
CREATE TABLE TBL_TARGET
(SURTARGET      NUMBER(1)    DEFAULT 1    NOT NULL   -- 설문대상
,FK_SURNO		NUMBER(20)       NOT NULL   -- 설문번호
,CONSTRAINT PK_TBL_TARGET_SURTARGET PRIMARY KEY(SURTARGET)
,CONSTRAINT FK_TBL_TARGET_FK_SURNO FOREIGN KEY(FK_SURNO) REFERENCES TBL_SURVEY(SURNO)ON DELETE CASCADE
);

-- 설문조사대상테이블 시퀀스
create sequence seq_tbl_target
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;


-- 설문조사문항테이블
CREATE TABLE  TBL_ASK
(QUESTNO 	    NUMBER(20)      NOT NULL       -- 문항번호
,FK_SURNO		NUMBER(20)      NOT NULL       -- 설문번호
,QUESTION		VARCHAR2(300)   NOT NULL       -- 설문질문
,OPTION1		VARCHAR2(100)                  -- 선택지1
,OPTION2		VARCHAR2(100)         	       -- 선택지2
,OPTION3		VARCHAR2(100)        	       -- 선택지3
,OPTION4		VARCHAR2(100)         	       -- 선택지4
,OPTION5		VARCHAR2(100)         	       -- 선택지5
,CONSTRAINT PK_TBL_ASK_QUESTNO   PRIMARY KEY(QUESTNO)
,CONSTRAINT FK_TBL_ASK_FK_SURNO FOREIGN KEY(FK_SURNO) REFERENCES TBL_SURVEY(SURNO)ON DELETE CASCADE
);

-- 칼럼 변경
alter table tbl_ask modify option1 varchar2(100) 
alter table tbl_ask modify option2 varchar2(100) 
alter table tbl_ask modify option3 varchar2(100) 
alter table tbl_ask modify option4 varchar2(100) 
alter table tbl_ask modify option5 varchar2(100) 
delete from tbl_ask
commit
drop table tbl_ask

-- 설문조사문항테이블 시퀀스
create sequence seq_tbl_ask
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

drop table tbl_joinsurvey

-- 설문참여테이블
create table  TBL_JOINSURVEY 
(JOINSURNO 	number(20)        not null       -- 설문참여번호
,FK_EMPNO	number            not null   	 -- 사원번호
,FK_SURNO   number(20)        not null       -- 설문번호
,FK_QUESTNO	number(20)        not null       -- 문항번호
,ANSWER		number(20)        not null       -- 답변
,SURJOINDATE date  default SYSDATE  not null  -- 답변제출일
,constraint PK_TBL_JOINSURVEY_JOINSURNO  primary key(JOINSURNO)
,constraint FK_TBL_JOINSURVEY_FK_EMPNO foreign key(FK_EMPNO) references TBL_EMPLOYEE(EMPNO)on delete cascade
,constraint FK_TBL_JOINSURVEY_FK_SURNO foreign key(FK_SURNO) references TBL_SURVEY(SURNO)on delete cascade
,constraint FK_TBL_JOINSURVEY_FK_QUESTNO foreign key(FK_QUESTNO) references TBL_ASK(QUESTNO)on delete cascade
);

select *
from tbl_joinsurvey

-- 설문참여테이블 시퀀스
create sequence seq_tbl_joinsurvey
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

commit


-- 시퀀스조회
SELECT seq_tbl_survey.CURRVAL FROM DUAL;

SELECT seq_tbl_survey.NEXTVAL FROM DUAL;
SELECT seq_tbl_survey.CURRVAL FROM DUAL
where surno=1;


SELECT surno from tbl_survey where surno = 1

delete from tbl_survey where surno = 56

SELECT *
FROM TBL_ASK

--- 설문테이블 insert
insert into tbl_survey(surno,fk_empno,surtitle,surexplain,surcreatedate,surstart,surend,surstatus,suropenstatus)
values(seq_tbl_survey.nextval,13,'설문조사','확인해보기',sysdate,'2022-12-10','2022-12-20',default, default)

select *
from tbl_ask

select *
from tbl_survey
order by surno desc


insert into tbl_ask(questno,fk_surno,question,option1)
values(seq_tbl_ask.nextval,2,'팀플설문조사 많이 어려운가요?', 1)


drop table tbl_ask
drop table tbl_joinsurvey
drop table tbl_target




select * from tbl_survey
delete from tbl_survey 
where surno = 2
commit
--

select surstart,surend,surtitle,sursubdate,
        surno,surexplain,
from tbl_survey S left join tbl_joinsurvey J
on S.surno = J.fk_surno
where J.fk_empno = '13'

select sursubdate
from tbl_joinsurvey 
where joinsurno = 13

-- 설문리스트 조회
SELECT SURTITLE, SURNO, TO_CHAR(SURSTART, 'yyyy-mm-dd')SURSTART,TO_CHAR(SUREND, 'yyyy-mm-dd')SUREND,TO_CHAR(SURSUBDATE, 'yyyy-mm-dd') SURSUBDATE
FROM TBL_SURVEY S LEFT JOIN TBL_JOINSURVEY J
ON S.SURNO = J.FK_SURNO

-- 설문내용 조회
SELECT QUESTNO,FK_SURNO,QUESTION,OPTION1,OPTION2,OPTION3,OPTION4,OPTION5
      ,SURTITLE, surexplain
FROM TBL_ASK A left JOIN TBL_SURVEY S
ON A.FK_SURNO = S.SURNO 
where FK_SURNO = 54 and fk_empno = 13


-- 설문 조회 및 페이지네이션
SELECT *
FROM (SELECT ROWNUM AS RNO, v.*
    FROM( 
        SELECT SURTITLE, SURNO, S.FK_EMPNO, TO_CHAR(SURSTART, 'yyyy-mm-dd')SURSTART,TO_CHAR(SUREND, 'yyyy-mm-dd')SUREND,TO_CHAR(SURSUBDATE, 'yyyy-mm-dd') SURSUBDATE
        FROM TBL_SURVEY S LEFT JOIN TBL_JOINSURVEY J
        ON S.SURNO = J.FK_SURNO
        where S.FK_EMPNO = 13 
        ORDER BY SURNO DESC
    )V)
WHERE RNO BETWEEN #{startRno} AND #{endRno}

      SELECT QUESTNO,FK_SURNO,QUESTION,OPTION1,OPTION2,OPTION3,OPTION4,OPTION5
		      ,SURTITLE, SUREXPLAIN
		FROM TBL_ASK A left JOIN TBL_SURVEY S
		ON A.FK_SURNO = S.SURNO 
		WHERE FK_SURNO = 19
        
        
select *
from TBL_Ask a left join tbl_survey s
on a.fk_surno = s.surno
where joinsurno = 13

select *
from tbl_joinsurvey

--설문조사 참여테이블
insert into tbl_joinsurvey(joinsurno,fk_empno,fk_surno,fk_questno,answer,surjoindate)
                    values(seq_tbl_joinsurvey.nextval,13,57,193,3, sysdate)

-- 관리자 설문목록결과 조회
SELECT *
    FROM (SELECT ROWNUM AS RNO, V.*
        FROM( 
            SELECT SURNO,SURTITLE,SUREXPLAIN,SURCREATEDATE,SURSTART,SUREND,SURSTATUS,SURTARGET
            FROM TBL_SURVEY S LEFT JOIN TBL_TARGET T
            ON S.SURNO = T.FK_SURNO
            ORDER BY SURNO DESC
        )V)
    WHERE RNO BETWEEN #{startRno} AND #{endRno}
    
SELECT COUNT(*) AS CNT , count(surtitle)
FROM TBL_SURVEY S join an

select count(*)
from tbl_joinsurvey


select *
from tbl_joinsurvey

select *
from tbl_survey 

select *
from tbl_target

select *
from tbl_employee

select *
from tbl_ask

select count(surjoindate)from tbl_joinsurvey

SELECT COUNT(fk_empno)FROM TBL_JOINSURVEY
where fk_surno = 57

SELECT COUNT(empno)FROM tbl_employee

SELECT PWD
FROM tbl_employee
WHERE NAME ='김민수'

	SELECT COUNT(surjoindate)FROM TBL_JOINSURVEY
    WHERE FK_SURNO = 13


 SELECT SURNO,SURTITLE,SUREXPLAIN,TO_CHAR(SURCREATEDATE, 'YYYY-MM-DD')SURCREATEDATE,SURSTART,SUREND,SURSTATUS,SURTARGET
        FROM TBL_SURVEY S LEFT JOIN TBL_TARGET T
        ON S.SURNO = T.FK_SURNO

INSERT INTO TBL_SURVEY(SURNO,FK_EMPNO,SURTITLE,SUREXPLAIN,SURCREATEDATE,SURSTART,SUREND,SURSTATUS,SUROPENSTATUS, SURTARGET)
		VALUES(#{surno},#{fk_empno},#{surtitle},#{surexplain},sysdate,#{surstart},#{surend},default, default,#{surtarget})
 SELECT *
 FROM       TBL_SURVEY 
        
delete from TBL_SURVEY
where surno = 47

rollback;



 SELECT SURNO, SURTITLE, SUREXPLAIN, TO_CHAR(SURCREATEDATE,'YYYY-MM-DD')SURCREATEDATE
        	  ,TO_CHAR(SURSTART,'YYYY-MM-DD') SURSTART,TO_CHAR(SUREND,'YYYY-MM-DD')SUREND, SURSTATUS,SURTARGET
        FROM TBL_SURVEY S LEFT JOIN TBL_TARGET T
        ON S.SURNO = T.FK_SURNO
        WHERE SURNO = 47


SELECT QUESTNO,FK_SURNO,QUESTION,OPTION1,OPTION2,OPTION3,OPTION4,OPTION5
		      ,SURTITLE, SUREXPLAIN
		FROM TBL_ASK A left JOIN TBL_SURVEY S
		ON A.FK_SURNO = S.SURNO 
		WHERE FK_SURNO = #{surno}
        

-- 제약추가하기
ALTER TABLE tbl_employee add constraint  UK_tbl_employee_pay  unique(pay);

ALTER TABLE tbl_survey add constraint  FK_tbl_survey_fk_surtarget foreign key(fk_surtarget) references tbl_target(surtarget)ON DELETE CASCADE;

alter table tbl_survey add column surtarget



-- 컬럼삭제
alter table tbl_survey drop column FK_surtarget
,constraint FK_tbl_joinsurvey_fk_questno foreign key(fk_questno) references tbl_ask(questno)ON DELETE CASCADE
COMMIT

SELECT *
FROM TBL_SURVEY
ORDER BY SURNO DESc

select *
from tbl_target


SELECT PAYNO, FK_EMPNO, NAME, BUMUN, DEPARTMENT, POSITION, SALARY,PAY ,ANNUALPAY,OVERTIMEPAY,PAYMENTDATE,OVERPAY,
	        INCOMTAX,PENSION,INSURANCE, ALLPAY, TAX,
	        (ALLPAY - TAX) AS MONTHPAY
	FROM 
	    (
	        SELECT PAYNO, FK_EMPNO, NAME, BUMUN, DEPARTMENT, POSITION, SALARY,PAY ,ANNUALPAY,OVERTIMEPAY,PAYMENTDATE,OVERPAY,
	                    INCOMTAX,PENSION,INSURANCE, 
	                    (SALARY+ANNUALPAY+OVERTIMEPAY) AS ALLPAY,
	                    (INCOMTAX+PENSION+INSURANCE) AS TAX
	                    
	        FROM 
	        (
	            SELECT PAYNO, FK_EMPNO, NAME, BUMUN, DEPARTMENT, POSITION, SALARY,PAY ,ANNUALPAY,OVERTIMEPAY,PAYMENTDATE, (ANNUALPAY+OVERTIMEPAY) AS OVERPAY,
	                    CEIL(SALARY*INCOMTAX) AS INCOMTAX, CEIL(SALARY*PENSION)AS PENSION, CEIL(SALARY*INSURANCE)AS INSURANCE
	            FROM
	                (SELECT E.EMPNO, NAME, BUMUN, DEPARTMENT, POSITION, ROUND(SALARY/12)AS SALARY,
	                        PAYNO, FK_EMPNO, PAY, NVL(ANNUALPAY,0) AS ANNUALPAY, NVL(OVERTIMEPAY,0)  AS OVERTIMEPAY, TO_CHAR(PAYMENTDATE, 'YYYY-MM-DD') AS PAYMENTDATE
	                        ,INCOMTAX,PENSION,INSURANCE
	                FROM TBL_EMPLOYEE E RIGHT JOIN TBL_PAY P
	                ON E.EMPNO = P.FK_EMPNO
                   where empno = 13 and payno = 1
	            )V
	        )A
	    )P


        SELECT *
	    FROM (SELECT ROWNUM AS RNO, V.*
	        FROM( 
	            SELECT SURNO,SURTITLE,SUREXPLAIN,TO_CHAR(SURCREATEDATE, 'YYYY-MM-DD')SURCREATEDATE,TO_CHAR(SURSTART, 'YYYY-MM-DD')SURSTART
	            		,TO_CHAR(SUREND, 'YYYY-MM-DD')SUREND,SURSTATUS
	            FROM TBL_SURVEY S LEFT JOIN TBL_TARGET T
	            ON S.SURNO = T.fk_surno
	         	
	            ORDER BY SURNO DESC
	        )V)
	    WHERE RNO BETWEEN #{startRno} AND #{endRno}
        

INSERT INTO TBL_DRAFT_FILE (DRAFT_FILE_NO, FK_DRAFT_NO, ORIGINALFILENAME, FILENAME, FILESIZE)
		SELECT SEQ_DRAFT_FILE_NO.NEXTVAL AS DRAFT_FILE_NO, A.* 
		FROM (
		<foreach collection="list" item="dfvo" separator="union all">
			SELECT #{dfvo.fk_draft_no} AS FK_DRAFT_NO, #{dfvo.originalFilename} AS ORIGINALFILENAME,
			#{dfvo.filename} AS FILENAME, #{dfvo.filesize} AS FILESIZE FROM DUAL
		</foreach>) A
        
        
        INSERT INTO TBL_JOINSURVEY(JOINSURNO,FK_EMPNO,FK_SURNO,FK_QUESTNO,ANSWER,SURJOINDATE)
        VALUES(seq_tbl_joinsurvey.nextval,#{jvoList.fk_empno},#{jvoList.fk_surno},#{jvoList.fk_questno},#{jvoList.answer}, sysdate)


INSERT INTO TBL_JOINSURVEY(JOINSURNO,FK_EMPNO,FK_SURNO,FK_QUESTNO,ANSWER,SURJOINDATEm)
select SEQ_TBL_JOINSURVEY.NEXTVAL AS JOINSURNO,FK_EMPNO,FK_SURNO,FK_QUESTNO,ANSWER,sysdate as SURJOINDATE
from (
        SELECT JOINSURNO,FK_EMPNO,FK_SURNO,FK_QUESTNO,ANSWER,TO_CHAR(SURJOINDATE, 'yyyy-mm-dd')AS SURJOINDATE
        FROM TBL_JOINSURVEY
        )A;
        
        
    SELECT CLBNO, FK_EMPNO, to_char(CLBDATE, 'YYYY-MM-DD') AS CLBDATE, CLBPAY, CLBTYPE, CLBSTATUS
		FROM TBL_CELEBRATE
        

