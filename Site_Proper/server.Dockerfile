FROM node:24
WORKDIR /home/node/
ADD *.js *.json .env MatchingTest ./
ADD views ./views/
ADD public ./public/
ADD MatchingTest ./MatchingTest/
ADD Queries ./Queries/
CMD npm ci && npm start
