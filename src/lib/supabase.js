import { createClient } from "@supabase/supabase-js"

const supabaseUrl = "https://psvcsbazdvjaqvchgpal.supabase.co"
const supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBzdmNzYmF6ZHZqYXF2Y2hncGFsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTEzOTEwNjEsImV4cCI6MjA2Njk2NzA2MX0.tYFsVjck8qnEC8l8hj3WVheaSGXCeFDEMwOvlZ3KJRA"

export const supabase = createClient(supabaseUrl, supabaseKey)
