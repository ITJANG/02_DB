/*
[JOIN 용어 정리]
  오라클                                   SQL : 1999표준(ANSI)
----------------------------------------------------------------------------------------------------------------
등가 조인                               내부 조인(INNER JOIN), JOIN USING / ON
                                            + 자연 조인(NATURAL JOIN, 등가 조인 방법 중 하나)
----------------------------------------------------------------------------------------------------------------
포괄 조인                             왼쪽 외부 조인(LEFT OUTER), 오른쪽 외부 조인(RIGHT OUTER)
                                            + 전체 외부 조인(FULL OUTER, 오라클 구문으로는 사용 못함)
----------------------------------------------------------------------------------------------------------------
자체 조인, 비등가 조인                             JOIN ON
----------------------------------------------------------------------------------------------------------------
카테시안(카티션) 곱                        교차 조인(CROSS JOIN)
CARTESIAN PRODUCT


- 미국 국립 표준 협회(American National Standards Institute, ANSI) 미국의 산업 표준을 제정하는 민간단체.
- 국제표준화기구 ISO에 가입되어 있음.
*/
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- JOIN
-- 하나 이상의 테이블에서 데이터를 조회하기 위해 사용.
-- 수행 결과는 하나의 Result Set으로 나옴.


-- (참고) JOIN은 서로 다른 테이블의 행을 하나씩 이어 붙이기 때문에
--       시간이 오래 걸리는 단점이 있다!


/*
- 관계형 데이터베이스에서 SQL을 이용해 테이블간 '관계'를 맺는 방법.


- 관계형 데이터베이스는 최소한의 데이터를 테이블에 담고 있어
  원하는 정보를 테이블에서 조회하려면 한 개 이상의 테이블에서
  데이터를 읽어와야 되는 경우가 많다.
  이 때, 테이블간 관계를 맺기 위한 연결고리 역할이 필요한데,
  두 테이블에서 같은 데이터를 저장하는 컬럼이 연결고리가됨.  
*/


------------------------------------------------------------------------------------

-- 사번, 이름, 부서코드 부서명 조회
-- EMPLOYEE.DEPT_CODE와 DEPARTMENT.DEPT_ID가 같다
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID));

-- 1. INNER JOIN (내부 조인) ( == EQAUL JOIN(등가 조인))
--> 연결되는 컬럼의 값이 일치하는 행들만 조인
--> 일치하는 값이 없는 행은 조인에서 제외
--> JOIN의 DEFAULT

-- 작성 방법(ANSI 구문 / 오라클 구문)
-- ANSI (USING / ON)

-- 1) 두 컬럼명이 다른 경우

-- EMPLOYEE, JOB 테이블 참조하여
-- 사번, 이름, 직급코드, 직급명 조회

-- ANSI : ON
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

-- ORACLE
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;

-- DEPARTMENT 테이블, LOCATION 테이블
-- 부서명, 지역명 조회

-- ANSI
SELECT DEPT_TITLE, LOCAL_NAME
FROM DEPARTMENT
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);

-- ORACLE
SELECT DEPT_TITLE, LOCAL_NAME
FROM DEPARTMENT, LOCATION
WHERE LOCATION_ID = LOCAL_CODE;

-- 2) 두 컬럼명이 같은 경우

-- EMPLOYEE, JOB 테이블 참조하여
-- 사번, 이름, 직급코드, 직급명 조회

-- ANSI : USING
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);

-- ORACLE : 테이블 별칭 사용
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;

-----------------------------------------------------

-- 2. OUTER JOIN(외부 조인)
-- 연결되는 컬럼의 값이 일치하지 않는 행도 조인에 포함
-- OUTER JOIN 반드시 명시(LEFT, RIGHT 명시 시 생략)

-- 1) LEFT [OUTER] JOIN : 합치기에 사용한 두 테이블 중 왼편에 기술된 
-- 테이블의 컬럼 수 기준으로 JOIN
--> 왼편에 작성된 테이블의 모든 행이 결과에 포함
-- (JOIN 이 안되는 행도 결과에 포함)

-- ANSI
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
LEFT JOIN DEPARTMENT
ON (DEPT_CODE = DEPT_ID);

-- ORACLE : 반대쪽 테이블 컬럼에 (+)
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);


-- 2) RIGHT [OUTER] JOIN : 합치기에 사용한 두 테이블중
-- 오른편에 기술된 테이블의 컬럼 수를 기준으로 JOIN

-- ANSI
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
RIGHT JOIN DEPARTMENT
ON (DEPT_CODE = DEPT_ID);

-- ORACLE : 반대쪽 테이블 컬럼에 (+)
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID;


-- 3) FULL [OUTER] JOIN : 합치기에 사용한 두 테이블이 가진 모든 행을 결과에 포함
-- 오라클 구문 FULL OUTER JOIN 없음

-- ANSI
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
FULL JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-----------------------------------------------------------------

-- 3. CROSS JOIN(교차 조인)
-- 조인되는 테이블의 각 행들이 모두 매핑된 데이터가 검색되는 조회
--> JOIN 구문 잘못 작성 시 CROSS JOIN의 결과가 조회됨 

SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE CROSS JOIN DEPARTMENT;

------------------------------------------------------------------

-- 4. NONE EQUAL JOIN(비등가 조인)

-- '=' 등호를 사용하지 않는 JOIN
-- 컬럼값이 일치하는 경우가 아닌, 값의 범위에 포함되는 ROW들을 연결

SELECT * FROM SAL_GRADE;

SELECT EMP_NAME, SAL_LEVEL FROM EMPLOYEE;

-- 사원의 급여에 따른 급여 등급
SELECT EMP_NAME, SALARY, SAL_GRADE.SAL_LEVEL 
FROM EMPLOYEE
JOIN SAL_GRADE ON(SALARY BETWEEN MIN_SAL AND MAX_SAL );

------------------------------------------------------------------

-- 5. SELF JOIN(자체 조인)

-- 같은 테이블을 조인
-- 자기 자신과 조인을 맺음
-- 같은 테이블 2개 있다고 생각하고 JOIN
-- 테이블마다 별칭 작성(미 작성시 열의 정의 애매하다는 오류)

-- 사번, 이름, 사수의 사번, 사수 이름 조회
-- 단, 사수가 없으면 '없음', '-'조회

-- ANSI 표준
SELECT E1.EMP_ID 사번, E1.EMP_NAME  사원이름, 
NVL(E1.MANAGER_ID, '없음') "사수의 사번", 
NVL(E2.EMP_NAME, '-') "사수의 이름"
FROM EMPLOYEE E1
LEFT JOIN EMPLOYEE E2 ON (E1.MANAGER_ID = E2.EMP_ID);

-- ORACLE
SELECT E1.EMP_ID 사번, E1.EMP_NAME  사원이름, 
NVL(E1.MANAGER_ID, '없음') "사수의 사번", 
NVL(E2.EMP_NAME, '-') "사수의 이름"
FROM EMPLOYEE E1, EMPLOYEE E2
WHERE E1.MANAGER_ID = E2.EMP_ID(+);

-------------------------------------------------------------

-- 6. NATURAL JOIN(자연조인)
-- 동일한 타입과 이름을 가진 컬럼이 있는 테이블간의 조인을 간단히 표현하는 방법
-- 반드시 두 테이블간의 동일한 컬럼명, 타입을 가진 컬럼이 필요
--> 없는데도 NATURAL JOIN을 할 경우 CROSS JOIN 결과가 조회됨
-- INNER JOIN의 USING과 같음

SELECT EMP_NAME, JOB_NAME
FROM EMPLOYEE
NATURAL JOIN JOB;

-- CROSS JOIN 결과 조회됨
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
NATURAL JOIN DEPARTMENT;

--------------------------------------------------------------

-- 7. 다중 조인
-- N개의 테이블을 조인할 때 사용(순서 중요)

-- 사원 이름, 부서명, 지역명 조회
-- EMP_NAME   (EMPLOYEE)
-- DEPT_TITLE (DEPARTMENT)
-- LOCAL_NAME (LOCATION)

SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;
SELECT * FROM LOCATION;

-- LOCATION_ID가 DEPARTMENT에 있기에 순서 중요
-- ANSI 표준
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);

-- ORACLE
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE, DEPARTMENT, LOCATION
WHERE DEPT_CODE = DEPT_ID
AND LOCATION_ID = LOCAL_CODE;


-- [다중 조인 연습 문제]

-- 직급이 대리이면서 아시아 지역에 근무하는 직원 조회(ASIA%)
-- 사번, 이름, 직급명, 부서명, 근무지역명, 급여

SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME, SALARY
FROM EMPLOYEE E
JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE JOB_NAME = '대리' AND LOCAL_NAME LIKE 'ASIA%';

----------------------- JOIN 연습문제 ---------------------------

--1. 주민번호가 70년대 생이면서 성별이 여자이고, 성이 '전'씨인 직원들의
--사원명, 주민번호, 부서명, 직급명을 조회하시오.

SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB ON (EMPLOYEE.JOB_CODE = JOB.JOB_CODE )
WHERE EMP_NO LIKE '7%' AND EMP_NO LIKE '_______2%' 
AND EMP_NAME LIKE '전%';


--2. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 직급명, 부서명을
--조회하시오.
SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB ON (EMPLOYEE.JOB_CODE = JOB.JOB_CODE )
WHERE EMP_NAME LIKE '%형' OR EMP_NAME LIKE '%형%'
OR EMP_NAME LIKE '형%';


--3. 해외영업 1부, 2부에 근무하는 사원의 사원명, 직급명, 부서코드, 부서명을
--조회하시오.
SELECT EMP_NAME, JOB_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB ON (EMPLOYEE.JOB_CODE = JOB.JOB_CODE )
WHERE DEPT_CODE IN ('D5', 'D6');


--4. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을
--조회하시오.
SELECT EMP_NAME, BONUS, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID	= LOCAL_CODE)
WHERE BONUS IS NOT NULL;


--5. 부서가 있는 사원의 사원명, 직급명, 부서명, 지역명 조회
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB ON (EMPLOYEE.JOB_CODE = JOB.JOB_CODE )
JOIN LOCATION ON (LOCATION_ID	= LOCAL_CODE)
WHERE DEPT_CODE IS NOT NULL;


--6. 급여등급별 최소급여(MIN_SAL)를 초과해서 받는 직원들의 사원명, 직급명,
--급여, 연봉(보너스포함)을 조회하시오. (연봉에 보너스포인트를 적용하시오.)
SELECT EMP_NAME, JOB_NAME, SALARY, 
(SALARY * 12) + (SALARY * NVL(BONUS, 0) * 12) 연봉
FROM EMPLOYEE
JOIN SAL_GRADE ON (EMPLOYEE.SAL_LEVEL = SAL_GRADE.SAL_LEVEL)
JOIN JOB ON (EMPLOYEE.JOB_CODE = JOB.JOB_CODE)
WHERE SALARY > MIN_SAL;

--7.한국(KO)과 일본(JP)에 근무하는 직원들의 사원명, 부서명, 지역명, 국가명을
--조회하시오.
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION L ON (LOCATION_ID	= LOCAL_CODE)
JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
WHERE L.NATIONAL_CODE IN ('KO', 'JP');



--8. 같은 부서에 근무하는 직원들의 사원명, 부서코드, 동료이름을
--조회하시오.(SELF JOIN 사용)
SELECT E1.EMP_NAME, E1.DEPT_CODE, 
NVL(E2.EMP_NAME, '-')
FROM EMPLOYEE E1
LEFT JOIN EMPLOYEE E2 ON (E1.DEPT_CODE = E2.DEPT_CODE);



--9. 보너스포인트가 없는 직원들 중에서 직급코드가 J4와 J7인 직원들의 사원명,
--직급명, 급여를 조회하시오. (단, JOIN, IN 사용할 것)
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (DEPT_CODE = DEPT_ID)
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE BONUS IS NULL AND E.JOB_CODE IN ('J4', 'J7');












