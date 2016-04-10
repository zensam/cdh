INSERT INTO configs
  (config_id, role_id, attr, value, service_id, host_id, config_container_id, optimistic_lock_version, role_config_group_id)
SELECT MAX(config_id)+1, NULL, 'auth_backend_order', '{{ auth_backend_order }}', NULL, NULL, 2, 0, NULL FROM configs;

INSERT INTO configs
  (config_id, role_id, attr, value, service_id, host_id, config_container_id, optimistic_lock_version, role_config_group_id)
SELECT MAX(config_id)+1, NULL, 'ldap_bind_pw', '{{ ldap_bind_pw }}', NULL, NULL, 2, 0, NULL FROM configs;

INSERT INTO configs
  (config_id, role_id, attr, value, service_id, host_id, config_container_id, optimistic_lock_version, role_config_group_id)
SELECT MAX(config_id)+1, NULL, 'ldap_user_search_filter', '{{ ldap_user_search_filter }}', NULL, NULL, 2, 0, NULL FROM configs;

INSERT INTO configs
  (config_id, role_id, attr, value, service_id, host_id, config_container_id, optimistic_lock_version, role_config_group_id)
SELECT MAX(config_id)+1, NULL, 'ldap_dn_pattern', '{{ ldap_dn_pattern }}', NULL, NULL, 2, 0, NULL FROM configs;

INSERT INTO configs
  (config_id, role_id, attr, value, service_id, host_id, config_container_id, optimistic_lock_version, role_config_group_id)
SELECT MAX(config_id)+1, NULL, 'ldap_group_search_filter', '{{ ldap_group_search_filter }}', NULL, NULL, 2, 0, NULL FROM configs;

INSERT INTO configs
  (config_id, role_id, attr, value, service_id, host_id, config_container_id, optimistic_lock_version, role_config_group_id)
SELECT MAX(config_id)+1, NULL, 'ldap_user_search_base', '{{ ldap_user_search_base }}', NULL, NULL, 2, 0, NULL FROM configs;

INSERT INTO configs
  (config_id, role_id, attr, value, service_id, host_id, config_container_id, optimistic_lock_version, role_config_group_id)
SELECT MAX(config_id)+1, NULL, 'ldap_url', '{{ ldap_url }}', NULL, NULL, 2, 0, NULL FROM configs;

INSERT INTO configs
  (config_id, role_id, attr, value, service_id, host_id, config_container_id, optimistic_lock_version, role_config_group_id)
SELECT MAX(config_id)+1, NULL, 'ldap_bind_dn', '{{ ldap_bind_dn }}', NULL, NULL, 2, 0, NULL FROM configs;

INSERT INTO configs
  (config_id, role_id, attr, value, service_id, host_id, config_container_id, optimistic_lock_version, role_config_group_id)
SELECT MAX(config_id)+1, NULL, 'ldap_group_search_base', '{{ ldap_group_search_base }}', NULL, NULL, 2, 0, NULL FROM configs;

INSERT INTO configs
  (config_id, role_id, attr, value, service_id, host_id, config_container_id, optimistic_lock_version, role_config_group_id)
SELECT MAX(config_id)+1, NULL, 'ldap_type', 'LDAP', NULL, NULL, 2, 0, NULL FROM configs;
