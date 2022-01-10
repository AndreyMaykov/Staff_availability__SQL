/* 
	List of employees
*/
CREATE TABLE employees (
    employee_id INT NOT NULL AUTO_INCREMENT,
	first_name varchar(50) NOT NULL,
	last_name varchar(50) NULL,
	PRIMARY KEY (employee_id)
);

/*
	Availability of each employee during a regular week 
	assuming that 
	1. the availability of a employee (fixed employee_id) can vary from day to day during the week; 
	2. several time intervals of availability are possible for one employee_id;
*/
CREATE TABLE staff_regular_availability ( 
	interval_id INT NOT NULL AUTO_INCREMENT,
	employee_id INT NOT NULL,
	day_of_week INT(1) NOT NULL, 
												-- day_of_week = 1 for Sunday, day_of_week = 2 for Monday, etc.
	interval_beginning_time TIME NOT NULL, 		
	interval_end_time TIME NOT NULL,			
	CHECK (interval_beginning_time < interval_end_time),
	PRIMARY KEY (interval_id),
	FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
		ON DELETE CASCADE ON UPDATE CASCADE
);

/*
	Supplementary table for determining staff availability;
	contains information regarding the PLANNED periods (from date1 to date2 where date1 less or equal than date2) 
	when each employee will be unavailable --  
	such as vacations, leaves for medical reasons, etc.
	 
	In the table, each employee can have several blocked periods
*/
CREATE TABLE blocked_periods ( 
	blocked_period_id INT NOT NULL AUTO_INCREMENT,
	employee_id INT NOT NULL,
	blocked_period_beginning DATE NOT NULL, 
	blocked_period_end DATE NOT NULL,
	CHECK (blocked_period_beginning <= blocked_period_end),
	PRIMARY KEY (blocked_period_id),
	FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
		ON DELETE CASCADE ON UPDATE CASCADE
);


/*
							TABLES FOR SLOT PLANNING
*/
/*
	Slots -- time parameters
*/
CREATE TABLE slot_timings (
	slot_id INT NOT NULL AUTO_INCREMENT,
	slot_beginning_time DATETIME NOT NULL,
	slot_end_time DATETIME NOT NULL,
	note VARCHAR(4000) NULL,
	CHECK(DATE(slot_beginning_time) = DATE(slot_end_time)),
	CHECK (slot_beginning_time < slot_end_time),
	PRIMARY KEY (slot_id)
);

/*
	For each slot: employees available for the slot
*/
CREATE TABLE slot_available_staff (
	slot_employee_interval_id INT NOT NULL AUTO_INCREMENT,
	slot_id INT NOT NULL,
	employee_id INT NOT NULL,
	availability_interval_beginning_time time,
	availability_interval_end_time time,
	PRIMARY KEY (slot_employee_interval_id),
	FOREIGN KEY (slot_id) REFERENCES slot_timings(slot_id)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
		ON DELETE CASCADE ON UPDATE CASCADE
);

/* 
When a new row (i.e. slot) is inserted into slot_timings table, the rigger insert_into_slot_availability_table
	1) calculates for the new slot when each employee is available based on both their regular availability (the staff_regular_availability table) and planned leaves (the blocked_periods table);
	2) adds the results of the calculation to the slot_available_staff table(by inserting the appropriate rows into it)
*/


CREATE TRIGGER insert_into_slot_availability_table
AFTER INSERT 
ON slot_timings FOR EACH ROW
	BEGIN
	DECLARE sbt, sendt TIME; 
	SET sbt = TIME(NEW.slot_beginning_time);
	SET sendt = TIME(NEW.slot_end_time);
	INSERT INTO slot_available_staff
		(slot_id, employee_id, availability_interval_beginning_time, availability_interval_end_time) 
		SELECT 
			NEW.slot_id, 
			employee_id, 
			GREATEST(
				TIME(interval_beginning_time), sbt
			) AS aib, 
			LEAST(
				TIME(interval_end_time), sendt
			)
		FROM staff_regular_availability
		WHERE 
			day_of_week = DAYOFWEEK(NEW.slot_beginning_time)
			AND 
			TIME(interval_beginning_time) < sendt
			AND 
			TIME(interval_end_time) > sbt
			AND 
			staff_regular_availability.employee_id NOT IN (
				SELECT employee_id FROM blocked_periods 
				WHERE
					(DATE(NEW.slot_beginning_time) BETWEEN DATE(blocked_period_beginning) AND DATE(blocked_period_end))
			)
		ORDER BY employee_id, aib;
	END;