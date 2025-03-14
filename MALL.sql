CREATE TABLE CATEGORIES (
	CATEGORY_ID NUMBER PRIMARY KEY,
	CATEGORY_NAME VARCHAR2(100) UNIQUE
);

CREATE TABLE PRODUCTS (
	PRODUCT_ID NUMBER PRIMARY KEY,
	PRODUCT_NAME VARCHAR2(100) NOT NULL,
	CATEGORY NUMBER,
	PRICE NUMBER DEFAULT 0,
	STOCK_QUANTITY NUMBER DEFAULT 0,
	FOREIGN KEY (CATEGORY)
  REFERENCES CATEGORIES(CATEGORY_ID)
);

CREATE TABLE CUSTOMERS (
	CUSTOMER_ID NUMBER PRIMARY KEY,
	NAME VARCHAR2(20) NOT NULL,
	GENDER CHAR(3) CHECK (GENDER IN('남', '여')),
	ADDRESS VARCHAR2(100),
	PHONE VARCHAR2(30)
);

CREATE TABLE ORDERS (
	ORDER_ID NUMBER PRIMARY KEY,
	ORDER_DATE DATE DEFAULT SYSDATE,
	STATUS CHAR(1) DEFAULT 'N' CHECK (STATUS IN('Y', 'N')) ,
	CUSTOMER_ID NUMBER,
	FOREIGN KEY (CUSTOMER_ID)
  REFERENCES CUSTOMERS(CUSTOMER_ID) ON DELETE CASCADE
);

CREATE TABLE ORDER_DETAILS (
	ORDER_DETAIL_ID NUMBER PRIMARY KEY,
	ORDER_ID NUMBER,
	PRODUCT_ID NUMBER,
	QUANTITY NUMBER,
	PRICE_PER_UNIT NUMBER,
 	FOREIGN KEY (ORDER_ID)
  REFERENCES ORDERS(ORDER_ID)ON DELETE CASCADE,
  FOREIGN KEY (PRODUCT_ID)
  REFERENCES PRODUCTS(PRODUCT_ID) ON DELETE SET NULL
);

INSERT INTO CATEGORIES VALUES (1, '스마트폰');
INSERT INTO CATEGORIES VALUES (2, 'TV');
INSERT INTO CATEGORIES VALUES (3, 'Gaming');

INSERT INTO PRODUCTS VALUES (101, 'APPLE IPHONE 12', 1, 1500000, 30);
INSERT INTO PRODUCTS VALUES (102, 'SAMSUNG GALAXY S24', 1, 1800000,50);
INSERT INTO PRODUCTS VALUES (201, 'LG OLED TV', 2, 3600000,10);
INSERT INTO PRODUCTS VALUES (301, 'SONY PLAYSTATION 5', 3, 700000,15);

INSERT INTO CUSTOMERS VALUES (1, '홍길동', '남', '서울시 성동구 왕십리', '010-1111-2222');
INSERT INTO CUSTOMERS VALUES (2, '유관순', '여', '서울시 종로구 안국동', '010-3333-1111');

INSERT INTO ORDERS VALUES (576, '2024-02-29', 'N', 1);
INSERT INTO ORDERS VALUES (978, '2024-03-11', 'Y', 2);
INSERT INTO ORDERS VALUES (777, '2024-03-11', 'N', 2);
INSERT INTO ORDERS VALUES (134, '2022-12-25', 'Y', 1);
INSERT INTO ORDERS VALUES (499, '2020-01-03', 'Y', 1);

INSERT INTO ORDER_DETAILS VALUES (111, 576, 101, 1, 1500000);
INSERT INTO ORDER_DETAILS VALUES (222, 978, 201, 2, 3600000);
INSERT INTO ORDER_DETAILS VALUES (333, 978, 102, 1, 1800000);
INSERT INTO ORDER_DETAILS VALUES (444, 777, 301, 5, 700000);
INSERT INTO ORDER_DETAILS VALUES (555, 134, 102, 1, 1800000);
INSERT INTO ORDER_DETAILS VALUES (666, 499, 201, 3, 3600000);


SELECT * FROM CATEGORIES;
SELECT * FROM PRODUCTS;
SELECT * FROM CUSTOMERS;
SELECT * FROM ORDERS;
SELECT * FROM ORDER_DETAILS;

COMMIT;

-- 1.쇼핑몰 관리자가 주문은 받았으나, 아직 처리가 안된 주문을 처리하려고
-- 한다. 현재 주문 내역 중 아직 처리되지 않은 주문을 조회하시오. 😀
-- (고객명, 주문일, 처리상태)
SELECT NAME, ORDER_DATE, STATUS
FROM CUSTOMERS
JOIN ORDERS USING (CUSTOMER_ID)
WHERE STATUS = 'N';

-- 2. 홍길동 고객이 2024년도에 본인이 주문한 전체 내역을 조회하고자 한다.
-- 주문번호, 주문날짜, 처리상태 조회하시오
SELECT ORDER_ID, ORDER_DATE, STATUS
FROM CUSTOMERS
JOIN ORDERS USING (CUSTOMER_ID)
WHERE NAME = '홍길동';

SELECT ORDER_ID, ORDER_DATE, STATUS
FROM CUSTOMERS
JOIN ORDERS USING (CUSTOMER_ID)
WHERE ORDER_DATE LIKE '2024%'











