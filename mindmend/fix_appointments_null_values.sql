-- Fix Appointments with Null Values
-- This script will update any appointments that have null values in critical fields

-- 1. Check for appointments with null values
SELECT '=== APPOINTMENTS WITH NULL VALUES ===' as info;
SELECT 
  COUNT(*) as total_appointments,
  COUNT(CASE WHEN type IS NULL THEN 1 END) as null_type,
  COUNT(CASE WHEN status IS NULL THEN 1 END) as null_status,
  COUNT(CASE WHEN duration IS NULL THEN 1 END) as null_duration,
  COUNT(CASE WHEN scheduled_at IS NULL THEN 1 END) as null_scheduled_at
FROM appointments;

-- 2. Show specific appointments with null values
SELECT '=== APPOINTMENTS WITH NULL VALUES (DETAILS) ===' as info;
SELECT 
  id,
  patient_id,
  therapist_id,
  scheduled_at,
  duration,
  type,
  status,
  notes,
  created_at
FROM appointments 
WHERE type IS NULL 
   OR status IS NULL 
   OR duration IS NULL 
   OR scheduled_at IS NULL
ORDER BY created_at DESC;

-- 3. Fix appointments with null type
UPDATE appointments 
SET type = 'Video Call'
WHERE type IS NULL;

-- 4. Fix appointments with null status
UPDATE appointments 
SET status = 'upcoming'
WHERE status IS NULL;

-- 5. Fix appointments with null duration
UPDATE appointments 
SET duration = 30
WHERE duration IS NULL;

-- 6. Verify the fixes
SELECT '=== AFTER FIXING NULL VALUES ===' as info;
SELECT 
  COUNT(*) as total_appointments,
  COUNT(CASE WHEN type IS NULL THEN 1 END) as null_type,
  COUNT(CASE WHEN status IS NULL THEN 1 END) as null_status,
  COUNT(CASE WHEN duration IS NULL THEN 1 END) as null_duration,
  COUNT(CASE WHEN scheduled_at IS NULL THEN 1 END) as null_scheduled_at
FROM appointments;

-- 7. Show sample of fixed appointments
SELECT '=== SAMPLE OF FIXED APPOINTMENTS ===' as info;
SELECT 
  id,
  patient_id,
  therapist_id,
  scheduled_at,
  duration,
  type,
  status,
  created_at
FROM appointments 
ORDER BY created_at DESC
LIMIT 5;
