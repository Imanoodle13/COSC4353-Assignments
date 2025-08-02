FROM node:24
WORKDIR /home/node/
ADD *.js *.json .env MatchingTest ./
ADD views ./views/
ADD public ./public/
ADD MatchingTest ./MatchingTest/
CMD npm ci && npm start
