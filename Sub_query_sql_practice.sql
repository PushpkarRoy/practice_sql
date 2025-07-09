CREATE TABLE doctors (
doctor_id INT,
name VARCHAR(50),
specialty VARCHAR(50),
city VARCHAR(50),
experience_years INT
)

CREATE TABLE patients (
patient_id INT,
name VARCHAR(50),
age INT,
gender VARCHAR(10),
city VARCHAR(50)
)

CREATE TABLE visits(
visit_id INT,
patient_id INT,
doctor_id	INT,
visit_date	DATE,
bill_amount	INT,
follow_up VARCHAR(10)
)

SELECT * FROM doctors
SELECT * FROM patients
SELECT * FROM visits

-- Quest 1.Find patients who have been billed more than the average bill across all visits.

SELECT p.name, SUM(v.bill_amount) AS total_bill
FROM patients AS p
JOIN visits AS v
ON p.patient_id = v.patient_id 
GROUP BY p.name 
HAVING SUM(v.bill_amount) >= (SELECT AVG(bill_amount)
                             FROM visits) 
ORDER BY total_bill DESC

-- Quest 2. List doctors whose average bill per visit is greater than the overall average bill amount.

SELECT d.name, ROUND(AVG(v.bill_amount):: NUMERIC, 2) avg_doctor_bill
FROM visits AS v
JOIN doctors AS d
ON v.doctor_id = d.doctor_id
GROUP BY d.name 
HAVING AVG(v.bill_amount) >= ( SELECT AVG(bill_amount)
								FROM visits )
ORDER BY avg_doctor_bill DESC

-- Quest 3. Find the patient(s) who spent the most overall (total bill).

SELECT p.name, 	
		SUM(v.bill_amount) AS Total_bill,
		ROUND(SUM(v.bill_amount) * 100.0 / ( SELECT SUM(bill_amount)
									FROM visits ):: NUMERIC,2) AS percentage_spend
FROM patients AS p
JOIN visits AS v
ON p.patient_id = v.patient_id
GROUP BY p.name

-- Quest 4. List patients who never had a follow-up visit.

SELECT p.patient_id, p.name, COUNT(p.name) AS total_visit
FROM patients AS p
JOIN visits AS v
ON p.patient_id = v.patient_id 
GROUP BY p.patient_id, p.name 
HAVING 
	SUM(CASE 
			WHEN follow_up = 'Y' THEN 1
			ELSE  0 END ) = 0

-- Quest 5. Show doctors who were visited by patients from more than 2 different cities.

SELECT d.doctor_id, d.name AS doctor_name, COUNT(DISTINCT p.city) AS unique_patient_city
FROM doctors AS d
JOIN visits AS v
ON v.doctor_id = d.doctor_id
JOIN patients AS p
ON p.patient_id = v.patient_id
GROUP BY d.doctor_id, d.name
HAVING  COUNT(DISTINCT p.city) >= 2 

-- Quest 6. Find patients who visited every specialty the hospital offers.

SELECT  p.patient_id, 
		p.name
FROM patients AS p
JOIN visits AS v
ON p.patient_id = v.patient_id 
JOIN doctors AS d
ON d.doctor_id = v.doctor_id 
GROUP BY p.patient_id, p.name 
HAVING COUNT( DISTINCT d.specialty) = (SELECT COUNT(DISTINCT specialty)
										FROM doctors )

-- Quest 7. Show the doctor with the highest total revenue (sum of bill amounts from all visits).

SELECT  d.name, 
		SUM(v.bill_amount) AS total_bill_revenue,
		ROUND(SUM(v.bill_amount) * 100.0 / (SELECT SUM(bill_amount)
										FROM visits ):: NUMERIC ,2) AS percentage 
FROM doctors AS d
JOIN visits AS v
ON d.doctor_id = v.doctor_id 
GROUP BY d.name
ORDER BY total_bill_revenue DESC

-- Quest 8. Which patients had their first visit with a doctor not from their own city?

SELECT patient_name, patient_city, visit_date, doctor_name, doctor_city
FROM (
	SELECT  p.name AS patient_name, p.city AS patient_city,
			v.visit_date , 
			d.name AS doctor_name, d.city AS doctor_city,
			RANK() OVER(PARTITION BY p.name ORDER BY visit_date) AS ranking
	FROM patients AS p
	JOIN visits As V
	ON p.patient_id = v.patient_id 
	JOIN doctors AS d
	ON d.doctor_id = v.doCtor_id ) AS x
WHERE patient_city != doctor_city AND ranking = 1

-- Quets 9. List all patients who had multiple visits but only one follow-up total.

SELECT DISTINCT p.patient_id , p.name AS patient_name,COUNT(v.patient_id) AS total_visisting_count
FROM patients AS p
JOIN visits AS v
ON p.patient_id = v.patient_id 
GROUP BY p.patient_id , patient_name
HAVING SUM(
			CASE 
				WHEN follow_up = 'Y' THEN 1
				ELSE 0
			END ) = 1 AND COUNT(v.patient_id) = 2			

-- Quest 10. Find doctors who haven’t been visited in the last 60 days.

SELECT d.name AS doctor_name, v.visit_date
FROM doctors AS d
JOIN visits AS v
ON d.doctor_id = v.doctor_id 
WHERE visit_date <= (SELECT visit_date
					FROM visits 
					ORDER BY visit_date DESC 
					LIMIT 1 ) - INTERVAL '2 Month' 

-- _____________________________________ OR ______________________________________________
	
SELECT d.doctor_id, d.name
FROM doctors d
WHERE NOT EXISTS (
    SELECT 1
    FROM visits v
    WHERE v.doctor_id = d.doctor_id
      AND v.visit_date >= (SELECT visit_date
					FROM visits 
					ORDER BY visit_date DESC 
					LIMIT 1 )- INTERVAL '60 day'
);
