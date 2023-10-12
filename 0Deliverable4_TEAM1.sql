-- Kyle Keener
-- Team 1
-- Dhruv Chawla, Marcellus De Burgo, Amina El-Ashry
SET SERVEROUTPUT ON;


--drop sequences commands 
DROP SEQUENCE order_id;
DROP SEQUENCE waiter_id;
drop sequence restaurant_id_seq;
drop sequence menu_item_id;
drop sequence cuisine_id_seq;
DROP SEQUENCE Customers_ID;

--drop tables
DROP TABLE orders;
DROP table restaurant_inventory;
DROP table menu_item;
DROP TABLE WAITERS;
drop table restaurants; 
drop table cuisine_type;
DROP TABLE Customers;


--Create TABLES

--Customer tables
CREATE TABLE Customers (
    Customer_ID NUMBER(10) NOT NULL,
    Cust_Name VARCHAR2(25),
    Email VARCHAR2(25),
    Street_add VARCHAR2(25),
    City VARCHAR2(25),
    State VARCHAR2(2),
    Zip NUMBER(7),
    Credit_Card_Num NUMBER(16),
    CONSTRAINT PK_Customers PRIMARY KEY (Customer_ID)
); 


--cuisine table creation 
create table cuisine_type(
    cuisine_type_id     number          not null,
    cuisine_name        varchar2(50)    not null,    
    constraint cuisine_pk primary key (cuisine_type_id), 
    constraint cuisine_name_uq unique (cuisine_name)
);

--restaurant table creation 
create table restaurants(
    restaurant_id               number          not null,
    restaurant_name             varchar2(50)    not null, 
    restaurant_street_address   varchar2(50)    not null, 
    restaurant_city             varchar2(50)    not null,
    restaurant_state            char(2)         not null, 
    restaurant_zip              varchar2(20)    not null,
    cuisine_type                number          not null,
    constraint restaurant_pk primary key (restaurant_id),
    constraint cuisine_fk foreign key (cuisine_type) references cuisine_type (cuisine_type_id),
    constraint restaurant_name_uq unique (restaurant_name)
);

--Waiters table 
CREATE TABLE WAITERS(
    waiter_id NUMBER PRIMARY KEY,
    waiter_name VARCHAR2 (80),
    restaurant_id NUMBER,
    FOREIGN KEY (restaurant_id) REFERENCES RESTAURANTS(restaurant_id)
);

--Menu table
CREATE TABLE menu_item
(
  menu_item_id                     NUMBER           NOT NULL,
  cuisine_type_id                  NUMBER           NOT NULL,
  menu_item_name                   VARCHAR(30)     NOT NULL,
  menu_item_price                  NUMBER (9,2)     NOT NULL,

  CONSTRAINT menu_item_pk 
    PRIMARY KEY (menu_item_id),
  CONSTRAINT mi_fk_cuisine_id
    FOREIGN KEY (cuisine_type_id) 
    REFERENCES cuisine_type (cuisine_type_id)
);

--restaurant inventory table
create table restaurant_inventory
(
  menu_item_id                     NUMBER            NOT NULL,
  menu_item_name1                   varchar(100)	     NOT NULL,
  restaurant_id                    NUMBER            NOT NULL,
  menu_item_quantity               NUMBER            NOT NULL,

  CONSTRAINT restaurant_inventory_pk 
    PRIMARY KEY (menu_item_id),
  CONSTRAINT ri_fk_mid
    FOREIGN KEY (menu_item_id) 
    REFERENCES menu_item (menu_item_id),
   CONSTRAINT ri_fk_rid
    FOREIGN KEY (restaurant_id) 
    REFERENCES restaurants (restaurant_id)
);

--Creates table orders that references numerous other tables
CREATE TABLE orders(
    order_id NUMBER PRIMARY KEY,
    customer_id NUMBER,
    amount_paid NUMBER(9, 2),
    menu_item_id NUMBER,
    menu_item_quantity NUMBER,
    restaurant_id NUMBER,
    waiter_id NUMBER,
    tip NUMBER(9, 2),
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (menu_item_id) REFERENCES menu_item(menu_item_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id),
    FOREIGN KEY (waiter_id) REFERENCES waiters(waiter_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

--SEQUENCE CREATIONS

--Creates Customer ID sequence
CREATE SEQUENCE Customers_ID
INCREMENT BY 1 START WITH 1;

--cuisine sequence
create sequence cuisine_id_seq start with 1;

--restaurant sequence
create sequence restaurant_id_seq start with 1; 

--Create sequence for waiter IDs
CREATE SEQUENCE waiter_id
INCREMENT BY 1 START WITH 1;


--menu item sequence
CREATE SEQUENCE menu_item_id
INCREMENT BY 1 START WITH 1;

--order id sequence
CREATE SEQUENCE order_id
INCREMENT BY 1 START WITH 1;


--INSERTS
--Inserts values for customer table
INSERT INTO Customers
VALUES (customers_ID.NEXTVAL, 'Charles Alexander', 'charAl@gmail.com', '490 Fakevile ave', 'Catonsville', 'OH', 21043, 7812771827364901);

INSERT INTO Customers
VALUES (customers_ID.NEXTVAL, 'Jim Alexander', 'JimAl@gmail.com', '1993 Fakevile ave', 'Catonsville', 'MD', 09143, 7812701827364901);

INSERT INTO Customers
VALUES (customers_ID.NEXTVAL, 'Carry Rose', 'CarR@gmail.com', '981 Fakevile lane', 'Miniannapolis', 'DA', 00043, 7856701827364901);

INSERT INTO Customers
VALUES (customers_ID.NEXTVAL, 'Jimi Hendrix', 'Guitarist@gmail.com', '8010 watchTower lane', 'Rocksville', 'MD', 09743, 0956701827364902);

INSERT INTO Customers
VALUES (customers_ID.NEXTVAL, 'David Bowie', 'BowI@gmail.com', '110 LifonMars lane', 'Bowie', 'MD', 09923, 0950001821164902);

--procedures and functions
--Helper functions
--Find cusisine id
CREATE OR REPLACE FUNCTION find_cuisine_type_id(c_name IN VARCHAR2)
RETURN NUMBER IS
    
    cuisine_id NUMBER;

BEGIN

    SELECT cuisine_type_id INTO cuisine_id
    FROM cuisine_type
    WHERE cuisine_name = c_name;
    
    RETURN cuisine_id;

END;
/

--Fine restaurant id
CREATE OR REPLACE FUNCTION find_restaurant_id(r_name IN VARCHAR2)
RETURN NUMBER IS

    r_id NUMBER;
    
BEGIN

    SELECT restaurant_id INTO r_id
    FROM restaurants
    WHERE restaurant_name = r_name;
    
    RETURN r_id;
    
END;
/

--Find menu item id
CREATE OR REPLACE FUNCTION find_menu_item_id(item_name IN VARCHAR2)
RETURN NUMBER IS
    
    item_id NUMBER;
    
BEGIN

    SELECT menu_item_id INTO item_id
    FROM menu_item
    WHERE menu_item_name = item_name;
    
    RETURN item_id;
    
END;
/

--Find Customer ID
CREATE OR REPLACE FUNCTION GetCustID (Customer_Name IN VARCHAR2)
RETURN NUMBER
IS
    C_ID NUMBER(3);
begin
    select Customer_ID
      into C_ID
      from Customers c
     where c.Cust_Name = Customer_Name;
     RETURN C_ID;
end;
/

--Find waiter id
CREATE OR REPLACE FUNCTION find_waiter_id(w_name IN VARCHAR2)
RETURN NUMBER IS
    
    w_id NUMBER;
    
BEGIN
    
    SELECT waiter_id INTO w_id
    FROM waiters
    WHERE waiter_name = w_name;
    
    RETURN w_id;
    
END;
/

/*
- add_cuisine_type: adds a cuisine name to the database 
- input: user defined cuisine name as a string (varchar2 data type)
- cuisine type ID is automatically generated via sequences
*/

create or replace procedure add_cuisine_type (cuisine_type IN cuisine_type.cuisine_name%type) is 
    null_cuisine exception; 
begin
    --exception handling for null values 
    if cuisine_type is null then
        raise null_cuisine; 
    end if;
    dbms_output.put_line('created by Amina El-Ashry');
    --inserts into the cuisine_type table 
    insert into cuisine_type (cuisine_type_id, cuisine_name) values (cuisine_id_seq.nextval, cuisine_type);
exception
    when null_cuisine then 
        raise_application_error(-20003,'Please enter a cuisine name');
end;
/

/*
- add_restaurant: adds a new restaurant to the database
- input: user defined restaurant name, address, city, state, and
         zipcode as strings/characters.the user can also pass the
         cuisine type ID as a number to associate a cuisine type
         for the restaurant. 
- the restaurant ID is automatically generated via sequences
*/
create or replace procedure add_restaurant (
    rname IN restaurants.restaurant_name%type, 
    rstreet_address IN restaurants.restaurant_street_address%type, 
    rcity IN restaurants.restaurant_city%type,
    rstate IN restaurants.restaurant_state%type, 
    rzip IN restaurants.restaurant_zip%type,
    cuisineType IN cuisine_type.cuisine_type_id%type
) is
    null_restaurant exception; 
begin
    --exception handling for null values 
    if rname is null then
        raise null_restaurant; 
    end if;
    
    --inserts into the restaurant table 
    insert into restaurants 
        (restaurant_id, restaurant_name, restaurant_street_address, 
        restaurant_city, restaurant_state, restaurant_zip, cuisine_type) values 
            (restaurant_id_seq.nextval, rname, rstreet_address, rcity, rstate, rzip, cuisineType);
    dbms_output.put_line('created by Amina El-Ashry');
exception
    when null_restaurant then 
        raise_application_error(-20004,'Please enter a restaurant name'); 
end;
/

/*
- find_cuisine_type_id: returns the ID of a given cuisine name 
- input: the name of the cuisine the user wants an ID for as a string 
- output: the associated ID of the cuisine name as a number 
*/
create or replace function find_cuisine_type_id (cname IN cuisine_type.cuisine_name%type) return number is
    cID cuisine_type.cuisine_type_id%type; --variable for implicit cursor 
begin
    --select statement to find the assocaited ID of a cuisine name 
    select cuisine_type_id into cID
    from cuisine_type
    where cuisine_name = cname;
    return cID; --returning the ID 
    dbms_output.put_line('created by Amina El-Ashry');
exception
    /*exception that is raised when a null or invalid data type is entered, 
      or when a cuisine name cannot be found*/
    when no_data_found then 
        raise_application_error(-20001, 'Invalid cuisine name');    
end;
/

/*
- find_restaurant_id: returns the ID of a given restaurant 
- input: the name of the restaurant the user wants an ID for as a string 
- output: the associated ID of the restaurant as a number 
*/
create or replace function find_restaurant_id (rname IN restaurants.restaurant_name%type) return number is
    rID restaurants.restaurant_id%type; --variable for implicit cursor 
begin
    --select statement to find the assocaited ID of a restaurant  
    select restaurant_id into rID
    from restaurants
    where restaurant_name = rname;
    return rID; --returning the ID 
    dbms_output.put_line('created by Amina El-Ashry'); 
exception
    /*exception that is raised when a null or invalid data type is entered, 
      or when a restaurant cannot be found*/
    when no_data_found then 
        raise_application_error(-20001,'Invalid restaurant name');
end;
/

/*
- display restaurant by cuisine: displays all restaurant information that fall under a given cuisine type 
- input: the id associated with a cuisine type
- output: display of all restaurants (name and address) for that given cuisine
*/
create or replace procedure display_restaurant_by_cuisine (cuisine_type_id IN cuisine_type.cuisine_type_id%type) is
    --explicit cursor to select restaurant information 
     cursor restaurant_for_cuisine is 
            select restaurant_name, restaurant_street_address, restaurant_city, restaurant_state, restaurant_zip, cuisine_type
            from restaurants
            where cuisine_type = cuisine_type_id;
    restaurant_for_cuisine_r restaurants%rowtype;
begin
    for restaurant_for_cuisine_r in restaurant_for_cuisine 
        loop
            dbms_output.put_line('Restaurant name: ' || restaurant_for_cuisine_r.restaurant_name); 
            dbms_output.put_line('Restaurant address: ' || restaurant_for_cuisine_r.restaurant_street_address || ', ' ||
               restaurant_for_cuisine_r.restaurant_city || ' ' || restaurant_for_cuisine_r.restaurant_state || ' ' ||
               restaurant_for_cuisine_r.restaurant_zip); 
            dbms_output.put_line('==================================');
        end loop;
    dbms_output.put_line('created by Amina El-Ashry');
exception
    /*exception that is raised when a null or invalid data type is entered, 
      or when a restaurant cannot be found*/
    when no_data_found then 
        raise_application_error(-20009,'Invalid cuisine type');
end;
/

/*
- report income by state: displays total restaurant income by state and cuisine 
- input: none
- output: display of total restaurant income by each state and cuisine
*/
create or replace procedure report_income_by_state is
    --explicit cursor to calculate total income 
    cursor income_state is 
            select restaurant_state, cuisine_name, sum(total_cost) as total_income
            from orders o, restaurants r, cuisine_type c
            where o.restaurant_id = r.restaurant_id and r.cuisine_type = c.cuisine_type_id
            group by restaurant_state, cuisine_name;
    income_state_r orders%rowtype;
begin
    for income_state_r in income_state
        loop
            dbms_output.put_line('Total income of ' || income_state_r.total_income || ' for ' || income_state_r.restaurant_state 
                || ' ' || income_state_r.cuisine_name || ' cuisine');
        end loop; 
    dbms_output.put_line('created by Amina El-Ashry');
exception
    /*exception that is raised when a null or invalid data type is entered, 
      or when a restaurant cannot be found*/
    when no_data_found then 
        raise_application_error(-20008,'Invalid cuisine type');
end;
/

commit; 

--procedure to create menu item
create or replace procedure create_menu_item(
cname IN cuisine_type.cuisine_name%type,
mname IN menu_item.menu_item_name%type,
mprice IN menu_item.menu_item_price%type)
is 
cid NUMBER;
begin
    cid:=find_cuisine_type_id(cname);
    insert into menu_item (menu_item_id,cuisine_type_id, menu_item_name, menu_item_price ) values (menu_item_id.nextval, cid,mname,mprice);
    dbms_output.put_line('created by Dhruv Chawla');
end;
/

--procedure to add menu item to restaurant inventory
create or replace procedure create_restaurant_inventory (
mname IN menu_item.menu_item_name%type,
rname IN restaurants.restaurant_name%type,
mquant IN restaurant_inventory.menu_item_quantity%type
)
is
rid NUMBER;
mid NUMBER;
begin
rid:= find_restaurant_id(rname);
mid:= find_menu_item_id(mname);
    --inserts into the menu_ table 
    insert into restaurant_inventory (menu_item_id,menu_item_name1, restaurant_id, menu_item_quantity ) values (mid, mname,rid,mquant);
	dbms_output.put_line('created by Dhruv Chawla');
end;
/

--procedure to update menu item quantity
create or replace procedure update_menu_item(
mname IN menu_item.menu_item_name%type,
rname IN restaurants.restaurant_name%type,
quantity IN NUMBER)
is
rid NUMBER;
mid NUMBER;
begin
rid:= find_restaurant_id(rname);
mid:= find_menu_item_id(mname);
update restaurant_inventory
set menu_item_quantity= menu_item_quantity-quantity
where
restaurant_id=rid AND menu_item_id=mid;
dbms_output.put_line('created by Dhruv Chawla');
end;
/
--procedure to report menu items

create or replace procedure report_menu_item
is
begin
select menu_item_name,menu_item_quantity
from restaurant_inventory;
end;
/

CREATE OR REPLACE FUNCTION get_item_cost(item_id IN NUMBER)
RETURN NUMBER IS

    item_cost NUMBER(9,2);

BEGIN

    SELECT item_cost INTO item_cost
    FROM menu_item
    WHERE menu_item_id = item_id;
    
    RETURN item_cost;
END;
/

BEGIN
dbms_output.put_line('---------- WAITER REPORTS BY MEMBER 2: Kyle Keener -------------');
END;
/

--Procedure accepts Waiter name, restaurant they intend to work at and inserts them with a new waiter_id sequence number into waiters table
CREATE OR REPLACE PROCEDURE hire_waiter(waiter_name IN VARCHAR2, restaurant_id IN NUMBER)
IS 
BEGIN
    INSERT INTO WAITERS(waiter_id, waiter_name, restaurant_id)
    VALUES(waiter_id.NEXTVAL, waiter_name, restaurant_id);
END;
/

--Procedure prints all waiters working at a restaurant
CREATE OR REPLACE PROCEDURE show_waiters(rid IN NUMBER)
IS
    CURSOR staff_roll IS
        SELECT waiter_id, waiter_name 
        FROM waiters
        WHERE waiters.restaurant_id = rid;

    staff staff_roll%rowtype;
    
    wid NUMBER;
    wname VARCHAR2(80);
    
BEGIN
    OPEN staff_roll;
    LOOP
        FETCH staff_roll INTO staff;
        EXIT WHEN staff_roll%NOTFOUND;
        dbms_output.put_line('Waiter name: ' || staff.waiter_name || ' Waiter ID: ' || staff.waiter_id);
    END LOOP;
    
    EXCEPTION WHEN NO_DATA_FOUND
        THEN dbms_output.put_line(rid || ' has no available staff.');
END;
/

CREATE OR REPLACE PROCEDURE report_tips(wid IN NUMBER)
IS 
    lvt_waiter_name waiters.waiter_name%type;
    lvt_total_tips orders.tip%type;
    
BEGIN
    SELECT waiter_name INTO lvt_waiter_name
    FROM waiters
    WHERE waiter_id = wid;

    SELECT SUM(tip) INTO lvt_total_tips
    FROM orders
    JOIN waiters
    ON waiters.waiter_id = orders.waiter_id
    WHERE waiters.waiter_id = wid;

    dbms_output.put_line('Waiter name: ' || lvt_waiter_name);
    dbms_output.put_line('Tips Earned: ' || lvt_total_tips);
    
    EXCEPTION WHEN NO_DATA_FOUND
        THEN dbms_output.put_line(wid || ' was not found in the data.');
END;
/
    
CREATE OR REPLACE PROCEDURE report_tips_by_state(r_state IN CHAR)
IS
    tip_total NUMBER(9, 2);
    
BEGIN

    SELECT SUM(tip) INTO tip_total
    FROM orders
    JOIN restaurants
    ON restaurants.restaurant_state = r_state;
    
    dbms_output.put_line('The total tips earned in: ' || r_state || ' was $' || tip_total);

    EXCEPTION WHEN NO_DATA_FOUND
        THEN dbms_output.put_line(r_state || ' was not found in the data.');
        
END;
/


BEGIN
dbms_output.put_line('---------- ORDER REPORTS BY MEMBER 5: Kyle Keener -------------');
END;
/

--Place order procedure
CREATE OR REPLACE PROCEDURE place_order(c_id IN NUMBER, item_cost IN NUMBER, menu_item IN NUMBER, item_quantity IN NUMBER, restaurant_id IN NUMBER, tip IN NUMBER, order_date IN DATE)
IS
BEGIN

    INSERT INTO orders(order_id, customer_id, amount_paid, menu_item_id, menu_item_quantity, restaurant_id, tip, order_date)
    VALUES(order_id.NEXTVAL, c_id, item_cost, menu_item, item_quantity, restaurant_id, tip, order_date);

END;
/

--List all orders at given restaurant
CREATE OR REPLACE PROCEDURE display_orders(r_id IN NUMBER, o_date IN DATE)
IS

    CURSOR orders IS
        SELECT order_id, customer_id, amount_paid, menu_item_id, menu_item_quantity, tip
        FROM orders
        WHERE restaurant_id = r_id
        AND order_date = o_date;
        
    display orders%rowtype;
    
BEGIN

    dbms_output.put_line('Restaurant: ' || r_id || ' orders on date ' || o_date);

    FOR display IN orders
    LOOP
        dbms_output.put_line('Order ID: ' || display.order_id || ' for customer: ' || display.customer_id || ' who purchased ' || display.menu_item_quantity || ' of item number: ' || display.menu_item_id || ' paying $' || display.amount_paid || '.  The customer tipped $' || display.tip);
    END LOOP;
    
    EXCEPTION WHEN NO_DATA_FOUND
        THEN dbms_output.put_line('Order ID ' || r_id || ' on date ' || o_date || ' does not exist.');

END;
/

--List most popular items
CREATE OR REPLACE PROCEDURE most_popular_items(c_id IN NUMBER)
IS

    item_count NUMBER;

BEGIN

    SELECT COUNT(orders.menu_item_id) INTO item_count
    FROM orders, menu_item
    WHERE menu_item.cuisine_type_id = c_id
    AND orders.menu_item_id = menu_item.menu_item_id;

    dbms_output.put_line(item_count || ' of this order.');
    
    EXCEPTION WHEN NO_DATA_FOUND
        THEN dbms_output.put_line(c_id || ' has not been served.');

END;
/

--Top 3 restaurants
CREATE OR REPLACE FUNCTION top_rest_amount(r_id IN NUMBER)
RETURN NUMBER IS

    total NUMBER(9, 2);

BEGIN

    SELECT SUM(amount_paid) INTO total
    FROM orders 
    WHERE restaurant_id = r_id;
        
    RETURN total;
    
END;
/

CREATE OR REPLACE PROCEDURE top_restaurants(r_state IN CHAR)
IS

    total_earning NUMBER(9, 2);
    r_name VARCHAR2(60);
    r_id NUMBER;

    CURSOR top IS
        SELECT restaurant_id, restaurant_name INTO r_id, r_name
        FROM restaurants
        WHERE restaurant_state = r_state;
        
    list_top top%rowtype;

BEGIN

    FOR list_top IN top
    LOOP
        total_earning := top_rest_amount(r_id);
        dbms_output.put_line(r_name || ' earned $ ' || total_earning);
    END LOOP;
    
    EXCEPTION WHEN NO_DATA_FOUND
        THEN dbms_output.put_line('No restaurants exist in ' || r_name);

END;
/

--Member 5 Customer Procedures
--gathers the top and bottom paying customers (tips included) in cursors. Runs a loop to print the top 3 in these cursors
CREATE OR REPLACE PROCEDURE topBotCustomers
IS
    cursor top_cursor is 
        SELECT Customer_ID, SUM(amount_paid+tip) as total_paid
        FROM Orders
        WHERE ROWNUM <= 3
        GROUP BY Customer_ID
        ORDER BY SUM(amount_paid+tip) DESC;
    
    cursor bot_cursor is 
        SELECT Customer_ID, SUM(amount_paid+tip)  as total_paid
        FROM Orders
        WHERE ROWNUM <= 3
        GROUP BY Customer_ID
        ORDER BY SUM(amount_paid+tip) ASC;
begin
    dbms_output.put_line('The top 3 customers are: ');
    for top_rec in top_cursor
     loop
        dbms_output.put_line('Customer ID: '||top_rec.Customer_ID|| ', Total paid by customer: '||top_rec.total_paid);
    end loop;

    dbms_output.put_line('The bottom 3 customers are: ');
    for bot_rec in bot_cursor
     loop
        dbms_output.put_line('Customer ID: '||bot_rec.Customer_ID|| ', Total paid by customer: '||bot_rec.total_paid);
    end loop;
end;
/

--Uses select to create a list of the states by tip amount. prints each state and tip amount
CREATE OR REPLACE PROCEDURE stateTips
IS
    cursor top_tipper_state is 
        SELECT c.State, SUM(o.tip) as total_paid
        FROM Orders o, Customers c
        WHERE c.Customer_ID = o.Customer_ID
        GROUP BY c.State
        ORDER BY SUM(tip) DESC;
begin
    dbms_output.put_line('States in order of highest to lowest tippers:');
    for top_tip_rec in top_tipper_state
     loop
        dbms_output.put_line('State: '||top_tip_rec.State|| ', Total paid in tips: '||top_tip_rec.total_paid);
    end loop;
end;
/

-- List names of all customers who live in a given zip code
CREATE OR REPLACE PROCEDURE customersInZip (ZipCode IN NUMBER)
IS
    cursor customerZips is 
        SELECT Cust_Name
        FROM Customers
        WHERE Zip = ZipCode;
begin
    dbms_output.put_line('The names of customers from the zip code of '|| ZipCode || ' are:');
    for customerZips_rec in customerZips
    loop
        dbms_output.put_line(customerZips_rec.Cust_Name);
    end loop;
end;
/

--Add a customer
CREATE OR REPLACE PROCEDURE AddCustomer (Customer_ID IN NUMBER,
    Cust_Name IN VARCHAR2,
    Email IN VARCHAR2,
    Street_add IN VARCHAR2,
    City IN VARCHAR2,
    State IN VARCHAR2,
    Zip IN NUMBER,
    Credit_Card_Num IN NUMBER)
IS 
begin
    INSERT INTO Customers
    VALUES (Customer_ID, Cust_Name, Email, Street_add, City, State, Zip, Credit_Card_Num);
end;
/
--c_id IN NUMBER, item_cost IN NUMBER, menu_item IN NUMBER, item_quantity IN NUMBER, restaurant_id IN NUMBER, tip IN NUMBER, order_date IN DATE
--Execute order test conditions
EXECUTE place_order(1, 12.00, 3, 2, 1, 5.00, '08-DEC-2022');
EXECUTE display_orders(1, '11-NOV-2002');
EXECUTE display_orders(2, '01-JAN-2002');

EXECUTE most_popular_items(5);
EXECUTE most_popular_items(4);

EXECUTE top_restaurants('MD');
EXECUTE top_restaurants('VT');

--Execute statements
execute topBotCustomers();
execute stateTips();
execute customersInZip(21043);
execute AddCustomer(6, 'Bob Dylan', 'Bobby@gmail.com', '801 WatchTower lane', 'Rocksville', 'MD', 07823, 4530001821164902);


--execute create menu item procedure
execute create_menu_item('Italian', 'White Sauce Pasta', 14.99); 

--execute procedure to create restaurant inventory
execute create_restaurant_inventory ('burger', 'Busters Burger Bar',5);

--execute procedure to update menu item quantity
execute update_menu_item('burger', 'Busters Burger Bar',2);

--calling procedures 
    --inserting data via procedures 
    
    --inserting all cuisine types into cuisine_type table 
execute     add_cuisine_type('American');
execute     add_cuisine_type('Indian');
execute     add_cuisine_type('Italian');
execute     add_cuisine_type('BBQ');
execute     add_cuisine_type('Ethiopian');

    --inserting restaurants for each cuisine type into the restaurants table 
execute     add_restaurant('Starbucks', '8200 Crestwood Heights Dr', 'Tysons', 'VA', '22102', 1);
execute     add_restaurant('McDonalds', '8516 Leesburg Pike', 'Vienna', 'VA', '22182', 1);
execute     add_restaurant('Bombay Tandoor Bar and Grill', '8603 Westwood Center Dr', 'Vienna', 'VA', '22182', 2);
execute     add_restaurant('Masala Indian Cuisine', '1394 Chain Bridge Rd', 'McLean', 'VA', '22101', 2);
execute     add_restaurant('Filomena Ristorante', '1063 Wisconsin Ave NW', 'Washington', 'DC', '20007', 3);
execute     add_restaurant('Angolo Ristorante Italiano', '2934 M St NW', 'Washington', 'DC', '20007', 3);
execute     add_restaurant('Lucy Ethiopian Restaurant', '8301 Georgia Ave', 'Silver Spring', 'MD', '20910', 5);
execute     add_restaurant('Nile Restaurant and Market', '7815 Georgia Ave NW', 'Washington', 'DC', '20012', 5);
execute     add_restaurant('Mission BBQ', '3410 Plumtree Dr', 'Ellicott City', 'MD', '21042', 4);
execute     add_restaurant('The Wiggly Pig', '3830 Ten Oaks Rd', 'Glenelg', 'MD', '21737', 4);
execute     display_restaurant_by_cuisine(1);
execute     display_restaurant_by_cuisine(3);
execute     report_income_by_state();

--Insert values into the waiters tables
--id 1
INSERT INTO WAITERS(waiter_id, waiter_name, restaurant_id)
VALUES (waiter_id.NEXTVAL, 'Jack', 1);

INSERT INTO WAITERS(waiter_id, waiter_name, restaurant_id)
VALUES (waiter_id.NEXTVAL, 'Jill', 1);

INSERT INTO WAITERS(waiter_id, waiter_name, restaurant_id)
VALUES (waiter_id.NEXTVAL, 'Wendy', 1);

INSERT INTO WAITERS(waiter_id, waiter_name, restaurant_id)
VALUES (waiter_id.NEXTVAL, 'Hailey', 1);

--id 5
INSERT INTO WAITERS(waiter_id, waiter_name, restaurant_id)
VALUES (waiter_id.NEXTVAL, 'Mary', 2);

INSERT INTO WAITERS(waiter_id, waiter_name, restaurant_id)
VALUES (waiter_id.NEXTVAL, 'Pat', 2);

INSERT INTO WAITERS(waiter_id, waiter_name, restaurant_id)
VALUES (waiter_id.NEXTVAL, 'Michael', 2);

INSERT INTO WAITERS(waiter_id, waiter_name, restaurant_id)
VALUES (waiter_id.NEXTVAL, 'Rakesh', 2);

INSERT INTO WAITERS(waiter_id, waiter_name, restaurant_id)
VALUES (waiter_id.NEXTVAL, 'Verma', 2);

--id 10
INSERT INTO WAITERS(waiter_id, waiter_name, restaurant_id)
VALUES (waiter_id.NEXTVAL, 'Mike', 3);

INSERT INTO WAITERS(waiter_id, waiter_name, restaurant_id)
VALUES (waiter_id.NEXTVAL, 'Judy', 3);

INSERT INTO WAITERS(waiter_id, waiter_name, restaurant_id)
VALUES (waiter_id.NEXTVAL, 'Trevor', 4);

INSERT INTO WAITERS(waiter_id, waiter_name, restaurant_id)
VALUES (waiter_id.NEXTVAL, 'Trudy', 5);

INSERT INTO WAITERS(waiter_id, waiter_name, restaurant_id)
VALUES (waiter_id.NEXTVAL, 'Trisha', 5);

--id 15
INSERT INTO WAITERS(waiter_id, waiter_name, restaurant_id)
VALUES (waiter_id.NEXTVAL, 'Tariq', 5);

INSERT INTO WAITERS(waiter_id, waiter_name, restaurant_id)
VALUES (waiter_id.NEXTVAL, 'Chap', 6);

INSERT INTO WAITERS(waiter_id, waiter_name, restaurant_id)
VALUES (waiter_id.NEXTVAL, 'Hanna', 7);

--insert menu items
INSERT INTO menu_item (menu_item_id, cuisine_type_id,menu_item_name,menu_item_price)
VALUES (menu_item_id.nextval,1,'burger',5.99);
INSERT INTO menu_item (menu_item_id, cuisine_type_id,menu_item_name,menu_item_price)
VALUES (menu_item_id.nextval,1,'fries',9.99);
INSERT INTO menu_item (menu_item_id, cuisine_type_id,menu_item_name,menu_item_price)
VALUES (menu_item_id.nextval,1,'pasta',3.99);
INSERT INTO menu_item (menu_item_id, cuisine_type_id,menu_item_name,menu_item_price)
VALUES (menu_item_id.nextval,1,'salad',4.99);
INSERT INTO menu_item (menu_item_id, cuisine_type_id,menu_item_name,menu_item_price)
VALUES (menu_item_id.nextval,1,'salmon',6.99);
INSERT INTO menu_item (menu_item_id, cuisine_type_id,menu_item_name,menu_item_price)
VALUES (menu_item_id.nextval,2,'steak',8.99);
INSERT INTO menu_item (menu_item_id, cuisine_type_id,menu_item_name,menu_item_price)
VALUES (menu_item_id.nextval,2,'pork',10.99);
INSERT INTO menu_item (menu_item_id, cuisine_type_id,menu_item_name,menu_item_price)
VALUES (menu_item_id.nextval,2,'loin',10.99);
INSERT INTO menu_item (menu_item_id, cuisine_type_id,menu_item_name,menu_item_price)
VALUES (menu_item_id.nextval,2,'filet mignon',10.99);
INSERT INTO menu_item (menu_item_id, cuisine_type_id,menu_item_name,menu_item_price)
VALUES (menu_item_id.nextval,3,'dal soup',10.99);
INSERT INTO menu_item (menu_item_id, cuisine_type_id,menu_item_name,menu_item_price)
VALUES (menu_item_id.nextval,3,'rice',10.99);
INSERT INTO menu_item (menu_item_id, cuisine_type_id,menu_item_name,menu_item_price)
VALUES (menu_item_id.nextval,3,'tandoori chicken',10.99);
INSERT INTO menu_item (menu_item_id, cuisine_type_id,menu_item_name,menu_item_price)
VALUES (menu_item_id.nextval,3,'samosa',10.99);
INSERT INTO menu_item (menu_item_id, cuisine_type_id,menu_item_name,menu_item_price)
VALUES (menu_item_id.nextval,4,'lasagna',10.99);
INSERT INTO menu_item (menu_item_id, cuisine_type_id,menu_item_name,menu_item_price)
VALUES (menu_item_id.nextval,4,'meatballs',10.99);
INSERT INTO menu_item (menu_item_id, cuisine_type_id,menu_item_name,menu_item_price)
VALUES (menu_item_id.nextval,4,'spaghetti',10.99);
INSERT INTO menu_item (menu_item_id, cuisine_type_id,menu_item_name,menu_item_price)
VALUES (menu_item_id.nextval,4,'pizza',10.99);
INSERT INTO menu_item (menu_item_id, cuisine_type_id,menu_item_name,menu_item_price)
VALUES (menu_item_id.nextval,5,'meat chunks',10.99);
INSERT INTO menu_item (menu_item_id, cuisine_type_id,menu_item_name,menu_item_price)
VALUES (menu_item_id.nextval,5,'legume stew',10.99);
INSERT INTO menu_item (menu_item_id, cuisine_type_id,menu_item_name,menu_item_price)
VALUES (menu_item_id.nextval,5,'flatbread',10.99);


COMMIT;

--Populates orders
--cust1
INSERT INTO ORDERS(order_id, customer_id, amount_paid, menu_item_id, menu_item_quantity, restaurant_id, waiter_id, tip, order_date)
VALUES(order_id.NEXTVAL, 1, 20.00, 17, 1, 2, 5, 6.00, '11-OCT-2022');

--cust11
INSERT INTO ORDERS(order_id, customer_id, amount_paid, menu_item_id, menu_item_quantity, restaurant_id, waiter_id, tip, order_date)
VALUES(order_id.NEXTVAL, 2, 30.00, 15, 2, 2, 5, 8.00, '15-OCT-2022');

--cust11
INSERT INTO ORDERS(order_id, customer_id, amount_paid, menu_item_id, menu_item_quantity, restaurant_id, waiter_id, tip, order_date)
VALUES(order_id.NEXTVAL, 2, 20.00, 16, 1, 2, 13, 5.00, '15-OCT-2022');

--custny1
INSERT INTO ORDERS(order_id, customer_id, amount_paid, menu_item_id, menu_item_quantity, restaurant_id, waiter_id, tip, order_date)
VALUES(order_id.NEXTVAL, 3, 60.00, 8, 2, 7, 17, 8.00, '1-NOV-2022');

--custny1
INSERT INTO ORDERS(order_id, customer_id, amount_paid, menu_item_id, menu_item_quantity, restaurant_id, waiter_id, tip, order_date)
VALUES(order_id.NEXTVAL, 3, 60.00, 8, 2, 7, 17, 8.00, '2-NOV-2022');

--custny2
INSERT INTO ORDERS(order_id, customer_id, amount_paid, menu_item_id, menu_item_quantity, restaurant_id, waiter_id, tip, order_date)
VALUES(order_id.NEXTVAL, 4, 15.00, 6, 1, 7, 17, 5.00, '1-NOV-2022');

--custpa1
INSERT INTO ORDERS(order_id, customer_id, amount_paid, menu_item_id, menu_item_quantity, restaurant_id, waiter_id, tip, order_date)
VALUES(order_id.NEXTVAL, 5, 120.00, 17, 10, 5, 14, 15.00, '1-DEC-2022');

--custpa1
INSERT INTO ORDERS(order_id, customer_id, amount_paid, menu_item_id, menu_item_quantity, restaurant_id, waiter_id, tip, order_date)
VALUES(order_id.NEXTVAL, 5, 120.00, 17, 10, 5, 14, 12.00, '1-DEC-2022');

--custpa1
INSERT INTO ORDERS(order_id, customer_id, amount_paid, menu_item_id, menu_item_quantity, restaurant_id, waiter_id, tip, order_date)
VALUES(order_id.NEXTVAL, 5, 120.00, 17, 10, 5, 14, 15.00, '5-DEC-2022');

--custpa2
INSERT INTO ORDERS(order_id, customer_id, amount_paid, menu_item_id, menu_item_quantity, restaurant_id, waiter_id, tip, order_date)
VALUES(order_id.NEXTVAL, 6, 100.00, 18, 10, 4, 12, 15.00, '1-DEC-2022');

--custpa2
INSERT INTO ORDERS(order_id, customer_id, amount_paid, menu_item_id, menu_item_quantity, restaurant_id, waiter_id, tip, order_date)
VALUES(order_id.NEXTVAL, 6, 100.00, 18, 10, 4, 12, 15.00, '6-DEC-2022');

COMMIT;

--Execute hire and show waiters procedures
EXECUTE hire_waiter('Burke', 3);
EXECUTE show_waiters(3);
COMMIT;

--Execute tip reporting procedures
EXECUTE report_tips(12);
EXECUTE report_tips(5);
EXECUTE report_tips(10);

EXECUTE report_tips_by_state('MD');
EXECUTE report_tips_by_state('VA');