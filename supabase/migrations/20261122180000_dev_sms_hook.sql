-- =====================================================================
-- DEV ONLY: "Send SMS" auth hook that sends nothing.
--
-- Supabase needs an SMS provider (or a Send SMS hook) to enable phone
-- login. During development we only use the test numbers in config.toml
-- ([auth.sms.test_otp]), which never call this hook. Real numbers will
-- get no SMS until a real provider is chosen (PRD open decision 1).
-- =====================================================================

create or replace function public.send_sms_dev(event jsonb)
returns jsonb
language plpgsql
set search_path = ''
as $$
begin
  -- Intentionally empty: no SMS is sent in development.
  return '{}'::jsonb;
end;
$$;

-- Only the Auth service may call it.
grant execute on function public.send_sms_dev(jsonb) to supabase_auth_admin;
revoke execute on function public.send_sms_dev(jsonb) from authenticated, anon, public;
