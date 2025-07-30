FROM node:24
WORKDIR /home/node/test_app
COPY package.json .
CMD npm init ava && npm install && npm test
