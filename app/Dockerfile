FROM node:20-alpine

WORKDIR /app

COPY . .

RUN yarn install

RUN yarn global add serve
RUN yarn build

EXPOSE 3000

USER user

ENTRYPOINT ["serve", "-s", "build"]