FROM node:24
WORKDIR /home/node/MatchingTest
COPY ./MatchingTest .
WORKDIR /home/node/MatchingTest/test
CMD npm init ava && npm install && npm test
