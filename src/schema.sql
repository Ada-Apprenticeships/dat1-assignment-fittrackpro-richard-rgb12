.open fittrackpro.db
.mode column

PRAGMA foreign_keys = ON;

CREATE TABLE locations (
    location_id INTEGER PRIMARY KEY,
    name VARCHAR(255),
    address VARCHAR(255),
    phone_number VARCHAR(13) UNIQUE,
    email VARCHAR(255) CHECK(email LIKE '%@fittrackpro.com') UNIQUE,
    opening_hours VARCHAR(222)
);

CREATE TABLE members (
    member_id INTEGER PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email CHECK(email LIKE '%@%.%'),
    phone_number VARCHAR(13) CHECK(phone_number LIKE '07%'),
    date_of_birth DATE,
    join_date DATE,
    emergency_contact_name VARCHAR(255),
    emergency_contact_phone	VARCHAR(13)
);

CREATE TABLE staff (
    staff_id INTEGER PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email VARCHAR(255) CHECK(email LIKE '%@fittrackpro.com') UNIQUE,
    phone_number VARCHAR(13) CHECK(phone_number LIKE '07%') UNIQUE,
    position VARCHAR(255) CHECK(position IN('Trainer', 'Manager', 'Receptionist', 'Maintenance')),
    hire_date DATE,
    location_id INTEGER NOT NULL,
    FOREIGN KEY(location_id) REFERENCES locations(location_id)
);

CREATE TABLE equipment (
    equipment_id INTEGER PRIMARY KEY,
    name VARCHAR(255),
    type VARCHAR(255) CHECK(type IN('Cardio', 'Strength')),
    purchase_date DATE,
    last_maintenance_date DATE,
    next_maintenance_date DATE,
    location_id INTEGER NOT NULL,
    FOREIGN KEY(location_id) REFERENCES locations(location_id)
);

CREATE TABLE classes (
    class_id INTEGER PRIMARY KEY,	
    name VARCHAR(255),	
    description	VARCHAR(255),
    capacity INTEGER,
    duration INTEGER,
    location_id INTEGER NOT NULL,
    FOREIGN KEY(location_id) REFERENCES locations(location_id)
);

CREATE TABLE class_schedule (
    schedule_id INTEGER PRIMARY KEY,
    class_id INTEGER NOT NULL,	
    staff_id INTEGER NOT NULL,	
    start_time DATETIME,
    end_time DATETIME,
    FOREIGN KEY(class_id) REFERENCES classes(class_id),
    FOREIGN KEY(staff_id) REFERENCES staff(staff_id)
);

CREATE TABLE memberships (
    membership_id INTEGER PRIMARY KEY,
    member_id INTEGER NOT NULL UNIQUE,
    type VARCHAR(255) CHECK(type IN('Standard', 'Premium')),
    start_date DATE,
    end_date DATE,
    status VARCHAR(255) CHECK(status IN('Active', 'Inactive')),
    FOREIGN KEY(member_id) REFERENCES members(member_id)
);

CREATE TABLE attendance (
    attendance_id INTEGER PRIMARY KEY,	
    member_id INTEGER NOT NULL,	
    location_id INTEGER NOT NULL,	
    check_in_time DATETIME,	
    check_out_time DATETIME,
    FOREIGN KEY(location_id) REFERENCES locations(location_id),
    FOREIGN KEY(member_id) REFERENCES members(member_id)
);

CREATE TABLE class_attendance (
    class_attendance_id INTEGER PRIMARY KEY,
    schedule_id INTEGER NOT NULL,	
    member_id INTEGER NOT NULL,	
    attendance_status CHECK(attendance_status IN ('Registered', 'Attended', 'Unattended')),
    FOREIGN KEY(schedule_id) REFERENCES class_schedule(schedule_id),
    FOREIGN KEY(member_id) REFERENCES members(member_id)
);

CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY,
    member_id INTEGER NOT NULL,
    amount REAL(2),
    payment_date DATETIME,
    payment_method VARCHAR(13) CHECK(payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal', 'Cash')),
    payment_type VARCHAR(22) CHECK(payment_type IN ('Monthly membership fee', 'Day pass')),
    FOREIGN KEY(member_id) REFERENCES members(member_id)
);

CREATE TABLE personal_training_sessions (
    session_id INTEGER PRIMARY KEY,	
    member_id INTEGER NOT NULL,	
    staff_id INTEGER NOT NULL, 	
    session_date DATE,
    start_time TIME,	
    end_time TIME,	
    notes VARCHAR(255), 
    FOREIGN KEY(member_id) REFERENCES members(member_id),
    FOREIGN KEY(staff_id) REFERENCES staff(staff_id)
);

CREATE TABLE member_health_metrics (
    metric_id INTEGER PRIMARY KEY,
    member_id INTEGER NOT NULL,
    measurement_date DATE,
    weight DECIMAL(5, 2),
    body_fat_percentage DECIMAL(5, 2),
    muscle_mass DECIMAL(5, 2),
    bmi DECIMAL(5, 2)
);

CREATE TABLE equipment_maintenance_log (
    log_id INTEGER PRIMARY KEY,
    equipment_id INTEGER NOT NULL,
    maintenance_date DATE,
    description VARCHAR(255),
    staff_id INTEGER NOT NULL,
    FOREIGN KEY(equipment_id) REFERENCES equipment(equipment_id),
    FOREIGN KEY(staff_id) REFERENCES staff(staff_id)
);

