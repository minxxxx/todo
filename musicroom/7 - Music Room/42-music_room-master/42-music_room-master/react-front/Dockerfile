FROM node:8.9.0 as react-build
WORKDIR /usr/src/react
RUN npm install -g pm2
ADD . .
RUN npm install
EXPOSE 3000
ENTRYPOINT ["/bin/bash", "./run.sh"]
CMD ["start"]
