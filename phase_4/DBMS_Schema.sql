-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TABLE "roles" (
  "role_id" int PRIMARY KEY,
  "role_name" varchar
);

CREATE TABLE "permissions" (
  "permission_id" int PRIMARY KEY,
  "permission_name" varchar,
  "description" text
);

CREATE TABLE "role_permissions" (
  "role_id" int,
  "permission_id" int,
  PRIMARY KEY ("role_id", "permission_id")
);

CREATE TABLE "users" (
  "user_id" int PRIMARY KEY,
  "email" varchar,
  "password_hash" varchar,
  "is_active" boolean,
  "created_at" timestamp DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "user_roles" (
  "user_id" int,
  "role_id" int,
  PRIMARY KEY ("user_id", "role_id")
);

CREATE TABLE "staff_profiles" (
  "staff_id" int PRIMARY KEY,
  "user_id" int,
  "first_name" varchar,
  "last_name" varchar,
  "contact_email" varchar,
  "emergency_contact" varchar,
  "created_at" timestamp DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "clinics" (
  "clinic_id" int PRIMARY KEY,
  "clinic_name" varchar,
  "clinic_address" varchar,
  "city" varchar,
  "state" varchar,
  "postal_code" varchar,
  "weekday_hours" varchar,
  "weekend_hours" varchar
);

CREATE TABLE "patients" (
  "patient_id" int PRIMARY KEY,
  "primary_clinic_id" int,
  "first_name" varchar,
  "last_name" varchar,
  "date_of_birth" date,
  "gender" varchar,
  "street_address" varchar,
  "city" varchar,
  "state" varchar,
  "postal_code" varchar,
  "country" varchar,
  "registration_date" date,
  "created_at" timestamp DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "emergency_contacts" (
  "emergency_contact_id" int PRIMARY KEY,
  "patient_id" int,
  "full_name" varchar,
  "contact_relationship" varchar,
  "phone_number" varchar,
  "created_at" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "medical_history" (
  "medical_history_id" int PRIMARY KEY,
  "patient_id" int,
  "history_type" varchar,
  "description" text,
  "start_date" date,
  "end_date" date,
  "is_active" boolean,
  "recorded_at" timestamp
);

CREATE TABLE "provider_schedules" (
  "schedule_id" int PRIMARY KEY,
  "staff_id" int,
  "clinic_id" int,
  "schedule_rules" text,
  "valid_from" date,
  "valid_to" date
);

CREATE TABLE "appointments" (
  "appointment_id" int PRIMARY KEY,
  "patient_id" int,
  "staff_id" int,
  "clinic_id" int,
  "appointment_period" tsrange,
  "appointment_type" varchar,
  "status" varchar,
  "notes" text,
  "created_at" timestamp DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "treatment_codes" (
  "code_id" int PRIMARY KEY,
  "code_system" varchar,
  "code_value" varchar,
  "description" text,
  "standard_fee" decimal,
  "is_active" boolean
);

CREATE TABLE "treatment_plans" (
  "plan_id" int PRIMARY KEY,
  "patient_id" int,
  "staff_id" int,
  "plan_date" date,
  "description" text,
  "status" varchar,
  "created_at" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "plan_items" (
  "plan_item_id" int PRIMARY KEY,
  "plan_id" int,
  "code_id" int,
  "quantity" int,
  "fee_quoted" decimal
);

CREATE TABLE "procedures_log" (
  "procedure_id" int PRIMARY KEY,
  "appointment_id" int,
  "patient_id" int,
  "staff_id" int,
  "code_id" int,
  "procedure_date" date,
  "fee_charged" decimal,
  "notes" text
);

CREATE TABLE "invoices" (
  "invoice_id" int PRIMARY KEY,
  "patient_id" int,
  "invoice_date" date,
  "due_date" date,
  "total_amount" decimal,
  "amount_paid" decimal,
  "status" varchar,
  "created_at" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "invoice_items" (
  "invoice_item_id" int PRIMARY KEY,
  "invoice_id" int,
  "procedure_id" int,
  "amount" decimal
);

CREATE TABLE "payments" (
  "payment_id" int PRIMARY KEY,
  "invoice_id" int,
  "payment_date" date,
  "amount" decimal,
  "payment_method" varchar,
  "transaction_id" varchar,
  "created_at" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "insurance_companies" (
  "company_id" int PRIMARY KEY,
  "company_name" varchar,
  "payer_id" varchar,
  "contact_info" text
);

CREATE TABLE "patient_plans" (
  "patient_plan_id" int PRIMARY KEY,
  "patient_id" int,
  "company_id" int,
  "policy_number" varchar,
  "group_number" varchar,
  "subscriber_id" varchar,
  "relationship_to_subscriber" varchar,
  "is_primary" boolean,
  "effective_date" date,
  "termination_date" date
);

CREATE TABLE "claims" (
  "claim_id" int PRIMARY KEY,
  "invoice_id" int,
  "patient_plan_id" int,
  "submission_date" date,
  "status" varchar,
  "paid_amount" decimal,
  "adjudication_date" date
);

CREATE TABLE "teeth" (
  "tooth_id" int PRIMARY KEY,
  "universal_number" varchar,
  "tooth_name" varchar,
  "is_primary" boolean
);

CREATE TABLE "patient_odontogram" (
  "patient_id" int,
  "tooth_id" int,
  "current_state" varchar,
  "state_history" text,
  "updated_at" timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("patient_id", "tooth_id")
);

CREATE TABLE "perio_exams" (
  "perio_exam_id" int PRIMARY KEY,
  "patient_id" int,
  "staff_id" int,
  "exam_date" date,
  "created_at" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "perio_measurements" (
  "perio_measurement_id" int PRIMARY KEY,
  "perio_exam_id" int,
  "tooth_id" int,
  "measurement_type" varchar,
  "site" varchar,
  "value" varchar,
  "exam_date" date
);

CREATE TABLE "prescriptions" (
  "prescription_id" int PRIMARY KEY,
  "patient_id" int,
  "staff_id" int,
  "appointment_id" int,
  "drug_name" varchar,
  "dosage" varchar,
  "quantity" int,
  "instructions" text,
  "refills" int,
  "date_prescribed" date,
  "created_at" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "clinical_notes" (
  "note_id" int PRIMARY KEY,
  "appointment_id" int,
  "patient_id" int,
  "staff_id" int,
  "note_title" varchar,
  "note_text" text,
  "is_finalized" boolean,
  "created_at" timestamp DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "documents" (
  "document_id" int PRIMARY KEY,
  "patient_id" int,
  "appointment_id" int,
  "document_type" varchar,
  "file_name" varchar,
  "storage_identifier" varchar,
  "mime_type" varchar,
  "file_size_bytes" int,
  "metadata" text,
  "upload_timestamp" timestamp
);

CREATE TABLE "dentists" (
  "staff_id" int PRIMARY KEY,
  "dental_degree" varchar,
  "years_of_experience" int
);

CREATE TABLE "administrative_staff" (
  "staff_id" int PRIMARY KEY,
  "department" varchar,
  "access_level" varchar
);

CREATE TABLE "nurses" (
  "staff_id" int PRIMARY KEY,
  "nursing_license_number" varchar,
  "nursing_degree" varchar
);

CREATE TABLE "healthcare_providers" (
  "provider_id" int PRIMARY KEY,
  "provider_type" varchar,
  "provider_ref_id" int
);

CREATE TABLE "external_specialists" (
  "specialist_id" int PRIMARY KEY,
  "specialty_area" varchar,
  "referral_network" text
);

CREATE TABLE "staff_specializations" (
  "specialization_id" int PRIMARY KEY,
  "staff_id" int,
  "specialization" varchar,
  "created_at" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "staff_phone_numbers" (
  "phone_id" int PRIMARY KEY,
  "staff_id" int,
  "phone_number" varchar,
  "phone_type" varchar,
  "is_primary" boolean,
  "created_at" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "clinic_phone_numbers" (
  "phone_id" int PRIMARY KEY,
  "clinic_id" int,
  "phone_number" varchar,
  "phone_type" varchar,
  "created_at" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "clinic_email_addresses" (
  "email_id" int PRIMARY KEY,
  "clinic_id" int,
  "email_address" varchar,
  "email_type" varchar,
  "created_at" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "clinic_services" (
  "service_id" int PRIMARY KEY,
  "clinic_id" int,
  "service_name" varchar,
  "description" text,
  "created_at" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "clinic_insurance_accepted" (
  "insurance_id" int PRIMARY KEY,
  "clinic_id" int,
  "insurance_name" varchar,
  "created_at" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "patient_allergies" (
  "allergy_id" int PRIMARY KEY,
  "patient_id" int,
  "allergy_name" varchar,
  "severity" varchar,
  "notes" text,
  "created_at" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "patient_email_addresses" (
  "email_id" int PRIMARY KEY,
  "patient_id" int,
  "email_address" varchar,
  "email_type" varchar,
  "is_primary" boolean,
  "created_at" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "patient_phone_numbers" (
  "phone_id" int PRIMARY KEY,
  "patient_id" int,
  "phone_number" varchar,
  "phone_type" varchar,
  "is_primary" boolean,
  "created_at" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "dentist_procedures" (
  "procedure_id" int PRIMARY KEY,
  "staff_id" int,
  "procedure_name" varchar,
  "proficiency_level" varchar,
  "years_experience" int,
  "created_at" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "admin_responsibilities" (
  "responsibility_id" int PRIMARY KEY,
  "staff_id" int,
  "responsibility" varchar,
  "description" text,
  "created_at" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "nurse_specializations" (
  "specialization_id" int PRIMARY KEY,
  "staff_id" int,
  "specialization" varchar,
  "certification_date" date,
  "certification_expiry" date,
  "created_at" timestamp DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE "staff_profiles" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("user_id");

ALTER TABLE "user_roles" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("user_id");

ALTER TABLE "user_roles" ADD FOREIGN KEY ("role_id") REFERENCES "roles" ("role_id");

ALTER TABLE "role_permissions" ADD FOREIGN KEY ("role_id") REFERENCES "roles" ("role_id");

ALTER TABLE "role_permissions" ADD FOREIGN KEY ("permission_id") REFERENCES "permissions" ("permission_id");

ALTER TABLE "patients" ADD FOREIGN KEY ("primary_clinic_id") REFERENCES "clinics" ("clinic_id");

ALTER TABLE "emergency_contacts" ADD FOREIGN KEY ("patient_id") REFERENCES "patients" ("patient_id");

ALTER TABLE "medical_history" ADD FOREIGN KEY ("patient_id") REFERENCES "patients" ("patient_id");

ALTER TABLE "provider_schedules" ADD FOREIGN KEY ("staff_id") REFERENCES "staff_profiles" ("staff_id");

ALTER TABLE "provider_schedules" ADD FOREIGN KEY ("clinic_id") REFERENCES "clinics" ("clinic_id");

ALTER TABLE "appointments" ADD FOREIGN KEY ("patient_id") REFERENCES "patients" ("patient_id");

ALTER TABLE "appointments" ADD FOREIGN KEY ("staff_id") REFERENCES "staff_profiles" ("staff_id");

ALTER TABLE "appointments" ADD FOREIGN KEY ("clinic_id") REFERENCES "clinics" ("clinic_id");

ALTER TABLE "plan_items" ADD FOREIGN KEY ("plan_id") REFERENCES "treatment_plans" ("plan_id");

ALTER TABLE "plan_items" ADD FOREIGN KEY ("code_id") REFERENCES "treatment_codes" ("code_id");

ALTER TABLE "treatment_plans" ADD FOREIGN KEY ("patient_id") REFERENCES "patients" ("patient_id");

ALTER TABLE "treatment_plans" ADD FOREIGN KEY ("staff_id") REFERENCES "staff_profiles" ("staff_id");

ALTER TABLE "procedures_log" ADD FOREIGN KEY ("appointment_id") REFERENCES "appointments" ("appointment_id");

ALTER TABLE "procedures_log" ADD FOREIGN KEY ("patient_id") REFERENCES "patients" ("patient_id");

ALTER TABLE "procedures_log" ADD FOREIGN KEY ("staff_id") REFERENCES "staff_profiles" ("staff_id");

ALTER TABLE "procedures_log" ADD FOREIGN KEY ("code_id") REFERENCES "treatment_codes" ("code_id");

ALTER TABLE "invoice_items" ADD FOREIGN KEY ("invoice_id") REFERENCES "invoices" ("invoice_id");

ALTER TABLE "invoice_items" ADD FOREIGN KEY ("procedure_id") REFERENCES "procedures_log" ("procedure_id");

ALTER TABLE "invoices" ADD FOREIGN KEY ("patient_id") REFERENCES "patients" ("patient_id");

ALTER TABLE "payments" ADD FOREIGN KEY ("invoice_id") REFERENCES "invoices" ("invoice_id");

ALTER TABLE "patient_plans" ADD FOREIGN KEY ("patient_id") REFERENCES "patients" ("patient_id");

ALTER TABLE "patient_plans" ADD FOREIGN KEY ("company_id") REFERENCES "insurance_companies" ("company_id");

ALTER TABLE "claims" ADD FOREIGN KEY ("invoice_id") REFERENCES "invoices" ("invoice_id");

ALTER TABLE "claims" ADD FOREIGN KEY ("patient_plan_id") REFERENCES "patient_plans" ("patient_plan_id");

ALTER TABLE "patient_odontogram" ADD FOREIGN KEY ("patient_id") REFERENCES "patients" ("patient_id");

ALTER TABLE "patient_odontogram" ADD FOREIGN KEY ("tooth_id") REFERENCES "teeth" ("tooth_id");

ALTER TABLE "perio_exams" ADD FOREIGN KEY ("patient_id") REFERENCES "patients" ("patient_id");

ALTER TABLE "perio_exams" ADD FOREIGN KEY ("staff_id") REFERENCES "staff_profiles" ("staff_id");

ALTER TABLE "perio_measurements" ADD FOREIGN KEY ("perio_exam_id") REFERENCES "perio_exams" ("perio_exam_id");

ALTER TABLE "perio_measurements" ADD FOREIGN KEY ("tooth_id") REFERENCES "teeth" ("tooth_id");

ALTER TABLE "prescriptions" ADD FOREIGN KEY ("patient_id") REFERENCES "patients" ("patient_id");

ALTER TABLE "prescriptions" ADD FOREIGN KEY ("staff_id") REFERENCES "staff_profiles" ("staff_id");

ALTER TABLE "prescriptions" ADD FOREIGN KEY ("appointment_id") REFERENCES "appointments" ("appointment_id");

ALTER TABLE "clinical_notes" ADD FOREIGN KEY ("appointment_id") REFERENCES "appointments" ("appointment_id");

ALTER TABLE "clinical_notes" ADD FOREIGN KEY ("patient_id") REFERENCES "patients" ("patient_id");

ALTER TABLE "clinical_notes" ADD FOREIGN KEY ("staff_id") REFERENCES "staff_profiles" ("staff_id");

ALTER TABLE "documents" ADD FOREIGN KEY ("patient_id") REFERENCES "patients" ("patient_id");

ALTER TABLE "documents" ADD FOREIGN KEY ("appointment_id") REFERENCES "appointments" ("appointment_id");

ALTER TABLE "staff_specializations" ADD FOREIGN KEY ("staff_id") REFERENCES "staff_profiles" ("staff_id");

ALTER TABLE "staff_phone_numbers" ADD FOREIGN KEY ("staff_id") REFERENCES "staff_profiles" ("staff_id");

ALTER TABLE "clinic_phone_numbers" ADD FOREIGN KEY ("clinic_id") REFERENCES "clinics" ("clinic_id");

ALTER TABLE "clinic_email_addresses" ADD FOREIGN KEY ("clinic_id") REFERENCES "clinics" ("clinic_id");

ALTER TABLE "clinic_services" ADD FOREIGN KEY ("clinic_id") REFERENCES "clinics" ("clinic_id");

ALTER TABLE "clinic_insurance_accepted" ADD FOREIGN KEY ("clinic_id") REFERENCES "clinics" ("clinic_id");

ALTER TABLE "patient_allergies" ADD FOREIGN KEY ("patient_id") REFERENCES "patients" ("patient_id");

ALTER TABLE "patient_email_addresses" ADD FOREIGN KEY ("patient_id") REFERENCES "patients" ("patient_id");

ALTER TABLE "patient_phone_numbers" ADD FOREIGN KEY ("patient_id") REFERENCES "patients" ("patient_id");

ALTER TABLE "dentist_procedures" ADD FOREIGN KEY ("staff_id") REFERENCES "dentists" ("staff_id");

ALTER TABLE "admin_responsibilities" ADD FOREIGN KEY ("staff_id") REFERENCES "administrative_staff" ("staff_id");

ALTER TABLE "nurse_specializations" ADD FOREIGN KEY ("staff_id") REFERENCES "nurses" ("staff_id");

ALTER TABLE "dentists" ADD FOREIGN KEY ("staff_id") REFERENCES "staff_profiles" ("staff_id");

ALTER TABLE "administrative_staff" ADD FOREIGN KEY ("staff_id") REFERENCES "staff_profiles" ("staff_id");

ALTER TABLE "nurses" ADD FOREIGN KEY ("staff_id") REFERENCES "staff_profiles" ("staff_id");

ALTER TABLE "healthcare_providers" ADD FOREIGN KEY ("provider_ref_id") REFERENCES "staff_profiles" ("staff_id");

ALTER TABLE "healthcare_providers" ADD FOREIGN KEY ("provider_ref_id") REFERENCES "external_specialists" ("specialist_id");

-- Create triggers to automatically update updated_at timestamps
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON "users" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_staff_profiles_updated_at BEFORE UPDATE ON "staff_profiles" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_patients_updated_at BEFORE UPDATE ON "patients" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_appointments_updated_at BEFORE UPDATE ON "appointments" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_patient_odontogram_updated_at BEFORE UPDATE ON "patient_odontogram" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_clinical_notes_updated_at BEFORE UPDATE ON "clinical_notes" FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
