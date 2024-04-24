FROM node:20.11.1-alpine3.19 AS builder

# Set the working directory inside the container
WORKDIR /app
# Copy package.json and package-lock.json to the container
COPY package*.json ./
# Clean npm cache and install dependencies
RUN npm cache clean --force
#RUN npm install -g npm@10.2.4 -g @angular/cli
RUN npm install
# Copy the rest of the app files to the container
COPY . .
# Build the Angular app
RUN npm run build -- --configuration=production
# --- 2nd Stage ---
FROM nginx:alpine AS runner
# Kopiere den gebauten Angular-Code in das Nginx-Verzeichnis
COPY --from=builder /app/dist/haushut/browser /usr/share/nginx/html
# Kopiere die nginx.conf in das Nginx-Verzeichnis
COPY nginx.conf /etc/nginx/conf.d/default.conf
# Expose the port your app will run on (usually 80)
EXPOSE 80
