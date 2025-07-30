FROM node:24
WORKDIR /home/node/app
COPY package.json .
CMD npm install && npm start
