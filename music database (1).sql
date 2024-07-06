
/*Q1  Who is the senior most employee based on the job title? */
select * from employee
order by levels desc
limit 1;

/*Q2 Which countries have the most Invoices? */
SELECT COUNT(*) as c,billing_country
from invoice
GROUP BY billing_country
ORDER BY c desc ;

/*Q3 What are the top 3 values of total invoice? */
select total from invoice
order by total desc
limit 3 ;

/* Q4 Which city has the best customers? We would like to throw a promotional Music festival in the city we made the most money. Write a query that returns one
city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals? */
select sum(total) as def, billing_city
from invoice
group by billing_city
order by def desc ;

/* Q5 Who is the best customer? The person who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money?*/ 
select customer.customer_id, customer.first_name, customer.last_name,sum(invoice.total)as total
from customer
join invoice on customer.customer_id=invoice.customer_id
group by customer.customer_id
order by total desc
limit 1;

/*Q6 Write query to return the email,first name, last name and Genre of all Rock music listeners. Return your list ordered alphabetically by email starting with A?*/
select distinct email,first_name, last_name 
from customer
join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice.invoice_id= invoice_line.invoice_id
where track_id in(
	select track_id from track
	join genre on track.genre_id=genre.genre_id
	where genre.name='Rock'
)
order by email;
/* Q7 Let's invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count of top 10 rock bands?*/
select artist.artist_id, artist.name, count(artist.artist_id)as gt
from album
join artist on artist.artist_id=album.artist_id
join track on track.album_id=album.album_id
join genre on genre.genre_id=track.genre_id
where genre.name='Rock'
group by artist.artist_id
order by gt desc
limit 10;

/* Q8 Return all the track names that have a song length longer than the average song length. Return the Name and milliseconds for each track. Order by the song length with longest song listed firdt?*/
select name, milliseconds
from track
where milliseconds>(
	select avg(milliseconds)as ad
	from track

)
order by milliseconds desc;
/* Q9 Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent?*/
with bsa as (
 select artist.artist_id as w,artist.name as i,
 sum(invoice_line.unit_price*invoice_line.quantity)as totalsales
 from invoice_line
 join track on invoice_line.track_id=track.track_id
 join album on album.album_id= track.album_id
 join artist on album.artist_id= artist.artist_id
 group by artist.artist_id
 order by totalsales desc
 limit 1
)

select customer.customer_id, customer.first_name, customer.last_name, bsa.i,
sum(invoice_line.unit_price*invoice_line.quantity)as amountspent
from invoice
join customer on customer.customer_id= invoice.customer_id
join invoice_line on invoice_line.invoice_id=invoice.invoice_id
join track on track.track_id= invoice_line.track_id
join album on track.album_id = album.album_id
join bsa on album.artist_id= bsa.w
group by 1,2,3,4
order by 5 desc;

/* Q10 We want to find out the most popular music genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. Write a 
query that returns each country along with the top genre. For countries where the maximum number of purchases
is shared return all genres?*/
with popular_genre as
(
	select count(invoice_line.quantity)as purchases,customer.country,genre.name,genre.genre_id,
	row_number() over(partition by customer.country order by count(invoice_line.quantity) desc)as rowno
	from invoice_line
	join invoice on invoice.invoice_id=invoice_line.invoice_id
	join customer on customer.customer_id=invoice.customer_id
	join track on track.track_id = invoice_line.track_id
	join genre on track.genre_id = genre.genre_id
	group by 2,3,4
	order by 2 asc,1 desc
	)
	select*from popular_genre where rowno<=1;

/* Q11 Write a query that determines the customer that has spent the most on music for each
       country. Write a query that returns the country along with the top customer and
	   how much they spent?*/
with best_customer as
(
	   select customer.customer_id, customer.first_name, customer.last_name,customer.country ,sum(invoice_line.unit_price*invoice_line.quantity)as amountspent
	   ,row_number()over(partition by customer.country order by sum(invoice_line.unit_price*invoice_line.quantity)desc)as rowno
	   from invoice_line
	   join invoice on invoice.invoice_id=invoice_line.invoice_id
	   join customer on customer.customer_id= invoice.customer_id
	   group by 1,2,3,4
	   order by 4 asc, 5 desc
)

select * from best_customer where rowno<=1
	   
	   




