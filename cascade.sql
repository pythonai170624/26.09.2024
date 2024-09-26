CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    employee_name VARCHAR(100),
    department_id INT,
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE CASCADE
);

INSERT INTO departments (department_name) VALUES ('HR'), ('IT'), ('Finance');
INSERT INTO employees (employee_name, department_id) VALUES
('Alice', 1), ('Bob', 2), ('Charlie', 3);
DELETE FROM departments WHERE department_id = 1;
SELECT * FROM employees;