FROM node:20
 
# Install required tools
RUN apt-get update && apt-get install -y jq
 
# Create app directory
WORKDIR /app
 
# Install ESLint globally
RUN npm install -g eslint
 
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
 
ENTRYPOINT ["/entrypoint.sh"]
