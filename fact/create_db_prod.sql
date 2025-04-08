-- Step 1: Create Database
CREATE DATABASE production_db;

-- Step 2: Use the Database
USE production_db;

-- Step 3: Create Table
CREATE TABLE temperature_data (
    p_id VARCHAR(10),
    timestamp DATETIME,
    temp INT
);

-- Step 4: Insert Data
INSERT INTO temperature_data (p_id, timestamp, temp) VALUES
('P1', '2025-02-02T13:00:00', 20),
('P1', '2025-02-02T13:30:00', 25),
('P1', '2025-02-02T14:00:00', 22),
('P2', '2025-02-02T13:00:00', 18),
('P2', '2025-02-02T13:30:00', 20),
('P2', '2025-02-02T14:00:00', 25);
