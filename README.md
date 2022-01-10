# Staff_availability__SQL

## OBJECTIVE
The goal of this project was to test a solution for automating planning assignments for a company’s staff using a simple test database.
## DATABASE
The database comprises five tables:<br><br>
**employees**<br> 
List of all the employees.<br><br>
**staff_regular_availability**<br><br>
Availability of each employee during a regular day (i.e. when the employee is not on leave for any reason) of the week.<br>
<li>
  Several time intervals of availability are possible for a single employee.
</li>
<li>
  Availability intervals may be different for different days of the week.
</li>
<br>
**blocked_periods**<br>
Planned employee leaves (from date1 to date2 where date1 less or equal than date2).
<br>
**slot_timings**<br>
Time intervals – slots – within a specified day for which the availability of each employee is to be determined. Multiple slots are possible for each day (e.g. from 09:00 to 12:00 and from 13:00 to 16:30 on 2022-09-18). The slots may be different for different days.
<br>
**slot_available_staff**
Contains the information about the availability of each employee during each time slot.
## PROBLEM
Within each slot, it is required to calculate when each employee is available based on both their regular availability (the staff_regular_availability table) and planned leaves (the blocked_periods table). The results of the calculation must be added to the slot_available_staff table automatically each time when a new slot is added to the slot_timings table.
## SOLUTION
Trigger insert_into_slot_availability_table that both perform the calculations and inserts the required rows into slot_available_staff when a new row is added to slot_timings.

This database was created and tested in MariaDB v.10.4.22 using DBeaver v.21.3.0.202111281534  
