INSERT INTO employees 
		(first_name, 	last_name)
	VALUES
		('Alexander', 	'the Great'),
		('Alexander', 	'the Small'),
		('Alexander', 	'the Middle'),
		('Samuel', 	  	'Clemens');



INSERT INTO staff_regular_availability 
		(employee_id,	day_of_week,	interval_beginning_time,	interval_end_time)
	VALUES	
		(1,				1,				'09:00',					'12:00'),
		(1,				3,				'15:00',					'18:00'),
		(2,				1,				'09:00',					'20:00'),
		(2,				2,				'10:00',					'18:00'),
		(2,				3,				'10:00',					'18:00'),
		(2,				4,				'10:00',					'18:00'),
		(2,				5,				'10:00',					'18:00'),
		(2,				6,				'10:00',					'18:00'),
		(2,				7,				'10:00',					'18:00'),
		(1, 			7, 				'09:00', 					'10:00'),
		(1, 			7, 				'10:30', 					'11:00'),
		(1, 			7, 				'11:30', 					'12:00'),
		(1, 			7, 				'12:30', 					'21:30');



INSERT INTO blocked_periods 
		(employee_id,	blocked_period_beginning,	blocked_period_end)
	VALUES
		(1,			'2022-09-16',			'2022-09-24'),
		(1,			'2022-10-01',			'2022-10-01');



