# pull official base image
FROM node:10 AS builder

# set working directory
WORKDIR /app


# install app dependencies
#copies package.json and package-lock.json to Docker environment
COPY package.json ./

# Installs all node packages
RUN npm install 


# Copies everything over to Docker environment
COPY . ./
RUN npm run build

#Stage 2
#pull the official nginx:1.19.0 base image
FROM nginx:alpine
# Set working directory to nginx resources directory
WORKDIR /usr/share/nginx/html
#cleanup
RUN rm -rf /usr/share/nginx/html/*
RUN rm /etc/nginx/conf.d/default.conf
# Copies static resources from builder stage
COPY --from=builder /app/dist /usr/share/nginx/html/
COPY docker/nginx-react.conf /etc/nginx/conf.d/nginx-react.conf
#expose-port
EXPOSE 80
# Containers run nginx with global directives and daemon off
CMD ["nginx", "-g", "daemon off;"]
