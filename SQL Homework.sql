-- open sakila DB
use sakila;

-- 1a Display the first and last names of all actors from the table `actor`.
select first_name, last_name from actor;

-- 1b Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
select concat(first_name, ' ', last_name) as 'Actor Name' from actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name from actor  where first_name = "Joe";

-- 2b. Find all actors whose last name contain the letters `GEN`
select first_name, last_name from actor where last_name like '%gen%';

--  2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
select first_name, last_name from actor where last_name like '%li%' order by last_name, first_name;

--  2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:

select country_id, country from country where country in  ("Bangladesh","Afghanistan", "China");

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).

alter table actor
add description blob;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.

alter table actor DROP description;
select*from actor;

-- 4a. List the last names of actors, as well as how many actors have that last name.

select last_name, count(last_name) from actor group by (last_name);

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

select last_name, count(last_name) from actor group by (last_name) having count(last_name) >=2;

-- 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.

update actor 
set first_name = "Harpo"
where first_name = "Groucho" and last_name = "Williams";
select first_name, last_name from actor where last_name = "Williams" and first_name = "Harpo";

-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
update actor 
set first_name = "Groucho" where first_name = "Harpo" and last_name = "Williams";

-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?

SHOW CREATE TABLE address;

-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:

select*from staff;
select*from address;

select staff.first_name, staff.last_name, address.address from address
inner join staff on 
staff.address_id = address.address_id;

-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.

select*from payment;
select*from staff;

select staff.first_name, staff.last_name, sum(payment.amount) from payment
join staff on 
staff.staff_id = payment.staff_id
where month(payment.payment_date) and year(payment.payment_date) = 2005
group by staff.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.

select*from film;

select film.title, count(actor_id) from film
inner join film_actor on 
film.film_id = film_actor.film_id
group by film.title;

-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?

select*from inventory;
select*from film;

select film.title, count(inventory.film_id) from inventory
join film on
inventory.film_id = film.film_id
where film.title = "Hunchback Impossible";

-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:

select*from customer;
select*from payment;

select customer.first_name, customer.last_name, sum(payment.amount) from customer
join payment on
customer.customer_id = payment.customer_id
group by customer.customer_id
order by customer.last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.

select title from film where title like 'K%' or title like 'Q%'
and language_id in (
select language_id from language
where name = "English");

-- HOW DO WE GET THE LANGUAGE FOT THESE MOVIES IN THE RESULT???

-- 7b Use subqueries to display all actors who appear in the film `Alone Trip`.

select*from film_actor;

select first_name, last_name from actor
where actor_id in (
select actor_id from film_actor
where film_id in(
select film_id from film
where title = "Alone Trip"));

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

select*from country;

select customer.first_name, customer.last_name, customer.email  from customer
inner join address on customer.address_id = address.address_id
inner join city on address.city_id = city.city_id
inner join country on city.country_id = country.country_id
where country.country = "Canada"; 

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.

select*from film_category;

select film.title from film 
inner join film_category on film.film_id = film_category.film_id
inner join category on film_category.category_id = category.category_id
where category.name = "Family";
 
-- * 7e. Display the most frequently rented movies in descending order.

select*from inventory;

select film.title from film
inner join


