-- ============================================================
--  EMPLOYEE MANAGEMENT SYSTEM — Full Database Schema
--  Database: ems_db
-- ============================================================

CREATE DATABASE IF NOT EXISTS ems_db;
USE ems_db;

-- ── 1. USERS (login) ─────────────────────────────────────────
CREATE TABLE users (
    user_id    INT AUTO_INCREMENT PRIMARY KEY,
    username   VARCHAR(50)  NOT NULL UNIQUE,
    password   VARCHAR(255) NOT NULL,
    role       ENUM('admin','hr','manager') DEFAULT 'hr',
    is_active  TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ── 2. DEPARTMENTS ───────────────────────────────────────────
CREATE TABLE departments (
    dept_id    INT AUTO_INCREMENT PRIMARY KEY,
    dept_name  VARCHAR(100) NOT NULL UNIQUE,
    dept_head  VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ── 3. EMPLOYEES ─────────────────────────────────────────────
CREATE TABLE employees (
    emp_id       INT AUTO_INCREMENT PRIMARY KEY,
    first_name   VARCHAR(50)  NOT NULL,
    last_name    VARCHAR(50)  NOT NULL,
    gender       ENUM('Male','Female','Other'),
    phone        VARCHAR(20),
    email        VARCHAR(100) UNIQUE,
    address      TEXT,
    dept_id      INT,
    designation  VARCHAR(100),
    hire_date    DATE,
    status       ENUM('Active','Inactive') DEFAULT 'Active',
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE SET NULL
);

-- ── 4. ATTENDANCE ─────────────────────────────────────────────
CREATE TABLE attendance (
    att_id     INT AUTO_INCREMENT PRIMARY KEY,
    emp_id     INT NOT NULL,
    att_date   DATE NOT NULL,
    status     ENUM('Present','Absent','Late','Half-Day') DEFAULT 'Present',
    remarks    VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE,
    UNIQUE KEY unique_att (emp_id, att_date)
);

-- ── 5. SALARY ─────────────────────────────────────────────────
CREATE TABLE salary (
    sal_id      INT AUTO_INCREMENT PRIMARY KEY,
    emp_id      INT NOT NULL,
    month_year  VARCHAR(20) NOT NULL,
    basic_pay   DECIMAL(10,2) DEFAULT 0,
    bonus       DECIMAL(10,2) DEFAULT 0,
    deduction   DECIMAL(10,2) DEFAULT 0,
    net_salary  DECIMAL(10,2) GENERATED ALWAYS AS (basic_pay + bonus - deduction) STORED,
    paid_date   DATE,
    status      ENUM('Paid','Pending') DEFAULT 'Pending',
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE,
    UNIQUE KEY unique_sal (emp_id, month_year)
);

-- ── 6. LEAVE ──────────────────────────────────────────────────
CREATE TABLE leaves (
    leave_id    INT AUTO_INCREMENT PRIMARY KEY,
    emp_id      INT NOT NULL,
    leave_type  ENUM('Sick','Annual','Emergency','Unpaid') DEFAULT 'Annual',
    from_date   DATE NOT NULL,
    to_date     DATE NOT NULL,
    reason      TEXT,
    status      ENUM('Pending','Approved','Rejected') DEFAULT 'Pending',
    applied_on  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE
);

-- ── SAMPLE DATA ───────────────────────────────────────────────
INSERT INTO users (username, password, role) VALUES
('Roman', 'admin123', 'admin'),
('hr_user', 'hr123', 'hr');

INSERT INTO departments (dept_name, dept_head) VALUES
('Information Technology', 'Ali Hassan'),
('Human Resources', 'Sara Khan'),
('Finance', 'Ahmed Raza'),
('Marketing', 'Fatima Malik'),
('Operations', 'Usman Tariq');

INSERT INTO employees (first_name, last_name, gender, phone, email, address, dept_id, designation, hire_date) VALUES
('Ali',    'Hassan',  'Male',   '0300-1234567', 'ali@ems.com',    'Karachi',    1, 'Senior Developer',  '2022-01-10'),
('Sara',   'Khan',    'Female', '0301-2345678', 'sara@ems.com',   'Lahore',     2, 'HR Manager',        '2021-05-15'),
('Ahmed',  'Raza',    'Male',   '0302-3456789', 'ahmed@ems.com',  'Islamabad',  3, 'Accountant',        '2023-03-20'),
('Fatima', 'Malik',   'Female', '0303-4567890', 'fatima@ems.com', 'Peshawar',   4, 'Marketing Lead',    '2022-08-01'),
('Usman',  'Tariq',   'Male',   '0304-5678901', 'usman@ems.com',  'Multan',     5, 'Operations Head',   '2020-11-12');

INSERT INTO salary (emp_id, month_year, basic_pay, bonus, deduction, paid_date, status) VALUES
(1, 'May-2025', 75000, 5000, 2000, '2025-05-30', 'Paid'),
(2, 'May-2025', 65000, 3000, 1500, '2025-05-30', 'Paid'),
(3, 'May-2025', 55000, 2000, 1000, '2025-05-30', 'Paid'),
(4, 'May-2025', 60000, 2500, 1200, '2025-05-30', 'Paid'),
(5, 'May-2025', 70000, 4000, 1800, '2025-05-30', 'Paid');
SHOW DATABASES;
SELECT * FROM users;
select * from departments;
select * from employees;
select *from salary;

