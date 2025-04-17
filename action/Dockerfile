FROM node:20-alpine
 
WORKDIR /app
 
COPY package.json package-lock.json* ./
RUN npm install
 
COPY entrypoint.sh /entrypoint.sh
COPY . .
 
RUN chmod +x /entrypoint.sh
 
ENTRYPOINT ["/entrypoint.sh"]
