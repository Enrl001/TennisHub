DROP FUNCTION IF EXISTS public.create_profile(uuid, text);

CREATE OR REPLACE FUNCTION public.create_profile(p_user_id uuid, p_user_role text, p_full_name text DEFAULT NULL)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, role, full_name)
  VALUES (p_user_id, p_user_role::user_role, p_full_name)
  ON CONFLICT (id) DO NOTHING;
END;
$$;

GRANT EXECUTE ON FUNCTION public.create_profile(uuid, text, text) TO anon, authenticated;
