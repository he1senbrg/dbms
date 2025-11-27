;
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
) AS complete_contacts;
