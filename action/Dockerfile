FROM node:20
 
# Install jq for JSON parsing
RUN apt-get update && apt-get install -y jq
 
WORKDIR /app
 
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
 
ENTRYPOINT ["/entrypoint.sh"]
 
