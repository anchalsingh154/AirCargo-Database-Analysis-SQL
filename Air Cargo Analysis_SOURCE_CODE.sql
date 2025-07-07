CREATE DATABASE AirCargoData;

/*2.	Write a query to create a route_details table using suitable data types for the fields, 
such as route_id, flight_num, origin_airport, destination_airport, aircraft_id, and distance_miles. 
Implement the check constraint for the flight number and unique constraint for the route_id fields. 
Also, make sure that the distance miles field is greater than 0. 
*/
CREATE table route_details (
	route_id int primary KEY,
    flight_num varchar(50) NOT null check (LENGTH(flight_num) BETWEEN 2 AND 10),
    origin_airport varchar(50) NOT NULL,
    destination_airport varchar(50) NOT NULL,
    aircraft_id varchar(50) NOT NULL,
    distance_miles int NOT NULL CHECK(distance_miles > 0 )
    ) ;
    

/* 3.	Write a query to display all the passengers (customers) who have travelled in routes 01 to 25. 
Take data from the passengers_on_flights table. */

SELECT * FROM passengers_on_flights WHERE route_id between 01 AND 25;

/*4.	Write a query to identify the number of passengers and total revenue in business class from the ticket_details table*/=
SELECT count(no_of_tickets) AS 'TOTAL_PASSENGER', sum(Price_per_ticket*no_of_tickets) AS 'REVENUE' FROM ticket_details
WHERE class_id = 'Bussiness';

/*5.Write a query to display the full name of the customer by extracting the first name and last name from the customer table.*/
SELECT concat(first_name,' ',last_name) AS 'Full_Name' FROM customer;

/*6.	Write a query to extract the customers who have registered and booked a ticket. 
Use data from the customer and ticket_details tables.*/

SELECT c.customer_id, c.first_name, c.last_name, t.p_date, t.no_of_tickets FROM customer C 
join ticket_details T ON C.customer_id = T.customer_id ;

/*7.	Write a query to identify the customer’s first name and last name based on their customer ID 
and brand (Emirates) from the ticket_details table.*/

SELECT C.customer_id, C.first_name, C.last_name, T.brand FROM customer C JOIN ticket_details T ON C.customer_id = T.customer_id
WHERE brand = 'Emirates';

/*8.	Write a query to identify the customers who have travelled by Economy Plus class 
using Group By and Having clause on the passengers_on_flights table. */
SELECT customer_id, class_id FROM passengers_on_flights
WHERE class_id = 'Economy Plus'
group by 1, 2
HAVING COUNT(customer_id) >= 1;

/*9.	Write a query to identify whether the revenue has crossed 10000 using the IF clause on the ticket_details table.*/
SELECT IF(SUM(Price_per_ticket*no_of_tickets) > 10000, 'ACHIEVED', 'NOT ACHIEVED') AS 'REVENUE_STATUS'
FROM ticket_details;

/*10.	Write a query to create and grant access to a new user to perform operations on a database.*/
CREATE USER 'new_user'@'localhost' identified BY 'junior123';

GRANT ALL privileges ON aircargodata.* to 'new_user'@'localhost';

SELECT USER, host FROM mysql.user ;

/*11.	Write a query to find the maximum ticket price for each class using window functions on the ticket_details table. */
SELECT customer_id, Price_per_ticket, class_id, 
max(Price_per_ticket) OVER(partition by class_id) AS 'MAX_TICKET_PRICE_PER_CLASS' 
FROM ticket_details;

/*12.	Write a query to extract the passengers whose route ID is 4 by improving 
the speed and performance of the passengers_on_flights table.*/

CREATE index idx_route_id on passengers_on_flights(route_id);

SELECT customer_id, aircraft_id, route_id FROM passengers_on_flights
WHERE route_id = 4;

/*13. For the route ID 4, write a query to view the execution plan of the passengers_on_flights table.*/
SELECT customer_id, aircraft_id, route_id FROM passengers_on_flights
WHERE route_id = 4;

/*14.	Write a query to calculate the total price of all tickets booked by a customer 
across different aircraft IDs using rollup function. */
SELECT customer_id, aircraft_id, SUM(Price_per_ticket*no_of_tickets) AS 'total_ticket_price' FROM ticket_details
group by 1,2 with rollup;

/*15.	Write a query to create a view with only business class customers along with the brand of airlines. */
CREATE VIEW aircargodata.view_bussiness_class_cust AS
	SELECT customer_id, class_id, brand FROM ticket_details
    WHERE class_id = 'Bussiness';
    
SELECT * FROM view_bussiness_class_cust;

/*16.	Write a query to create a stored procedure to get the details of all passengers flying between 
a range of routes defined in run time. Also, return an error message if the table doesn't exist.*/

DELIMITER //
CREATE PROCEDURE GetPassengerbyRouteRange(IN start_route int, IN end_route INT)
BEGIN
	IF EXISTS( SELECT 1 FROM information_schema.tables 
				WHERE table_schema = 'aircargodata' AND table_name = 'passengers_on_flights')
		THEN
			SELECT * FROM passengers_on_flights
            WHERE route_id BETWEEN start_route AND end_route;
		ELSE SELECT 'ERROR: Table passengers_on_flights does not exist' AS 'ERRORMESSAGE';
	END IF;
END //
DELIMITER ;

CALL GetPassengerbyRouteRange(8,18);

/*17. Write a query to create a stored procedure that extracts all the details from the routes table where the travelled distance is more than 2000 miles.*/
SELECT * FROM routes WHERE distance_miles > 2000;

DELIMITER //
CREATE procedure RouteDistance()
	BEGIN
		SELECT * FROM routes WHERE distance_miles > 2000;
	END//
DELIMITER ;

CALL RouteDistance();

/*18.Write a query to create a stored procedure that groups the distance travelled by each flight into three categories. 
The categories are, short distance travel (SDT) for >=0 AND <= 2000 miles, 
intermediate distance travel (IDT) for >2000 AND <=6500, and long-distance travel (LDT) for >6500.*/

DELIMITER //
CREATE PROCEDURE Category_Flight_Distance()
	BEGIN
		SELECT flight_num, distance_miles,
	CASE
		WHEN distance_miles >0 AND distance_miles <= 2000 THEN 'short distance travel (SDT)'
        WHEN distance_miles >2000 AND distance_miles <= 6500 THEN 'intermediate distance travel (IDT)'
        WHEN distance_miles >6500 THEN 'long-distance travel (LDT)'
        ELSE 'Invalid'
	END AS travel_category
    FROM routes;
	END //
DELIMITER ;

CALL Category_Flight_Distance();

/*19.	Write a query to extract ticket purchase date, customer ID, class ID and specify if the complimentary services are provided for the specific class 
using a stored function in stored procedure on the ticket_details table. 
Condition: 
●	If the class is Business and Economy Plus, then complimentary services are given as Yes, else it is No
*/
DELIMITER //
CREATE FUNCTION Get_Complimentary_services(class VARCHAR(20))
RETURNS VARCHAR(5)
    DETERMINISTIC
	BEGIN  
		RETURN CASE
		WHEN class = 'Bussiness' OR  class = 'Economy Plus' THEN 'YES'
        ELSE 'NO'
		END; 
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE extract_ticket_Info()
BEGIN
	SELECT p_date, customer_id, class_id, Get_Complimentary_services(class_id) AS 'Complimentary_services'
    FROM ticket_details;
END//
DELIMITER ;

CALL extract_ticket_info();

/*20. Write a query to extract the first record of the customer 
whose last name ends with Scott using a cursor from the customer table.*/

DELIMITER &&
CREATE procedure Get_Passenger_Record()
BEGIN
	DECLARE done INT DEFAULT 0;
    DECLARE CustID VARCHAR(20);
    DECLARE FirstName VARCHAR(20);
    DECLARE LastName VARCHAR(20);

	DECLARE CustomerCursor CURSOR FOR
		SELECT customer_id, first_name, last_name FROM customer WHERE last_name LIKE '%Scott';
	
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
	OPEN CustomerCursor ;
		FETCH CustomerCursor INTO CustID, FirstName, LastName;
	IF done = 0 THEN
		SELECT CustID AS 'Cust_ID', FirstName AS 'First_Name', LastName AS 'Last_Name';
	END IF;
    CLOSE CustomerCursor;
END &&  
DELIMITER ;

CALL Get_Passenger_Record();
