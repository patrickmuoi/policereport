var SUPABASE_CONFIG = {
  url: 'https://enlocvtauuhcyrrngskk.supabase.co',
  anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVubG9jdnRhdXVoY3lycm5nc2trIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTMyNTA0MDgsImV4cCI6MjEwODgyNjQwOH0.ydGgFGARZOH8it0rhOofPdgpJ9woZP2LANeQ02ZbEmQ'
};

if (typeof window !== 'undefined') {
  window.SUPABASE_CONFIG = SUPABASE_CONFIG;
}
if (typeof module !== 'undefined' && module.exports) {
  module.exports = SUPABASE_CONFIG;
}
