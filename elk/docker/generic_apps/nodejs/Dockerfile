FROM node:16

# Create app directory
WORKDIR /app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

# Install packages
RUN npm ci --only=production

# Bundle app source
COPY . .

# The port to expose
EXPOSE 3000

# Start the application with command mentioned in package.json under start
CMD ["npm", "start"]

