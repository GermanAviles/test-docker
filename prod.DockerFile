########################################
##  _           _  _     _            ##
## | |__  _  _ (_)| | __| | ___  _ _  ##
## | '_ \| || || || |/ _` |/ -_)| '_| ##
## |_.__/ \_,_||_||_|\__,_|\___||_|   ##
########################################

#base image
FROM node:14.15.4-slim as builder
# MAINTAINER German Aviles<german.aviles06@gmail.com>

#set working directory
# RUN mkdir /usr/src/app
WORKDIR /usr/src/app

#add `/usr/src/app/node_modules/.bin` to $PATH
# ENV PATH /usr/src/app/node_modules/.bin:$PATH

#Install and cache app dependencies
# COPY package.json /usr/src/app/package.json
# RUN npm install
COPY package.json package-lock.json ./
RUN npm install
COPY . .
# RUN npm install -g @angular/cli@

#add app
# COPY . /usr/src/app

#Generate build
RUN npm run build 

############################
##                     _  ##
##  _ __  _ _  ___  __| | ##
## | '_ \| '_|/ _ \/ _` | ##
## | .__/|_|  \___/\__,_| ##
## |_|                    ##
############################
# base image
# nginx:1.19.6-alpine
FROM nginx:stable-alpine

# copy artifact build from the 'build environment'
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /usr/src/app/dist /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d/default.conf
COPY ./publish/angular-docker /usr/share/nginx/html

# expose port 80
EXPOSE 80

# run nginx
CMD ["nginx", "-g", "daemon off;"]