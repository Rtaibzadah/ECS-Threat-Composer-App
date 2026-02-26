# Stage 1: Build stage
FROM node:24-alpine AS build
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install
# Copy all source code 
COPY . .
RUN yarn build

# Stage 2: Production stage
FROM node:24-alpine
WORKDIR /app
RUN yarn global add serve
COPY --from=build /app/build ./build
RUN addgroup -S appgroup && adduser -S user -G appgroup
RUN chown -R user:appgroup /app
EXPOSE 3000
USER user 

CMD ["serve", "-s", "build"]
