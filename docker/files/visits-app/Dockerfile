FROM node:alpine

WORKDIR /app

COPY package.json .

RUN npm install

COPY index.js .

EXPOSE 8080

CMD ["npm", "start"]