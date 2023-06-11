CREATE TABLE
    tbl_Employee (
        employee_name VARCHAR(255) NOT NULL,
        street VARCHAR(255) NOT NULL,
        city VARCHAR(255) NOT NULL,
        PRIMARY KEY(employee_name)
    );
 
 
CREATE TABLE
    tbl_Works (
        employee_name VARCHAR(255) NOT NULL,
		FOREIGN KEY(employee_name) REFERENCES tbl_Employee(employee_name),
        company_name VARCHAR(255),
        salary DECIMAL(10, 2)
    );
 
 CREATE TABLE
    tbl_Company (
        company_name VARCHAR(255) NOT NULL,
        city VARCHAR(255),
        PRIMARY KEY(company_name)
    );
 
CREATE TABLE
    tbl_Manages (
        employee_name VARCHAR(255) NOT NULL,
        FOREIGN KEY (employee_name) REFERENCES tbl_Employee(employee_name),
        manager_name VARCHAR(255)
    );
 
INSERT INTO
    tbl_Employee (employee_name, street, city)
VALUES (
        'Alice Williams',
        '321 Maple St',
        'Houston'
    ), (
        'Sara Davis',
        '159 Broadway',
        'New York'
    ), (
        'Mark Thompson',
        '235 Fifth Ave',
        'New York'
    ), (
        'Ashley Johnson',
        '876 Market St',
        'Chicago'
    ), (
        'Emily Williams',
        '741 First St',
        'Los Angeles'
    ), (
        'Michael Brown',
        '902 Main St',
        'Houston'
    ), (
        'Samantha Smith',
        '111 Second St',
        'Chicago'
    );
 
INSERT INTO
    tbl_Employee (employee_name, street, city)
VALUES (
        'Patrick',
        '123 Main St',
        'New Mexico'
    );
 
INSERT INTO
    tbl_Works (
        employee_name,
        company_name,
        salary
    )
VALUES (
        'Patrick',
        'Pongyang Corporation',
        500000
    );
 
INSERT INTO
    tbl_Works (
        employee_name,
        company_name,
        salary
    )
VALUES (
        'Sara Davis',
        'First Bank Corporation',
        82500.00
    ), (
        'Mark Thompson',
        'Small Bank Corporation',
        78000.00
    ), (
        'Ashley Johnson',
        'Small Bank Corporation',
        92000.00
    ), (
        'Emily Williams',
        'Small Bank Corporation',
        86500.00
    ), (
        'Michael Brown',
        'Small Bank Corporation',
        81000.00
    ), (
        'Samantha Smith',
        'Small Bank Corporation',
        77000.00
    );
 
INSERT INTO
    tbl_Company (company_name, city)
VALUES (
        'Small Bank Corporation', 'Chicago'), 
        ('ABC Inc', 'Los Angeles'), 
        ('Def Co', 'Houston'), 
        ('First Bank Corporation','New York'), 
        ('456 Corp', 'Chicago'), 
        ('789 Inc', 'Los Angeles'), 
        ('321 Co', 'Houston'),
        ('Pongyang Corporation','Chicago'
    );
 
INSERT INTO
    tbl_Manages(employee_name, manager_name)
VALUES (
	'Mark Thompson', 'Emily Williams'),
    ('Sara Davis', 'Jane Doe'),		--There was no John Smith
    ('Alice Williams', 'Emily Williams'),
    ('Samantha Smith', 'Sara Davis'),
    ('Patrick', 'Jane Doe');
 
SELECT * FROM tbl_Employee;
SELECT * FROM tbl_Works;
SELECT * FROM tbl_Company;
SELECT * FROM tbl_Manages;

--(a) Find the names of all employees who work for First Bank Corporation.
SELECT * FROM tbl_Works
WHERE company_name='First Bank Corporation'

--(b) Find the names and cities of residence of all employees who work for First Bank Corporation.
SELECT * FROM tbl_Works,tbl_Employee
WHERE company_name='First Bank Corporation'
AND tbl_Works.employee_name=tbl_Employee.employee_name

--(c) Find the names, street addresses, and cities of residence of all employees who work for First Bank Corporation and earn more than $10,000.
SELECT * FROM tbl_Employee
WHERE employee_name IN (SELECT employee_name FROM tbl_Works WHERE company_name='First Bank Corporation' AND salary>10000)


--(d) Find all employees in the database who live in the same cities as the companies for which they work.
SELECT tbl_Employee.employee_name FROM tbl_Company,tbl_Employee,tbl_Works
WHERE tbl_Employee.employee_name=tbl_Works.employee_name
AND tbl_Company.city=tbl_Employee.city
AND tbl_Works.company_name=tbl_Company.company_name;

--(e) Find all employees in the database who live in the same cities and on the same streets as do their managers.(Confused)
--First we have to insert address for manager
DROP TABLE tbl_Manages
CREATE TABLE
    tbl_Manages (
        employee_name VARCHAR(255) NOT NULL,
        FOREIGN KEY (employee_name) REFERENCES tbl_Employee(employee_name),
        manager_name VARCHAR(255),
		manager_address VARCHAR(255)
    );
INSERT INTO
    tbl_Manages(employee_name, manager_name,manager_address)
VALUES (
	'Mark Thompson', 'Emily Williams','New York'),
    ('Sara Davis', 'Jane Doe','Chicago'),		
    ('Alice Williams', 'Emily Williams','Houston'),
    ('Samantha Smith', 'Sara Davis','Chicago'),
    ('Patrick', 'Jane Doe','New Mexico');

	--Now Finally the code
	SELECT tbl_Manages.employee_name FROM tbl_Employee,tbl_Manages
	WHERE tbl_Employee.employee_name=tbl_Manages.employee_name
	AND tbl_Manages.manager_address=tbl_Employee.city

--(f) Find all employees in the database who do not work for First Bank Corporation.
SELECT * FROM tbl_Employee
WHERE employee_name IN (SELECT employee_name FROM tbl_Works WHERE NOT company_name = 'First Bank Corporation');

--(g) Find all employees in the database who earn more than each employee of Small Bank Corporation.
SELECT * FROM tbl_Employee
WHERE employee_name IN 
(SELECT employee_name FROM tbl_Works WHERE salary >(SELECT salary FROM tbl_Works WHERE 
salary=(SELECT MAX(salary) FROM tbl_Works 
WHERE company_name='Small Bank Corporation')));

--(h) Assume that the companies may be located in several cities. 
--Find all companies located in every city in which Small Bank Corporation is located.
SELECT company_name FROM tbl_Company
WHERE city IN (SELECT city FROM tbl_Company WHERE company_name='Small Bank Corporation');

--(i) Find all employees who earn more than the average salary of all employees of their company.
SELECT employee_name FROM tbl_Works
WHERE Salary > (SELECT AVG(salary) FROM tbl_Works);

--(j) Find the company that has the most employees.
SELECT company_name, COUNT(employee_name) AS no_of_Employee FROM tbl_Works
GROUP BY (company_name)
ORDER BY COUNT(employee_name) DESC;

--(k) Find the company that has the smallest payroll.
SELECT company_name FROM tbl_Works
WHERE salary IN (SELECT MIN(salary) FROM tbl_Works);

--(l) Find those companies whose employees earn a higher salary, on average, than the average salary at First Bank Corporation.
SELECT employee_name,Company_name FROM tbl_Works
WHERE Salary > (SELECT AVG(SALARY) FROM tbl_Works WHERE company_name='First Bank Corporation');

