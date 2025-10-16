prompt --application/pages/page_groups
begin
--   Manifest
--     PAGE GROUPS: 115
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.9'
,p_default_workspace_id=>9567395691388828
,p_default_application_id=>115
,p_default_id_offset=>0
,p_default_owner=>'INTELTANK'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(9634901638830702)
,p_group_name=>'Administration'
);
wwv_flow_imp.component_end;
end;
/
