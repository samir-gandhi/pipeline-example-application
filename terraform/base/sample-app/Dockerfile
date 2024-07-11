# Nginx runtime as a base image
FROM nginx:alpine

# Copy index.html to the nginx web root directory
COPY certs /usr/share/nginx/html/certs
COPY css /usr/share/nginx/html/css
COPY fonts /usr/share/nginx/html/fonts
COPY images /usr/share/nginx/html/images
COPY dashboard.html /usr/share/nginx/html/dashboard.html
COPY global.js /usr/share/nginx/html/global.js
COPY index.html /usr/share/nginx/html

# Copy Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80 to allow outside access to our webpage
EXPOSE 80

# Command to run Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]
