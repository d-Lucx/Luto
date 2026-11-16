alter extension pg_trgm set schema extensions;
-- Explicit deny policies document the intended server-only access model.
create policy moderator_membership_server_only on public.community_moderators for all to anon,authenticated using(false) with check(false);
create policy moderation_log_server_only on public.community_moderation_log for all to anon,authenticated using(false) with check(false);

create function public.community_moderate(p_reviewer uuid,p_recipe uuid,p_decision text,p_reason text) returns public.community_recipes
language plpgsql security invoker set search_path='' as $$
declare result public.community_recipes;
begin
 if not exists(select 1 from public.community_moderators where user_id=p_reviewer) then raise exception 'Reviewer access required'; end if;
 if p_decision not in ('published','archived') or length(trim(p_reason)) not between 3 and 2000 then raise exception 'Invalid decision'; end if;
 update public.community_recipes set status=p_decision,updated_at=now()
 where id=p_recipe and status='pending_review' and author_id<>p_reviewer returning * into result;
 if result.id is null then raise exception 'Held recipe unavailable or self-review forbidden'; end if;
 insert into public.community_moderation_log(recipe_id,moderator_id,decision,reason) values(p_recipe,p_reviewer,p_decision,p_reason);
 return result;
end $$;
revoke all on function public.community_moderate(uuid,uuid,text,text) from public,anon,authenticated;
grant execute on function public.community_moderate(uuid,uuid,text,text) to service_role;
