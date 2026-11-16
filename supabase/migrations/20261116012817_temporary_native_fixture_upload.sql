-- Temporary exact-object grant for the native media verification, subsequently disabled.
create policy luto_native_fixture_upload on storage.objects for insert to authenticated with check(bucket_id='luto-native-test' and name='lu2-logo.png' and (select auth.uid())='e461ac12-fd7f-40be-aed1-d073e327cc13'::uuid);
