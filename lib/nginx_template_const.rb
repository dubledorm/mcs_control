module NginxTemplateConst

  DEFAULT_HTTP_TEMPLATE = 'upstream <uniq_section_name> {
<ip_addresses>.each{  server <ip_address>:<ip_port>;
}}
server {
  listen <ip_port>;
  server_name <server_name>;
  location = / {
  rewrite ^.+ /<http_prefix> permanent;
  }
  location /<http_prefix> {
  proxy_pass http://<uniq_section_name>;
  }
}'

  DEFAULT_SIMPLE_HTTP_TEMPLATE = 'upstream <uniq_section_name> {
<ip_addresses>.each{  server <ip_address>:<ip_port>;
}}
server {
  listen <ip_port>;
  server_name <server_name>;
  location /<http_prefix> {
  proxy_pass http://<uniq_section_name>;
  }
}'

  DEFAULT_TCP_TEMPLATE = 'upstream <ident_name>_<ip_port> {
<ip_addresses>.each{  server <ip_address>:<ip_port>;
}}
server {
  listen <listen_ip_port>;
  proxy_pass <ident_name>_<ip_port>;
}'

end