-- =================================================================
-- COMPREHENSIVE SQL QUERIES FOR DENTAL CLINIC MANAGEMENT SYSTEM
-- Based on DBMS_Schema_V2.sql and fill_data.sql
-- Generated on November 16, 2025
-- =================================================================

-- i. GROUP BY...HAVING Query
-- Use case: Find patients who have had more than 2 appointments and show their total invoice amounts
-- This helps identify high-frequency patients and their financial contribution to the clinic
SELECT 
    p.patient_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    COUNT(a.appointment_id) AS total_appointments,
    SUM(i.total_amount) AS total_billed
FROM patients p
JOIN appointments a ON p.patient_id = a.patient_id
LEFT JOIN invoices i ON p.patient_id = i.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name
HAVING COUNT(a.appointment_id) > 2
ORDER BY total_billed DESC;

-- ii. ORDER BY Query
-- Use case: Generate a comprehensive patient report ordered by registration date and total amount owed
-- This helps the billing department prioritize collection efforts and track patient acquisition patterns
SELECT 
    p.patient_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    p.registration_date,
    p.city,
    p.state,
    COALESCE(SUM(i.total_amount - i.amount_paid), 0) AS outstanding_balance
FROM patients p
LEFT JOIN invoices i ON p.patient_id = i.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name, p.registration_date, p.city, p.state
ORDER BY p.registration_date DESC, outstanding_balance DESC;

-- iii.a. INNER JOIN Query
-- Use case: Get detailed appointment information with staff and patient details for completed appointments
-- This helps in generating appointment reports and tracking provider productivity
SELECT 
    a.appointment_id,
    a.appointment_type,
    a.status,
    p.first_name || ' ' || p.last_name AS patient_name,
    sp.first_name || ' ' || sp.last_name AS staff_name,
    c.clinic_name,
    lower(a.appointment_period) AS appointment_start,
    a.notes
FROM appointments a
INNER JOIN patients p ON a.patient_id = p.patient_id
INNER JOIN staff_profiles sp ON a.staff_id = sp.staff_id
INNER JOIN clinics c ON a.clinic_id = c.clinic_id
WHERE a.status = 'Completed';

-- iii.b. LEFT OUTER JOIN Query
-- Use case: Show all patients and their emergency contacts (including patients without emergency contacts)
-- This is crucial for patient safety and emergency preparedness
SELECT 
    p.patient_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    p.date_of_birth,
    COALESCE(ec.full_name, 'No Emergency Contact') AS emergency_contact_name,
    COALESCE(ec.contact_relationship, 'N/A') AS relationship,
    COALESCE(ec.phone_number, 'No Phone') AS emergency_phone
FROM patients p
LEFT OUTER JOIN emergency_contacts ec ON p.patient_id = ec.patient_id
ORDER BY p.last_name;

-- iii.c. SELF JOIN Query
-- Use case: Find patients who live in the same city (for potential group appointments or referrals)
-- This helps in community outreach and patient referral programs
SELECT DISTINCT
    p1.patient_id AS patient1_id,
    p1.first_name || ' ' || p1.last_name AS patient1_name,
    p2.patient_id AS patient2_id,
    p2.first_name || ' ' || p2.last_name AS patient2_name,
    p1.city,
    p1.state,
    p1.last_name
FROM patients p1
JOIN patients p2 ON p1.city = p2.city AND p1.state = p2.state AND p1.patient_id < p2.patient_id
ORDER BY p1.city, p1.last_name;

-- iii.d. NATURAL JOIN Query (Modified to work with the schema)
-- Use case: Get patient procedures with treatment codes using common patient_id
-- This helps in treatment analysis and clinical reporting
SELECT 
    pl.procedure_id,
    pl.patient_id,
    pl.procedure_date,
    tc.code_value,
    tc.description AS procedure_description,
    pl.fee_charged
FROM procedures_log pl, treatment_codes tc, patients p
WHERE pl.code_id = tc.code_id 
AND pl.patient_id = p.patient_id
ORDER BY pl.procedure_date DESC;

-- iv.a. INDEPENDENT SUBQUERY Query
-- Use case: Find all patients who have procedures more expensive than the average procedure cost
-- This helps identify high-value treatments and patient spending patterns
SELECT 
    p.patient_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    pl.procedure_date,
    tc.description AS procedure_description,
    pl.fee_charged
FROM patients p
JOIN procedures_log pl ON p.patient_id = pl.patient_id
JOIN treatment_codes tc ON pl.code_id = tc.code_id
WHERE pl.fee_charged > (
    SELECT AVG(fee_charged)
    FROM procedures_log
)
ORDER BY pl.fee_charged DESC;

-- iv.b. CORRELATED SUBQUERY Query
-- Use case: Find patients whose most recent appointment was more than 6 months ago (due for checkup)
-- This helps in patient recall and preventive care scheduling
SELECT 
    p.patient_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    p.city,
    p.state,
    ppe.email_address,
    ppn.phone_number
FROM patients p
LEFT JOIN patient_email_addresses ppe ON p.patient_id = ppe.patient_id AND ppe.is_primary = true
LEFT JOIN patient_phone_numbers ppn ON p.patient_id = ppn.patient_id AND ppn.is_primary = true
WHERE (
    SELECT MAX(lower(appointment_period))
    FROM appointments a
    WHERE a.patient_id = p.patient_id
) < CURRENT_DATE - INTERVAL '6 months'
OR NOT EXISTS (
    SELECT 1
    FROM appointments a
    WHERE a.patient_id = p.patient_id
)
ORDER BY p.last_name;

-- v.a. EXISTS Query
-- Use case: Find all staff members who have conducted periodontal examinations
-- This helps identify staff expertise and workload distribution
SELECT 
    sp.staff_id,
    sp.first_name || ' ' || sp.last_name AS staff_name,
    sp.contact_email,
    COUNT(pe.perio_exam_id) AS total_perio_exams
FROM staff_profiles sp
JOIN perio_exams pe ON sp.staff_id = pe.staff_id
GROUP BY sp.staff_id, sp.first_name, sp.last_name, sp.contact_email
ORDER BY total_perio_exams DESC;

-- v.b. NOT EXISTS Query
-- Use case: Find patients who have never had any invoices (potential billing issues or new patients)
-- This helps identify billing gaps and track new patient onboarding
SELECT 
    p.patient_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    p.registration_date,
    p.city,
    p.state,
    COUNT(a.appointment_id) AS total_appointments
FROM patients p
LEFT JOIN appointments a ON p.patient_id = a.patient_id
WHERE NOT EXISTS (
    SELECT 1
    FROM invoices i
    WHERE i.patient_id = p.patient_id
)
GROUP BY p.patient_id, p.first_name, p.last_name, p.registration_date, p.city, p.state
ORDER BY p.registration_date;

-- vi. AGGREGATE FUNCTIONS Query
-- Use case: Comprehensive clinic performance dashboard showing key metrics
-- This provides management with essential KPIs for business decision making
SELECT 
    c.clinic_name,
    COUNT(DISTINCT p.patient_id) AS total_patients,
    COUNT(a.appointment_id) AS total_appointments,
    AVG(i.total_amount) AS avg_invoice_amount,
    SUM(i.amount_paid) AS total_revenue,
    MAX(i.total_amount) AS highest_invoice,
    MIN(i.total_amount) AS lowest_invoice,
    STDDEV(i.total_amount) AS invoice_std_dev
FROM clinics c
LEFT JOIN appointments a ON c.clinic_id = a.clinic_id
LEFT JOIN patients p ON a.patient_id = p.patient_id
LEFT JOIN invoices i ON p.patient_id = i.patient_id
GROUP BY c.clinic_id, c.clinic_name
ORDER BY total_revenue DESC;

-- vii. BOOLEAN OPERATORS Query
-- Use case: Find high-risk patients (seniors with allergies and active medical conditions)
-- This helps in treatment planning and risk assessment
SELECT 
    p.patient_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    p.date_of_birth,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, p.date_of_birth)) AS age,
    pa.allergy_name,
    pa.severity,
    mh.description AS medical_condition
FROM patients p
JOIN patient_allergies pa ON p.patient_id = pa.patient_id
JOIN medical_history mh ON p.patient_id = mh.patient_id
WHERE (EXTRACT(YEAR FROM AGE(CURRENT_DATE, p.date_of_birth)) >= 65)
AND (pa.severity = 'Severe' OR pa.severity = 'Moderate')
AND mh.is_active = true
AND NOT (mh.history_type = 'Surgery' AND mh.end_date IS NOT NULL)
ORDER BY age DESC, pa.severity DESC;

-- viii. ARITHMETIC OPERATORS Query
-- Use case: Calculate payment efficiency and outstanding balances for financial reporting
-- This helps the finance team track collection rates and cash flow
SELECT 
    p.patient_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    i.invoice_id,
    i.total_amount,
    i.amount_paid,
    (i.total_amount - i.amount_paid) AS outstanding_balance,
    ROUND(((i.amount_paid / i.total_amount) * 100), 2) AS payment_percentage,
    (i.total_amount * 0.02) AS late_fee_if_overdue,
    CASE 
        WHEN i.due_date < CURRENT_DATE AND (i.total_amount - i.amount_paid) > 0 
        THEN (i.total_amount - i.amount_paid) + (i.total_amount * 0.02)
        ELSE (i.total_amount - i.amount_paid)
    END AS total_amount_due
FROM patients p
JOIN invoices i ON p.patient_id = i.patient_id
WHERE i.total_amount > 0
ORDER BY outstanding_balance DESC;

-- ix. STRING OPERATORS Query
-- Use case: Search for patients and staff with flexible name matching for reception lookup
-- This helps reception staff quickly find records during patient check-in
SELECT 
    'Patient' AS record_type,
    p.patient_id AS id,
    p.first_name || ' ' || p.last_name AS full_name,
    p.city || ', ' || p.state AS location,
    COALESCE(ppe.email_address, 'No Email') AS contact_info
FROM patients p
LEFT JOIN patient_email_addresses ppe ON p.patient_id = ppe.patient_id AND ppe.is_primary = true
WHERE UPPER(p.first_name) LIKE '%A%' 
   OR UPPER(p.last_name) SIMILAR TO '%(SMITH|BROWN|LEE)%'
   OR p.first_name ILIKE 'ch%'

UNION ALL

SELECT 
    'Staff' AS record_type,
    sp.staff_id AS id,
    sp.first_name || ' ' || sp.last_name AS full_name,
    'Staff Member' AS location,
    sp.contact_email AS contact_info
FROM staff_profiles sp
WHERE sp.first_name ~ '^[AE]'
   OR POSITION('ob' IN LOWER(sp.last_name)) > 0
ORDER BY record_type, full_name;

-- x. TO_CHAR and EXTRACT Query
-- Use case: Generate monthly appointment and revenue reports for business analysis
-- This provides detailed temporal analysis for scheduling optimization and financial planning
SELECT 
    TO_CHAR(lower(a.appointment_period), 'YYYY-MM') AS year_month,
    TO_CHAR(lower(a.appointment_period), 'Month') AS month_name,
    EXTRACT(QUARTER FROM lower(a.appointment_period)) AS quarter,
    EXTRACT(DOW FROM lower(a.appointment_period)) AS day_of_week,
    CASE EXTRACT(DOW FROM lower(a.appointment_period))
        WHEN 0 THEN 'Sunday'
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
    END AS day_name,
    COUNT(*) AS appointment_count,
    SUM(COALESCE(pl.fee_charged, 0)) AS total_revenue
FROM appointments a
LEFT JOIN procedures_log pl ON a.appointment_id = pl.appointment_id
WHERE lower(a.appointment_period) >= '2022-01-01'
GROUP BY 
    TO_CHAR(lower(a.appointment_period), 'YYYY-MM'),
    TO_CHAR(lower(a.appointment_period), 'Month'),
    EXTRACT(QUARTER FROM lower(a.appointment_period)),
    EXTRACT(DOW FROM lower(a.appointment_period))
ORDER BY year_month, day_of_week;

-- xi. BETWEEN, IN, NOT BETWEEN, NOT IN Query
-- Use case: Analyze treatment patterns and identify patients needing specific follow-up care
-- This helps in clinical workflow management and treatment outcome tracking
SELECT 
    p.patient_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    tc.description AS procedure_description,
    pl.procedure_date,
    pl.fee_charged,
    CASE 
        WHEN tc.code_value IN ('D0120', 'D1110') THEN 'Preventive Care'
        WHEN tc.code_value IN ('D2391') THEN 'Restorative Care'
        WHEN tc.code_value IN ('D0220') THEN 'Diagnostic'
        ELSE 'Other'
    END AS procedure_category
FROM patients p
JOIN procedures_log pl ON p.patient_id = pl.patient_id
JOIN treatment_codes tc ON pl.code_id = tc.code_id
WHERE pl.procedure_date BETWEEN '2022-01-01' AND '2023-12-31'
AND pl.fee_charged BETWEEN 50.00 AND 300.00
AND tc.code_value NOT IN ('D0270', 'D0330')  -- Excluding specific codes
AND p.patient_id NOT BETWEEN 100 AND 200     -- Excluding specific patient range
AND pl.procedure_date NOT BETWEEN '2023-06-01' AND '2023-06-30'  -- Excluding June 2023
ORDER BY pl.procedure_date DESC, p.last_name;

-- xii. SET OPERATIONS (UNION, INTERSECT, EXCEPT)
-- Use case: Comprehensive contact management for patient communication campaigns
-- This helps marketing and patient care teams coordinate outreach efforts

-- UNION: All patient contacts for emergency notifications
(SELECT 
    p.patient_id,
    'Primary Email' AS contact_type,
    ppe.email_address AS contact_value,
    p.first_name || ' ' || p.last_name AS patient_name
FROM patients p
JOIN patient_email_addresses ppe ON p.patient_id = ppe.patient_id
WHERE ppe.is_primary = true)

UNION

(SELECT 
    p.patient_id,
    'Primary Phone' AS contact_type,
    ppn.phone_number AS contact_value,
    p.first_name || ' ' || p.last_name AS patient_name
FROM patients p
JOIN patient_phone_numbers ppn ON p.patient_id = ppn.patient_id
WHERE ppn.is_primary = true)

ORDER BY patient_id, contact_type;

-- Additional SET OPERATION Examples:

-- INTERSECT: Find patients who have both email and phone contacts (complete contact info)
SELECT patient_id, 'Complete Contact Info' AS status
FROM (
    SELECT DISTINCT p.patient_id
    FROM patients p
    JOIN patient_email_addresses ppe ON p.patient_id = ppe.patient_id
    WHERE ppe.is_primary = true
    
    INTERSECT
    
    SELECT DISTINCT p.patient_id
    FROM patients p
    JOIN patient_phone_numbers ppn ON p.patient_id = ppn.patient_id
    WHERE ppn.is_primary = true
) complete_contacts;

-- EXCEPT: Find patients with appointments but no invoices (potential billing issues)
SELECT DISTINCT 
    a.patient_id,
    'Missing Invoice' AS billing_status
FROM appointments a
WHERE a.status = 'Completed'

EXCEPT

SELECT DISTINCT 
    i.patient_id,
    'Has Invoice' AS billing_status
FROM invoices i;

-- =================================================================
-- END OF QUERIES
-- =================================================================
-- Summary of Query Types Covered:
-- 1. GROUP BY...HAVING - Patient appointment frequency analysis
-- 2. ORDER BY - Patient financial reporting
-- 3. INNER JOIN - Completed appointment details
-- 4. LEFT OUTER JOIN - Patient emergency contacts
-- 5. SELF JOIN - Patients in same city
-- 6. NATURAL JOIN (adapted) - Patient procedures with codes
-- 7. Independent SUBQUERY - High-value procedures
-- 8. Correlated SUBQUERY - Patients due for checkups
-- 9. EXISTS - Staff with perio exam experience
-- 10. NOT EXISTS - Patients without invoices
-- 11. AGGREGATE FUNCTIONS - Clinic performance metrics
-- 12. BOOLEAN OPERATORS - High-risk patient identification
-- 13. ARITHMETIC OPERATORS - Payment efficiency calculation
-- 14. STRING OPERATORS - Flexible patient/staff search
-- 15. TO_CHAR/EXTRACT - Monthly appointment reports
-- 16. BETWEEN/IN/NOT operators - Treatment pattern analysis
-- 17. SET OPERATIONS - Contact management and billing analysis
-- =================================================================