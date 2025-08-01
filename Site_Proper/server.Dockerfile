FROM node:24
WORKDIR /home/node/
ADD *.js package.json eventInsert.json users.json MatchingTest ./
ADD views ./views/
ADD public ./public/
ADD MatchingTest ./MatchingTest/
CMD npm install && npm start
