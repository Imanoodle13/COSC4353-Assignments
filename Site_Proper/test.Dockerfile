FROM node:24
CMD npm init ava && npm install && npm test
