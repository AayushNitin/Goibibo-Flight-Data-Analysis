-- Aayush Nitin
-- NIT Jamshepdur

-- Goibibo Flight Data Analysis


# 1. Most popular routes based on Bookings
SELECT d.`from` AS origin, d.`to` AS destination, COUNT(*) AS bookings
FROM Destinations d
GROUP BY d.`from`, d.`to`
ORDER BY bookings DESC;

# 2. Most Preferred Airlines by Customers
SELECT a.airline, COUNT(*) AS bookings
FROM airline a
GROUP BY a.airline
ORDER BY bookings DESC;

# 3. Popular Booking Days of the Week
SELECT DAYNAME(d.flight_date) AS day_of_week, COUNT(*) AS bookings
FROM Destinations d
GROUP BY day_of_week
ORDER BY FIELD(day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

# 4. Preferred Departure Times Among Customers
SELECT 
  CASE 
    WHEN HOUR(t.dep_time) BETWEEN 5 AND 8 THEN 'Early Morning'
    WHEN HOUR(t.dep_time) BETWEEN 9 AND 11 THEN 'Morning'
    WHEN HOUR(t.dep_time) BETWEEN 12 AND 16 THEN 'Afternoon'
    WHEN HOUR(t.dep_time) BETWEEN 17 AND 20 THEN 'Evening'
    ELSE 'Night'
  END AS time_slot,
  COUNT(*) AS bookings
FROM Transit t
GROUP BY time_slot
ORDER BY FIELD(time_slot, 'Early Morning', 'Morning', 'Afternoon', 'Evening', 'Night');

# 5. Average Price by Airline
SELECT a.airline, round(AVG(c.price),3) AS average_price
FROM airline a
JOIN Class c ON a.flight_date = c.flight_date AND a.flight_num = c.flight_num
GROUP BY a.airline
ORDER BY average_price DESC;

# 6. Popular Routes by Class
SELECT d.`from` AS origin, d.`to` AS destination, c.class, COUNT(*) AS bookings
FROM Destinations d
JOIN Class c ON d.flight_date = c.flight_date AND d.flight_num = c.flight_num
GROUP BY d.`from`, d.`to`, c.class
ORDER BY bookings DESC;

# 7. Top 5 Airlines by Revenue
SELECT a.airline, SUM(c.price) AS total_revenue
FROM airline a
JOIN Class c ON a.flight_date = c.flight_date AND a.flight_num = c.flight_num
GROUP BY a.airline
ORDER BY total_revenue DESC
LIMIT 5;

# 8. Correlation Between Stops and Price (See how the number of stops affects the price customers are paying.)
SELECT d.stops, round(AVG(c.price),3) AS average_price, COUNT(*) AS bookings
FROM Destinations d
JOIN Class c ON d.flight_date = c.flight_date AND d.flight_num = c.flight_num
GROUP BY d.stops
ORDER BY d.stops;

# 9. Top Routes for Business Class Bookings
SELECT d.`from` AS origin, d.`to` AS destination, COUNT(*) AS bookings
FROM Destinations d
JOIN Class c ON d.flight_date = c.flight_date AND d.flight_num = c.flight_num
WHERE c.class = 'Business'
GROUP BY d.`from`, d.`to`
ORDER BY bookings DESC
LIMIT 10;

# 10. Average Price by Departure Time Slot (i.e. Analyze how departure times affect the prices customers pay.)
SELECT 
  CASE 
    WHEN HOUR(t.dep_time) BETWEEN 5 AND 8 THEN 'Early Morning'
    WHEN HOUR(t.dep_time) BETWEEN 9 AND 11 THEN 'Morning'
    WHEN HOUR(t.dep_time) BETWEEN 12 AND 16 THEN 'Afternoon'
    WHEN HOUR(t.dep_time) BETWEEN 17 AND 20 THEN 'Evening'
    ELSE 'Night'
  END AS time_slot,
  round(AVG(c.price),3) AS average_price
FROM Transit t
JOIN Class c ON t.flight_date = c.flight_date AND t.flight_num = c.flight_num
GROUP BY time_slot
ORDER BY FIELD(time_slot, 'Early Morning', 'Morning', 'Afternoon', 'Evening', 'Night');

# 11. Booking Distribution Across Airlines for Top Routes (i.e. which airlines customers prefer on the most popular routes.)
SELECT d.`from` AS origin, d.`to` AS destination, a.airline, COUNT(*) AS bookings
FROM Destinations d
JOIN airline a ON d.flight_date = a.flight_date AND d.flight_num = a.flight_num
WHERE (d.`from`, d.`to`) IN (
  SELECT `from`, `to`
  FROM (
    SELECT d2.`from`, d2.`to`, COUNT(*) AS route_bookings
    FROM Destinations d2
    GROUP BY d2.`from`, d2.`to`
    ORDER BY route_bookings DESC
    LIMIT 5
  ) AS top_routes
)
GROUP BY d.`from`, d.`to`, a.airline
ORDER BY origin, destination, bookings DESC;

# 12. Airline Market Share Among Goibibo Customers
SELECT a.airline, round((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM airline)),3) AS market_share_percentage
FROM airline a
GROUP BY a.airline
ORDER BY market_share_percentage DESC;
