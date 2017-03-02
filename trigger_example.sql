/* Setting to show server output */

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY HH24:MI:SS' NLS_DATE_LANGUAGE = 'english'; 

/* Create table employees */

CREATE TABLE employees
  ( employee_id           number(10)      not null,
     last_name            varchar2(50)      not null,
     email                varchar2(30),
     hire_date            date,
     job_id               varchar2(30),
     department_id        number(10),
     salary               number(6),
     manager_id           number(6)
   );

/* Insert data into employees */

INSERT INTO employees( employee_id, last_name, email, hire_date, job_id, salary,department_id ,manager_id)
                 VALUES ( 1001, 'Lawson', 'lawson@g.com', '01-JAN-2002','MGR', 30000,1 ,1004);


INSERT INTO employees( employee_id, last_name, email, hire_date, job_id, salary, department_id ,manager_id)
                 VALUES ( 1002, 'Wells', 'wells@g.com', '01-JAN-2002', 'DBA', 20000,2, 1005 );

INSERT INTO employees( employee_id, last_name, email, hire_date, job_id, salary, department_id ,manager_id)
                 VALUES( 1003, 'Bliss', 'bliss@g.com', '01-JAN-2002', 'PROG', 24000,3 ,1004);

INSERT INTO employees( employee_id, last_name, email, hire_date, job_id, salary, department_id, manager_id)
                 VALUES( 1004,  'Kyte', 'tkyte@a.com', SYSDATE-3650, 'MGR',25000 ,4, 1005);

INSERT INTO employees( employee_id, last_name, email, hire_date, job_id, salary, department_id, manager_id)
                 VALUES( 1005, 'Viper', 'sdillon@a .com', SYSDATE, 'PROG', 20000, 1, 1006);

INSERT INTO employees( employee_id, last_name, email, hire_date, job_id, salary, department_id,manager_id)
                 VALUES( 1006, 'Beck', 'clbeck@g.com', SYSDATE, 'PROG', 20000, 2, null);

INSERT INTO employees( employee_id, last_name, email, hire_date, job_id, salary, department_id, manager_id)
                 VALUES( 1007, 'Java', 'java01@g.com', SYSDATE, 'PROG', 20000, 3, 1006);

INSERT INTO employees( employee_id, last_name, email, hire_date, job_id, salary, department_id, manager_id)
                 VALUES( 1008, 'Oracle', 'wvelasq@g.com', SYSDATE, 'DBA', 20000, 4, 1006);

/* Create table for logs */
				 
CREATE TABLE employees_log(
     who varchar2(30),
     when date);
	 
/* Create trigger to save in logs before changing data */

CREATE OR REPLACE TRIGGER biud_employees_copy
BEFORE INSERT OR UPDATE OR DELETE ON employees
BEGIN
	INSERT INTO employees_log(who, when) VALUES (user, sysdate);
END;
/

/* Upddate salaries by 10%  */

UPDATE employees SET salary = salary * 1.1;
SELECT last_name, department_id, salary FROM employees;

/* Logs show 2 triggers executed, even though delete was not executed */

DELETE FROM employees WHERE department_id = 10;
SELECT * FROM employees_log;

/* Create trigger to save in logs after changing data */

CREATE OR REPLACE TRIGGER log_sum_change_trigger
AFTER UPDATE OF salary ON employees
BEGIN
	INSERT INTO employees_log(who, when) VALUES (user, sysdate);
END;
/

/* Logs show 4 triggers executed */

UPDATE employees SET salary = salary * 1.1;
SELECT last_name, department_id, salary FROM employees;
SELECT * FROM employees_log;

/* This trigger needs admin privileges */

DISCONNECT;
CONNECT system/class;

CREATE TABLE ddl_creations (
    user_id       VARCHAR2(30),
    object_type   VARCHAR2(20),
    object_name   VARCHAR2(30),
    object_owner  VARCHAR2(30),
    creation_date DATE);

CREATE OR REPLACE TRIGGER LogCreations
AFTER CREATE ON DATABASE
BEGIN
    INSERT INTO ddl_creations (user_id, object_type, object_name, object_owner, creation_date)
    VALUES (USER, SYS.DICTIONARY_OBJ_TYPE, SYS.DICTIONARY_OBJ_NAME, SYS.DICTIONARY_OBJ_OWNER, SYSDATE);
END LogCreations;
/

/* Execute trigger */

SELECT * FROM ddl_creations;

CREATE OR REPLACE TYPE address_type AS OBJECT (
	street VARCHAR2(20),
	st_num VARCHAR2(5));
/

SELECT * FROM ddl_creations;





