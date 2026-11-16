#!/bin/bash
# Creates all web_server solution files

ggp_domain="${1:-YOUR_DOMAIN.tech}"

mkdir -p web_server
cd web_server || exit 1

cat > README.md << 'EOF'
# web_server

Exercises on transferring files with scp and configuring an Nginx web server.

| File | Description |
| ---- | ----------- |
| 0-transfer_file | Transfers a file to a server with scp |
| 1-install_nginx_web_server | Installs nginx and serves "Holberton School for the win!" |
| 2-setup_a_domain_name | The domain name pointing to web-01 |
| 3-redirection | Configures a 301 redirect on /redirect_me |
| 4-not_found_page_404 | Configures a custom 404 page |
EOF

cat > 0-transfer_file << 'EOF'
#!/usr/bin/env bash
# Transfers a file from the client to a server's home directory using scp
if [ "$#" -lt 4 ]
then
  echo "Usage: 0-transfer_file PATH_TO_FILE IP USERNAME PATH_TO_SSH_KEY"
  exit 1
fi
ggp_file="$1"
ggp_ip="$2"
ggp_user="$3"
ggp_key="$4"
scp -o StrictHostKeyChecking=no -i "$ggp_key" "$ggp_file" "$ggp_user@$ggp_ip":~/
EOF

cat > 1-install_nginx_web_server << 'EOF'
#!/usr/bin/env bash
# Installs nginx and configures it to serve a page containing Holberton School
apt-get update -y
apt-get install -y nginx
echo "Holberton School for the win!" > /var/www/html/index.html
service nginx restart
EOF

printf '%s\n' "$ggp_domain" > 2-setup_a_domain_name

cat > 3-redirection << 'EOF'
#!/usr/bin/env bash
# Installs nginx and configures a 301 redirect from /redirect_me
apt-get update -y
apt-get install -y nginx
echo "Holberton School for the win!" > /var/www/html/index.html
ggp_conf="/etc/nginx/sites-available/default"
if ! grep -q "redirect_me" "$ggp_conf"
then
  sed -i "s|server_name _;|server_name _;\n\n\tlocation /redirect_me {\n\t\treturn 301 https://www.youtube.com/watch?v=QH2-TGUlwu4;\n\t}|" "$ggp_conf"
fi
service nginx restart
EOF

cat > 4-not_found_page_404 << 'EOF'
#!/usr/bin/env bash
# Installs nginx with a 301 redirect and a custom 404 page
apt-get update -y
apt-get install -y nginx
echo "Holberton School for the win!" > /var/www/html/index.html
echo "Ceci n'est pas une page" > /var/www/html/404.html
ggp_conf="/etc/nginx/sites-available/default"
if ! grep -q "redirect_me" "$ggp_conf"
then
  sed -i "s|server_name _;|server_name _;\n\n\tlocation /redirect_me {\n\t\treturn 301 https://www.youtube.com/watch?v=QH2-TGUlwu4;\n\t}|" "$ggp_conf"
fi
if ! grep -q "error_page 404" "$ggp_conf"
then
  sed -i "s|server_name _;|server_name _;\n\n\terror_page 404 /404.html;|" "$ggp_conf"
fi
service nginx restart
EOF

chmod +x 0-transfer_file 1-install_nginx_web_server 3-redirection 4-not_found_page_404

echo "Done! Files created in $(pwd):"
ls -l
