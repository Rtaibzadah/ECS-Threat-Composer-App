FROM node:20-alpine AS build
WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . .
ENV DISABLE_ESLINT_PLUGIN=true
RUN yarn build

# runtime
FROM nginx:1.27-alpine AS runtime

COPY --from=build /app/build /usr/share/nginx/html

# Run as non-root user
USER nginx

EXPOSE 3000

CMD ["nginx", "-g", "daemon off;"]

