FROM node:24
WORKDIR /home/node/app
COPY ./app .
COPY ./views ./views
CMD npm install && npm start
