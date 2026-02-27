.open fittrackpro.db
.mode column

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS equipment_maintenance_log;
DROP TABLE IF EXISTS member_health_metrics;
DROP TABLE IF EXISTS personal_training_sessions;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS class_attendance;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS memberships;
DROP TABLE IF EXISTS class_schedule;
DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS locations;


CREATE TABLE locations (
    location_id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(200) NOT NULL,
    phone_number VARCHAR(15) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE
        CHECK(email LIKE '%@fittrackpro.com'),
    opening_hours VARCHAR(100) NOT NULL
);

CREATE TABLE members (
    member_id INTEGER PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL
        CHECK(email LIKE '%@%.%'),
    phone_number VARCHAR(15) NOT NULL
        CHECK(phone_number LIKE '07%'),
    date_of_birth DATE NOT NULL,
    join_date DATE NOT NULL,
    emergency_contact_name VARCHAR(100),
    emergency_contact_phone	VARCHAR(15)
);

CREATE TABLE staff (
    staff_id INTEGER PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE 
        CHECK(email LIKE '%@fittrackpro.com'),
    phone_number VARCHAR(15) NOT NULL UNIQUE
        CHECK(phone_number LIKE '07%'),
    position VARCHAR(20) NOT NULL
        CHECK(position IN('Trainer', 'Manager', 'Receptionist', 'Maintenance')),
    hire_date DATE NOT NULL,
    location_id INTEGER NOT NULL,
    FOREIGN KEY(location_id) 
        REFERENCES locations(location_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE equipment (
    equipment_id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(20) NOT NULL 
        CHECK(type IN('Cardio', 'Strength')),
    purchase_date DATE NOT NULL,
    last_maintenance_date DATE,
    next_maintenance_date DATE,
    location_id INTEGER NOT NULL,
    FOREIGN KEY(location_id)
        REFERENCES locations(location_id)
        ON DELETE CASCADE
);

CREATE TABLE classes (
    class_id INTEGER PRIMARY KEY,	
    name VARCHAR(100) NOT NULL,	
    description	TEXT NOT NULL,
    capacity INTEGER NOT NULL
        CHECK(capacity > 0),
    duration INTEGER NOT NULL
        CHECK(duration > 0),
    location_id INTEGER NOT NULL,
    FOREIGN KEY(location_id) 
        REFERENCES locations(location_id)
        ON DELETE CASCADE
    
);

CREATE TABLE class_schedule (
    schedule_id INTEGER PRIMARY KEY,
    class_id INTEGER NOT NULL,	
    staff_id INTEGER NOT NULL,	
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL
        CHECK(end_time > start_time),
    FOREIGN KEY(class_id) 
        REFERENCES classes(class_id)
        ON DELETE CASCADE,
    FOREIGN KEY(staff_id) 
        REFERENCES staff(staff_id)
        ON DELETE CASCADE
);

CREATE TABLE memberships (
    membership_id INTEGER PRIMARY KEY,
    member_id INTEGER NOT NULL UNIQUE,
    type VARCHAR(10) NOT NULL 
        CHECK(type IN('Standard', 'Premium')),
    start_date DATE NOT NULL,
    end_date DATE
        CHECK(end_date > start_date),
    status VARCHAR(10) NOT NULL DEFAULT 'Active'
        CHECK(status IN('Active', 'Inactive')),
    FOREIGN KEY(member_id) 
        REFERENCES members(member_id)
        ON DELETE CASCADE
);

CREATE TABLE attendance (
    attendance_id INTEGER PRIMARY KEY,	
    member_id INTEGER NOT NULL,	
    location_id INTEGER NOT NULL,	
    check_in_time DATETIME NOT NULL,	
    check_out_time DATETIME
        CHECK(check_out_time IS NULL OR check_out_time > check_in_time),
    FOREIGN KEY(location_id) 
        REFERENCES locations(location_id)
        ON DELETE CASCADE,
    FOREIGN KEY(member_id) 
        REFERENCES members(member_id)
        ON DELETE CASCADE
);

CREATE TABLE class_attendance (
    class_attendance_id INTEGER PRIMARY KEY,
    schedule_id INTEGER NOT NULL,	
    member_id INTEGER NOT NULL,	
    attendance_status VARCHAR(15) NOT NULL
        CHECK(attendance_status IN ('Registered', 'Attended', 'Unattended')),
    FOREIGN KEY(schedule_id) 
        REFERENCES class_schedule(schedule_id)
        ON DELETE CASCADE,
    FOREIGN KEY(member_id) 
        REFERENCES members(member_id)
        ON DELETE CASCADE
);

CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY,
    member_id INTEGER NOT NULL,
    amount DECIMAL(10,2) NOT NULL
        CHECK (amount > 0),
    payment_date DATETIME NOT NULL,
    payment_method VARCHAR(20) NOT NULL
        CHECK(payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal', 'Cash')),
    payment_type VARCHAR(30) NOT NULL
        CHECK(payment_type IN ('Monthly membership fee', 'Day pass')),
    FOREIGN KEY(member_id) 
        REFERENCES members(member_id)
        ON DELETE CASCADE
);

CREATE TABLE personal_training_sessions (
    session_id INTEGER PRIMARY KEY,	
    member_id INTEGER NOT NULL,	
    staff_id INTEGER NOT NULL, 	
    session_date DATE NOT NULL,
    start_time TIME NOT NULL,	
    end_time TIME NOT NULL
        CHECK(end_time > start_time),	
    notes TEXT, 
    FOREIGN KEY(member_id) 
        REFERENCES members(member_id),
    FOREIGN KEY(staff_id) 
        REFERENCES staff(staff_id)
        ON DELETE CASCADE
);

CREATE TABLE member_health_metrics (
    metric_id INTEGER PRIMARY KEY,
    member_id INTEGER NOT NULL,
    measurement_date DATE NOT NULL,
    weight DECIMAL(5, 2)
        CHECK(weight > 0),
    body_fat_percentage DECIMAL(5, 2)
        CHECK(body_fat_percentage BETWEEN 0 AND 100),
    muscle_mass DECIMAL(5, 2)
        CHECK (muscle_mass > 0),
    bmi DECIMAL(5, 2) 
        CHECK(bmi > 0),
    FOREIGN KEY (member_id)
        REFERENCES members(member_id)
        ON DELETE CASCADE
);

CREATE TABLE equipment_maintenance_log (
    log_id INTEGER PRIMARY KEY,
    equipment_id INTEGER NOT NULL,
    maintenance_date DATE NOT NULL,
    description TEXT,
    staff_id INTEGER NOT NULL,
    FOREIGN KEY(equipment_id) 
        REFERENCES equipment(equipment_id)
        ON DELETE CASCADE,
    FOREIGN KEY(staff_id) 
        REFERENCES staff(staff_id)
        ON DELETE CASCADE
);

