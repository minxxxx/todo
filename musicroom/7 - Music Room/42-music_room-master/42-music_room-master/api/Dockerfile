FROM node:8.9.0
RUN echo "deb http://deb.debian.org/debian stretch main" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y build-essential
COPY package.json /tmp/package.json
RUN cd /tmp && npm install
RUN mkdir -p /usr/src/musicroom && cp -a /tmp/node_modules /usr/src/musicroom
WORKDIR /usr/src/musicroom
RUN npm install -g pm2
COPY . /usr/src/musicroom
EXPOSE 4242
CMD ["pm2-runtime", "ecosystem.config.json"]
