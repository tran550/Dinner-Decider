#!/bin/bash
set -e

# Update and install dependencies
apt-get update -y
apt-get install -y docker.io git nginx

# Start services
systemctl enable --now docker
systemctl enable --now nginx

# Clone the repository and deploy
cd /opt
git clone "${repo_url}" dinner-decider || (cd dinner-decider && git pull origin main)
cd dinner-decider

# Build the Docker image
docker build -t dinner-decider:latest .

# Stop and remove old container if exists
docker rm -f dinner-app || true

# Run the container bound to localhost (nginx will proxy to it)
docker run -d \
  --name dinner-app \
  -p 127.0.0.1:5000:5000 \
  -e GEMINI_API_KEY="${gemini_key}" \
  -e UNSPLASH_KEY="${unsplash_key}" \
  dinner-decider:latest

# Configure nginx to reverse proxy to the app
cat > /etc/nginx/sites-available/dinner <<'NGINX_EOF'
server {
  listen 80;
  server_name _;
  location / {
    proxy_pass http://127.0.0.1:5000;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
  }
}
NGINX_EOF

ln -sf /etc/nginx/sites-available/dinner /etc/nginx/sites-enabled/dinner
rm -f /etc/nginx/sites-enabled/default || true
nginx -t && systemctl restart nginx

echo "Dinner Decider app is now running at http://$(hostname -I | awk '{print $1}')"
