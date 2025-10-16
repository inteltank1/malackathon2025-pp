prompt --application/shared_components/navigation/lists/page_navigation
begin
--   Manifest
--     LIST: Page Navigation
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.9'
,p_default_workspace_id=>9567395691388828
,p_default_application_id=>115
,p_default_id_offset=>0
,p_default_owner=>'INTELTANK'
);
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(9988144438832189)
,p_name=>'Page Navigation'
,p_list_status=>'PUBLIC'
,p_version_scn=>39291256613087
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(9988547720832191)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Reportaje'
,p_list_item_link_target=>'f?p=&APP_ID.:2:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-table'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(9988926609832192)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Filtrar'
,p_list_item_link_target=>'f?p=&APP_ID.:4:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-table-search'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(9989365343832193)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Varios Datos'
,p_list_item_link_target=>'f?p=&APP_ID.:5:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-dashboard'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp.component_end;
end;
/
