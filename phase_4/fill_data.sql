-- Active: 1761272742613@@127.0.0.1@5432
-- =================================================================
-- DUMMY DATA INSERTION SCRIPT
-- Generated for schema: DBMS_Schema_V2.sql
-- =================================================================
-- This script inserts dummy data in an order that
-- respects foreign key constraints.
-- =================================================================

-- Round 1: Tables with no (or self-referencing) foreign keys

INSERT INTO "roles" ("role_id", "role_name") VALUES
(1, 'Admin'),
(2, 'Dentist'),
(3, 'Nurse'),
(4, 'Patient'),
(5, 'Receptionist');

INSERT INTO "permissions" ("permission_id", "permission_name", "description") VALUES
(1, 'manage_users', 'Can create, edit, and delete users.'),
(2, 'manage_patients', 'Can create, edit, and view patient records.'),
(3, 'manage_appointments', 'Can schedule and modify appointments.'),
(4, 'view_billing', 'Can view invoices and payments.'),
(5, 'manage_billing', 'Can create and modify invoices and payments.'),
(6, 'view_clinical_notes', 'Can view clinical notes.'),
(7, 'manage_clinical_notes', 'Can create and edit clinical notes.');

INSERT INTO "users" ("user_id", "email", "password_hash", "is_active", "created_at", "updated_at") VALUES
(1, 'admin@dental.com', 'hashed_password_placeholder_123', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 'dr.eve@dental.com', 'hashed_password_placeholder_456', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 'nurse.bob@dental.com', 'hashed_password_placeholder_789', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(4, 'reception@dental.com', 'hashed_password_placeholder_101', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(5, 'patient.alice@example.com', 'hashed_password_placeholder_112', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(6, 'patient.charlie@example.com', 'hashed_password_placeholder_113', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
-- Note: User IDs for patients are not strictly necessary if patients don't log in.

INSERT INTO "clinics" ("clinic_id", "clinic_name", "clinic_address", "city", "state", "postal_code", "weekday_hours", "weekend_hours") VALUES
(1, 'Downtown Dental Care', '123 Main St', 'Metropolis', 'NY', '10001', '8:00 AM - 6:00 PM', '9:00 AM - 1:00 PM'),
(2, 'Uptown Smiles', '456 Oak Ave', 'Metropolis', 'NY', '10021', '9:00 AM - 5:00 PM', 'Closed');

INSERT INTO "treatment_codes" ("code_id", "code_system", "code_value", "description", "standard_fee", "is_active") VALUES
(1, 'ADA', 'D0120', 'Periodic oral evaluation', 55.00, true),
(2, 'ADA', 'D1110', 'Prophylaxis - adult', 120.00, true),
(3, 'ADA', 'D2391', 'Resin-based composite - one surface, posterior', 250.00, true),
(4, 'ADA', 'D0220', 'Intraoral - periapical first film', 30.00, true);

INSERT INTO "insurance_companies" ("company_id", "company_name", "payer_id", "contact_info") VALUES
(1, 'MetroHealth Insurance', 'MH12345', '1-800-555-1234, claims@metrohealth.com'),
(2, 'DentalGuard', 'DG98765', '1-800-555-6789, providers@dentalguard.com');

INSERT INTO "teeth" ("tooth_id", "universal_number", "tooth_name", "is_primary") VALUES
(1, '1', 'Third Molar - Upper Right', false),
(2, '2', 'Second Molar - Upper Right', false),
(3, '3', 'First Molar - Upper Right', false),
(4, '4', 'Second Bicuspid - Upper Right', false),
(5, '5', 'First Bicuspid - Upper Right', false),
(6, '6', 'Cuspid (Canine) - Upper Right', false),
(7, '7', 'Lateral Incisor - Upper Right', false),
(8, '8', 'Central Incisor - Upper Right', false),
(9, '9', 'Central Incisor - Upper Left', false),
(10, '10', 'Lateral Incisor - Upper Left', false),
(11, '11', 'Cuspid (Canine) - Upper Left', false),
(12, '12', 'First Bicuspid - Upper Left', false),
(13, '13', 'Second Bicuspid - Upper Left', false),
(14, '14', 'First Molar - Upper Left', false),
(15, '15', 'Second Molar - Upper Left', false),
(16, '16', 'Third Molar - Upper Left', false),
(17, '17', 'Third Molar - Lower Left', false),
(18, '18', 'Second Molar - Lower Left', false),
(19, '19', 'First Molar - Lower Left', false),
(20, '20', 'Second Bicuspid - Lower Left', false),
(21, '21', 'First Bicuspid - Lower Left', false),
(22, '22', 'Cuspid (Canine) - Lower Left', false),
(23, '23', 'Lateral Incisor - Lower Left', false),
(24, '24', 'Central Incisor - Lower Left', false),
(25, '25', 'Central Incisor - Lower Right', false),
(26, '26', 'Lateral Incisor - Lower Right', false),
(27, '27', 'Cuspid (Canine) - Lower Right', false),
(28, '28', 'First Bicuspid - Lower Right', false),
(29, '29', 'Second Bicuspid - Lower Right', false),
(30, '30', 'First Molar - Lower Right', false),
(31, '31', 'Second Molar - Lower Right', false),
(32, '32', 'Third Molar - Lower Right', false);

INSERT INTO "external_specialists" ("specialist_id", "specialty_area", "referral_network") VALUES
(1, 'Orthodontics', 'Metropolis Specialist Network'),
(2, 'Endodontics', 'City Endodontics Group');

-- Round 2: Tables dependent on Round 1

INSERT INTO "role_permissions" ("role_id", "permission_id") VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7), -- Admin: all
(2, 2), (2, 3), (2, 6), (2, 7), -- Dentist: manage patients, appts, clinical notes
(3, 2), (3, 6), -- Nurse: manage patients, view clinical notes
(5, 2), (5, 3), (5, 4); -- Receptionist: manage patients, appts, view billing

INSERT INTO "user_roles" ("user_id", "role_id") VALUES
(1, 1), -- admin@dental.com is Admin
(2, 2), -- dr.eve@dental.com is Dentist
(3, 3), -- nurse.bob@dental.com is Nurse
(4, 5); -- reception@dental.com is Receptionist
-- Note: Patients (user_id 5, 6) could be given role_id 4

INSERT INTO "staff_profiles" ("staff_id", "user_id", "first_name", "last_name", "contact_email", "emergency_contact", "created_at", "updated_at") VALUES
(1, 2, 'Eve', 'Hanson', 'dr.eve@dental.com', 'Mark Hanson (Spouse) 555-0101', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 3, 'Bob', 'Miller', 'nurse.bob@dental.com', 'Susan Miller (Sister) 555-0202', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 4, 'Sarah', 'Chen', 'reception@dental.com', 'Tom Chen (Father) 555-0303', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(4, 1, 'Adam', 'Admin', 'admin@dental.com', 'N/A', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO "patients" ("patient_id", "primary_clinic_id", "first_name", "last_name", "date_of_birth", "gender", "street_address", "city", "state", "postal_code", "country", "registration_date", "created_at", "updated_at") VALUES
(1, 1, 'Alice', 'Smith', '1990-05-15', 'Female', '789 Pine Ln', 'Metropolis', 'NY', '10005', 'USA', '2023-01-10', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 1, 'Charlie', 'Brown', '1985-11-22', 'Male', '321 Elm St', 'Metropolis', 'NY', '10003', 'USA', '2022-11-05', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 2, 'David', 'Lee', '2005-02-28', 'Male', '654 Maple Dr', 'Metropolis', 'NY', '10021', 'USA', '2023-03-20', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Round 3: Tables dependent on Round 2

INSERT INTO "staff_phone_numbers" ("phone_id", "staff_id", "phone_number", "phone_type", "is_primary", "created_at") VALUES
(1, 1, '555-111-2222', 'Work', true, CURRENT_TIMESTAMP),
(2, 2, '555-111-3333', 'Work', true, CURRENT_TIMESTAMP),
(3, 3, '555-111-4444', 'Work', true, CURRENT_TIMESTAMP);

INSERT INTO "clinic_phone_numbers" ("phone_id", "clinic_id", "phone_number", "phone_type", "created_at") VALUES
(1, 1, '212-555-1000', 'Main', CURRENT_TIMESTAMP),
(2, 1, '212-555-1001', 'Fax', CURRENT_TIMESTAMP),
(3, 2, '212-555-2000', 'Main', CURRENT_TIMESTAMP);

INSERT INTO "clinic_email_addresses" ("email_id", "clinic_id", "email_address", "email_type", "created_at") VALUES
(1, 1, 'info@downtowndental.com', 'General', CURRENT_TIMESTAMP),
(2, 1, 'billing@downtowndental.com', 'Billing', CURRENT_TIMESTAMP),
(3, 2, 'contact@uptownsmiles.com', 'General', CURRENT_TIMESTAMP);

INSERT INTO "clinic_services" ("service_id", "clinic_id", "service_name", "description", "created_at") VALUES
(1, 1, 'General Dentistry', 'Checkups, cleanings, fillings.', CURRENT_TIMESTAMP),
(2, 1, 'Cosmetic Dentistry', 'Whitening, veneers.', CURRENT_TIMESTAMP),
(3, 2, 'General Dentistry', 'Checkups, cleanings, fillings.', CURRENT_TIMESTAMP);

INSERT INTO "clinic_insurance_accepted" ("insurance_id", "clinic_id", "insurance_name", "created_at") VALUES
(1, 1, 'MetroHealth Insurance', CURRENT_TIMESTAMP),
(2, 1, 'DentalGuard', CURRENT_TIMESTAMP),
(3, 2, 'MetroHealth Insurance', CURRENT_TIMESTAMP);

INSERT INTO "emergency_contacts" ("emergency_contact_id", "patient_id", "full_name", "contact_relationship", "phone_number", "created_at") VALUES
(1, 1, 'John Smith', 'Spouse', '555-0123', CURRENT_TIMESTAMP),
(2, 2, 'Sally Brown', 'Sister', '555-0456', CURRENT_TIMESTAMP),
(3, 3, 'Grace Lee', 'Mother', '555-0789', CURRENT_TIMESTAMP);

INSERT INTO "medical_history" ("medical_history_id", "patient_id", "history_type", "description", "start_date", "end_date", "is_active", "recorded_at") VALUES
(1, 1, 'Allergy', 'Penicillin', '1995-01-01', NULL, true, '2023-01-10 09:00:00'),
(2, 1, 'Condition', 'Hypertension', '2018-06-15', NULL, true, '2023-01-10 09:00:00'),
(3, 2, 'Surgery', 'Appendectomy', '2010-07-20', '2010-07-20', false, '2022-11-05 14:00:00');

INSERT INTO "patient_allergies" ("allergy_id", "patient_id", "allergy_name", "severity", "notes", "created_at") VALUES
(1, 1, 'Penicillin', 'Severe', 'Anaphylaxis', CURRENT_TIMESTAMP),
(2, 1, 'Latex', 'Mild', 'Skin rash', CURRENT_TIMESTAMP),
(3, 3, 'Peanuts', 'Severe', 'Carries EpiPen', CURRENT_TIMESTAMP);

INSERT INTO "patient_email_addresses" ("email_id", "patient_id", "email_address", "email_type", "is_primary", "created_at") VALUES
(1, 1, 'alice.smith@example.com', 'Personal', true, CURRENT_TIMESTAMP),
(2, 2, 'cbrown@example.com', 'Personal', true, CURRENT_TIMESTAMP),
(3, 3, 'david.lee@example.com', 'Personal', true, CURRENT_TIMESTAMP);

INSERT INTO "patient_phone_numbers" ("phone_id", "patient_id", "phone_number", "phone_type", "is_primary", "created_at") VALUES
(1, 1, '555-321-1234', 'Mobile', true, CURRENT_TIMESTAMP),
(2, 2, '555-654-4567', 'Mobile', true, CURRENT_TIMESTAMP),
(3, 2, '555-654-9999', 'Work', false, CURRENT_TIMESTAMP),
(4, 3, '555-987-7890', 'Mobile', true, CURRENT_TIMESTAMP);

INSERT INTO "provider_schedules" ("schedule_id", "staff_id", "clinic_id", "schedule_rules", "valid_from", "valid_to") VALUES
(1, 1, 1, '{"Mon": "8:00-17:00", "Tue": "8:00-17:00", "Wed": "9:00-13:00"}', '2023-01-01', '2023-12-31'),
(2, 2, 1, '{"Mon": "8:00-17:00", "Tue": "8:00-17:00"}', '2023-01-01', '2023-12-31'),
(3, 1, 2, '{"Thu": "9:00-17:00", "Fri": "9:00-17:00"}', '2023-01-01', '2023-12-31');

INSERT INTO "treatment_plans" ("plan_id", "patient_id", "staff_id", "plan_date", "description", "status", "created_at") VALUES
(1, 1, 1, '2023-01-15', 'Initial treatment plan for Alice', 'Active', CURRENT_TIMESTAMP),
(2, 2, 1, '2022-11-10', 'Restorative work for Charlie', 'Completed', CURRENT_TIMESTAMP);

INSERT INTO "dentists" ("staff_id", "dental_degree", "years_of_experience") VALUES
(1, 'DDS', 10);

INSERT INTO "administrative_staff" ("staff_id", "department", "access_level") VALUES
(3, 'Front Desk', 'Level 2'),
(4, 'Management', 'Level 5');

INSERT INTO "nurses" ("staff_id", "nursing_license_number", "nursing_degree") VALUES
(2, 'RN123456', 'RN');

INSERT INTO "patient_plans" ("patient_plan_id", "patient_id", "company_id", "policy_number", "group_number", "subscriber_id", "relationship_to_subscriber", "is_primary", "effective_date", "termination_date") VALUES
(1, 1, 1, 'P123456789', 'G654321', 'S-12345', 'Self', true, '2023-01-01', NULL),
(2, 2, 2, 'P987654321', 'G123456', 'S-67890', 'Self', true, '2022-01-01', NULL),
(3, 3, 1, 'P123456789', 'G654321', 'S-98765', 'Dependent', true, '2020-01-01', NULL); -- David Lee, dependent on parent's plan

INSERT INTO "patient_odontogram" ("patient_id", "tooth_id", "current_state", "state_history", "updated_at") VALUES
(1, 3, 'Restored (Composite)', '[{"date": "2023-02-01", "state": "Restored (Composite)"}]', CURRENT_TIMESTAMP),
(1, 16, 'Missing', '[{"date": "2015-01-01", "state": "Missing"}]', CURRENT_TIMESTAMP),
(2, 30, 'Caries', '[{"date": "2022-11-10", "state": "Caries"}]', CURRENT_TIMESTAMP);

INSERT INTO "perio_exams" ("perio_exam_id", "patient_id", "staff_id", "exam_date", "created_at") VALUES
(1, 1, 1, '2023-01-15', CURRENT_TIMESTAMP),
(2, 2, 1, '2022-11-10', CURRENT_TIMESTAMP);

-- Round 4: Tables dependent on Round 3

INSERT INTO "appointments" ("appointment_id", "patient_id", "staff_id", "clinic_id", "appointment_period", "appointment_type", "status", "notes", "created_at", "updated_at") VALUES
(1, 1, 1, 1, '[2023-01-15 09:00:00, 2023-01-15 10:00:00)', 'New Patient Exam', 'Completed', 'New patient, full exam and x-rays.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 2, 1, 1, '[2022-11-10 14:00:00, 2022-11-10 14:30:00)', 'Periodic Exam', 'Completed', '6-month checkup.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 1, 1, 1, '[2023-02-01 11:00:00, 2023-02-01 12:00:00)', 'Restorative', 'Completed', 'Filling on #3.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(4, 3, 1, 2, '[2023-03-20 10:00:00, 2023-03-20 10:30:00)', 'Consultation', 'Completed', 'Ortho consult.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(5, 2, 1, 1, '[2022-11-20 10:00:00, 2022-11-20 11:00:00)', 'Restorative', 'Completed', 'Filling on #30.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO "plan_items" ("plan_item_id", "plan_id", "code_id", "quantity", "fee_quoted") VALUES
(1, 1, 1, 1, 55.00),
(2, 1, 2, 1, 120.00),
(3, 1, 3, 1, 250.00), -- Plan for filling on #3
(4, 2, 3, 1, 250.00); -- Plan for filling on #30

INSERT INTO "staff_specializations" ("specialization_id", "staff_id", "specialization", "created_at") VALUES
(1, 1, 'Cosmetic Dentistry', CURRENT_TIMESTAMP),
(2, 1, 'Pediatric Dentistry', CURRENT_TIMESTAMP);

INSERT INTO "dentist_procedures" ("procedure_id", "staff_id", "procedure_name", "proficiency_level", "years_experience", "created_at") VALUES
(1, 1, 'Root Canal Therapy', 'Expert', 8, CURRENT_TIMESTAMP),
(2, 1, 'Implants', 'Proficient', 5, CURRENT_TIMESTAMP);

INSERT INTO "admin_responsibilities" ("responsibility_id", "staff_id", "responsibility", "description", "created_at") VALUES
(1, 3, 'Scheduling', 'Manage patient appointment book.', CURRENT_TIMESTAMP),
(2, 3, 'Check-in', 'Greet and check in patients.', CURRENT_TIMESTAMP),
(3, 4, 'Office Management', 'Oversee all administrative staff.', CURRENT_TIMESTAMP);

INSERT INTO "nurse_specializations" ("specialization_id", "staff_id", "specialization", "certification_date", "certification_expiry", "created_at") VALUES
(1, 2, 'Dental Anesthesia', '2022-06-01', '2024-06-01', CURRENT_TIMESTAMP);

-- NOTE: The schema has a design issue. A column ("provider_ref_id")
-- cannot have two foreign keys referencing two different tables.
-- The inserts below *assume* this was intended to be flexible, but
-- the constraints themselves would fail to create in a real DB.
-- I will insert one of each type, assuming the FKs were not applied.
INSERT INTO "healthcare_providers" ("provider_id", "provider_type", "provider_ref_id") VALUES
(1, 'Staff', 1), -- References Dr. Eve Hanson (staff_profiles.staff_id = 1)
(2, 'External', 1); -- References Orthodontics (external_specialists.specialist_id = 1)

INSERT INTO "perio_measurements" ("perio_measurement_id", "perio_exam_id", "tooth_id", "measurement_type", "site", "value", "exam_date") VALUES
(1, 1, 2, 'Probing Depth', 'Mesiobuccal', '3', '2023-01-15'),
(2, 1, 2, 'Probing Depth', 'Buccal', '2', '2023-01-15'),
(3, 1, 2, 'Probing Depth', 'Distobuccal', '3', '2023-01-15'),
(4, 1, 3, 'Probing Depth', 'Mesiobuccal', '3', '2023-01-15'),
(5, 1, 3, 'Probing Depth', 'Buccal', '3', '2023-01-15'),
(6, 1, 3, 'Probing Depth', 'Distobuccal', '3', '2023-01-15');

-- Round 5: Tables dependent on Round 4

INSERT INTO "procedures_log" ("procedure_id", "appointment_id", "patient_id", "staff_id", "code_id", "procedure_date", "fee_charged", "notes") VALUES
(1, 1, 1, 1, 1, '2023-01-15', 55.00, 'Periodic oral eval.'),
(2, 1, 1, 1, 4, '2023-01-15', 30.00, 'PA film x1.'),
(3, 2, 2, 1, 1, '2022-11-10', 55.00, 'Periodic oral eval.'),
(4, 3, 1, 1, 3, '2023-02-01', 250.00, 'Composite filling #3 MOD.'),
(5, 5, 2, 1, 3, '2022-11-20', 250.00, 'Composite filling #30 O.');

INSERT INTO "prescriptions" ("prescription_id", "patient_id", "staff_id", "appointment_id", "drug_name", "dosage", "quantity", "instructions", "refills", "date_prescribed", "created_at") VALUES
(1, 2, 1, 5, 'Amoxicillin', '500mg', 20, '1 tablet 3 times a day for 7 days', 0, '2022-11-20', CURRENT_TIMESTAMP),
(2, 1, 1, 3, 'Ibuprofen', '600mg', 30, '1 tablet as needed for pain, max 4 per day', 1, '2023-02-01', CURRENT_TIMESTAMP);

INSERT INTO "clinical_notes" ("note_id", "appointment_id", "patient_id", "staff_id", "note_title", "note_text", "is_finalized", "created_at", "updated_at") VALUES
(1, 1, 1, 1, 'New Patient Exam', 'Patient presents for initial exam. No immediate concerns. Full mouth x-rays taken. Plan: Prophy and 1 filling.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 3, 1, 1, 'Restorative Visit', 'Completed #3 MOD composite. Patient tolerated well. Advised on post-op sensitivity.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 5, 2, 1, 'Restorative Visit', 'Completed #30 O composite. Pre-op infection noted. Prescribed Amoxicillin.', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO "documents" ("document_id", "patient_id", "appointment_id", "document_type", "file_name", "storage_identifier", "mime_type", "file_size_bytes", "metadata", "upload_timestamp") VALUES
(1, 1, 1, 'X-Ray', 'fmx_20230115.zip', 's3-bucket/path/fmx_1_abc.zip', 'application/zip', 15728640, '{"series_id": "FMX-123"}', '2023-01-15 09:30:00'),
(2, 1, NULL, 'Consent Form', 'hipaa_consent_alice_smith.pdf', 's3-bucket/path/consent_1_def.pdf', 'application/pdf', 102400, '{"form_version": "v3.1"}', '2023-01-10 08:55:00'),
(3, 2, 2, 'X-Ray', 'bw_20221110.png', 's3-bucket/path/bw_2_ghi.png', 'image/png', 204800, '{"series_id": "BW-456"}', '2022-11-10 14:15:00');

-- Round 6: Tables dependent on Round 5

INSERT INTO "invoices" ("invoice_id", "patient_id", "invoice_date", "due_date", "total_amount", "amount_paid", "status", "created_at") VALUES
(1, 1, '2023-01-15', '2023-02-14', 85.00, 0.00, 'Sent', CURRENT_TIMESTAMP), -- For appointment 1
(2, 2, '2022-11-10', '2022-12-10', 55.00, 55.00, 'Paid', CURRENT_TIMESTAMP), -- For appointment 2
(3, 1, '2023-02-01', '2023-03-03', 250.00, 50.00, 'Partial', CURRENT_TIMESTAMP), -- For appointment 3
(4, 2, '2022-11-20', '2022-12-20', 250.00, 0.00, 'Sent', CURRENT_TIMESTAMP); -- For appointment 5

-- Round 7: Tables dependent on Round 6

INSERT INTO "invoice_items" ("invoice_item_id", "invoice_id", "procedure_id", "amount") VALUES
(1, 1, 1, 55.00), -- Invoice 1: Proc 1 (Eval)
(2, 1, 2, 30.00), -- Invoice 1: Proc 2 (X-Ray)
(3, 2, 3, 55.00), -- Invoice 2: Proc 3 (Eval)
(4, 3, 4, 250.00), -- Invoice 3: Proc 4 (Filling)
(5, 4, 5, 250.00); -- Invoice 4: Proc 5 (Filling)

INSERT INTO "payments" ("payment_id", "invoice_id", "payment_date", "amount", "payment_method", "transaction_id", "created_at") VALUES
(1, 2, '2022-11-15', 55.00, 'Credit Card', 'txn_12345ABC', CURRENT_TIMESTAMP),
(2, 3, '2023-02-05', 50.00, 'Insurance', 'chk_98765', CURRENT_TIMESTAMP);

INSERT INTO "claims" ("claim_id", "invoice_id", "patient_plan_id", "submission_date", "status", "paid_amount", "adjudication_date") VALUES
(1, 1, 1, '2023-01-16', 'Submitted', NULL, NULL),
(2, 2, 2, '2022-11-11', 'Paid', 45.00, '2022-11-25'), -- Insurance paid 45, patient paid 10 (total 55)
(3, 3, 1, '2023-02-02', 'Paid', 50.00, '2023-02-05'),
(4, 4, 2, '2022-11-21', 'Submitted', NULL, NULL);

-- =================================================================
-- END OF DUMMY DATA INSERTION SCRIPT
-- =================================================================