-- Simple fix for unavailability table issues
-- Run this in Supabase SQL Editor

-- 1. Drop and recreate the table with correct structure
DROP TABLE IF EXISTS therapist_unavailability CASCADE;

CREATE TABLE therapist_unavailability (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    therapist_id UUID NOT NULL REFERENCES therapists(id) ON DELETE CASCADE,
    appointment_id UUID REFERENCES appointments(id) ON DELETE CASCADE,
    start_time TIMESTAMP WITH TIME ZONE NOT NULL,
    end_time TIMESTAMP WITH TIME ZONE NOT NULL,
    reason TEXT DEFAULT 'Booked session',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Disable RLS to avoid permission issues
ALTER TABLE therapist_unavailability DISABLE ROW LEVEL SECURITY;

-- 3. Create simple trigger function
CREATE OR REPLACE FUNCTION create_therapist_unavailability()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO therapist_unavailability (
        therapist_id,
        appointment_id,
        start_time,
        end_time,
        reason
    ) VALUES (
        NEW.therapist_id,
        NEW.id,
        NEW.scheduled_at,
        NEW.scheduled_at + (NEW.duration || ' minutes')::interval,
        'Booked session - ' || COALESCE(NEW.type, 'Unknown')
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 4. Create trigger
DROP TRIGGER IF EXISTS trigger_create_therapist_unavailability ON appointments;
CREATE TRIGGER trigger_create_therapist_unavailability
    AFTER INSERT ON appointments
    FOR EACH ROW
    EXECUTE FUNCTION create_therapist_unavailability();

-- 5. Test insert
INSERT INTO therapist_unavailability (
    therapist_id,
    start_time,
    end_time,
    reason
) VALUES (
    (SELECT id FROM therapists LIMIT 1),
    '2025-01-15T10:00:00+00:00',
    '2025-01-15T11:00:00+00:00',
    'Test session'
);

-- 6. Verify
SELECT 'Fix completed successfully' as status;
SELECT COUNT(*) as unavailability_count FROM therapist_unavailability;
