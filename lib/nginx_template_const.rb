module NginxTemplateConst

  DEFAULT_HTTP_TEMPLATE = 'upstream <uniq_section_name> {
  <ip_addresses>.each{server <ip_address>:<ip_port>;}
}

server {

  listen <ip_port>;

  server_name <server_name>;

  location / {

  proxy_pass http://<uniq_section_name>;

  }

}'

  DEFAULT_TCP_TEMPLATE = 'upstream <uniq_section_name> {
  <ip_addresses>.each{server <ip_address>:<ip_port>;}
}

server {

  listen <ip_port>;

  proxy_pass <uniq_section_name>;

}'

end