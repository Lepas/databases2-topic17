/* Setting to show server output */

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY HH24:MI:SS' NLS_DATE_LANGUAGE = 'english'; 

/* Create table employees */

CREATE TABLE employees
  ( employee_id           number(10)        NOT NULL,
     last_name            varchar2(50)      NOT NULL,
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

CREATE TABLE log_emp_table
 (who VARCHAR2(30),
 when DATE,
 which_employee VARCHAR2(10), 
  old_salary NUMBER(6), 
  new_salary NUMBER(6)
);

/* Trigger for each row */

CREATE OR REPLACE TRIGGER log_emps
AFTER UPDATE OF salary ON employees FOR EACH ROW
BEGIN
	INSERT INTO log_emp_table (who, when, which_employee, old_salary, new_salary)
	VALUES (USER, SYSDATE, :OLD.employee_id, :OLD.salary, :NEW.salary);
END;
/

SELECT employee_id, department_id, salary FROM employees;

/* Update selected rows */

UPDATE employees SET salary = salary * 1.1 WHERE department_id = 4;
SELECT employee_id, department_id, salary FROM employees;

SELECT * FROM log_emp_table;



CREATE TABLE audit_emp
 (user_name VARCHAR2(30),
 time_stamp DATE,
 id VARCHAR2(10), 
 old_last_name VARCHAR2(30),
 new_last_name VARCHAR2(30),
 old_title VARCHAR2(30),
 new_title VARCHAR2(30),
  old_salary NUMBER(6), 
  new_salary NUMBER(6)
);

CREATE OR REPLACE TRIGGER audit_emp_values
AFTER DELETE OR INSERT OR UPDATE ON employees FOR EACH ROW
BEGIN
	INSERT INTO audit_emp(user_name, time_stamp, id, old_last_name, new_last_name, old_title, new_title, old_salary, new_salary)
	VALUES (USER, CURRENT_TIMESTAMP, :OLD.employee_id, :OLD.last_name, :NEW.last_name, :OLD.job_id, :NEW.job_id, :OLD.salary, :NEW.salary);
END;
/

INSERT INTO employees (employee_id, last_name, job_id, salary) VALUES (999, 'Temp emp', 'SA_REP', 1000);

SELECT employee_id, last_name, job_id, salary FROM employees;
UPDATE employees SET salary = 2000, last_name = 'Smith' WHERE employee_id = 999;
SELECT user_name AS "UN", time_stamp AS "TIME", id, old_last_name AS "OLD LN", new_last_name "NEW LN", old_title AS "OT", new_title AS "NT", old_salary AS "OS", new_salary AS "NS" from audit_emp;
